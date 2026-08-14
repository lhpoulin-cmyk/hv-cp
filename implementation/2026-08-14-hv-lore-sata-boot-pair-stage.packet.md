# Implementation packet: stage Lore SATA boot pair

**Date:** 2026-08-14
**Host:** `hv-lore`
**Authority:** explicit operator request to build the future 256 GB SATA boot pair
**Runbook:** `runbooks/hv-lore-sata-boot-pair-stage.md`

## Objective

Qualify, partition, and stage Lore's two empty P3-256 SATA SSDs as a future
mirrored Proxmox boot/root pair while leaving the existing NVMe `rpool` mirror
fully authoritative and untouched.

This packet is **phase 1 only**. It does not migrate root data, change firmware
boot order, initialize the new ESPs into the active boot-tool set, reboot, or
retire the NVMe mirror.

## Approved destructive scope

Destructive writes are authorized **only** to the two whole disks that resolve
by stable identity to:

- model `P3-256`, serial `9760522200232`, expected ~238.5 GiB SATA
- model `P3-256`, serial `9760511210658`, expected ~238.5 GiB SATA

Never use bare `sdX` names as authority. Resolve each serial to exactly one
whole-disk `/dev/disk/by-id/` path and re-check the serial immediately before
every destructive command. Stop on ambiguity or identity drift.

No other disk may be written.

## Governing starting evidence

Read before action:

- `decisions/2026-07-31-lore-boot-layout.md`
- `evidence/2026-08-14-hv-lore-256gb-boot-feasibility.md`
- `evidence/2026-08-14-hv-lore-256gb-boot-feasibility-raw.txt`
- `evidence/2026-08-14-hv-lore-guest-autostart-restored.md`
- `runbooks/hv-lore-sata-boot-pair-stage.md`

The 2026-07-31 decision still blocks root cutover until firmware fallback is
proven. This packet does not supersede that boundary; it stages replacement
media only.

## Repository preflight

In `~/helix-arpa/hv-cp`:

- read `AGENTS.md`;
- fetch and compare local HEAD with `origin/main`;
- record starting SHA and preserve unrelated worktree changes;
- run the live-mutation runbook audit required by hv-cp before execution.

Stop on authority or repository mismatch.

## Live preflight

Capture before mutation:

```bash
hostname
date -Is
pveversion --verbose
/usr/sbin/proxmox-boot-tool status
findmnt /
zpool status rpool
zpool list rpool
zfs list -r -o name,used,avail,refer,mountpoint rpool
pvesm status
lsblk -d -o NAME,MODEL,SERIAL,SIZE,TRAN,HCTL
ls -l /dev/disk/by-id/
```

Resolve exact candidate by-id paths from the two approved serials. Confirm the
resolved objects are whole disks, not partitions.

For each candidate capture:

```bash
lsblk -o NAME,PATH,MODEL,SERIAL,SIZE,TYPE,FSTYPE,PTTYPE,PARTTYPE,MOUNTPOINTS <by-id>
wipefs -n <by-id>
sgdisk -p <by-id>
```

Required result: no partition/filesystem data requiring preservation.

Also capture the current partition layout of one authoritative NVMe boot member
using its stable by-id path. Record partition numbers, sizes, start sectors,
and GPT type codes. Do not write to it.

## Media qualification

SMART qualification is mandatory before using these SSDs for boot media.

If `smartctl` is already available, use it. If it is absent, this packet
authorizes installation of **only** the `smartmontools` package, provided APT
can do so without removing packages or performing a broad upgrade. Stop if the
package transaction proposes anything materially broader.

For both candidate disks:

```bash
smartctl -x <by-id>
smartctl -t short <by-id>
```

Wait for the advertised short-test completion and capture `smartctl -x` again.

Hard stop on SMART overall failure, self-test failure, uncorrectable/read-error
indicators, or any result that makes the device unsuitable as boot media.
Record wear/power-on information when exposed by the device.

## Partitioning

Only after all preflight/SMART gates pass:

1. Re-resolve both approved serials to stable whole-disk by-id paths.
2. Remove old signatures/GPT from those two disks only.
3. Create a fresh GPT on each candidate.
4. Reproduce the current Proxmox boot member's partition-1 and partition-2
   **roles and sizes** on each candidate.
5. Use the remainder of each candidate for partition 3 with the same ZFS GPT
   role/type as the current root member.
6. Preserve normal alignment; do not clone the current disk's final LBA because
   the candidates are smaller.
7. `partprobe`/udev settle and verify both resulting layouts before continuing.

Do not guess the partition geometry if the current authoritative layout cannot
be read clearly. Stop and report instead.

## ESP staging

Format each new partition-2 ESP using the installed Proxmox boot tool:

```bash
/usr/sbin/proxmox-boot-tool format <candidate-part2>
```

**Do not run `proxmox-boot-tool init` in this phase.**

Reason: phase 1 must not alter the current managed-ESP set, EFI NVRAM entries,
or firmware boot order. ESP initialization and independent boot testing belong
to the cutover/fallback phase.

Verify both partition-2 filesystems are valid FAT EFI System Partitions and are
not mounted unexpectedly.

## ZFS staging mirror

Create a new, uniquely named ZFS mirror from the two new partition-3 members.
Target name:

```text
rpool-sata-stage
```

Before creation, inspect the live current root-pool/vdev properties and local
installed Proxmox/ZFS documentation. Choose creation properties deliberately
from that evidence; do not copy unsupported properties or invent a root-pool
layout.

Required characteristics:

- exactly two candidate partition-3 members;
- mirror topology;
- no mountpoint collision with `/` or current `rpool`;
- no PVE storage definition added in this phase;
- no datasets copied from current `rpool` in this phase.

After creation capture:

```bash
zpool status rpool-sata-stage
zpool list rpool-sata-stage
zpool status rpool
/usr/sbin/proxmox-boot-tool status
lsblk -o NAME,PATH,MODEL,SERIAL,SIZE,TYPE,FSTYPE,PTTYPE,PARTTYPE,MOUNTPOINTS
```

## Required post-state

PASS requires all of the following:

- current `rpool` remains ONLINE and unchanged;
- current root remains `rpool/ROOT/pve-1`;
- the two approved P3-256 disks passed qualification;
- each P3-256 has the approved 3-partition GPT layout;
- each new partition 2 is formatted as an ESP;
- `rpool-sata-stage` exists as an ONLINE two-member mirror on the two new
  partition-3 members;
- current `proxmox-boot-tool status` managed ESP set is unchanged;
- no firmware boot-order/NVRAM mutation was performed;
- no guest configuration or PVE storage definition changed;
- no reboot occurred.

## Hard stops

Stop immediately if:

- either candidate serial does not match exactly;
- either candidate contains unexpected data/signatures;
- SMART qualification fails;
- current `rpool` is not ONLINE or shows data errors;
- partition geometry/type cannot be established from current evidence;
- a destructive command would target anything other than the two approved
  candidate disks;
- boot-tool state differs materially from the known UEFI+GRUB configuration;
- staging would require changing current root, firmware, guests, or storage
  definitions.

## Evidence and documentation

Write dated evidence under `hv-cp/evidence/` containing:

- repository starting SHA;
- exact candidate by-id paths and serial proof;
- SMART before/after short-test summaries;
- current NVMe partition-layout reference;
- candidate before-state;
- exact destructive commands executed;
- candidate final GPT layouts;
- ESP formatting results;
- `rpool-sata-stage` topology/status;
- current `rpool` before/after status;
- boot-tool status before/after;
- explicit statement that no root migration, ESP initialization, firmware
  mutation, guest change, or reboot occurred.

Update the 256 GB boot-feasibility summary only if new evidence materially
changes it. Do not rewrite immutable prior evidence.

Run applicable hv-cp validators/audits, commit only coherent hv-cp changes, and
push if normal authority permits.

Suggested commit message:

```text
Stage Lore SATA boot pair
```

## Report back

Return:

- starting/final hv-cp SHA and origin/main parity;
- exact stable by-id path for each P3-256 serial;
- SMART qualification result for each SSD;
- exact final partition table for each SSD;
- ESP UUID for each new partition 2;
- `rpool-sata-stage` member identities and status;
- current `rpool` status;
- current boot-tool managed ESP set;
- every package installed, if any;
- every destructive command executed;
- confirmation that root migration/cutover/reboot did not occur;
- any blocker for phase 2.

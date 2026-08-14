# Runbook: stage Lore SATA boot pair

## Purpose

Qualify and stage the two empty 256 GB SATA SSDs in `hv-lore` as a future
mirrored Proxmox boot/root pair while leaving the current NVMe `rpool` mirror
fully authoritative and unchanged.

This runbook does **not** migrate, replace, rename, detach, offline, export, or
otherwise modify the current `rpool` members. It does not reboot the host and
does not claim the new pair is independently bootable as a root pool.

The live action requires a dated implementation packet and explicit operator
authority.

## Candidate identities

Expected candidates from 2026-08-14 evidence:

- `P3-256`, serial `9760522200232`, approximately 238.5 GiB SATA
- `P3-256`, serial `9760511210658`, approximately 238.5 GiB SATA

Never target `sdX` names. Resolve each serial to exactly one whole-disk
`/dev/disk/by-id/` path and stop on ambiguity.

## Preconditions

1. `hostname` is exactly `hv-lore`.
2. Current `rpool` is ONLINE with no data errors.
3. Current root is `rpool/ROOT/pve-1`.
4. Both candidate serials are present and resolve to stable whole-disk by-id
   paths.
5. `wipefs -n` and partition inspection confirm both candidates contain no
   data that must be preserved.
6. SMART identity/health and a short self-test are acceptable. If `smartctl`
   is unavailable, the implementation packet decides whether installing
   `smartmontools` is authorized; do not skip health qualification silently.
7. Capture the current boot layout and `proxmox-boot-tool status` using the
   absolute executable path when necessary.

## Layout rule

Do not invent a partition layout. Read the current Proxmox NVMe boot member
partition table and reproduce its boot-partition semantics on each P3-256:

- partition 1: same boot-helper/BIOS-boot role and size as the current member;
- partition 2: same EFI System Partition role and size as the current member;
- partition 3: ZFS member using the remaining aligned capacity.

The candidate drives are smaller, so only partitions 1 and 2 are copied by
role/size; partition 3 consumes the remaining candidate capacity.

## Staging procedure

After exact-device confirmation immediately before each destructive command:

1. Record current partition/signature state for both candidates.
2. Remove signatures/GPT only from the two approved candidate disks.
3. Create the approved three-partition GPT layout on both candidates.
4. Re-read the partition tables and verify type GUIDs, sizes, alignment, and
   candidate serial-to-device mapping.
5. Format each new EFI System Partition with `proxmox-boot-tool format`.
6. Initialize each new EFI System Partition with `proxmox-boot-tool init ... grub`
   only if the live boot-tool status confirms Lore is currently managed as
   UEFI+GRUB and the implementation packet authorizes adding the new ESPs to
   the managed set.
7. Refresh/sync through `proxmox-boot-tool` and verify all previously managed
   ESPs remain present plus the two new ESPs.
8. Create a **new uniquely named** mirrored ZFS staging pool from the two new
   partition-3 members, for example `rpool-sata-stage`, using properties chosen
   from the live current root-pool baseline rather than guessed defaults.
9. Leave the staging pool empty other than any minimal pool metadata unless a
   separate migration packet explicitly authorizes dataset replication.

## Forbidden actions

Do not:

- write to either current NVMe `rpool` member;
- `zpool replace`, `attach`, `detach`, `offline`, `remove`, `export`, or rename
  the current `rpool`;
- copy current root datasets into the staging pool without a separate approved
  migration step;
- change firmware boot order;
- edit GRUB, initramfs, or kernel parameters;
- reboot;
- start a root cutover;
- touch the three Toshiba TrueNAS disks or the failed 12 TB dispute drive.

## Validation

Required post-state:

- current `rpool` still ONLINE and unchanged;
- both P3-256 identities still resolve correctly;
- both new GPT layouts match the approved roles;
- both ESPs format successfully and, if initialized, appear in
  `proxmox-boot-tool status` without removing existing managed ESPs;
- new ZFS staging pool is ONLINE as a two-member mirror;
- no current guest disk path or PVE storage definition changed;
- no reboot occurred.

Record before/after evidence in `hv-cp/evidence/` and stop. Root-data migration,
independent boot testing, firmware fallback proof, and final NVMe retirement are
separate operations.

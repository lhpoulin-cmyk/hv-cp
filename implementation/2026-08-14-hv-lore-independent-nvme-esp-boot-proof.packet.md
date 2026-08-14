# Implementation packet: Prove Lore independent NVMe ESP boot paths

**Date:** 2026-08-14  
**Status:** execution-ready after live preflight and operator console confirmation  
**Runbook:** `runbooks/2026-08-14-hv-lore-independent-nvme-esp-boot-proof.md`

## Authority and scope

This packet authorizes the narrow acceptance test requested for `hv-lore`:
two temporary UEFI entries targeting the two current managed NVMe ESPs,
two `BootNext`-controlled normal host reboots, and cleanup. It does not
authorize SATA migration, SATA ESP initialization, root copying, or bootloader
configuration changes.

Governing records:

- `decisions/2026-07-31-lore-boot-layout.md`
- `evidence/2026-08-14-hv-lore-storage-and-boot-record.md`
- `evidence/2026-08-14-hv-lore-sata-boot-pair-stage.md`

The historical decision remains unchanged. A new dated decision may close its
fallback-evidence blocker only after both tests pass.

## Hard gates

Stop before mutation if hostname is not `hv-lore`; physical console/recovery
is unavailable; `rpool` is not healthy; the normal existing `proxmox` entry is
missing; either ESP cannot be uniquely resolved; both ESPs resolve to one
physical NVMe; or current `rpool-sata-stage` is not unchanged/healthy.

The operator must have physical HP Z840 console access throughout. The
break-glass path is the HP firmware boot menu selecting the normal Proxmox
entry. No recovery path means no reboot.

## Preflight capture

Capture hostname, ISO date, kernel, PVE version, root mount, `zpool status`
and `zpool list` for `rpool`, `proxmox-boot-tool status`, `efibootmgr -v`, and
full `lsblk -o NAME,PATH,MODEL,SERIAL,SIZE,FSTYPE,PARTTYPE,PARTUUID,UUID,MOUNTPOINTS`.
Resolve UUIDs `A829-1935` and `A829-9C79` live with `blkid`/`lsblk`; record
parent NVMe, partition number, and PARTUUID. Confirm both are in the managed
boot-tool set and preserve exact `BootCurrent` and `BootOrder`.

Capture every VM and CT through `qm`/`pct`: ID, name, running/stopped,
`onboot`, and `startup`, plus the exact currently running set. Preserve the
full raw configs as evidence.

## Execution

For each currently running guest, cleanly shut it down via its normal PVE
interface. For each object whose captured `onboot` is `1`, set `onboot=0` via
`qm set` or `pct set`; do not alter `startup`. Verify no guest is running.

Create temporary entries using the resolved parent disk and partition and
loader `\\EFI\\proxmox\\shimx64.efi`, with labels `Lore ESP-A TEST` and
`Lore ESP-B TEST`. Record their numeric IDs. Immediately restore the captured
BootOrder byte-for-byte with `efibootmgr -o`; do not modify the existing
normal `proxmox` entry.

For A, set only `BootNext` to the A entry, capture `efibootmgr -v`, and issue
one normal reboot. After boot require hostname `hv-lore`, root
`rpool/ROOT/pve-1`, healthy `rpool`, consumed/cleared `BootNext`, unchanged
original `BootOrder`, unchanged managed ESP set, and `BootCurrent` equal to
the A entry. Repeat exactly for B. A BootCurrent mismatch is a fail-closed
stop; reaching Proxmox alone is not proof.

After both pass, delete only the two temporary entries, restore the original
BootOrder, verify BootNext is unset and the normal `proxmox` entry remains,
then restore every captured `onboot` value and the previously running guest
set through PVE interfaces. Do not reboot again solely for cleanup.

## Evidence and acceptance

Raw captures belong under:
`evidence/2026-08-14-hv-lore-independent-esp-boot-proof/`.
The reviewed summary is
`evidence/2026-08-14-hv-lore-independent-esp-boot-proof.md`, with SHA-256
manifest beside it. Acceptance requires:

```text
ESP_A_EXPLICIT_BOOT=PASS
ESP_B_EXPLICIT_BOOT=PASS
ORIGINAL_BOOTORDER_RESTORED=PASS
TEMPORARY_EFI_ENTRIES_REMOVED=PASS
CURRENT_RPOOL=ONLINE
SATA_STAGE_POOL=UNCHANGED
GUEST_ONBOOT_POLICY_RESTORED=PASS
```

Record every command that changes UEFI, guest `onboot`, guest power state, or
host power state in the final summary. Do not claim the old blocker closed
unless both `BootCurrent` checks pass.

# Runbook: Prove Lore independent NVMe ESP boot paths

**Date:** 2026-08-14  
**Host:** `hv-lore` (HP Z840)  
**Packet:** `implementation/2026-08-14-hv-lore-independent-nvme-esp-boot-proof.packet.md`

## Purpose

Prove, with two controlled reboots and temporary `BootNext` selections, that
each currently managed NVMe Proxmox ESP can independently boot Lore. This
runbook does not authorize SATA root migration or any SATA ESP operation.

## Preconditions and recovery

- Operator confirms physical HP Z840 console access for the entire test.
- Firmware boot menu can select the normal existing Proxmox entry as break-glass recovery.
- `rpool` is healthy and mounted from `rpool/ROOT/pve-1`.
- ESP UUIDs `A829-1935` and `A829-9C79` resolve uniquely to different NVMe devices and are both listed by `proxmox-boot-tool status`.
- The original `BootOrder` is captured exactly before any UEFI mutation.

If a reboot does not return with the requested temporary entry as
`BootCurrent`, fail closed and use the confirmed firmware recovery path.

## Procedure boundary

1. Capture host, rpool, boot-tool, UEFI, disk, and guest state.
2. Temporarily set `onboot=0` only for guests currently configured `onboot=1`,
   then cleanly stop the guests that were running.
3. Create one temporary explicit UEFI entry per current NVMe ESP, restore the
   original `BootOrder` immediately, and record entry numbers.
4. Test A and B with one `BootNext` and one normal host reboot each.
5. Require `BootCurrent` to identify the requested temporary entry after each
   reboot, while validating hostname, root dataset, rpool, BootOrder, and
   managed ESP set.
6. Only after both passes, delete temporary entries, restore exact BootOrder,
   restore guest `onboot` values and the previously running guest set, and
   record final evidence.

Use `qm` and `pct` interfaces for guest state. Do not edit `/etc/pve`.

## Forbidden in this run

Do not initialize or format SATA ESPs, touch `rpool-sata-stage`, copy root
datasets, modify the current NVMe rpool, alter GRUB/initramfs/kernel files,
change firmware boot order permanently, delete the normal `proxmox` entry, or
perform an extra reboot solely for convenience.

## Evidence

Store raw captures under `evidence/2026-08-14-hv-lore-independent-esp-boot-proof/`
and the reviewed summary at
`evidence/2026-08-14-hv-lore-independent-esp-boot-proof.md`. Hash every raw
capture and the summary after collection.

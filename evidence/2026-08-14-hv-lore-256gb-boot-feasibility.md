# Feasibility: using Lore's two 256 GB SSDs as boot drives

## Result

**Feasible as a future fresh/rebuilt boot-device pair; not a direct in-place
replacement for Lore's current NVMe root mirror.**

## Evidence

- Lore boots UEFI and currently uses `rpool/ROOT/pve-1` as `/`.
- `rpool` is an ONLINE ZFS mirror on `/dev/nvme0n1p3` and `/dev/nvme1n1p3`.
- Each current NVMe root member is approximately 475 GB; the pool reports
  472 GB and 129 GB allocated.
- The two candidate SATA SSDs are `P3-256`, approximately 238.5 GiB each,
  and both are currently unpartitioned with no filesystem signatures reported
  by `wipefs -n`.
- Firmware is UEFI. The active Proxmox boot entry points to the existing
  NVMe EFI system partition. A stale/available firmware entry named `P3-256`
  is present, but the candidate disks have no EFI partition or boot files.
- `proxmox-boot-tool` was not available in the current command path, so its
  managed-boot state could not be queried.

## Feasibility boundary

The candidates are detected as SATA disks and have enough raw capacity for a
new Proxmox root installation with mirrored EFI/root layouts. However, they
are smaller than the existing NVMe root members, so they cannot simply replace
the current ZFS mirror members in place. A viable migration would require an
approved maintenance window, complete configuration/guest backup validation,
new partitioning and bootloader installation, and either a fresh Proxmox
installation or a carefully planned smaller-root-pool migration followed by
boot testing and rollback validation.

No partitioning, formatting, pool operation, bootloader write, or other
configuration change was performed during this assessment. SMART health was
not assessed because `smartctl` is not installed; basic identity and
enumeration alone are not sufficient to approve them as boot media.

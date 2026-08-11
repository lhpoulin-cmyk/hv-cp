# VM260 pbs-katra image-protection realization

Date: 2026-08-11

- hv-lore storage `pbs-katra-vm260` targets PBS `192.168.10.242`, datastore
  `hv-katra`, and is restricted to hv-lore.
- Job `pbs-katra-vm260-recovery` is enabled, selects VM260 only, uses snapshot
  mode daily at `01:30`, and has no client-side pruning.
- One manual validation backup succeeded. Receipt
  `vm/260/2026-08-11T18:33:20Z` contains `qemu-server.conf`, EFI, and boot-disk
  indexes. VM260's guest NFS mount is not a PVE-managed disk.
- A future drill restores the image as stopped VM9260 on hv-matrix `local-zfs`,
  removes restored NICs before any boot, and does not mount the live pbs-core
  datastore. No restore occurred here.

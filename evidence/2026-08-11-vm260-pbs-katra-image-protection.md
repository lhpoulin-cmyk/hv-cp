# VM260 pbs-katra image-protection realization

Date: 2026-08-11

- hv-lore storage `pbs-katra-vm260` targets PBS `192.168.10.242`, datastore
  `hv-katra`, and is restricted to hv-lore.
- Job `pbs-katra-vm260-recovery` is enabled, selects VM260 only, uses snapshot
  mode daily at `01:30`, and has no client-side pruning.
- One manual validation backup succeeded. Receipt
  `vm/260/2026-08-11T18:33:20Z` contains `qemu-server.conf`, EFI, and boot-disk
  indexes. VM260's guest NFS mount is not a PVE-managed disk.
- The image was restored once as stopped VM9260 on hv-matrix `local-zfs`.
  Both inherited NICs were removed before its only boot. The recovered PBS
  appliance had no non-loopback links and did not mount or contact the live
  pbs-core datastore. Debian 13, PBS 4.2.0-1, configuration, token identity
  records, TLS identity, and auth/session state were observed read-only.
- VM9260 and its two restore-created volumes were destroyed. The temporary
  hv-matrix PBS storage definition was removed. Production VM260, the source
  image, pbs-katra, and hv-matrix `local-zfs` remained healthy.
- This validates only isolated image recovery. Production cutover, live
  datastore adoption, hv-lore total-loss recovery, and pbs-core datastore
  disaster recovery remain unvalidated.

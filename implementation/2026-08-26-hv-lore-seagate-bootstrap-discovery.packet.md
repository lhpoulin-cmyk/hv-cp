# hv-lore Seagate bootstrap discovery implementation packet

Date: 2026-08-26

Status: completed read-only on `hv-matrix` after operator expanded the target;
Seagate bootstrap classified `FOUND_PARTIAL`

Runbook: [`../runbooks/2026-08-26-hv-lore-seagate-bootstrap-discovery.md`](../runbooks/2026-08-26-hv-lore-seagate-bootstrap-discovery.md)

## Authority and boundary

Perform read-only discovery on `hv-lore` to determine whether an attached
Seagate Expansion independently supplies VM260 `pbs-core` recovery. Do not
change guests, storage definitions, mounts, filesystems, ZFS, boot state,
credentials, the P3 targets, or the Seagate.

Stop when the Seagate is absent from both its documented host and the inspected
target, ambiguous, unhealthy, or cannot be accessed without mutation. The
operator explicitly directed continuation on documented host `hv-matrix`.

## Result

On 2026-08-26, `hv-lore` was positively identified and `rpool` was ONLINE with
no known data errors. The Seagate was absent there but was then positively
identified on operator-directed `hv-matrix` as serial `00000000NT1H79L3`.
Its exFAT partition was mounted with verified `ro,nosuid,nodev,noexec` options,
inspected, and cleanly unmounted.

The drive contains a complete 2026-08-11 ZFS send stream of the shared
`pbs-core` datastore and a structurally valid 2026-07-20 standalone VM242
`pbs-katra` VMA with EFI and its 64G system disk. It contains no filename with
`260`, no standalone VM260 archive, no native PBS datastore tree, no completed
VM120 archive, no TrueNAS configuration export, and no external credential
escrow indicator. VM242's live datastore is NFS from VM120 `slowPool`, not the
Seagate. Bootstrap status is therefore `FOUND_PARTIAL`.

Evidence: [`../evidence/2026-08-26-hv-lore-seagate-bootstrap-discovery.md`](../evidence/2026-08-26-hv-lore-seagate-bootstrap-discovery.md)

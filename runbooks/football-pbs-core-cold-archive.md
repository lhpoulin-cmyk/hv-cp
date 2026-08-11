# Football pbs-core cold-archive runbook

This runbook implements the bounded cold-disaster archive authorized by
PLAY-96. It is not a PVE storage target and must not become a boot dependency.

## Identity and preservation guard

Use only `/dev/disk/by-id/usb-Seagate_Expansion_HDD_00000000NT1H79L3-0:0` on
`hv-matrix`; require serial `00000000NT1H79L3`, exFAT UUID `011D-FABB`, and
label `Expansion`. Existing top-level data, notably `truenas-katra` and
`nvme dump`, is preserved. Only
`/mnt/helix-arpa-football/helix-arpa-football/pbs-core-dr` may be created or
changed.

Mount the existing partition with restrictive root ownership and
`rw,nosuid,nodev,noexec`; unmount it after the archive operation. Do not add
an fstab entry or PVE storage definition.

## Source and archive boundary

Snapshot creation and removal are performed only through the trusted VM120 TrueNAS control path. hv-matrix pulls with the dedicated `football-pbs-export` account, whose ZFS delegation is `send` only; it has no snapshot, destroy, mount, receive, or administrative authority.

The only source is `slowPool/backup/pbs/pbs-core` on `truenas-lore`. Require
the source pool and pbs-core service healthy, with no active backup, prune,
GC, or verification task. Create one Football-specific snapshot, send it as a
full, non-incremental stream to a `.zfs.part` file, SHA-256 it, validate the
stream with `zstreamdump`, then atomically rename it and write non-secret
metadata. The initial accepted stream serves both DAILY and MONTHLY roles.

Never delete an accepted point until a validated replacement exists. At 70%
Football filesystem use, review capacity; at 80%, stop. Never touch legacy
Football files, partitioning, or future GitLab/LUKS reservation intent.

## Recovery boundary

For a future drill, mount Football read-only where practical; verify device
identity and archive SHA-256; then, only under separate authority, feed the
full stream to `zfs receive` on separate recovery storage. Never receive over
the live pbs-core source dataset.

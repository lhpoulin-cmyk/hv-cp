# Football pbs-core cold-archive implementation packet

Date: 2026-08-11

Runbook: [`../runbooks/football-pbs-core-cold-archive.md`](../runbooks/football-pbs-core-cold-archive.md)

## Scope

Create only the dedicated exFAT archive directory and one validated full ZFS
send stream of `slowPool/backup/pbs/pbs-core`. The existing Seagate Expansion
disk data is mandatory-preserve. No repartitioning, formatting, ZFS pool,
GitLab, LUKS vault, PVE storage target, or permanent mount is authorized.

## Preconditions and stop conditions

Require the stable disk identity, serial, UUID, label, existing retained
top-level objects, clean unmounted state, healthy source pool/dataset, healthy
pbs-core with no active maintenance/backup task, and enough space for the
full stream plus reserve. Stop on any identity mismatch, active task, failed
snapshot/send/checksum/stream validation, or inability to unmount.

## Mutation and rollback

Create only the dedicated archive directory, source snapshot, temporary stream
file, final stream/metadata after validation, and bounded snapshot cleanup.
If validation fails, retain the `.part` only for diagnosis or remove that exact
file; do not alter an accepted archive or legacy data. Finally sync and
unmount Football. The archive itself is a cold copy, not live PBS storage.

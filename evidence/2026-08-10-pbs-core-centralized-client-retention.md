# pbs-core fleet client-retention boundary

Date: 2026-08-10

## Authority

Fleet PVE jobs submit backups only. PBS retention and pruning belong to
`pbs-cp` and are realized solely by server-side job `pbs-core-retention` on
datastore `pbs-core`: daily `04:40`, keep-daily 7, keep-weekly 4, and
keep-monthly 3.

## Read-back validation

- `hv-lore` job `pbs-core-lore-all-guests`: no `prune-backups`; target
  `pbs-core-lore`, schedule `02:15`, `all=1`, exclusions 120 and 260.
- `hv-katra` job `vaultwarden-lore-pbs`: previously had 7/4/3
  `prune-backups`; that field alone was removed. Target `pbs-core-katra`,
  schedule `03:30`, selected guests 249, 320, 251, and 244, plus existing
  compression, hook, and notification fields remain unchanged.
- `hv-matrix` job `pbs-core-matrix-vm310`: no `prune-backups`; target
  `pbs-core`, schedule `04:00`, selected VM310 only.

PBS read-back confirmed `pbs-core-retention` unchanged, datastore GC at
`05:10`, and verification at Sunday `05:40` with `outdated-after 30`.

No client identity was granted `Datastore.Modify` or `Datastore.Prune`; that
least-privilege result is intentional. No backup or maintenance task was run.

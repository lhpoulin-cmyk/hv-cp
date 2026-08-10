# PBS-FLEET-01B: Katra PVE backup coverage

Status: completed 2026-08-10 — configuration validation passed; backup receipt
remains separately authorized and unvalidated.

## Method and target

Method version: `1cf2fa912e64c388083323517fd96f13ff13f324` (published `hv-cp`
main at shared-core reconciliation; this packet does not authorize a live
change).

Target: `hv-katra`, active PVE PBS target `pbs-core-katra` -> datastore
`pbs-core`. The existing daily `vaultwarden-lore-pbs` job has schedule `03:30`,
retains daily 7 / weekly 4 / monthly 3, and currently includes CT 249 only.

Intended guest set: CT 249 `vaultwarden-lore`, VM 320 `cuda-compute-katra`, CT
251 `lxc-katra-dns`, and CT 244 `time-katra`. Reuse of the established 03:30
schedule is conditional on exact preflight confirmation; no new schedule is
invented. Katra's 1 TB figure is an internal shared-core fleet budget, not a
dedicated datastore or independent hard quota.

## Preconditions and intended mutation

Before any later execution: capture the exact current job and PBS-storage
definition; prove `pbs-core-katra` and datastore `pbs-core` remain active;
confirm all four guest identities and no current backup lock; verify that the
existing credential reference remains usable without alteration; and capture a
private before-state/evidence destination.

The execution updated existing PVE job `vaultwarden-lore-pbs` to select the
approved guest set and `pbs-core-katra` target. Storage definitions,
credentials, service placement, retention values, and PBS maintenance jobs
were not altered. The existing `pbs-katra` target/service remains transitional
and was not removed or retired.

## Rollback, validation, and canonical outputs

Stop on a mismatch in job ID, schedule, retention, storage target, guest
identity, or PBS availability. Roll back only by restoring the exact captured
prior job selection and target; do not run a backup merely to validate
configuration.

The 2026-08-10 execution retained the `03:30` schedule and existing retention
fields while setting exact selection `249,320,251,244` and storage
`pbs-core-katra`. Read-only validation confirmed the target active. No backup
was run, so receipt, integrity, and restore confidence remain unvalidated.

## Forward correction: centralized pbs-core retention authority

The Katra receipt validation proved every selected snapshot was received, then
each client-side `prune-backups` attempt failed because the Katra PBS identity
does not have datastore prune authority. Fleet PVE jobs targeting `pbs-core`
submit backups only: guest selection, schedule, target, and client validation
remain `hv-cp` authority; retention and pruning remain `pbs-cp` authority.

The canonical shared-datastore realization is PBS job `pbs-core-retention` at
04:40 with daily/weekly/monthly 7/4/3. The approved correction removes only
`prune-backups` from `vaultwarden-lore-pbs`; it preserves the job ID, enabled
state, target, schedule, selected guests, compression, hook, notification
settings, and all unrelated options. It neither grants
`Datastore.Modify|Datastore.Prune` nor runs a backup or maintenance task.

- this packet: records the completed bounded configuration transition;
- `evidence/2026-08-10-hv-katra-pbs-core-configuration.md`: records
  non-secret execution evidence;
- private `hv-katra` current-state and validation records: record
  configuration status; and
- `pbs-cp/docs/PBS_FLEET_COVERAGE.md`: records realized configuration and the
  pending receipt gate.

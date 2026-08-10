# PBS-FLEET-01A: Lore PVE backup coverage

Status: completed 2026-08-10 — configuration validation passed; backup receipt
remains separately authorized and unvalidated.

## Method and target

Method version: `1cf2fa912e64c388083323517fd96f13ff13f324` (published `hv-cp`
main at shared-core reconciliation; this packet does not authorize a live
change).

Target: `hv-lore` PVE backup-job realization through active `pbs-core-lore`
-> `pbs-core`. Desired inclusion is all Lore guests except VM 120
`truenas-lore`; that exclusion is explicit.

`pbs-core` is the shared fleet datastore. Lore's 4 TB figure is an internal
fleet-budget allocation, not a dedicated datastore or independent hard quota.

## Current state and required decision

`pbs-lore` -> `hv-lore` is disabled. `pbs-core-lore` is active, but no job
selects it. Existing `arpa-all-guests` selects non-PBS `arpa-vzdump`, which was
offline in read-only evidence. The operator selected `pbs-core-lore` ->
`pbs-core` and approved reuse of the existing daily `02:15` schedule after
execution-time read-only confirmation. `pbs-lore` remains transitional and is
not repaired or retired by this packet.

The offline non-PBS `arpa-all-guests` job is superseded by the validated PBS
successor. Its exact captured definition was preserved, then it was disabled
after the successor's exact target, guest set, exclusion, and schedule
validated. It was not deleted.

## Preconditions, rollback, and stop boundary

Before any later execution: capture exact current PVE storage/job state; prove
`pbs-core-lore` and datastore `pbs-core` are active; verify no credential or
storage-definition change is needed; confirm the existing `02:15` schedule and
guest inventory/VM 120 exclusion; and name a private evidence destination.
Stop on any target, availability, guest-set, schedule, or credential mismatch.

Rollback is limited to restoring the exact captured PVE job definitions,
including re-enabling `arpa-all-guests` only if the validated successor cannot
remain configured. Do not repair `pbs-lore`, alter PVE storage, mount backing
storage, or change TrueNAS.

## Validation and canonical outputs

The 2026-08-10 execution created enabled job `pbs-core-lore-all-guests` with
`all=1`, `exclude=120`, storage `pbs-core-lore`, and schedule `02:15`.
Read-only validation confirmed active `pbs-core-lore` and a disabled preserved
`arpa-all-guests` predecessor. No backup was run, so receipt, integrity, and
restore confidence remain unvalidated.

- this packet: records the completed bounded configuration transition;
- `evidence/2026-08-10-hv-lore-pbs-core-configuration.md`: records
  non-secret execution evidence;
- private `hv-lore` current-state and validation records: record configuration
  status; and
- `pbs-cp/docs/PBS_FLEET_COVERAGE.md`: records realized configuration and the
  pending receipt gate.

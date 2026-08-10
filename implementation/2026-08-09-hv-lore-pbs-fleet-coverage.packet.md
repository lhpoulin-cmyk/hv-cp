# PBS-FLEET-01A: Lore PVE backup coverage

Status: prepared — execution remains separately authorized.

**NOT EXECUTION AUTHORITY**

## Method and target

Method version: `ede4162e889ae701052a62ae930484e234035147` (local `hv-cp`
main at packet creation; this packet does not authorize a live change).

Target: `hv-lore` PVE backup-job realization through active `pbs-core-lore`
-> `pbs-core`. Desired inclusion is all Lore guests except VM 120
`truenas-lore`; that exclusion is explicit.

## Current state and required decision

`pbs-lore` -> `hv-lore` is disabled. `pbs-core-lore` is active, but no job
selects it. Existing `arpa-all-guests` selects non-PBS `arpa-vzdump`, which was
offline in read-only evidence. The operator selected `pbs-core-lore` ->
`pbs-core` and approved reuse of the existing daily `02:15` schedule after
execution-time read-only confirmation.

The offline non-PBS `arpa-all-guests` job is superseded by the validated PBS
successor. Preserve its exact captured definition, then disable it only after
the successor job's exact target, guest set, exclusion, and schedule validate.
Do not delete it in this packet.

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

After a separately authorized execution, validate the PVE job definition,
selected target, exact inclusion/exclusion, and one bounded job result without
claiming restore confidence.

- `implementation/2026-08-09-hv-lore-pbs-fleet-coverage.packet.md`: create.
- `evidence/`: create dated non-secret execution evidence after success.
- private `hv-lore` current state and validation record: update after success.
- `pbs-cp/docs/PBS_FLEET_COVERAGE.md`: update current realization only after
  validated execution.

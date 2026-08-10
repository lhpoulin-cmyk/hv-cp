# PBS-FLEET-01C: Matrix PVE backup coverage

Status: completed 2026-08-10 — configuration validation passed; backup receipt
remains separately authorized and unvalidated.

## Method and target

Method version: `1cf2fa912e64c388083323517fd96f13ff13f324` (published `hv-cp`
main at shared-core reconciliation; this packet does not authorize a live
change).

Target: `hv-matrix`, active PVE PBS target `pbs-core` -> datastore `pbs-core`.
Desired guest inclusion: VM 310 `b70-encode` only.

`pbs-core` is the shared fleet datastore. Matrix's 1 TB figure is an internal
fleet-budget allocation, not a dedicated datastore or independent hard quota.

## Current state and required decision

Matrix has active `pbs-core` storage and no scheduled PVE backup job. The
operator approved daily `04:00` as the backup schedule. It is not inferred
from another host or PBS maintenance cadence.

## Preconditions, rollback, and stop boundary

Before any later execution: capture exact PVE storage/job state; prove
`pbs-core` availability; confirm VM 310 and its backup eligibility; verify the
approved daily `04:00` schedule and existing credential reference without
changing it; and name private evidence output.

The 2026-08-10 execution created one enabled Matrix PVE backup job,
`pbs-core-matrix-vm310`, for VM310 using the approved schedule and existing
`pbs-core` storage. Stop conditions were satisfied. Rollback, if separately
authorized, is deletion of only this newly created job after preserving its
exact before/after evidence.

## Validation and canonical outputs

Read-only validation confirmed VM310-only selection, target `pbs-core`, active
storage, and schedule `04:00`. No backup was run, so receipt, integrity, and
restore confidence remain unvalidated.

- this packet: records the completed bounded configuration transition;
- `evidence/2026-08-10-hv-matrix-pbs-core-configuration.md`: records
  non-secret execution evidence;
- private `hv-matrix` current-state and validation records: record
  configuration status; and
- `pbs-cp/docs/PBS_FLEET_COVERAGE.md`: records realized configuration and the
  pending receipt gate.

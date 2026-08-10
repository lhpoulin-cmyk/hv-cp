# PBS-FLEET-01C: Matrix PVE backup coverage

Status: prepared — execution remains separately authorized.

**NOT EXECUTION AUTHORITY**

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

The sole future mutation may be creation of one Matrix PVE backup job for VM
310 using the approved schedule. Stop on a storage, identity, schedule, or
credential-reference mismatch. Rollback is deletion of only the newly created
job, after preserving its exact before/after evidence.

## Validation and canonical outputs

After separately authorized execution, validate the job's exact VM, target,
schedule, and a separately authorized bounded result. Do not claim restore
confidence from job creation or backup completion alone.

- `implementation/2026-08-09-hv-matrix-pbs-fleet-coverage.packet.md`: create.
- `evidence/`: create dated non-secret execution evidence after success.
- private `hv-matrix` current state and validation record: update after success.
- `pbs-cp/docs/PBS_FLEET_COVERAGE.md`: update current realization only after
  validated execution.

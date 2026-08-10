# PBS-FLEET-01B: Katra PVE backup coverage

Status: prepared — execution remains separately authorized.

**NOT EXECUTION AUTHORITY**

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

The sole proposed mutation is to update the existing PVE backup job to select
the approved guest set and `pbs-core` target. Do not alter storage definitions,
credentials, service placement, retention values, or PBS maintenance jobs.
The existing `pbs-katra` target/service is transitional: preserve its exact
before-state and do not remove or retire it in this mutation.

## Rollback, validation, and canonical outputs

Stop on a mismatch in job ID, schedule, retention, storage target, guest
identity, or PBS availability. Roll back only by restoring the exact captured
prior job selection and target; do not run a backup merely to validate
configuration.

After separately authorized execution, validate exact PVE selection, retained
schedule/retention, target availability, and a separately authorized bounded
backup result. A successful backup does not raise restore confidence.

- `implementation/2026-08-09-hv-katra-pbs-fleet-coverage.packet.md`: create.
- `evidence/`: create dated non-secret execution evidence after success.
- private `hv-katra` current state and validation record: update after success.
- `pbs-cp/docs/PBS_FLEET_COVERAGE.md`: update current realization only after
  validated execution.

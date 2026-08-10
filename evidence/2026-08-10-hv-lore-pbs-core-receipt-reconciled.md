# Lore pbs-core validation receipt — reconciled

Date: 2026-08-10

## Scope

This record closes receipt evidence for the single authorized validation task:

`UPID:hv-lore:0035C428:02FEC66D:6A79EAB4:vzdump::root@pam:`

No backup was retried. Bounded read-only inspection used the approved path
`hv-lore` -> PVE guest agent -> VM 260 `pbs-core`; direct PBS SSH was not
used.

## Self-target correction

VM 260 is the running PBS server providing datastore `pbs-core` to the
`pbs-core-lore` target used by `pbs-core-lore-all-guests`. The original job
attempted VM 260 and failed its QMP PBS connection during the HTTP upgrade.
The existing enabled job was changed only from `exclude=120` to
`exclude=120,260`. It remains `all=1`, targets `pbs-core-lore`, and runs at
`02:15`; preserved predecessor `arpa-all-guests` remains disabled.

VM 120 `truenas-lore` remains excluded as designed. VM 260 requires a
separate non-self-targeted recovery design.

## Receipt proof

The exact archive identifiers in the original PVE task log each had a matching
PBS `index.json.blob` in datastore `pbs-core`, namespace `lore`:

- VMs 130, 140, 141, 142, 149, 150, and 242;
- CTs 243, 245, 246, 247, 248, 249, and 252.

The corresponding timestamps are the archive timestamps recorded by the task,
from VM 130 at `2026-08-10T15:13:56Z` through CT 252 at
`2026-08-10T16:24:37Z`. VM 260's attempted `16:24:48Z` archive has no index,
matching its client-side failure.

## Datastore observation

PBS was active. `/mnt/pbs-core` was mounted from
`192.168.100.111:/mnt/slowPool/backup/pbs/pbs-core` and reported
436,800,061,440 bytes used with 5,563,200,045,056 bytes available on a
6,000,000,106,496-byte filesystem. The approximately 126 GB pre-run
observation therefore increased physically by approximately 310.8 GB; PBS
deduplication and compression mean this is not a logical-size measurement.

Receipt is proven for the fourteen client-completed guests only. Backup
integrity, restore recovery, maintenance execution, and VM 260 protection are
not proven by this evidence.

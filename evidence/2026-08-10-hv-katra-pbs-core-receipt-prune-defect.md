# Katra pbs-core validation receipt — prune defect

Date: 2026-08-10

## Authorized task

One existing PVE job was invoked once:

`UPID:hv-katra:001C76D0:00EA75FA:6A7A0CB0:vzdump::root@pam:`

Job `vaultwarden-lore-pbs` selected CTs 244, 249, and 251 plus VM 320 through
`pbs-core-katra` -> `pbs-core`. It ended with `job errors`; no retry occurred.

## Receipt

The task logged these archive timestamps, and read-only inspection through the
approved `hv-lore` -> PVE guest-agent -> VM260 route found an exact matching
`index.json.blob` in namespace `katra` for every one:

- CT244: `2026-08-10T17:38:56Z`;
- CT249: `2026-08-10T17:39:08Z`;
- CT251: `2026-08-10T17:39:12Z`; and
- VM320: `2026-08-10T17:39:22Z`.

VM320 completed a 224 GiB logical snapshot transfer. These records prove
receipt, not backup integrity or recovery.

## Failure classification

After each upload, PVE invoked its configured
`prune-backups=keep-daily=7,keep-weekly=4,keep-monthly=3`. Every client-side
prune failed for missing `Datastore.Modify|Datastore.Prune` on
`/datastore/pbs-core/katra`. The PVE task consequently reported errors even
though each snapshot was received.

PBS already has canonical server-side job `pbs-core-retention` at `04:40` with
the same 7/4/3 retention. This is duplicate retention authority. The
recommended separate correction is REMOVE CLIENT-SIDE PRUNE; this evidence
does not authorize it or any permission change.

## Capacity

The active `/mnt/pbs-core` mount reported 494,439,235,584 bytes used and
5,505,560,870,912 bytes available on a 6,000,000,106,496-byte filesystem. The
hard fleet quota remains 6 TB decimal. Physical growth must not be treated as
logical backup size because PBS deduplication and compression apply.

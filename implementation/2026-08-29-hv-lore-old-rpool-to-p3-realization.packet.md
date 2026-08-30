# Implementation packet: hv-lore old-rpool-to-P3 realization

Status: operationally accepted; hv-cp truth reconciliation complete

Date: 2026-08-29
Host: `hv-lore`
Authority: operator correction that the authoritative rollback NVMe state is
the recovery source and the P3-256 rpool is the production destination
Runbook: [old-rpool-to-P3 realization](../runbooks/2026-08-29-hv-lore-old-rpool-to-p3-realization.md)

## Objective

Restore Lore selectively from the authoritative pre-reinstall state on the
historical Timetec rpool to the production P3-256 rpool. Restore host and guest
objects in bounded units, validate each destination immediately, and reconcile
the active recovery record and canonical documentation as each unit is
accepted.

## Accepted current outcome

This packet preserves the execution chronology below. It no longer describes
pending runtime work. The accepted post-migration authority is:

```text
HV_LORE_MIGRATION=ACCEPTED
P3_RPOOL=ONLINE
P3_RPOOL_GUID=4137356908105663872
P3_MEMBER_1=ata-P3-256_9760522200232-part3
P3_MEMBER_2=ata-P3-256_9760511210658-part3
OLD_RPOOL_GUID=8921639095104950851
OLD_RPOOL=EXPORTED
OLD_RPOOL_ROLE=HISTORICAL_CONFIGURATION_AUTHORITY_AND_READONLY_FALLBACK
LAST_ACCEPTED_RPOOL_FREE_GIB=130.00
LAST_ACCEPTED_RPOOL_FREE_PERCENT=55.08
```

This is not a block-level pool clone. The production mirror is smaller and is
already running accepted restored services. Copy only the authoritative object
needed for the current recovery step, using the owning PVE, ZFS, filesystem,
or host interface for the destination.

## Exact storage authority

Authoritative source:

```text
OLD_RPOOL_ROLE=AUTHORIZED_READ_ONLY_MIGRATION_SOURCE
OLD_RPOOL_GUID=8921639095104950851
OLD_RPOOL_MEMBER_1=TP250913B5D3323
OLD_RPOOL_MEMBER_2=TP250913B5D1797
SOURCE_MUTATION=PROHIBITED
```

Production destination:

```text
DESTINATION_RPOOL_GUID=4137356908105663872
DESTINATION_MEMBER_1=ata-P3-256_9760522200232-part3
DESTINATION_MEMBER_2=ata-P3-256_9760511210658-part3
DESTINATION_STORAGE=local-zfs
MIN_RPOOL_FREE_PERCENT=20
```

The historical pool may remain physically connected. It must remain exported
except during an explicitly bounded source operation. Import it only by exact
GUID and exact member paths, under a non-conflicting temporary name and
altroot, with `readonly=on` and `cachefile=none`. Forced import is authorized
only for this exact stale-host recovery source. Export it after the bounded
read/copy operation.

## Interim accepted state during execution

Do not recopy or reconstruct these accepted objects unless a real dependency
failure later invalidates their acceptance:

- VM120: running; QGA accepted; slowPool healthy; Toshiba mappings accepted.
- VM260: running; PBS service, datastore, Lore client, and backup visibility
  accepted.
- CT252: running; DNS service accepted; its missing syslog dataset was copied
  from the historical rpool and verified; the historical pool was exported.

The last accepted capacity observation was approximately 34.29 GiB allocated,
201.71 GiB free, and 85.47 percent free.

## Historical realization order

The following was the active execution order at the time. All listed
migration work is complete; it is retained to preserve chronology and grants
no present runtime authority.

1. Restore the exact pre-reinstall `louis` account and SSH operator realization
   from the historical root dataset, cross-checked against `auth-cp` and
   Foundation authority. Copy no private CA/signer material and install no
   unmanaged key.
2. Restore ordinary Lore containers `243`, `245`, `246`, `247`, `248`, and
   `249` from their authoritative old-rpool config and storage state.
3. Restore ordinary QEMU guests `100`, `141`, `142`, `149`, and `150`.
4. Handle VM130, VM140, and VM242 separately because their storage or hardware
   contracts are exceptional. VM140 raw NVMe and GPU passthrough remain a
   dedicated bounded operation.
5. Reconcile remaining host policy and canonical node documentation after the
   recovered estate is operational.

## Per-object execution contract

For every host or guest object:

1. Observe production rpool identity/health/capacity, destination state, and
   the exact source object without mutation.
2. Import the historical pool only when the source read is needed, using the
   exact read-only contract above.
3. Read the authoritative configuration and source storage for only the named
   object. Do not perform a general recovery search.
4. Create or reuse only an unambiguous owned destination. Preserve verified
   partial work and never overwrite an accepted or conflicting object.
5. Copy with the semantics required by the object: exact-size block copy and
   equality proof for zvols; numeric IDs, xattrs, ACLs, and sparse/hard-link
   semantics for filesystems; selective realization for host configuration.
6. Export the historical pool before starting or accepting the destination.
7. Realize configuration through its owner (`qm`, `pct`, `pvesm`, ZFS, or the
   relevant host service), then validate the meaningful guest/service state.
8. Re-measure rpool capacity. Stop before the next object if projected free
   space would cross 20 percent or a stricter canonical floor.
9. Append a concise accepted-state record and update the relevant canonical
   node/guest documentation before moving to the next object.

## Safety boundaries

Never write, snapshot, rename, scrub, upgrade, destroy, or persistently import
the historical pool. Never add either historical member to the production
pool or PVE writable storage. Never wipe, format, or repartition VM140 raw
NVMe, jellyPool media, or Toshiba media. Never wholesale restore `config.db`,
`/etc/pve`, `/etc`, boot files, or machine identity.

Stop on destructive ambiguity, source identity mismatch, an existing
destination owned by another object, copy-verification failure, production
rpool degradation, capacity-floor violation, or a genuine authority conflict.
A parser/format mismatch is ordinary debugging and is not itself recovery
drift.

## Execution and documentation model

Active recovery uses ordinary direct host administration. Ansible is limited
to read-only reconnaissance; Semaphore is not the recovery execution plane.
For each accepted object, record source identity, destination identity, copy
verification, service acceptance, capacity, old-pool export state, and the
next bounded object. Keep credentials and secret file contents out of Git.

Update the private `hv-lore` node record and the owning peer authority when an
accepted change affects them. Preserve older evidence as immutable historical
context; supersede incorrect plans with dated records rather than rewriting
their observed results.

## Repository state

Packet authored from hv-cp commit
`7d7a9d97ecc1583e575c7a3a6885d89281d1308e`. A fresh fetch on 2026-08-29
showed this checkout five commits ahead of, and zero commits behind,
`origin/main` (`e615f0c8581b0ef18aa5ad9c8a9088a6c004928d`). Unrelated dirty work is
preserved. Do not commit or push unless separately requested.

## Execution result

The operator superseded the incident-style framing during execution: this was
a planned migration/reinstallation. PBS supplied ordinary guest payloads, the
historical rpool supplied read-only configuration authority and the few
host-side prerequisites absent from PBS, and the P3 mirror remained the
production destination.

The guest estate is operationally accepted as recorded in
[`2026-08-29-hv-lore-recovery-state.md`](../evidence/2026-08-29-hv-lore-recovery-state.md).
The final P3 observation was ONLINE with both exact expected members and 55.08
percent free. The historical rpool was exported. CT249 is preserved as an
intentionally parked/incomplete Vaultwarden surface rather than receiving an
invented application deployment; its container shell exists, its Vaultwarden
runtime does not, and `onboot=0`. The current startup and shutdown policy,
fresh-boot observation, observer restoration, and deferred SMART tuning are
accepted in
[`2026-08-30-hv-lore-startup-policy-v1-acceptance.md`](../evidence/2026-08-30-hv-lore-startup-policy-v1-acceptance.md).

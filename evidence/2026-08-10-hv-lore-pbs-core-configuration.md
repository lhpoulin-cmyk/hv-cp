# Lore PBS core configuration evidence

Observed: 2026-08-10.

## Bounded change

The separately authorized Lore PBS transition created PVE backup job
`pbs-core-lore-all-guests` and then disabled the preserved predecessor
`arpa-all-guests`.

## Post-change configuration

- successor: enabled, node `hv-lore`, storage `pbs-core-lore`, mode
  `snapshot`, schedule `02:15`, `all=1`, explicit `exclude=120`;
- excluded guest: VM 120, observed as `truenas-lore`;
- predecessor: retained with its original non-PBS `arpa-vzdump` target and
  observed disabled; and
- PBS storage: `pbs-core-lore` active, backed by the shared `pbs-core`
  datastore.

## Boundary

No backup was run. This evidence proves configuration only; it does not prove
server-side receipt, backup integrity, or restore confidence.

# Katra PBS core configuration evidence

Observed: 2026-08-10.

## Bounded change

The separately authorized Katra PBS transition updated existing PVE backup job
`vaultwarden-lore-pbs`.

## Post-change configuration

- enabled job: `vaultwarden-lore-pbs` on `hv-katra`;
- target: active PVE storage `pbs-core-katra` -> datastore `pbs-core`;
- schedule: `03:30` daily;
- exact selected VMIDs: 249, 320, 251, and 244; and
- transitional `pbs-katra` storage/service: retained.

## Boundary

No backup was run. This evidence proves configuration only; it does not prove
server-side receipt, backup integrity, or restore confidence.

# Matrix PBS core configuration evidence

Observed: 2026-08-10.

## Bounded change

The separately authorized Matrix PBS transition created PVE backup job
`pbs-core-matrix-vm310`.

## Post-change configuration

- enabled job: `pbs-core-matrix-vm310` on `hv-matrix`;
- target: active PVE storage `pbs-core` -> datastore `pbs-core`;
- schedule: `04:00` daily; and
- exact selected VMID: 310 (`b70-encode`).

## Boundary

No backup was run. This evidence proves configuration only; it does not prove
server-side receipt, backup integrity, or restore confidence.

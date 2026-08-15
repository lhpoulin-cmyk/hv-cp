# PVE Guest Timing V2 calibration packet

Date: 2026-08-15
Authority: PVE Guest Timing V2 play, hv-cp guest lifecycle boundary
Evidence destination: `evidence/pve-guest-timing/2026-08-15/`

## Selected guests

| Host | Guest | Initial state | Selection basis |
| --- | --- | --- | --- |
| `hv-katra` | CT131 `lxc-katra-jellyfin` | stopped | noncritical application container; no storage, DNS, identity, or root-of-trust role; already stopped, so restoration boundary is explicit |
| `hv-katra` | VM320 `cuda-compute-katra` | running | QGA healthy; read-only guest process, established-connection, and GPU-process checks found no active workload beyond the inspection SSH session; Ollama service readiness is measured separately |

CT251 DNS, TrueNAS, PBS/storage guests, Matrix staging, and active Matrix
encoding were excluded. VM320 remains a bounded calibration choice because it
is an appliance; the live preflight found no active compute workload. A cycle
stops only the selected guest, uses graceful PVE shutdown, never force-stops,
and restores the original state before completion.

## Measurement boundary

Run three cycles per guest with `tools/pve-guest-timing measure-cycle`. Record
request timestamps, PVE/PCT running, QGA/init, safe network probes, and an
existing service probe (`jellyfin` for CT131 and `ollama` for VM320). A service
probe is evidence of that service only; QGA/init readiness is not application
readiness. On any graceful-shutdown failure, stop the cycle and preserve the
failure result; do not force-stop or alter startup configuration.

## Rollback and validation

The rollback is the original running/stopped state. Validate final guest
status, no startup config mutation, and independent host reachability. No
host reboot, storage, network, Ceph, DNS, or credential mutation is in scope.

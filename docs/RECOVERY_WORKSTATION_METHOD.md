# Hypervisor recovery-workstation method

**Status:** reusable planning method; no VM, passthrough, storage, network, or
boot-media change is authorized by this document.

## Purpose

A healthy hypervisor may host a recovery workstation for incident diagnosis or
vendor tooling. This method provides a safe, secondary graphical workspace; it
does not replace SSH-first operations or independent bare-metal recovery.

Use an ordinary virtual display and virtual NIC first. A workstation must be
useful before it receives any host-specific enhancements.

## Recovery paths

| Failure state | Appropriate path |
| --- | --- |
| Hypervisor healthy; another system impaired | Start the approved recovery workstation. |
| A vendor tool requires a graphical or platform-specific environment | Start the approved workstation that provides that environment. |
| Hypervisor cannot boot or its storage is unavailable | Use the independently verified bootable recovery media. |

The workstation must never be the sole path to recover the hypervisor that
hosts it.

## Baseline capabilities

The initial workstation should provide:

- key-only SSH and browser access to approved management services;
- read-only host, storage, and network diagnostics by default;
- confirmation-gated repair tooling; and
- a separate, verified bootable recovery-media fallback.

It must not be the only location for credentials, host configuration, recovery
keys, or other recovery material. Access to any protected recovery material is
an independent custody decision and must not be logged as plaintext.

## Boundary and escalation rules

This method owns only the hypervisor-side pattern for hosting a recovery
workstation. The following remain separate decisions and authorities:

| Decision | Owner / boundary |
| --- | --- |
| Guest operating-system image, administrator access, and vendor applications | Product or endpoint owner |
| DNS, bridge/VLAN policy, routing, VPN, and physical fabric access | `network-cp` |
| Datasets, exports, pools, backup storage, or recovery-vault custody | `truenas-cp` or Foundation |
| Ceph membership, devices, pools, or RBD policy | `ceph-cp` |
| GPU placement, inventory, allocation, and passthrough approval | `gpu-cp`; the hypervisor packet may implement an approved attachment only |
| USB passthrough, host device selection, or boot-media creation | Host-specific approved packet |

GPU or USB passthrough is optional and is never part of the baseline. Add it
only after a basic virtual-display workflow works and a host-specific packet
names the exact device, rollback path, validation, and evidence destination.

## Controlled adoption

Before creating a recovery workstation, create a dated implementation packet
and linked runbook. It must name the host, management path, guest identity,
resource allocation, guest-image provenance, network boundary, recovery-media
fallback, stop conditions, rollback, and evidence destination. The packet must
not authorize any non-hypervisor decision listed above.

For an execution-ready packet, run
`tools/audit-live-mutation-runbooks.sh`. This documentary audit does not grant
live authority.

## Validation

Validate the baseline without widening scope:

1. Boot the planned workstation on its intended host.
2. Confirm the declared management path and DNS boundary.
3. Confirm the approved recovery-material access path without exposing private
   content in logs.
4. Confirm read-only diagnostic visibility for the declared host, storage, and
   network targets.
5. Rehearse recovery of one non-critical service while the hypervisor remains
   healthy.

Record results in the packet's declared canonical and private-evidence paths.
Any repair, import, mount, restore, firmware operation, or cross-domain change
requires its own approval.

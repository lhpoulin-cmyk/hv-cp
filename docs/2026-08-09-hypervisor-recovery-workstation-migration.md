# Hypervisor recovery-workstation authority migration

**Date:** 2026-08-09
**Status:** adopted reusable method; no live-host authority

## Source and custody

| Field | Value |
| --- | --- |
| Legacy source | `/home/louis/infrastructure` |
| Exact source revision | `38329bf359fc75b627fe7a7e77877c72d09dd50a` |
| Source path | `workspace/drafts/hypervisor-recovery-vm-environment.md` |
| Source blob | `c5ae88db11b656818e4bd9422e1f582ec489a774` |
| Source disposition | Retained unchanged; this migration does not modify it. |

## Adopted authority

The source's reusable, hypervisor-side method for hosting a recovery
workstation is now represented by
[RECOVERY_WORKSTATION_METHOD.md](RECOVERY_WORKSTATION_METHOD.md). The new
method is sanitized and planning-only; it is not a copy of node state and does
not authorize a VM or any live action.

## Explicit exclusions

This migration does not adopt firmware baselines, node inventories, guest
application configuration, DNS or network policy, storage/pool configuration,
backup service policy, recovery-vault custody, Ceph work, GPU allocation, USB
device selection, credentials, or boot-media artifacts. Those facts remain
with their applicable node records or owning control planes.

No recovered binary, archive, credential-bearing source, raw evidence capture,
or node-specific configuration was imported.

## Completion boundary

The migration is complete as a documentation change. A future implementation
requires a separate host-specific packet, linked runbook, operator approval,
and named evidence destinations.

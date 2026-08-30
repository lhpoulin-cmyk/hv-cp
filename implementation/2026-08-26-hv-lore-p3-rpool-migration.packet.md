# Implementation packet: migrate Lore rpool to P3 mirror

Status: superseded on 2026-08-29 by
[old-rpool-to-P3 realization](2026-08-29-hv-lore-old-rpool-to-p3-realization.packet.md).
This packet remains the record of the original installer migration plan and
its 2026-08-26 Phase-0 stop.

Date: 2026-08-26
Host: `hv-lore`
Authority: explicit operator packet `HV-LORE P3 RPOOL MIGRATION AND RESTORATION`
Runbook: [Lore P3 rpool migration](../runbooks/2026-08-26-hv-lore-p3-rpool-migration.md)

## Objective

Fresh-install Proxmox VE 9.2 on a ZFS mirror made only from the two approved
P3-256 SATA SSDs, bootstrap VM260/PBS, restore Lore selectively, validate
physical-storage and passthrough semantics, prove each P3 independently boots,
and retain the original NVMe rpool offline and untouched as rollback authority.

## Destructive authority

Whole-disk destruction is authorized only after every hard gate passes, and
only for these stable identities:

- `/dev/disk/by-id/ata-P3-256_9760522200232`, model `P3-256`, serial
  `9760522200232`;
- `/dev/disk/by-id/ata-P3-256_9760511210658`, model `P3-256`, serial
  `9760511210658`.

Capture-time `sdX` names are never authority. The installer must see an
unambiguous target set and both serials must be re-read immediately before
selection.

## Mandatory preservation

Never wipe, repartition, format, initialize, or import destructively:

- old rpool NVMes `TP250913B5D3323` and `TP250913B5D1797`;
- VM140 raw NVMe `TP250916B5D0198`;
- jellyPool NVMe `TP250913B5D1792`;
- Toshiba disks `16N2A02XFWUH`, `16N2A042FWUH`, and `16X2A00KFWUH`.

The old NVMe rpool pair must remain physically isolated from the installer and
offline after acceptance. It is the rollback environment, not a migration
source to import alongside the new pool.

## Phase-0 gates

Before guest shutdown or P3 destruction:

1. Prove VM260 `pbs-core` has a current `pbs-katra-vm260` backup whose catalog
   and extracted configuration contain the appliance system payload.
2. Prove `pbs-katra-vm260` is independent of VM260 and remains reachable when
   VM260 is unavailable.
3. Prove the storage definition, fingerprint, user/token identity, and secret
   required after reinstall exist in an external secure recovery source. A
   secret present only under the old `/etc/pve/priv` fails this gate. Never
   print or commit the secret.
4. Prove operator console access, installer media, exact physical isolation
   plan, and ability to reconnect the original NVMe topology for rollback.

Failure of any item aborts before destructive work. Creating/rotating a PBS
credential or choosing a secret-escrow system is a separate security mutation
unless the operator explicitly authorizes it.

## Execution boundary

Follow the linked runbook exactly. The authorized sequence includes graceful
guest shutdown, host shutdown, operator-performed physical isolation and
installer selection, selective reconstruction, bounded restores, hardware
reconnection, jellyPool import, VM120 raw-disk reattachment, VM140
reconstruction/current-BDF passthrough mapping, service acceptance, capacity
monitoring through existing authority, and two operator-controlled degraded
single-P3 boot tests.

Do not wholesale restore `/etc/pve`, restore `config.db`, create a new
jellyPool/slowPool, change network architecture, clone VM140's raw NVMe,
invent monitoring, impose a ZFS quota, or start the destructive work before a
recorded handoff confirms physical state.

## Rollback

Before final acceptance, any material failure uses power-off rollback: isolate
the P3 installation if necessary, reconnect the two original NVMe rpool
members in their preserved topology, select the prior firmware boot path, boot
old Lore, prove old rpool ONLINE, and resume the old environment. Repairing
the new environment is not a prerequisite.

## Repository and canonical outputs

Repository start:
`7d7a9d97ecc1583e575c7a3a6885d89281d1308e`; freshly fetched
`origin/main` `e615f0c8581b0ef18aa5ad9c8a9088a6c004928d` is its ancestor.
Preserve unrelated worktree state.

Create/update:

- `evidence/2026-08-26-hv-lore-p3-rpool-migration.md` and bounded raw evidence
  sets for each execution stage;
- private canonical
  `nodes/local-compute/hv/hv-lore/CURRENT_STATE.md`, `HARDWARE.md` or the
  established storage record, `VALIDATION.md`, and `TODO.md` as applicable;
- peer PBS canonical recovery state when VM260/PBS restoration is accepted;
- existing monitoring authority documentation only if its established
  mechanism is used for the capacity guardrails.

Run the live-mutation audit before Phase 0 and the canonical-node validator
before completion. Do not commit or push unless separately requested.

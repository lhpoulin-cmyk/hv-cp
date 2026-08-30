# Implementation packet: Lore recovery coverage gate

Status: completed 2026-08-26 — runtime and recovery-coverage validation passed

Date: 2026-08-26
Host: `hv-lore`
Authority: explicit operator packet `HV-LORE RECOVERY COVERAGE AND BACKUP POLICY GATE`
Runbook: [Lore recovery coverage runbook](../runbooks/2026-08-26-hv-lore-recovery-coverage.md)

## Objective and authority

Clear the remaining recovery gates before a separately authorized destructive
Lore rpool migration. This packet authorizes only:

1. changing the existing `pbs-core-lore-all-guests` guest selection so VM 120
   joins the normal recurring policy while VM 260 remains excluded;
2. creating and verifying VM 120's first normal snapshot backup on
   `pbs-core-lore`; and
3. collecting a fresh external VM 140 configuration/GPU/raw-NVMe recovery
   record, without cloning its raw NVMe.

## Expected identities and pre-state

- host `hv-lore`; standalone PVE 9.2.6; `rpool` ONLINE;
- normal job `pbs-core-lore-all-guests`: enabled, `all=1`, `exclude=120,260`,
  schedule `02:15`, mode `snapshot`, storage `pbs-core-lore`;
- P3 targets `ata-P3-256_9760522200232` and
  `ata-P3-256_9760511210658`;
- VM 120 `truenas-lore`: managed `local-zfs` system disk plus raw Toshiba
  serials `16N2A02XFWUH`, `16N2A042FWUH`, and `16X2A00KFWUH`, each
  `backup=0`;
- VM 140 `ws-lore-agent`: raw NVMe serial `TP250916B5D0198`, stable ID
  `nvme-Timetec_PCIe_SSD_TP250916B5D0198`, outside `rpool` and outside the P3
  targets.

The repository starting commit is
`7d7a9d97ecc1583e575c7a3a6885d89281d1308e`; freshly fetched
`origin/main` at `e615f0c8581b0ef18aa5ad9c8a9088a6c004928d` is its ancestor.
Unrelated worktree state must remain untouched.

## Approved mutation and rollback

Change only `pbs-core-lore-all-guests.exclude` from `120,260` to `260` using
the PVE-owned backup-job interface. Preserve every other property. If exact
post-change policy validation fails before backup execution, restore
`exclude=120,260` through the same interface and verify the pre-state.

Create one VM 120 backup using the normal job's target and snapshot semantics.
PBS data creation and ordinary snapshot lifecycle are authorized. Guest
shutdown is not. No special recurring job is authorized.

## Forbidden scope

No `rpool`, P3, Toshiba, VM 140 raw-NVMe, VM mapping, PCI/VFIO, boot, network,
storage-topology, package, guest-power, or destructive migration mutation is
authorized. The future incremental JBOD is documentary context only.

## Evidence and completion

Follow the linked runbook. Record before/after policy, backup UPID/log/result,
catalog/config proof, device-preservation proof, VM 140 recovery semantics,
and final migration readiness in dated `evidence/`. Do not commit or push
unless separately requested.

Canonical outputs:

- update
  `/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-lore/CURRENT_STATE.md`
  with the accepted recurring-policy and VM140 recovery boundary;
- update
  `/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-lore/VALIDATION.md`
  with the VM120 receipt/config-extraction proof and explicit restore limits;
- update
  `/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-lore/TODO.md`
  to retire the obsolete PBS review wording and preserve the separately
  authorized destructive-migration boundary; and
- `README.md` is not affected because node identity and role did not change.

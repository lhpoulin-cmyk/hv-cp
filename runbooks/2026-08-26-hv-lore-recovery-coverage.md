# Runbook: clear Lore rpool-migration recovery gates

Status: completed historical validation procedure

## Purpose

Add VM 120 `truenas-lore` to Lore's established recurring
`pbs-core-lore-all-guests` policy, create and verify its first normal PBS
backup, and record VM 140 `ws-lore-agent` configuration recovery semantics.
This runbook does not migrate storage or protect the three Toshiba TrueNAS
data disks.

## Protected boundaries

Do not modify `rpool`, either P3-256 target, any Toshiba disk, VM disk
mappings, PCI/VFIO configuration, boot configuration, networking, storage
definitions, or VM 140's raw NVMe. Do not start or stop either VM solely for
this work. Never remove `backup=0` from VM 120's raw Toshiba attachments.

## Preconditions

1. Prove the host is `hv-lore`, `rpool` is ONLINE, and the exact VM, P3,
   Toshiba, and VM 140 raw-NVMe identities match the packet.
2. Capture `/etc/pve/jobs.cfg`, `/etc/vzdump.conf`, the API representation of
   all backup jobs, `pvesm status`, and the latest relevant PBS content.
3. Require `pbs-core-lore` ACTIVE with enough free capacity for VM 120's
   Proxmox-managed system disk.
4. Require the existing normal job to remain enabled, `all=1`, snapshot mode,
   schedule `02:15`, target `pbs-core-lore`, and exclusion `120,260` before
   mutation.
5. Confirm VM 120's `scsi0` is the rpool-resident managed 64G system disk and
   `scsi1`-`scsi3` are stable-id Toshiba raw disks with `backup=0`.

Stop on any mismatch.

## Policy change

Capture the exact before representation. Through the PVE API/CLI, change only
the `exclude` property on `pbs-core-lore-all-guests` from `120,260` to `260`.
Re-read the job and compare every other property. Do not create a VM120-only
job and do not alter any other backup job.

Rollback, if post-change policy validation fails before a successful backup,
is to restore only that job's exclusion to `120,260` and verify the exact
pre-state. Do not roll back merely because backup execution exposes an
ordinary diagnosable error; preserve the intended inclusion while debugging
within the packet boundary unless continued selection is unsafe.

## First VM 120 backup

Run only VM 120 with the equivalent of the normal job: target
`pbs-core-lore`, snapshot mode, and the job's existing retention/removal
semantics. Do not invoke the all-guests schedule. Capture start/end time, task
UPID, command/task log, exit status, target volume, and reported size.

Hard stop if vzdump attempts to copy `scsi1`, `scsi2`, or `scsi3`, selects a
Toshiba/P3 disk as a destination, requests a guest shutdown, or reports an
unrecoverable error.

Validate the resulting PBS catalog entry and extract/inspect the backed-up VM
configuration through installed PVE interfaces. Prove that VM configuration
and `scsi0` are represented and that the three `backup=0` raw disks are not
backup payloads. Their stable mappings may remain in the configuration; that
does not mean their contents were copied.

## VM 140 recovery record

Capture `qm config 140`, stable raw-NVMe identity, current and configured GPU
BDFs, vendor/device IDs, drivers, IOMMU group, and PCI topology. Do not run a
normal vzdump if its default semantics would copy the raw NVMe. Preserve the
configuration externally in the reviewed evidence record instead. Do not
change stale BDFs during this play.

## Final validation

Re-read the normal job, latest VM 120 backup, `rpool`, P3 identities, storage
status, guest status, and boot-tool status. PASS requires VM 120 included in
the recurring job, a verified successful VM 120 PBS backup, preserved raw
disks, recoverable VM 140 configuration, understood GPU remapping, unchanged
P3 targets, and an ONLINE `rpool`.

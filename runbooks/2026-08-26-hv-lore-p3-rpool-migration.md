# Runbook: Lore P3 rpool migration and restoration

Status: superseded for the active post-reinstall recovery by
[the old-rpool-to-P3 realization runbook](2026-08-29-hv-lore-old-rpool-to-p3-realization.md).
Retain this document as the original installer/physical-swap procedure.

## Purpose and control model

Replace Lore's NVMe rpool with a fresh PVE 9.2 ZFS mirror on the two approved
P3-256 SSDs while keeping the old NVMe mirror physically isolated and intact
as a bootable rollback environment. This is a staged console-assisted runbook:
automation must stop at every physical/installer handoff and re-prove live
identity after every boot or reconnection.

## Stage A — pre-mutation gates

1. Record repository commit, host/PVE/kernel identity, rpool status/capacity,
   boot-tool state, all guest configs/status, backup/storage/jobs state,
   network and selective host configuration, and stable physical identities.
2. Inspect VM260 and its newest `pbs-katra-vm260` archive. Extract its config
   using PVE tooling. Require a current successful archive containing VM
   configuration, EFI metadata, and system disk.
3. Prove the bootstrap PBS endpoint is independent of VM260. Prove its
   storage definition and authentication inputs can be reconstructed after
   reinstall from an external secure source. Hash/inventory secret material
   only; never emit it. A secret held only on old rpool fails closed.
4. Require active physical console, approved installer media, and an exact
   operator-confirmed disconnect/reconnect map. Record old NVMe slot/cable
   topology and rollback firmware path.
5. Re-prove the two P3 targets by model, serial, whole-disk stable ID, size,
   SMART health, mount absence, and active-pool absence. Re-prove all
   preservation disks.

Do not stop guests or mutate P3 media until all five pass.

## Stage B — final capture and graceful shutdown

Preserve exact `qm config`/`pct config` for every object plus the named host
files in the packet evidence. Do not plan a wholesale `/etc/pve` restore.
Capture the currently running set and onboot/startup policy.

Stop guests through `qm shutdown`/`pct shutdown` in dependency-aware order:
application/service guests first, storage consumers before their providers,
VM120 only after its consumers, and VM260 after PBS-dependent work is done.
Wait and validate; do not kill QEMU/LXC processes. Run `sync`, confirm old
rpool ONLINE/zero errors, then issue a normal host shutdown. Record console
confirmation that the system is powered off.

## Stage C — physical isolation and installation

Operator physically disconnects both old-rpool NVMes and, preferably, VM140
raw NVMe, jellyPool NVMe, and all three Toshiba disks. Leave visible only the
two exact P3 targets and approved installer media. Record every disconnect.

At the graphical/console installer, stop if any target identity is ambiguous.
Select only both P3 serials, ZFS RAID1, hostname `hv-lore`, and the established
management identity. Do not reproduce the old raw size or add unrelated
tuning. Before committing the installer write, the operator must verbally or
textually confirm both displayed target serials and that no preservation disk
is visible.

## Stage D — isolated first boot

With old rpool and all preservation media still isolated, prove hostname,
PVE/kernel, network, failed units, boot-tool state, and an ONLINE two-P3
mirror. Record actual zpool size. Stop if either P3 is absent or any unexpected
disk is a member. Normalize only within PVE major version 9 to the approved
repository state; reboot only if required, then repeat acceptance.

## Stage E — selective bootstrap reconstruction

Recreate hostname, management network/DNS, external `pbs-katra-vm260` storage,
required authentication/users/firewall, VFIO modules, remaining storage
definitions, and backup jobs selectively. Never restore `config.db`, all of
`/etc/pve`, or installer-generated boot files wholesale.

Require `pbs-katra-vm260` ACTIVE and the current VM260 archive visible before
restore. Restore original VMID 260 unchanged to new local-zfs, start it, and
validate guest network and PBS services. Recreate `pbs-core-lore` only after
VM260 is healthy; require its catalog visible.

## Stage F — preserved storage and guests

Power off before physical reconnection when required. Reconnect VM140 raw
NVMe, jellyPool NVMe, and the three Toshiba disks; keep both old-rpool NVMes
isolated. Boot and re-prove all identities.

Run read-only `zpool import` discovery and import only the known existing
`jellyPool`; never create or format it. Validate its health/datasets and
recreate `jelly-zfs` before VM130 restore.

Restore ordinary PBS guests in dependency-aware bounded batches, original IDs
and architecture. Inspect each config before start and validate its service,
not only its process state.

Restore VM120 from the verified PBS archive. Prove its restored payload is
only EFI/system disk, then attach the three unchanged Toshiba disks by their
exact stable IDs and preserved `backup=0` semantics. Never partition, format,
initialize, or create a pool. Start VM120 and validate existing slowPool
members, health, datasets, and expected services without repair.

Recreate VM140 from the dated external config record and stable raw-NVMe ID;
do not clone/format it. Re-enumerate PCI/IOMMU, identify the paired P6000 by
`10de:1b30` and `10de:10ef`, bind through the recorded VFIO method, and map
the fresh BDFs. Start only after config inspection. Validate raw-NVMe boot,
guest OS, GPU, driver, and an appropriate CUDA/GPU workload.

## Stage G — policy, capacity, and services

Restore `pbs-core-lore-all-guests` with `all=1`, target `pbs-core-lore`, daily
`02:15`, snapshot mode, and `exclude=260`; VM120 must remain included. Keep
retention server-owned at daily 7/weekly 4/monthly 3 and preserve the separate
VM260 bootstrap policy.

Measure actual new rpool size and allocation. Calculate thresholds from actual
size and implement WATCH 170 GiB, WARNING 180 GiB, and operator hard stop
190 GiB through an already-authorized Lore monitoring/notification mechanism.
No new monitoring stack or ZFS quota is authorized. Explicitly document zvol
logical overcommit versus physical allocation.

Validate pools, storage, guests, failed services, boot-tool, and external
service acceptance for PBS, TrueNAS, Jellyfin, DNS, monitoring, Vaultwarden,
Headscale, NTP, ntfy, and VM140 GPU workload.

## Stage H — independent P3 boot proof

Require operator console and all production guests stopped. Sync and confirm
the mirror ONLINE. Power off and physically isolate one P3 at a time:

1. boot only serial `9760522200232`; prove UEFI/PVE, expected DEGRADED rpool,
   and management reachability; shut down;
2. reconnect both, allow/verify ONLINE health, shut down;
3. boot only serial `9760511210658` and prove the same; shut down;
4. reconnect both and boot final production state; require rpool ONLINE and
   both ESPs managed.

Do not run production guests during degraded tests. Stop on unexpected
resilver/error state and do not improvise destructive repair.

## Acceptance and rollback

Acceptance requires every condition in the governing packet: restored PBS
chain, VM120 and VM140, all guests/services, capacity monitoring, two
independent P3 boots, final ONLINE mirror, and old rpool untouched/offline.

At any pre-acceptance material failure, power off the new environment,
isolate P3 if needed, reconnect the original NVMe pair exactly, select its
prior boot path, boot old Lore, prove its rpool ONLINE, and resume the old
environment. Do not import both pools named `rpool` together.

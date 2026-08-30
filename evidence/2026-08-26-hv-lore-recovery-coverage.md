# hv-lore recovery coverage and backup policy gate

Date: 2026-08-26
Host: `hv-lore`
Packet: `implementation/2026-08-26-hv-lore-recovery-coverage.packet.md`
Runbook: `runbooks/2026-08-26-hv-lore-recovery-coverage.md`

## Result

**PASS — the rpool-migration recovery gates are cleared.** The existing
normal job `pbs-core-lore-all-guests` was changed only from
`exclude=120,260` to `exclude=260`. VM 120 is now durably selected by that
daily policy. Its first normal encrypted PBS snapshot backup completed with
exit status `OK`, and PVE catalog/config extraction verified the intended
payload.

VM 140's recovery boundary is also established without cloning its raw NVMe.
Its configuration, stable raw-NVMe identity, and current GPU mapping are
recorded here. A fresh normal VM140 backup was intentionally not run because
its raw NVMe has default backup eligibility; doing so would clone the raw disk
and contradict this packet.

No rpool, boot, P3 target, Toshiba data, VM140 raw-NVMe, VM mapping, PCI/VFIO,
network, storage-topology, package, reboot, or guest-power mutation occurred.

## Required report

```text
PLAY=HV-LORE-RPOOL-RECOVERY-COVERAGE

TARGET=hv-lore

HOST_IDENTITY=PASS

RPOOL_MUTATION=NONE
BOOT_MUTATION=NONE
P3_TARGET_MUTATION=NONE
TOSHIBA_DATA_MUTATION=NONE
VM140_RAW_NVME_MUTATION=NONE

RPOOL_HEALTH=ONLINE; zero errors
RPOOL_ALLOCATED=138739023872 bytes (129.211 GiB) final

NORMAL_BACKUP_JOB=pbs-core-lore-all-guests
NORMAL_BACKUP_TARGET=pbs-core-lore -> datastore pbs-core, namespace lore
NORMAL_BACKUP_SCHEDULE=daily 02:15
NORMAL_BACKUP_RETENTION=server-owned pbs-core-retention: daily 7, weekly 4, monthly 3; no client prune-backups

VM120_NAME=truenas-lore
VM120_ADDED_TO_NORMAL_POLICY=YES
VM120_BACKUP_CREATED=YES
VM120_BACKUP_ID=pbs-core-lore:backup/vm/120/2026-08-26T15:51:52Z
VM120_BACKUP_DATE=2026-08-26 11:51:52-04:00 through 11:57:24-04:00
VM120_BACKUP_SIZE=68720018587 bytes catalog logical size; 13.484375 GiB observed PBS storage-use increase
VM120_CONFIG_INCLUDED=YES
VM120_RPOOL_SYSTEM_DISK_INCLUDED=YES

VM120_TOSHIBA_DISKS_EXPECTED_IN_PBS=NO
VM120_TOSHIBA_DISKS_PRESERVED=YES
VM120_TOSHIBA_IDENTITIES_PROVEN=YES

TRUENAS_SECONDARY_DATA_BACKUP=INCREMENTAL_JBOD
JBOD_IN_SCOPE_TODAY=NO
JBOD_REQUIRED_FOR_RPOOL_MIGRATION=NO

VM120_RECOVERY_COVERAGE=PASS

VM140_NAME=ws-lore-agent
VM140_CONFIG_RECOVERABLE=YES
VM140_BACKUP_REFRESHED=NO; intentionally avoided raw-NVMe clone

VM140_RAW_NVME_SERIAL=TP250916B5D0198
VM140_RAW_NVME_BY_ID=/dev/disk/by-id/nvme-Timetec_PCIe_SSD_TP250916B5D0198
VM140_RAW_NVME_PRESERVED=YES
VM140_RAW_NVME_OUTSIDE_RPOOL=YES
VM140_RAW_NVME_OUTSIDE_P3_TARGETS=YES

VM140_GPU_CONFIGURED_BDF=0000:06:00.0,0000:06:00.1
VM140_GPU_CURRENT_BDF=0000:04:00.0,0000:04:00.1
VM140_GPU_IDENTITY_PROVEN=YES
VM140_GPU_RESTORE_MAPPING_UNDERSTOOD=YES

P3_TARGET_1=/dev/disk/by-id/ata-P3-256_9760522200232
P3_TARGET_2=/dev/disk/by-id/ata-P3-256_9760511210658
P3_TARGETS_UNCHANGED=YES

CURRENT_DATA_FITS_TARGET=YES

RECOVERY_BLOCKERS=NONE
OTHER_BLOCKERS=NONE within this gate; destructive migration still requires its own packet

MIGRATION_READINESS=READY

NEXT_PLAY=author destructive hv-lore migration: fresh Proxmox install on mirrored P3-256 rpool; selective host restoration; guest restoration; passthrough validation; capacity guardrails; dual-P3 independent boot proof; old NVMe rpool retained as rollback authority
```

## Policy before and after

The normal job had this exact pre-state:

```text
all=1
enabled=1
exclude=120,260
mode=snapshot
node=hv-lore
remove=1
repeat-missed=1
schedule=02:15
storage=pbs-core-lore
```

The PVE-owned API command changed only `exclude` to `260`. Post-readback
confirmed all other fields byte-for-field equivalent at the API-property
level. No VM120-only job was created; the disabled `arpa-all-guests` and
separate VM260 recovery job were unchanged.

The client job intentionally has no `prune-backups`. The accepted centralized
retention boundary remains PBS server job `pbs-core-retention` at 04:40 with
daily 7, weekly 4, and monthly 3; datastore garbage collection and verification
remain PBS authority.

## VM 120 attachment classification

| Attachment | Source | On rpool | PVE managed | Backup eligible | Expected in vzdump |
|---|---|---|---|---|---|
| `efidisk0` | `local-zfs:vm-120-disk-0`, 1M | yes | yes | yes | yes |
| `scsi0` | `local-zfs:vm-120-disk-1`, 64G | yes | yes | yes | yes |
| `scsi1` | `ata-TOSHIBA_HDWG51CUZSVA_16N2A042FWUH`, 11176G | no | no; raw | no (`backup=0`) | no |
| `scsi2` | `ata-TOSHIBA_HDWG51CUZSVA_16X2A00KFWUH`, 11176G | no | no; raw | no (`backup=0`) | no |
| `scsi3` | `ata-TOSHIBA_HDWG51CUZSVA_16N2A02XFWUH`, 11176G | no | no; raw | no (`backup=0`) | no |

The three Toshiba disks resolved before and after to serials
`16N2A02XFWUH`, `16N2A042FWUH`, and `16X2A00KFWUH`. Their content was neither
read as backup payload nor modified. Their future secondary protection is an
incrementally built JBOD and is separate from Proxmox VM recovery.

## VM 120 receipt and recovery proof

- Start: `2026-08-26 11:51:52 EDT`.
- End: `2026-08-26 11:57:24 EDT`; duration 5m32s.
- PVE task:
  `UPID:hv-lore:00323289:05AB94EF:6A8F0B97:vzdump:120:root@pam:`.
- PBS/QEMU backup task: `045be284-7066-4d5d-ad85-b6028fde2b7f`.
- Archive: `vm/120/2026-08-26T15:51:52Z` on `pbs-core-lore`.
- Status: `OK`; VM remained running; snapshot mode used QGA freeze/thaw.
- Encryption was enabled.
- Task log explicitly included only 64G `scsi0` and 1M `efidisk0`, and
  explicitly excluded `scsi1`-`scsi3` as `backup=no`.
- The transfer scanned 64G, reported 16.44 GiB zero data and 16.44 GiB reused,
  and finished successfully.
- `pvesm list` returned catalog size 68,720,018,587 bytes. PBS storage use
  rose from 591,759,360 KiB to 605,898,752 KiB (13.484375 GiB); this is not a
  restore-size claim.
- `pvesm extractconfig` decrypted and returned the VM configuration. Its
  `#qmdump#map` contains exactly `efidisk0` and `scsi0`; no Toshiba attachment
  appears as a payload map. The stable Toshiba attachment lines remain in the
  configuration so they can be reattached after host recovery.

This proves backup receipt and configuration/payload selection. It is not a
full restore drill or PBS verification-job receipt.

## VM 140 recovery semantics

VM 140 remained stopped. Its primary disk is
`/dev/disk/by-id/nvme-Timetec_PCIe_SSD_TP250916B5D0198`, resolving at capture
to `/dev/nvme1n1`, model `Timetec PCIe SSD`, serial `TP250916B5D0198`, size
512,110,190,592 bytes. It is neither current rpool member
(`nvme-eui.6479a7b01ad00f81-part3` and
`nvme-eui.6479a7b01ad00df5-part3`) nor either SATA P3 target.

The raw disk's `scsi0` line has no `backup=0`, so ordinary vzdump semantics
would treat it as eligible. The older catalog entry's approximately 477 GiB
logical size corroborates that behavior. A fresh VM140 vzdump was therefore
not a safe configuration-only mechanism. This evidence record is the fresh
external configuration artifact; the raw device remains the preserved data
authority.

The VM configuration needed for restoration is:

```text
name: ws-lore-agent
bios: ovmf
machine: q35
boot: order=ide2;scsi0
efidisk0: local-zfs:vm-140-disk-0,efitype=4m,pre-enrolled-keys=0,size=1M
tpmstate0: local-zfs:vm-140-disk-1,size=4M,version=v2.0
scsi0: /dev/disk/by-id/nvme-Timetec_PCIe_SSD_TP250916B5D0198,cache=none,discard=on,size=500107608K,ssd=1
hostpci0: 0000:06:00.0,pcie=1
hostpci1: 0000:06:00.1,pcie=1
```

The configured `06:00.0` and `06:00.1` functions do not exist in the current
PCI tree; bus 06 is an empty downstream bridge. The only live Quadro P6000
pair is:

| Current BDF | Identity | Driver | IOMMU group |
|---|---|---|---:|
| `0000:04:00.0` | NVIDIA GP102GL Quadro P6000 `10de:1b30`, subsystem `103c:11a0` | `vfio-pci` | 100 |
| `0000:04:00.1` | NVIDIA GP102 HDMI Audio `10de:10ef`, subsystem `103c:11a0` | `vfio-pci` | 100 |

Classification is `CONFIG_STALE`. An earlier enumeration change is possible,
but current evidence alone does not prove when or why the BDF changed. Restore
mapping is nevertheless understood: after reinstall and fresh PCI/IOMMU
enumeration, identify the paired P6000 functions by IDs/topology and set the
restored VM's two `hostpci` mappings to those current BDFs under a separate
authorized validation step. This play did not edit them.

## Final safety/readiness state

Final `rpool` remained ONLINE with zero read/write/checksum errors and
138,739,023,872 bytes allocated. Both P3 stable IDs still resolved to the same
serials; both managed NVMe ESPs remained unchanged under UEFI+GRUB. VM 120
remained running, VM 140 remained stopped, and all other observed guest power
states were unchanged. `pbs-core-lore` remained active with 5,253,476,352 KiB
available after the backup.

The recovery gate is READY. This does not authorize or begin destructive
migration.

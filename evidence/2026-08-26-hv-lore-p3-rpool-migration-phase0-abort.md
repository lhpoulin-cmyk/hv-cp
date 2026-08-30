# hv-lore P3 rpool migration — Phase 0 abort

Date: 2026-08-26
Host: `hv-lore`
Packet: `implementation/2026-08-26-hv-lore-p3-rpool-migration.packet.md`
Runbook: `runbooks/2026-08-26-hv-lore-p3-rpool-migration.md`

## Result

**ABORTED BEFORE DESTRUCTIVE WORK.** The required VM260 bootstrap archive is
current and readable, but its PBS server is VM242 `pbs-katra`, whose appliance
disks are on the same Lore rpool that this migration would replace. The
bootstrap target therefore does not survive Lore shutdown/reinstallation.

The dedicated API-token secret is also held only in current PVE private
storage at `/etc/pve/priv/storage/pbs-katra-vm260.pw`. No approved external
secret escrow or post-reinstall credential source was proven. The secret was
not printed or copied.

No guest was stopped. No host shutdown/reboot occurred. Neither P3 target nor
any ZFS pool, disk, boot entry, VM, network, storage definition, credential,
or backup policy was mutated.

## Phase-0 evidence

```text
HOST=hv-lore

VM260_NAME=pbs-core
VM260_BOOTSTRAP_BACKUP_PRESENT=YES
VM260_BOOTSTRAP_BACKUP_CURRENT=YES
VM260_BOOTSTRAP_TARGET=pbs-katra-vm260
VM260_BOOTSTRAP_ARCHIVE=pbs-katra-vm260:backup/vm/260/2026-08-26T05:30:01Z
VM260_BOOTSTRAP_ARCHIVE_SIZE=68720018397 bytes
VM260_BOOTSTRAP_CONFIG_EXTRACTED=YES
VM260_BOOTSTRAP_PAYLOAD=efidisk0 + scsi0
VM260_RESTORE_DOES_NOT_DEPEND_ON_PBS_CORE=YES
VM260_RESTORE_SURVIVES_HV_LORE_RPOOL_REPLACEMENT=NO

PBS_KATRA_SERVER=192.168.10.242
PBS_KATRA_SERVER_IDENTITY=VM242 pbs-katra on hv-lore
PBS_KATRA_SERVER_RPOOL_DEPENDENCY=YES
PBS_KATRA_VM_EFI=rpool/data/vm-242-disk-0
PBS_KATRA_VM_SYSTEM_DISK=rpool/data/vm-242-disk-1
PBS_KATRA_LIVE_IP_PROVEN=192.168.10.242 on VM242 ens18

PBS_KATRA_STORAGE_USER=vm260-recovery@pbs!hv-lore
PBS_KATRA_STORAGE_FINGERPRINT=06:0e:8b:f0:c4:fb:99:7c:dc:33:bc:c7:e9:90:56:3b:05:ca:87:91:d4:fd:64:c9:49:a0:ab:84:4e:3c:27:cb
PBS_KATRA_SECRET_PRESENT=YES
PBS_KATRA_SECRET_EXTERNAL_ESCROW_PROVEN=NO
PBS_KATRA_SECRET_LOCATION=/etc/pve/priv/storage/pbs-katra-vm260.pw on old Lore rpool only
PBS_KATRA_SECRET_METADATA=root:www-data mode 0600 size 37 bytes
PBS_KATRA_SECRET_SHA256=40a28ef9d6866f6f0fefaf8a157bcddbe63026e869b804e1f0bcd7061821a0a7
PBS_KATRA_SECRET_CONTENT_CAPTURED=NO

PHASE0_BOOTSTRAP_GATE=FAIL
MIGRATION=ABORT
P3_DESTRUCTION=NONE
```

`pvesm list` proved eight daily VM260 archives through the current date.
`pvesm extractconfig` successfully returned VM260 configuration and exactly
two payload maps, `efidisk0` and `scsi0`. The archive itself is not defective.
The failure is placement/dependency: its serving PBS appliance is VM242 on
Lore `local-zfs`.

VM242 was running and live guest-agent evidence tied MAC
`bc:24:11:87:2e:06` to `192.168.10.242`. Its PVE configuration names
`local-zfs:vm-242-disk-0` and `local-zfs:vm-242-disk-1`; ZFS resolved those as
`rpool/data/vm-242-disk-0` and `rpool/data/vm-242-disk-1`. Thus the target
cannot serve a restore after the old rpool is physically isolated.

The credential file was inventoried by path, owner, mode, size, modification
time, and SHA-256 only. Canonical evidence already described this secret as
held only in PVE private storage; the live check confirmed that condition.

## Required corrective authority

Before rerunning this migration, establish and drill a bootstrap chain that
survives total Lore rpool loss. At minimum it must provide:

1. a PBS server or equivalent restore endpoint hosted independently of
   `hv-lore` and available while all Lore guests are stopped;
2. a current VM260 archive on that endpoint;
3. an approved secure external source for the target definition, token secret,
   fingerprint, and any encryption key, without storing secrets in Git; and
4. a restore drill from a fresh/independent PVE client proving VM260 can be
   recovered without old Lore or VM260.

Moving VM242, creating/rotating credentials, choosing secret escrow, copying
archives, or changing PBS topology are separate live/security decisions and
were not improvised under this migration packet.

## Required report

```text
PLAY=HV-LORE-P3-RPOOL-MIGRATION

TARGET=hv-lore

OLD_RPOOL_MUTATION=NONE
OLD_RPOOL_ROLLBACK_PRESERVED=YES

TARGET_1=/dev/disk/by-id/ata-P3-256_9760522200232
TARGET_1_SERIAL=9760522200232

TARGET_2=/dev/disk/by-id/ata-P3-256_9760511210658
TARGET_2_SERIAL=9760511210658

P3_INSTALL=NOT_STARTED

NEW_PVE_VERSION=NOT_APPLICABLE
NEW_KERNEL=NOT_APPLICABLE

NEW_RPOOL_TOPOLOGY=NOT_CREATED
NEW_RPOOL_SIZE=NOT_APPLICABLE
NEW_RPOOL_ALLOCATED=NOT_APPLICABLE
NEW_RPOOL_HEALTH=NOT_APPLICABLE

P3_1_BOOTABLE=NOT_TESTED
P3_2_BOOTABLE=NOT_TESTED
BOOT_REDUNDANCY=NOT_TESTED

PBS_BOOTSTRAP_SOURCE=pbs-katra-vm260; invalid as independent bootstrap because its server VM242 resides on old hv-lore rpool
VM260_RESTORED=NO
PBS_CORE_LORE_RESTORED=NO

JELLYPOOL_IMPORTED=NO
JELLYPOOL_MUTATION=NONE

VM120_RESTORED=NO
VM120_SYSTEM_DISK_RESTORED=NO
VM120_TOSHIBA_MAPPINGS_RESTORED=NO
VM120_SLOWPOOL_HEALTH=NOT_TESTED
VM120_DATA_MUTATION=NONE
VM120_REGULAR_BACKUP_POLICY=YES on unchanged old environment

VM140_RECONSTRUCTED=NO
VM140_RAW_NVME_SERIAL=TP250916B5D0198
VM140_RAW_NVME_PRESERVED=YES
VM140_GPU_CURRENT_BDF=0000:04:00.0,0000:04:00.1 on unchanged old environment
VM140_GPU_PASSTHROUGH=NOT_TESTED

VM_COUNT_EXPECTED=10
VM_COUNT_PRESENT=10 on unchanged old environment
CT_COUNT_EXPECTED=7
CT_COUNT_PRESENT=7 on unchanged old environment

GUEST_RESTORE=NOT_STARTED
SERVICE_ACCEPTANCE=NOT_STARTED

CAPACITY_WATCH=170 GiB
CAPACITY_WARNING=180 GiB
CAPACITY_HARD_STOP=190 GiB
CAPACITY_MONITORING=NOT_STARTED

PREEXISTING_WARNINGS=pbs-katra VM242 and its credential are hosted only on the hv-lore environment they are expected to bootstrap
NEW_WARNINGS=NONE; no migration mutation occurred
BLOCKERS=Phase-0 circular bootstrap dependency and no proven external credential escrow

MIGRATION_ACCEPTANCE=FAIL

OLD_NVME_RPOOL_DISPOSITION=ONLINE_UNCHANGED_CURRENT_PRODUCTION; intended future disposition remains OFFLINE_ROLLBACK

NEXT_PLAY=externalize and drill the VM260 bootstrap authority plus secure credential recovery, then rerun migration from Phase 0
```

```text
BLOCKER=VM260 bootstrap target and credential do not survive replacement of hv-lore rpool
operation=stop guests, destroy the two P3 targets, and begin fresh installation
observed=pbs-katra-vm260 is served by VM242 at 192.168.10.242; VM242 EFI/system disks are on hv-lore rpool; token secret exists only in current /etc/pve/priv
expected=an independently hosted restore endpoint and externally recoverable authentication available after old rpool isolation
authority=operator Phase-0 hard stop and hv-cp fail-closed destructive-migration doctrine
why_not_ordinary_debugging=fixing this requires a new PBS placement/topology and credential-escrow security decision before destructive work; the current archive itself is healthy
```

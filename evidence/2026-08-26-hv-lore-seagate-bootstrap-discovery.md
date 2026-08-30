# hv-lore Seagate bootstrap discovery

Date: 2026-08-26 EDT

Packet: [`../implementation/2026-08-26-hv-lore-seagate-bootstrap-discovery.packet.md`](../implementation/2026-08-26-hv-lore-seagate-bootstrap-discovery.packet.md)

## Outcome

After the drive was absent from `hv-lore`, the operator directed inspection of
its documented host. The exact Seagate Expansion was identified on
`hv-matrix`, mounted read-only, inspected, and cleanly unmounted. No disk,
filesystem, guest, PVE, ZFS, credential, or boot content was changed.

The drive provides real recovery material but not an independently complete
VM260 bootstrap. Classification is `FOUND_PARTIAL`.

## Direct identity and access evidence

- Lore remained `hv-lore`, PVE 9.2.6, kernel `7.0.14-8-pve`, with ONLINE
  472G NVMe `rpool`, 129G allocated, zero device errors and no known data
  errors. VM260 remained `pbs-core`; VM242 remained `pbs-katra`.
- Inspection host: `hv-matrix`, HP Z4 G4, PVE 9.2.2, kernel `7.0.2-6-pve`.
- Device: `/dev/sdc`, model `Expansion HDD`, serial `00000000NT1H79L3`, USB,
  6,001,175,125,504 bytes (5.46 TiB).
- Stable ID: `/dev/disk/by-id/usb-Seagate_Expansion_HDD_00000000NT1H79L3-0:0`.
- SMART identity/health passthrough was unsupported by the USB bridge with
  default and SAT modes; health is UNKNOWN, not failed or passed.
- GPT: 200 MiB FAT32 EFI plus 5.5 TiB exFAT. `sgdisk` reported a
  protective-MBR size mismatch; no repair or write occurred.
- Data partition: stable by-id suffix `-part2`, label `Expansion`, UUID
  `011D-FABB`, exFAT 1.0.
- Access: `/dev/sdc2` mounted at `/mnt/helix-arpa-football` with verified
  `ro,nosuid,nodev,noexec`; 5.5T total, 2.2T used, 3.4T free (39%). It was
  cleanly unmounted and final `lsblk` showed no mountpoint.

## VM260 finding

An exact whole-drive filename search returned zero objects containing `260`.
There is no standalone vzdump/VMA, disk image, configuration export, or direct
PBS backup group for VM260 on the exFAT filesystem. Current VM260 config hash
on Lore is `d7b7acc32120c31c1c2770d0da8bc1edc52fba13a680ef6771a2635b188ed4ce`;
there is no Seagate VM260 config hash to compare.

The live `pbs-katra-vm260` catalog still contains eight daily VM260 archives
through `2026-08-26T05:30:01Z`, but that catalog is not stored as an
independently consumable structure on the Seagate.

## pbs-core datastore cold stream

The drive contains a full, non-incremental ZFS send stream of
`slowPool/backup/pbs/pbs-core@football-2026-08-11`:

- `helix-arpa-football/pbs-core-dr/archives/pbs-core-2026-08-11.zfs`
- 536,241,455,560 bytes
- recorded SHA-256
  `b0e072c8b1669d1667ec60f7c8bc6f63431354e7144ea5730a6c96109305625d`
- retained metadata records `DRR_END`, 4,709,073 parsed records, no parser
  errors, and stream length equal to file size.

The exFAT tree has no `.chunks`, `index.json.blob`, manifest, or owner markers.
It is a cold ZFS stream, not a directly attachable PBS datastore. The stream
was not re-hashed or re-parsed end-to-end today; its size and acceptance
metadata match the 2026-08-12 validation.

## VM242 pbs-katra bridge

Five standalone VM242 archives exist from 2026-06-28 through 2026-07-20. The
newest is `vzdump-qemu-242-2026_07_20-07_19_26.vma.zst`, 1,268,049,723 bytes.
`zstd -t` passed. Streaming `vma config` and `vma list` proved complete VM242
configuration, its 540,672-byte EFI disk, and 68,719,476,736-byte system disk.

VM242 is locally restorable with `qmrestore`, but this alone does not expose
VM260. Live guest-agent inspection proved datastore `hv-katra` is mounted at
`/mnt/bigtank.pbs-katra` from
`192.168.100.111:/mnt/slowPool/backup/pbs/pbs-katra`. That is VM120 TrueNAS
storage, not Seagate storage.

## VM120 and credentials

The Seagate has only an incomplete VM120 temporary directory from 2026-05-23;
there is no completed VM120 archive. `truenas-configs/truenas-lore` and
`truenas-configs/truenas-katra` exist but are empty. No host-level PVE
configuration or filename indicating a bootstrap credential, API token,
escrow, or recovery key was found. No secret content was displayed.

## Protection matrix

| ARTIFACT | PRESENT | DATE | COMPLETE | BOOTSTRAP RELEVANCE |
|---|---|---:|---|---|
| VM260 standalone appliance archive | NO | — | NO | Direct bootstrap requirement not met |
| `pbs-core` datastore ZFS stream | YES | 2026-08-11 | YES as a ZFS stream | Needs receive and temporary PBS; no proven VM260 appliance backup |
| VM242 `pbs-katra` standalone VMA | YES | 2026-07-20 | YES | Restores PBS appliance, but datastore depends on VM120 `slowPool` |
| VM120 `truenas-lore` archive | NO | 2026-05-23 temporary only | NO | Cannot independently expose `slowPool` |
| TrueNAS configuration export | NO | empty directories | NO | No appliance reconstruction seed |
| External bootstrap credential | NO | — | NO | Current Lore client secret remains outside Seagate |

## Material artifact table

| ARTIFACT | PATH | DATE | SIZE | COMPLETE | RECOVERY ROLE |
|---|---|---:|---:|---|---|
| pbs-core datastore ZFS stream | `helix-arpa-football/pbs-core-dr/archives/pbs-core-2026-08-11.zfs` | 2026-08-11 | 536,241,455,560 | YES, retained structural proof | `zfs receive` plus PBS under separate authority |
| pbs-core metadata | `helix-arpa-football/pbs-core-dr/metadata/pbs-core-2026-08-11.yaml` | 2026-08-12 | 853 | YES | Non-secret hash and structural receipt |
| VM242 pbs-katra VMA | `truenas-katra/tank-arpa/backups/proxmox/hv-lore/dump/vzdump-qemu-242-2026_07_20-07_19_26.vma.zst` | 2026-07-20 | 1,268,049,723 | YES | Local `qmrestore`; backing NFS remains external |
| VM120 temporary backup | `truenas-katra/tank-arpa/backups/proxmox/hv-lore/dump/vzdump-qemu-120-2026_05_23-17_00_13.tmp` | 2026-05-23 | config file 0 bytes | NO | Not restorable |
| VM260 artifact | none | — | — | NO | Missing direct bootstrap artifact |

## Required report

```text
PLAY=HV-LORE-SEAGATE-BOOTSTRAP-DISCOVERY

TARGET=hv-lore; inspection device hosted by hv-matrix
MODE=READ_ONLY

HOST_IDENTITY=PASS

RPOOL_MUTATION=NONE
P3_TARGET_MUTATION=NONE
SEAGATE_MUTATION=NONE
GUEST_MUTATION=NONE
BOOT_MUTATION=NONE

RPOOL_HEALTH=ONLINE

SEAGATE_PRESENT=YES_ON_HV_MATRIX
SEAGATE_DEVICE=/dev/sdc
SEAGATE_MODEL=Expansion HDD
SEAGATE_SERIAL=00000000NT1H79L3
SEAGATE_SIZE=6001175125504 bytes / 5.46 TiB
SEAGATE_BY_ID=/dev/disk/by-id/usb-Seagate_Expansion_HDD_00000000NT1H79L3-0:0
SEAGATE_SMART=UNKNOWN_USB_BRIDGE_PASSTHROUGH_UNSUPPORTED

SEAGATE_PARTITION_LAYOUT=GPT; 200MiB EFI + 5.5TiB Microsoft basic data
SEAGATE_FILESYSTEMS=FAT32 EFI UUID 67E3-17ED; exFAT Expansion UUID 011D-FABB
SEAGATE_MOUNT_STATE=UNMOUNTED_FINAL
SEAGATE_READONLY_ACCESS=PASS

PBS_DATASTORE_STRUCTURE_PRESENT=NO_DIRECT_STRUCTURE; COMPLETE_ZFS_SEND_STREAM_PRESENT
PBS_DATASTORE_PATH=inside cold stream of slowPool/backup/pbs/pbs-core

VM260_ARTIFACT_FOUND=NO
VM260_ARTIFACT_TYPE=NONE
VM260_BACKUP_ID=NONE_ON_SEAGATE
VM260_BACKUP_DATE=NONE
VM260_BACKUP_SIZE=NONE

VM260_CONFIG_INCLUDED=NO
VM260_REQUIRED_DISKS_INCLUDED=NO
VM260_ARCHIVE_STRUCTURALLY_COMPLETE=NO
VM260_BACKUP_FRESHNESS=NO_VM260_ARCHIVE

BOOTSTRAP_CREDENTIAL_PRESENT=NO
BOOTSTRAP_CREDENTIAL_APPEARS_INDEPENDENT=NO
BOOTSTRAP_CREDENTIAL_SECRET_EXPOSED=NO

HV_LORE_HOST_CONFIG_PRESENT=NO
PBS_CORE_ARTIFACTS_PRESENT=YES_PARTIAL
OTHER_RECOVERY_ARTIFACTS=complete VM242 VMA; complete pbs-core datastore stream; mixed historical Lore vzdumps; incomplete VM120 temp; empty TrueNAS config directories

SEAGATE_PHYSICAL_DEVICE_INDEPENDENT_FROM_RPOOL=YES
SEAGATE_CONTENT_READABLE_WITHOUT_VM120=YES
SEAGATE_CONTENT_READABLE_WITHOUT_VM242=YES
SEAGATE_CONTENT_READABLE_WITHOUT_VM260=YES

RESTORE_TOOL_REQUIRED=qmrestore for VM242; zfs receive plus temporary PBS for pbs-core datastore stream
PBS_SERVER_REQUIRED=YES_FOR_DATASTORE_CONSUMPTION
LOCAL_FILE_RESTORE_POSSIBLE=YES_FOR_VM242; NO_FOR_VM260
EXTERNAL_CREDENTIAL_REQUIRED=YES_OR_SEPARATELY_AUTHORIZED_REPLACEMENT_CREDENTIAL

SEAGATE_BOOTSTRAP_STATUS=FOUND_PARTIAL

CURRENT_MIGRATION_BLOCKER=no standalone VM260 artifact; VM242 datastore depends on unavailable VM120 slowPool service; no completed VM120 seed or independent credential
BLOCKERS=bootstrap chain cannot reach current VM260 catalog without reconstructing missing VM120/PBS/auth dependencies

MIGRATION_READINESS=NOT_READY

NEXT_PLAY=bounded creation and validation of a standalone VM260 vzdump/VMA on the proven Seagate, including EFI, system disk, configuration, checksum, and independent qmrestore drill; do not create new PBS infrastructure or begin P3 migration
```

## Blocker record

```text
BLOCKER=Seagate recovery set is real but cannot independently restore VM260
operation=accept Seagate as the Phase-0 bootstrap authority for destructive Lore migration
observed=complete pbs-core datastore stream and VM242 appliance VMA exist; no VM260 artifact, completed VM120 seed, TrueNAS config export, native pbs-katra datastore copy, or credential escrow exists
expected=a complete local VM260 artifact or a fully independent, proven chain to the current VM260 PBS archive
authority=operator bootstrap success condition and hv-cp fail-closed destructive-migration doctrine
why_not_ordinary_debugging=closing the gap requires creating a durable recovery artifact and later exercising a restore under separate mutation authority; discovery cannot manufacture missing data
```

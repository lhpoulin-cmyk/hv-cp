# hv-lore old-rpool-to-P3 recovery state

Date opened: 2026-08-29
Packet: [old-rpool-to-P3 realization](../implementation/2026-08-29-hv-lore-old-rpool-to-p3-realization.packet.md)
Runbook: [old-rpool-to-P3 realization](../runbooks/2026-08-29-hv-lore-old-rpool-to-p3-realization.md)

## Governing correction

The operator established that the historical Timetec rpool is authoritative
pre-reinstall recovery state, not merely offline rollback evidence. Recovery
copies named host and guest objects from that exact read-only source to the
production P3-256 rpool and reconciles documentation after each accepted
object.

```text
SOURCE_GUID=8921639095104950851
SOURCE_ROLE=AUTHORIZED_READ_ONLY_MIGRATION_SOURCE
SOURCE_MEMBERS=TP250913B5D3323,TP250913B5D1797
DESTINATION_GUID=4137356908105663872
DESTINATION_MEMBERS=ata-P3-256_9760522200232-part3,ata-P3-256_9760511210658-part3
MIN_RPOOL_FREE_PERCENT=20
```

Earlier records that classify the historical media as physical-presence-only
or offline-rollback-only remain valid evidence of their dated authority, but
are superseded for the active recovery window by this correction.

## Accepted state at opening

Operator-reported accepted state:

```text
HOST_BASELINE=ACCEPTED
VM120_RUNNING=YES
VM120_QGA=PASS
SLOWPOOL=HEALTHY
VM120_TOSHIBA_MAPPINGS=PASS
VM260_RUNNING=YES
PBS_SERVICE=PASS
PBS_CORE_LORE=AVAILABLE
BACKUP_CONTENT_VISIBLE=PASS
CT252_RUNNING=YES
DNS_SERVICE=ACTIVE
PBS_REAL_RESTORE_PROOF=PASS
OLD_RPOOL_IMPORTED=NO
RPOOL_ALLOC_GIB=34.29
RPOOL_FREE_GIB=201.71
RPOOL_FREE_PERCENT=85.47
```

CT252 recovery copied and verified its authoritative historical syslog dataset
to `rpool/data/subvol-252-syslog`; CT252 then started and passed DNS acceptance.
The source pool was exported. Do not restore CT252 again.

## Historical next object at opening

The following was pending when this append-only migration record opened. It
was subsequently completed and is not a current action.

```text
OBJECT=HOST_OPERATOR_SSH_REALIZATION
SOURCE=HISTORICAL_RPOOL_ROOT_DATASET
DESTINATION=PRODUCTION_P3_HOST_ROOT
AUTHORITY=AUTH_CP_FOUNDATION_PLUS_AUTHORITATIVE_PRE_REINSTALL_STATE
MUTATION=NOT_YET_RECORDED
```

The old root must resolve the exact `louis` Unix identity and prior target-side
SSH realization before mutation. Secret values are never recorded here.

### Automation identity collision resolution

The authoritative old root established the exact pre-reinstall mapping:

```text
LOUIS=1000:1000;PRIMARY=louis;SUPPLEMENTAL=sudo,users
ANSIBLE_OBSERVER=1002:1002;PRIMARY=ansible-observer
ANSIBLE_EXECUTOR=1003:1003;PRIMARY=ansible-executor
```

The fresh reinstall had assigned `1000:1000` to `ansible-observer` and
`1001:1001` to `ansible-executor`. `auth-cp` governs their distinct account
names, credentials, lock state, and privilege posture but does not reserve
those temporary numeric IDs. The operator applied a collision-safe local
realignment, preserving the accounts and their owned files:

```text
AUTOMATION_IDENTITY_REALIGNMENT=PASS
ANSIBLE_OBSERVER=1002:1002
ANSIBLE_EXECUTOR=1003:1003
LOUIS_IDENTITY_1000_AVAILABLE=YES
ROLLBACK_BACKUP=/root/hv-lore-automation-id-pre.snKxCH
OLD_RPOOL_IMPORTED=NO
```

This completes the prerequisite for realizing authoritative `louis=1000:1000`.
It does not itself create `louis` or change SSH daemon policy.

## Accepted-object append format

Append, do not rewrite, one section per accepted object:

```text
OBJECT=
SOURCE_IDENTITY=
DESTINATION_IDENTITY=
COPY_VERIFICATION=
SERVICE_ACCEPTANCE=
OLD_RPOOL_IMPORTED=NO
RPOOL_ALLOC_GIB=
RPOOL_FREE_GIB=
RPOOL_FREE_PERCENT=
CANONICAL_DOCS_UPDATED=
NEXT_OBJECT=
```

## Accepted object: host operator SSH realization

Operator-reported completion from the exact historical root authority:

```text
OBJECT=HOST_OPERATOR_SSH_REALIZATION
SOURCE_IDENTITY=HISTORICAL_RPOOL_ROOT_DATASET_GUID_8921639095104950851
DESTINATION_IDENTITY=HV_LORE_PRODUCTION_P3_HOST_ROOT
LOUIS_REALIZATION_AUTHORITY=OLD_RPOOL_PLUS_AUTH_CP_FOUNDATION
LOUIS_ACCOUNT_CREATED=YES_OR_ALREADY_EXACT
LOUIS_IDENTITY=1000:1000
LOUIS_PRIMARY_GROUP=louis
LOUIS_SUPPLEMENTAL_GROUPS=sudo,users
SSH_CA_TRUST_RESTORED=YES
SSH_CA_PATH=/etc/ssh/trusted_user_ca_keys.d/lab-user-ca.pub
AUTHORIZED_PRINCIPALS_PATH=/etc/ssh/auth_principals/%u
LAB_ADMIN_PRINCIPAL_RESTORED=YES
SSHD_VALIDATION=PASS
SSH_RELOAD=PASS
OLD_RPOOL_IMPORTED=NO
ROLLBACK_BACKUP=/root/hv-lore-operator-ssh-pre.hwpaM0
MUTATION=BOUNDED_ACCOUNT_AND_SSH_OPERATOR_REALIZATION
CANONICAL_DOCS_UPDATED=RECOVERY_EVIDENCE_APPENDED
NEXT_OBJECT=DIRECT_OPERATOR_SSH_AND_PVE_CONTROL_PLANE_READ_ONLY_VALIDATION
```

The authoritative recovered SSH drop-in also preserves
`PubkeyAuthentication yes`, `PermitRootLogin no`, `PasswordAuthentication
no`, and `KbdInteractiveAuthentication no`. No CA private key or unmanaged
operator key was copied to `hv-lore`.

## Superseding operating classification

The operator subsequently clarified that this work is a planned
`hv-lore` migration/reinstallation, not a disaster-recovery exercise. The
storage/source precedence used for the completed migration was:

```text
CURRENT_ACCEPTED_RUNNING_STATE=CURRENT_RUNTIME_AUTHORITY
OLD_RPOOL=HISTORICAL_CONFIGURATION_BLUEPRINT
PBS=PRIMARY_GUEST_PAYLOAD_SOURCE
NEW_P3_RPOOL=PRODUCTION_DESTINATION
```

The historical rpool was used only for bounded read-only configuration or
host-side prerequisite reads. Ordinary guest payloads were restored natively
from `pbs-core-lore`. Earlier recovery wording remains dated evidence and does
not change this final classification.

## Accepted object: migrated guest estate

The planned migration restored and validated the following objects. Guests
with historical `onboot=0` were booted for validation and returned to their
authoritative stopped state.

| ID | Type | Accepted state | Meaningful acceptance |
| --- | --- | --- | --- |
| 243 | CT | running | `time-lore`; chrony active and synchronized; authoritative address present |
| 245 | CT | running | `ntfy-lore`; ntfy active and HTTP health passed |
| 246 | CT | running | `lxc-lore-headscale`; headscale active and HTTP health passed |
| 247 | CT | running | `lxc-lore-monitor`; Beszel and Uptime Kuma endpoints reachable |
| 248 | CT | running | `lxc-lore-www`; nginx and cloudflared active; HTTP 200 |
| 249 | CT | parked/incomplete; `onboot=0` | container shell exists; neither the PBS payload nor historical source contains a deployed Vaultwarden runtime or service |
| 252 | CT | running | DNS service accepted; historical syslog bind dataset copied and verified |
| 100 | VM | running | `ansible-console`; authoritative address reachable and SSH listener passed |
| 120 | VM | running | TrueNAS/QGA accepted; slowPool healthy; Toshiba mappings accepted |
| 130 | VM | running | Jellyfin active; P3 OS disk, original jellyPool data disk, and read-only media mounts accepted |
| 140 | VM | running | raw-NVMe boot, QGA, both network planes, jumbo path, and P6000/NVIDIA driver accepted |
| 141 | VM | stopped after validation | raw PBS restore booted; QGA and authoritative address passed; historical `onboot=0` preserved |
| 142 | VM | running | EQEmu login/world/zones and MariaDB active |
| 149 | VM | stopped after validation | raw PBS restore booted; QGA passed; historical `onboot=0` and both `link_down=1` NICs preserved |
| 150 | VM | stopped after validation | raw PBS restore booted; QGA, address, and MySQL passed; historical manual application-start model and `onboot=0` preserved |
| 242 | VM | running | PBS proxy, datastore, NFS backing, namespace content, and port 8007 accepted |
| 260 | VM | running | PBS service, datastore, Lore client, and backup visibility accepted |

CT249 is not a failed restore. Both its selected PBS backup and exact
historical `subvol-249-disk-0` contain the same source/build tree and no
Vaultwarden executable, service unit, runtime configuration, or listener.
Canonical surface authority independently classifies `vaultwarden-service` as
`PARKED` and Vaultwarden as an incomplete service. No new application design
or secret-bearing deployment was invented during migration.

```text
CT249=PARKED_INCOMPLETE
ONBOOT=0
CONTAINER_SHELL_EXISTS=YES
VAULTWARDEN_RUNTIME_DEPLOYED=NO
```

## Accepted object: VM140 exceptional realization

VM140 preserved its exact raw OS device and translated historical PCI bus
addresses to the same stable hardware identities currently enumerated on the
rebuilt host:

```text
VMID=140
NAME=ws-lore-agent
RAW_NVME=/dev/disk/by-id/nvme-Timetec_PCIe_SSD_TP250916B5D0198
P6000_GPU=0000:04:00.0;10de:1b30
P6000_AUDIO=0000:04:00.1;10de:10ef
IOMMU_GROUP=100;MEMBERS=0000:04:00.0,0000:04:00.1
EFI_STATE=PBS_RESTORED_TO_LOCAL_ZFS
TPM_STATE=PBS_RESTORED_TO_LOCAL_ZFS
RAW_NVME_PBS_COPY_TO_P3=NO
VFIO_CURRENT_DRIVER=vfio-pci
VFIO_NEXT_BOOT_CONFIGURATION=RESTORED_FROM_HISTORICAL_HOST
VM140_RUNNING=YES
QGA=PASS
GUEST_ROOT=/dev/sda3[/root];btrfs
GUEST_MANAGEMENT=192.168.10.90/24
GUEST_STORAGE=192.168.100.90/24
JUMBO_DF_8972=PASS
GUEST_GPU=Quadro_P6000
GUEST_NVIDIA_DRIVER=580.159.03
```

The EFI and TPM images were restored selectively with the installed PBS
client into PVE-allocated `local-zfs` state volumes. The approximately 500 GB
raw-NVMe backup image was deliberately not restored to the smaller P3 mirror.

## Operational migration close

Final observed production storage state after VM140 acceptance:

```text
RPOOL_GUID=4137356908105663872
RPOOL_HEALTH=ONLINE
RPOOL_MEMBERS=ata-P3-256_9760522200232-part3,ata-P3-256_9760511210658-part3
RPOOL_SIZE_GIB=236.00
RPOOL_ALLOC_GIB=106.00
RPOOL_FREE_GIB=130.00
RPOOL_FREE_PERCENT=55.08
RPOOL_CAPACITY_FLOOR_20_PERCENT=PASS
JELLYPOOL_GUID=2570796748144080705
JELLYPOOL_HEALTH=ONLINE
OLD_RPOOL_GUID=8921639095104950851
OLD_RPOOL_IMPORTED=NO
OLD_RPOOL=EXPORTED
OLD_RPOOL_ROLE=HISTORICAL_CONFIGURATION_AUTHORITY_AND_READONLY_FALLBACK
```

```text
HV_LORE_PLANNED_MIGRATION=OPERATIONALLY_ACCEPTED
GUEST_PAYLOAD_SOURCE=PBS
HISTORICAL_CONFIGURATION_SOURCE=OLD_RPOOL_READ_ONLY
PARKED_SERVICE=CT249_VAULTWARDEN
NEXT=CANONICAL_DOCUMENTATION_RECONCILIATION_AND_TEMPORARY_ARTIFACT_REVIEW
```

The runtime migration is complete. Canonical publication in the private
`hv-lore` node record and owning peer repositories remains a separate
documentation gate; this evidence does not claim that cross-repository
projection is complete.

## Repository reconciliation

The accepted current startup, shutdown, boot-event, observer, and deferred
SMART facts are recorded in
[`2026-08-30-hv-lore-startup-policy-v1-acceptance.md`](2026-08-30-hv-lore-startup-policy-v1-acceptance.md).
Within `hv-cp`, pre-migration policy claims are superseded and current truth is
reconciled.

```text
HV_CP_LORE_TRUTH_RECONCILIATION=PASS
SMARTD_TUNING=DEFERRED
NEXT=NORMAL_OPERATIONS
```

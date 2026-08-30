# hv-lore post-reinstall survey hard stop

Date: 2026-08-27
Play: `HV-LORE-POST-REINSTALL-REALIZATION`
Source: Semaphore template `HELIX - Observe Lore Post-Reinstall`, task recap
at 18:28:14 and its machine-readable evidence payload

## Survey result

```text
hv-lore ok=10 changed=0 unreachable=0 failed=0 skipped=0 rescued=0 ignored=0
MUTATION=NONE
```

The survey contract and Semaphore execution passed. Identity, DNS resolution,
systemd health, the production root pool, and automation identities were
observable without mutation.

## Production root pool

```text
RPOOL_HEALTH=ONLINE
RPOOL_SIZE=236G
RPOOL_ALLOC=2.05G
RPOOL_TOPOLOGY=mirror
RPOOL_MEMBER_1=/dev/disk/by-id/ata-P3-256_9760522200232-part3
RPOOL_MEMBER_2=/dev/disk/by-id/ata-P3-256_9760511210658-part3
RPOOL_ERRORS=NONE
```

## Hard-stop mismatch

The physical inventory unexpectedly contained both historical root-pool
NVMes:

| Observed device | Model | Serial | On live rpool |
| --- | --- | --- | --- |
| `/dev/nvme0n1` | Timetec PCIe SSD | `TP250913B5D3323` | no |
| `/dev/nvme1n1` | Timetec PCIe SSD | `TP250913B5D1797` | no |

Each still exposes a ZFS member partition labeled `rpool` with historical pool
identifier `8921639095104950851`. Neither was imported and neither was
mutated. Their physical presence contradicts the campaign's mandatory
`OFFLINE_ROLLBACK` posture and creates avoidable same-pool-name collision risk.

```text
BLOCKER=OLD_RPOOL_ROLLBACK_MEDIA_UNEXPECTEDLY_CONNECTED
operation=bounded hv-lore baseline realization through Semaphore
observed=TP250913B5D3323 and TP250913B5D1797 are physically visible with intact historical rpool member partitions
expected=both historical root-pool NVMes physically absent as OFFLINE_ROLLBACK until final migration acceptance
authority=operator-authorized HV-LORE-POST-REINSTALL-REALIZATION hard stop and fixed safety boundary
why_not_ordinary_debugging=continuing would violate the explicit rollback-isolation control and expose a same-named historical rpool during recovery
```

## Correctly returned non-root storage

The intended non-root NVMes are already physically visible:

```text
VM140_RAW_NVME_SERIAL=TP250916B5D0198
VM140_RAW_NVME_PRESENT=YES
JELLYPOOL_NVME_SERIAL=TP250913B5D1792
JELLYPOOL_NVME_PRESENT=YES
```

The three preserved VM120 Toshiba disks are also present with matching
serials `16N2A02XFWUH`, `16N2A042FWUH`, and `16X2A00KFWUH`. No pool import,
mount, guest mapping, partition, or disk mutation occurred.

## Other bounded findings

```text
HOST_IDENTITY=PASS
PVE_VERSION=pve-manager 9.2.2 / proxmox-ve 9.2.0
KERNEL=7.0.2-6-pve
APT_STATE=Debian trixie and PVE no-subscription active; enterprise PVE and enterprise Ceph definitions disabled
DNS_STATE=192.168.10.252 then 192.168.10.251; host and both internal DNS names resolve
NETWORK_STATE=vmbr0 192.168.10.20/24 via nic0; default gateway 192.168.10.1; 10GbE nic2/nic3 present but down
AUTOMATION_STATE=ansible-observer and ansible-executor identities present; observer has no passwordless sudo
SYSTEMD_FAILED_UNITS=0
P6000_CURRENT_BDF=04:00.0/04:00.1
P6000_CURRENT_DRIVER=nouveau/snd_hda_intel
P6000_IOMMU_GROUP=100
VFIO_BASELINE=NOT_YET_REALIZED
```

`proxmox-boot-tool status`, `pvesm status`, `qm list`, and `pct list` were
partial/unavailable to the unprivileged observer; this is a visibility limit,
not evidence of failure. No privilege expansion was attempted.

## Required operator handoff

Gracefully shut down `hv-lore`, physically remove only
`TP250913B5D3323` and `TP250913B5D1797`, preserve them together as offline
rollback authority, and boot the P3 installation. Do not remove or alter
`TP250916B5D0198`, `TP250913B5D1792`, the Toshiba disks, or either P3 target.
Rerun the admitted post-reinstall observer before baseline work resumes.

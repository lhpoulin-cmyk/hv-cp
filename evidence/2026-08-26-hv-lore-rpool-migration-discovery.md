# hv-lore rpool migration discovery

Date: 2026-08-26
Play: `HV-LORE-RPOOL-MIGRATION-DISCOVERY`
Mode: read-only
Repository starting commit: `7d7a9d97ecc1583e575c7a3a6885d89281d1308e`
Repository currency: fetched `origin/main`; `origin/main` at
`e615f0c8581b0ef18aa5ad9c8a9088a6c004928d` is an ancestor of the starting
commit. Unrelated pre-existing worktree changes were preserved.

## Result

**NOT READY — the backup hard stop fired.** VM 120 `truenas-lore` is a
critical storage-authority guest and has no external guest backup. It is
explicitly excluded from both the disabled `arpa-all-guests` job and the
enabled `pbs-core-lore-all-guests` job; its three 12 TB raw data disks are
also marked `backup=0`. VM 140 `ws-lore-agent` has no backup newer than
2026-08-14. No remediation was attempted.

No host, guest, ZFS, GPT, bootloader, package, network, or Proxmox
configuration mutation was performed. No guest was stopped and the host was
not rebooted.

## Required packet

```text
PLAY=HV-LORE-RPOOL-MIGRATION-DISCOVERY

TARGET=hv-lore
MODE=READ_ONLY
TARGET_MUTATION=NONE
REBOOT=NONE
GUEST_MUTATION=NONE

HOST_IDENTITY=PASS
PVE_VERSION=pve-manager 9.2.6/7f8d010005bd72cb; proxmox-ve 9.2.0
KERNEL=7.0.14-8-pve

CURRENT_RPOOL_HEALTH=ONLINE; zero read/write/checksum errors; no known data errors
CURRENT_RPOOL_TOPOLOGY=two-member mirror (mirror-0)
CURRENT_RPOOL_MEMBERS=nvme-eui.6479a7b01ad00f81-part3,nvme-eui.6479a7b01ad00df5-part3
CURRENT_RPOOL_MEMBER_SERIALS=TP250913B5D3323,TP250913B5D1797
CURRENT_RPOOL_SIZE=506806140928 bytes (472 GiB)
CURRENT_RPOOL_ALLOC=138742382592 bytes (129.214 GiB)
CURRENT_RPOOL_FREE=368063758336 bytes (342.786 GiB)
CURRENT_RPOOL_CAPACITY_PERCENT=27%
CURRENT_RPOOL_DATASET_USED=149161648128 bytes (138.918 GiB; recursive rpool USED accounting)
CURRENT_RPOOL_SNAPSHOT_USED=1966592000 bytes (1.832 GiB)

TARGET_DRIVE_COUNT=2
TARGET_1_DEVICE=/dev/sdd (ephemeral name at capture)
TARGET_1_MODEL=P3-256
TARGET_1_SERIAL=9760522200232
TARGET_1_BY_ID=/dev/disk/by-id/ata-P3-256_9760522200232
TARGET_1_SIZE=256060514304 bytes (238.475 GiB)
TARGET_1_SMART=PASSED; reallocated=0; reported-uncorrectable=0; CRC-errors=0

TARGET_2_DEVICE=/dev/sdf (ephemeral name at capture)
TARGET_2_MODEL=P3-256
TARGET_2_SERIAL=9760511210658
TARGET_2_BY_ID=/dev/disk/by-id/ata-P3-256_9760511210658
TARGET_2_SIZE=256060514304 bytes (238.475 GiB)
TARGET_2_SMART=PASSED; reallocated=0; pending=0; offline-uncorrectable=0; CRC-errors=0

TARGET_IDENTITY_PROVEN=YES

PVE_BOOT_MODE=UEFI
PROXMOX_BOOT_TOOL_STATUS=UEFI+GRUB; managed ESPs A829-1935 and A829-9C79
CURRENT_BOOT_DISKS=TP250913B5D3323 (/dev/nvme0n1) and TP250913B5D1797 (/dev/nvme2n1)

VM_COUNT=10
CT_COUNT=7
RUNNING_GUEST_COUNT=13

RPOOL_VM_DATA_USED=113424789504 bytes (105.635 GiB; rpool/data USED)
RPOOL_VAR_LIB_VZ_USED=20440055808 bytes (19.036 GiB)
RPOOL_ROOT_USED=6061088768 bytes (5.645 GiB)
RPOOL_SWAP_USED=9129426944 bytes (8.502 GiB dataset USED; 186642432 bytes referenced)

LARGEST_ZVOLS=VM141 256G; VM149 256G; VM150 200G; VM120/130/242/260 64G each
THIN_PROVISIONING_RISK=HIGH logical overcommit: rpool zvol VOLSIZE total is 1036.015 GiB versus a 472 GiB source pool and historical 236 GiB target-pool size; actual source allocation is 129.214 GiB

PASSTHROUGH_VMIDS=120,140
PASSTHROUGH_DEVICES=VM120 three stable-id Toshiba raw disks; VM140 configured 06:00.0/06:00.1, while live Quadro P6000 is 04:00.0/04:00.1 (10de:1b30/10de:10ef), IOMMU group 100, vfio-pci
VFIO_CONFIGURATION_CAPTURED=YES

NETWORK_CONFIGURATION_CAPTURED=YES
STORAGE_CONFIGURATION_CAPTURED=YES
PMXCFS_STATE_CAPTURED=YES

CLUSTER_STATE=STANDALONE

EXTERNAL_BACKUP_STORAGE=pbs-core-lore ACTIVE; pbs-katra-vm260 ACTIVE; arpa-vzdump ACTIVE but 99.94% full and its job disabled; pbs-lore DISABLED
GUESTS_WITH_CURRENT_BACKUP=100,130,141,142,149,150,242,243,245,246,247,248,249,252,260 (2026-08-26)
GUESTS_WITHOUT_CURRENT_BACKUP=120 (none),140 (latest 2026-08-14; stale)

CURRENT_DATA_FITS_TARGET=YES for capacity only: 129.214 GiB allocated is 54.75% of the historically observed 236 GiB staged target zpool; a future installer pool must be measured, not assumed

KNOWN_PREEXISTING_WARNINGS=critical VM120 has no external guest backup; VM140 backup stale and configured PCI addresses do not match live P6000 addresses; arpa-vzdump 99.94% full; P3 targets retain prior staged GPT/ESP/ZFS labels; imported pools report feature-upgrade notices but are healthy

BLOCKERS=backup hard stop: critical VM120 lacks an external guest recovery image; VM140 current-backup coverage is stale
MIGRATION_READINESS=NOT_READY

NEXT_PLAY=authorize and prove external recovery coverage for VM120 (including the storage-authority boundary) and refresh/validate VM140 backup; then rerun the backup/readiness gate and author a separate destructive migration packet
```

## Capacity analysis

```text
CURRENT_RPOOL_USABLE=506806140928 bytes (472 GiB zpool size)
CURRENT_RPOOL_ALLOCATED=138742382592 bytes (129.214 GiB physical allocation)
CURRENT_RPOOL_FREE=368063758336 bytes (342.786 GiB)

TARGET_P3_DRIVE_RAW_SIZE=256060514304 bytes each (238.475 GiB)
EXPECTED_TARGET_MIRROR_RAW_CEILING=256060514304 bytes (one-drive mirror ceiling)
CURRENT_TARGET_PARTITION_3_SIZE=254985707008 bytes each (237.474 GiB)
HISTORICAL_STAGED_ZPOOL_SIZE=236 GiB (observed 2026-08-14; not an installer guarantee)

CURRENT_DATA_FITS_TARGET=YES (capacity comparison only)

170G_THRESHOLD_PERCENT=72.03% of the observed 236 GiB zpool (71.29% of raw-device ceiling)
180G_THRESHOLD_PERCENT=76.27% of the observed 236 GiB zpool (75.48% of raw-device ceiling)
190G_THRESHOLD_PERCENT=80.51% of the observed 236 GiB zpool (79.67% of raw-device ceiling)
```

Raw device size is the manufacturer-visible whole disk. Partition size is
the current partition-3 span. Mirror raw ceiling is one member, not the sum of
both members. Zpool size is ZFS's usable pool geometry. Allocated ZFS space is
the source pool's physical allocation. Logical zvol size is provisioned guest
capacity and is not data that must necessarily be copied. Dataset/zvol `USED`
is the measured ZFS space charge; `REFER` excludes snapshots and some
dataset-level accounting.

The source `rpool` dataset hierarchy reports 149161648128 bytes (138.918 GiB)
`USED`, including dataset accounting effects; named snapshots account for
1966592000 bytes (1.832 GiB). The pool's authoritative physical allocation is
138742382592 bytes (129.214 GiB). Against the previously observed 236 GiB
staged target zpool, that leaves 114660687872 bytes (106.786 GiB) before any
future installer-layout or reserve-policy effects.

## Guest inventory

`ACTUAL USED` below is the measured `rpool` ZFS charge only. Raw passthrough
media and non-rpool storage are identified separately and are not silently
counted as migration payload.

| VMID | TYPE | NAME | STATUS | STORAGE | LOGICAL DISK | ACTUAL USED | PASSTHROUGH | LATEST BACKUP |
|---:|---|---|---|---|---|---:|---|---|
| 100 | VM | ansible-console | running | local-zfs | 20G | 0.647 GiB | none | pbs-core-lore 2026-08-26 |
| 120 | VM | truenas-lore | running | local-zfs + raw | 64G + 3x11176G raw | 29.143 GiB | 3 Toshiba disks, `backup=0` | **NONE** |
| 130 | VM | jellyfin-lore | running | local-zfs + jelly-zfs | 64G + 128G | 10.442 GiB on rpool | none | pbs-core-lore 2026-08-26 |
| 140 | VM | ws-lore-agent | stopped | raw NVMe + local-zfs metadata | 476.94G raw | 0.00014 GiB on rpool | configured P6000 `06:00.[01]`; live at `04:00.[01]` | pbs-core-lore 2026-08-14 (stale) |
| 141 | VM | ws-lore-apropos | stopped | local-zfs | 256G | 4.824 GiB | none | pbs-core-lore 2026-08-26 |
| 142 | VM | eq-lore | running | local-zfs | 40G | 9.272 GiB | none | pbs-core-lore 2026-08-26 |
| 149 | VM | ws-matriarch-gauntlet | stopped | local-zfs | 256G | 4.904 GiB | none | pbs-core-lore 2026-08-26 |
| 150 | VM | wow-unbound-prod | stopped | local-zfs | 200G | 33.582 GiB | none | pbs-core-lore 2026-08-26 |
| 242 | VM | pbs-katra | running | local-zfs | 64G | 2.831 GiB | none | pbs-core-lore 2026-08-26 |
| 260 | VM | pbs-core | running | local-zfs | 64G | 2.344 GiB | none | pbs-katra-vm260 2026-08-26 |
| 243 | CT | time-lore | running | local-zfs | 8G | 0.378 GiB | none | pbs-core-lore 2026-08-26 |
| 245 | CT | ntfy-lore | running | local-zfs | 8G | 1.137 GiB | none | pbs-core-lore 2026-08-26 |
| 246 | CT | lxc-lore-headscale | running | local-zfs | 8G | 0.432 GiB | none | pbs-core-lore 2026-08-26 |
| 247 | CT | lxc-lore-monitor | running | local-zfs | 16G | 1.051 GiB | none | pbs-core-lore 2026-08-26 |
| 248 | CT | lxc-lore-www | running | local-zfs | 8G | 0.900 GiB | none | pbs-core-lore 2026-08-26 |
| 249 | CT | vaultwarden-lore | running | local-zfs | 8G | 3.074 GiB | none | pbs-core-lore 2026-08-26 |
| 252 | CT | lxc-lore-dns | running | local-zfs | 8G + 1G syslog mount | 0.674 GiB | none | pbs-core-lore 2026-08-26 |

## Physical disks

Device names are capture-time observations only; stable IDs and serials are
the selection authority.

| DEVICE | MODEL | SERIAL | SIZE | BY-ID | ROLE |
|---|---|---|---:|---|---|
| sda | TOSHIBA HDWG51CUZSVA | 16N2A02XFWUH | 12000138625024 B | `ata-TOSHIBA_HDWG51CUZSVA_16N2A02XFWUH` | VM120 raw slowPool member |
| sdb | TOSHIBA HDWG51CUZSVA | 16N2A042FWUH | 12000138625024 B | `ata-TOSHIBA_HDWG51CUZSVA_16N2A042FWUH` | VM120 raw slowPool member |
| sdc | TOSHIBA HDWG51CUZSVA | 16X2A00KFWUH | 12000138625024 B | `ata-TOSHIBA_HDWG51CUZSVA_16X2A00KFWUH` | VM120 raw slowPool member |
| sdd | P3-256 | 9760522200232 | 256060514304 B | `ata-P3-256_9760522200232` | proposed target; prior staged GPT/ESP/ZFS label; unmounted; no active pool |
| sde | P3-512 | 9X50912007143 | 512110190592 B | `ata-P3-512_9X50912007143` | no partitions observed; not a migration target |
| sdf | P3-256 | 9760511210658 | 256060514304 B | `ata-P3-256_9760511210658` | proposed target; prior staged GPT/ESP/ZFS label; unmounted; no active pool |
| nvme0n1 | Timetec PCIe SSD | TP250913B5D3323 | 512110190592 B | `nvme-eui.6479a7b01ad00f81` | current rpool mirror + managed ESP A829-1935 |
| nvme1n1 | Timetec PCIe SSD | TP250916B5D0198 | 512110190592 B | `nvme-eui.6479a7b05a500df2` | VM140 whole-disk passthrough |
| nvme2n1 | Timetec PCIe SSD | TP250913B5D1797 | 512110190592 B | `nvme-eui.6479a7b01ad00df5` | current rpool mirror + managed ESP A829-9C79 |
| nvme3n1 | Timetec PCIe SSD | TP250913B5D1792 | 512110190592 B | `nvme-eui.6479a7b01ad00da4` | active jellyPool |

The target GPTs are identical: partition 1 sectors 34-2047, BIOS boot `EF02`;
partition 2 sectors 2048-2099199, 1 GiB EFI System `EF00`; partition 3 sectors
2099200-500118158, 254985707008 bytes, ZFS `BF01`. Target partition-3 labels
still name the non-imported prior staging pool `rpool-sata-stage`.

## Configuration preservation and pre-existing state

- Management is `vmbr0` / `192.168.10.20/24`, gateway `192.168.10.1`, on
  physical `nic0` (`05:00.0`, MAC `3c:52:82:5e:d0:8d`).
- Storage bridge `vmbr1` is `192.168.100.20/24`, MTU 9000, no gateway, on
  `nic2` (`89:00.1`, MAC `14:02:ec:71:fc:b1`). No bonds or tagged VLANs were
  observed; bridge VLAN state is untagged PVID 1.
- Lore is standalone: `/etc/pve/corosync.conf` is absent and both `pvecm`
  queries report that the host is not part of a cluster. PMXCFS `config.db`
  exists and was 68K at capture.
- Boot is UEFI with GRUB. `BootCurrent` was the NVMe entry for
  `eui.6479a7b01ad00f81`; both current NVMe ESP UUIDs resolve to the two rpool
  disks. The P3 ESPs are formatted but not in
  `/etc/kernel/proxmox-boot-uuids`.
- VFIO config binds `10de:1b30,10de:10ef`, blacklists nouveau/nvidiafb, and
  loads `vfio`, `vfio_iommu_type1`, `vfio_pci`, and `vfio_virqfd`. The live
  P6000 functions are bound to `vfio-pci` in IOMMU group 100.
- Required configuration paths were present except none were reported absent.
  `/root/.ssh` private-key contents were not printed; filenames, ownership,
  modes, sizes, and SHA-256 hashes were captured only.
- No failed systemd units, unhealthy imported pools, failed PVE services, or
  warning-or-higher kernel events in the previous 24 hours were observed.
- `local-zfs` (`rpool/data`) contains VM images and CT root filesystems.
  `local` (`rpool/var-lib-vz`) permits ISO, template, import, and backup
  content and currently charges 19.036 GiB to rpool.

The backup hard stop, not storage capacity or target identity, prevents a
destructive migration packet from being execution-ready.

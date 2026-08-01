# Cluster-wide physical disk map

Date: 2026-07-31
Method: read-only root-qualified SSH collection and accepted TrueNAS handoff

| Host | Device | Stable by-id | Physical path / controller | Current owner | Health | Future eligibility |
| --- | --- | --- | --- | --- | --- | --- |
| hv-lore | nvme0n1 | `nvme-eui.6479a7b01ad00f81` | PCI `84:00.0` | rpool boot mirror | SMART healthy observed | preserve — host boot |
| hv-lore | nvme1n1 | `nvme-eui.6479a7b01ad00df5` | PCI `85:00.0` | rpool boot mirror | SMART healthy observed | preserve — host boot |
| hv-lore | nvme2n1 | `nvme-eui.6479a7b01ad00da4` | PCI `86:00.0` | active `jellyPool` PVE storage | ZFS ONLINE | preserve — Proxmox storage |
| hv-lore | nvme3n1 | `nvme-eui.6479a7b05a500df2` | PCI `87:00.0` | VM 140 raw disk | not assessed | preserve — guest |
| hv-lore | sda/sdb/sdc | Toshiba IDs in ownership record | SAS2308 `01:00.0`; bays unknown | truenas-lore `slowPool` | accepted active members | preserve — TrueNAS |
| hv-lore | sdd | `ata-P3-256_9760511210658` | SATA path not proven | active `gitlab-p3` PVE storage | ZFS ONLINE | preserve — Proxmox storage |
| hv-lore | sde | P3-512 identity observed | SATA path not proven | active `jelly-zfs` PVE storage | active | preserve — Proxmox storage |
| hv-katra | sda | `ata-ST4000DM004-2CV104_ZFN3C6TC` | SATA `00:17.0`; port unknown | truenas-katra `tank` | accepted active member | preserve — TrueNAS |
| hv-katra | sdb/sdc | Patriot P210/P220 128 GB IDs | SATA `00:17.0`; ports unknown | rpool boot mirror | ZFS ONLINE | preserve — host boot |
| hv-katra | sdd | Kingston DataTraveler | USB | Ventoy/LUKS media | not assessed | preserve — recovery |
| hv-katra | nvme0n1 | `nvme-eui.00253857019e3d0d` | PCI `03:00.0` | not referenced by PVE storage or VMs | critical warning 0; zero media errors; 23,067 log entries | unknown — blocked |
| hv-matrix | sda/sdb | Patriot P210/P220 128 GB IDs | SATA `00:17.0`; ports unknown | rpool boot mirror | ZFS ONLINE | preserve — host boot |
| hv-matrix | nvme0n1 | `nvme-eui.e8238fa6bf530001001b448b4610889a` | PCI `2e:00.0` | NTFS `Local Storage` payload; consumer unknown | critical warning 0; 1 log entry | unknown — blocked |
| hv-matrix | nvme1n1 | `nvme-eui.e8238fa6bf530001001b448b4e85d1b3` | PCI `2f:00.0` | VM 310 raw `scsi0` p1 | critical warning 0; 9 log entries | preserve — guest |

All material chassis slot/bay labels not shown by PCI/by-path evidence remain
**operator inspection required**.

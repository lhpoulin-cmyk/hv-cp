# TrueNAS ownership handoff consumption

Date: 2026-07-31
Authority: accepted `/home/louis/helix-arpa` commit `152575c`
Sources: `truenas/registry/physical-ownership.md`, `pools-and-datasets.md`, and `CURRENT_STATE.md`

## Accepted dependency and host corroboration

This assessment consumes, but does not alter, the accepted TrueNAS frontier.

| Host | Stable identity | Current owner | Preserved path | Host corroboration |
| --- | --- | --- | --- | --- |
| hv-lore | `ata-TOSHIBA_HDWG51CUZSVA_16N2A042FWUH` | truenas-lore `slowPool` | SAS2308 `0000:01:00.0` | VM 120 raw `scsi1` |
| hv-lore | `ata-TOSHIBA_HDWG51CUZSVA_16X2A00KFWUH` | truenas-lore `slowPool` | SAS2308 `0000:01:00.0` | VM 120 raw `scsi2` |
| hv-lore | `ata-TOSHIBA_HDWG51CUZSVA_16N2A02XFWUH` | truenas-lore `slowPool` | SAS2308 `0000:01:00.0` | VM 120 raw `scsi3` |
| hv-katra | `ata-ST4000DM004-2CV104_ZFN3C6TC` | truenas-katra `tank` | onboard SATA `0000:00:17.0` | VM 110 raw `scsi1` |

The Lore disks are the active `slowPool` RAIDZ1 and the Katra disk is the sole
active `tank` member. They and their active controller paths are unavailable to
Ceph.

The accepted PBS chain remains `hv-lore -> pbs-lore -> datastore hv-lore ->
NFS -> truenas-lore -> slowPool/backup/pbs/pbs-lore`. Lore downtime temporarily
removes this backing storage. No host evidence contradicted the handoff.

No TrueNAS, Proxmox, PBS, network, or Ceph state changed.

# hv-lore storage and boot record

Date: 2026-08-14
Method: read-only SSH collection using the existing `hv-lore` path
Raw source: `inbox/2026-08-14-hv-lore/`

## Current host storage

The current host inventory contains the three known SAS2308-attached Toshiba
disks, each approximately 10.9T:

| Device | Serial | HCTL |
| --- | --- | --- |
| `sda` | `16N2A02XFWUH` | `8:0:0:0` |
| `sdb` | `16N2A042FWUH` | `8:0:1:0` |
| `sdc` | `16X2A00KFWUH` | `8:0:2:0` |

The current SAS sysfs and boot inventory show no `8:0:3:0`, no
`end_device-8:3`, and no newly enumerated fourth 12 TB block disk. The
existing host SATA, NVMe, optical, and virtual devices remain separate from
this three-disk SAS control set.

## Defective fourth-disk observation

The authoritative powered-off/cold-boot Lore evidence recorded the fourth
SAS2308 connection as handle `0x000c`, `end_device-8:3`, and SAS address
`0x4433221103000000`, but no corresponding usable SCSI/block device appeared.
The later persistent state contains only the three normal Toshiba block
devices. The exact historical PHY3 negotiated-rate and historical
`target_port_protocols`/`scsi_target_id` sysfs values were not retained; the
raw search documenting that limitation is preserved.

This is a device-initialization observation, not proof of a specific internal
mechanical or electronic failure mode. The live insertion event remains an
unsafe/invalid diagnostic event; the powered-off cold-boot test is the
authoritative Lore test.

## Two 256 GB SATA drives

The two P3-256 drives are present and directly enumerated:

| Device | Serial | Size | HCTL |
| --- | --- | ---: | --- |
| `sdd` | `9760522200232` | 238.5G | `1:0:0:0` |
| `sde` | `9760511210658` | 238.5G | `4:0:0:0` |

Both are unpartitioned, have no filesystem signatures, have no mountpoints,
and are not members of the visible `jellyPool` or `rpool`. `smartctl` is not
installed, so their health has not been validated beyond identity and basic
enumeration.

## Boot feasibility

Lore currently boots UEFI from `rpool/ROOT/pve-1`. `rpool` is an ONLINE ZFS
mirror on two approximately 475 GB NVMe members, with 129 GB allocated and
343 GB free at capture. The active Proxmox EFI entry points to an existing
NVMe EFI system partition. The P3-256 drives have no EFI partition or boot
files.

The P3-256 pair is feasible for a future fresh/rebuilt Proxmox boot layout,
but is not a direct in-place replacement for the larger current NVMe root
members. Such a migration requires an approved maintenance window, validated
backups, new partitioning and bootloader installation, and a planned
fresh-install/restore or smaller-root-pool migration with rollback testing.
`proxmox-boot-tool` was unavailable in the current command path, so its
managed-boot state was not queried.

## Integrity and boundary

Every raw capture in the inbox set is covered by `SHA256SUMS.txt` and passed
verification after relocation. No partitioning, formatting, pool operation,
bootloader write, firmware change, or other host/storage mutation was
performed.

# Lore SATA boot-pair staging — Phase 1 result

Date: 2026-08-14
Host: `hv-lore`
Packet: `implementation/2026-08-14-hv-lore-sata-boot-pair-stage.packet.md`
Runbook: `runbooks/hv-lore-sata-boot-pair-stage.md`

## Result

**PASS — Phase 1 staging completed.** The two approved P3-256 SSDs were SMART
qualified, partitioned, given formatted ESPs, and used to create the isolated
`rpool-sata-stage` mirror. The current NVMe `rpool` remained authoritative and
ONLINE. No root data was copied and the new ESPs were not initialized into the
managed boot-tool set.

## Approved devices

| Stable by-id path | Model | Serial | Resolved device |
|---|---|---|---|
| `ata-P3-256_9760522200232` | P3-256 | `9760522200232` | `/dev/sdd` |
| `ata-P3-256_9760511210658` | P3-256 | `9760511210658` | `/dev/sde` |

SMART overall health passed and the short self-test completed without error
for both drives. Drive `9760522200232` reported 2 power-on hours; drive
`9760511210658` reported 339 power-on hours. No errors were logged. SMART
qualification was read-only apart from the device-internal short self-tests.

## Final GPT layout

Both disks have the same layout:

| Partition | Sectors | Size | Type |
|---:|---:|---:|---|
| 1 | 34–2047 | 1007 KiB | BIOS boot `EF02` |
| 2 | 2048–2099199 | 1 GiB | EFI System `EF00` |
| 3 | 2099200–500118158 | 237.5 GiB | ZFS `BF01` |

ESP filesystem UUIDs:

- `9760522200232` p2: `6A94-CDF5`
- `9760511210658` p2: `6A96-8F07`

## Staging pool

`rpool-sata-stage` is an ONLINE mirror using only:

- `ata-P3-256_9760522200232-part3`
- `ata-P3-256_9760511210658-part3`

It uses `ashift=12`, `cachefile=none`, and a non-mounted root dataset
(`mountpoint=none`, `canmount=off`). It contains only pool metadata; no root
datasets were copied.

## Protected state and boundaries

- Current root remains `rpool/ROOT/pve-1`.
- Current NVMe `rpool` remains ONLINE with zero read/write/checksum errors.
- `proxmox-boot-tool status` before and after still lists only the two original
  NVMe ESPs (`A829-1935` and `A829-9C79`).
- `proxmox-boot-tool init` was not run.
- Firmware/NVRAM and boot order were not changed.
- No reboot occurred.
- No GRUB, initramfs, kernel, guest, PVE storage definition, Toshiba disk, or
  failed 12 TB drive was modified.
- `smartmontools` was already installed (`7.5-pve2`); no package transaction
  occurred.

The existing boot-layout decision remains binding: Phase 2 root cutover and
independent boot/fallback testing are not authorized by this staging result.

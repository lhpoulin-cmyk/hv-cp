# Lore boot-chain assessment

Date: 2026-07-31
Method: read-only root-qualified SSH collection

`hv-lore` runs PVE 9.1.1. `/` is `rpool/ROOT/pve-1`; `rpool` is an ONLINE ZFS
mirror with a clean 2026-07-12 scrub and no reported read, write, or checksum
errors.

| Stable device | Physical path | Size | Pool role | EFI partition | Bootloader state | Health |
| --- | --- | ---: | --- | --- | --- | --- |
| `nvme-eui.6479a7b01ad00f81` / Timetec `TP250913B5D3323` | `pci-0000:84:00.0-nvme-1` | 476.9 GiB | rpool mirror p3 | p2 UUID `A829-1935` | configured GRUB ESP, kernel `6.17.2-1-pve` | critical warning 0; 44 C; spare 100%; 1% used; zero media errors |
| `nvme-eui.6479a7b01ad00df5` / Timetec `TP250913B5D1797` | `pci-0000:85:00.0-nvme-1` | 476.9 GiB | rpool mirror p3 | p2 UUID `A829-9C79` | configured GRUB ESP, kernel `6.17.2-1-pve` | critical warning 0; 44 C; spare 100%; 1% used; zero media errors |

## Redundancy assessment

| Property | Result | Evidence |
| --- | --- | --- |
| ZFS redundancy | proven | two ONLINE mirror members; clean scrub |
| EFI partition redundancy | proven | both ESP UUIDs configured by `proxmox-boot-tool` |
| Firmware boot-entry redundancy | **not proven** | `efibootmgr -v` showed only `Boot001F` Proxmox, pointing to the `TP250913B5D1797` ESP |
| One-device boot recovery | **unknown — blocked** | no firmware-selection or one-device boot test authorized |

A mirrored rpool plus duplicated ESP contents is not proof of independent UEFI
bootability. This blocks a boot-layout decision. PCI paths prove controller
placement (`84:00.0` and `85:00.0`), not chassis slot labels; slot mapping is
**operator inspection required**.

No disk, boot entry, package, or host configuration was changed.

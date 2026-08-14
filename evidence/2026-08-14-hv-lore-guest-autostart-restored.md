# hv-lore guest autostart policy restored

Date: 2026-08-14
Host: `hv-lore`
hv-cp starting commit: `8ee618c84ce15e63b4471a7397832609b6dd3182`
Repository parity before mutation: `HEAD` and `origin/main` both
`8ee618c84ce15e63b4471a7397832609b6dd3182` after fetch.

## Scope and authority

This bounded change restores Proxmox guest/container `onboot` policy after the
2026-08-14 storage recovery. During recovery, all previously enabled guest
autostarts were intentionally set to `onboot=0` so hv-lore could boot bare.
The known pre-incident enabled set supplied by the approved play was accepted
after comparison with the live inventory. No newer durable startup-policy
record was found in hv-cp.

The host was accessed over SSH and PVE-managed state was changed only through
`qm` and `pct`. No `/etc/pve` files were edited. No guest was started or
stopped, and no reboot was performed.

## Preflight

| Item | Observed |
| --- | --- |
| Hostname | `hv-lore` |
| Capture time | `2026-08-14T17:17:58-04:00` |
| Uptime | `5 min` |
| PVE | `proxmox-ve 9.2.0`, `pve-manager 9.2.6`, kernel `7.0.14-8-pve` |

## Before startup-policy table

All guests were stopped at capture. A missing `onboot` line is represented as
`0`; a missing `startup` line is represented as `-`.

| TYPE | ID | NAME | STATUS | ONBOOT | STARTUP |
| --- | ---: | --- | --- | ---: | --- |
| QEMU | 100 | ansible-console | stopped | 0 | - |
| QEMU | 120 | truenas-lore | stopped | 0 | order=2,up=60 |
| QEMU | 130 | jellyfin-lore | stopped | 0 | order=3,up=180 |
| QEMU | 140 | ws-lore-agent | stopped | 0 | order=4,up=30 |
| QEMU | 141 | ws-lore-apropos | stopped | 0 | - |
| QEMU | 142 | eq-lore | stopped | 0 | - |
| QEMU | 149 | ws-matriarch-gauntlet | stopped | 0 | - |
| QEMU | 150 | wow-unbound-prod | stopped | 0 | - |
| QEMU | 242 | pbs-katra | stopped | 0 | order=50,up=30,down=60 |
| QEMU | 260 | pbs-core | stopped | 0 | order=3,up=60 |
| LXC | 243 | time-lore | stopped | 0 | order=1,up=10 |
| LXC | 245 | ntfy-lore | stopped | 0 | order=1,up=10 |
| LXC | 246 | lxc-lore-headscale | stopped | 0 | order=2,up=20 |
| LXC | 247 | lxc-lore-monitor | stopped | 0 | order=3,up=20 |
| LXC | 248 | lxc-lore-www | stopped | 0 | order=4,up=20 |
| LXC | 249 | vaultwarden-lore | stopped | 0 | - |
| LXC | 252 | lxc-lore-dns | stopped | 0 | order=1,up=20 |

The live inventory agreed with the approved pre-incident set. VMs 141, 149,
and 150 were not enabled. No startup ordering was invented.

## Exact mutations

```text
qm set 100 --onboot 1
qm set 120 --onboot 1
qm set 130 --onboot 1
qm set 140 --onboot 1
qm set 142 --onboot 1
qm set 242 --onboot 1
qm set 260 --onboot 1
pct set 243 --onboot 1
pct set 245 --onboot 1
pct set 246 --onboot 1
pct set 247 --onboot 1
pct set 248 --onboot 1
pct set 249 --onboot 1
pct set 252 --onboot 1
```

## After startup-policy table

| TYPE | ID | NAME | STATUS | ONBOOT | STARTUP |
| --- | ---: | --- | --- | ---: | --- |
| QEMU | 100 | ansible-console | stopped | 1 | - |
| QEMU | 120 | truenas-lore | stopped | 1 | order=2,up=60 |
| QEMU | 130 | jellyfin-lore | stopped | 1 | order=3,up=180 |
| QEMU | 140 | ws-lore-agent | stopped | 1 | order=4,up=30 |
| QEMU | 141 | ws-lore-apropos | stopped | 0 | - |
| QEMU | 142 | eq-lore | stopped | 1 | - |
| QEMU | 149 | ws-matriarch-gauntlet | stopped | 0 | - |
| QEMU | 150 | wow-unbound-prod | stopped | 0 | - |
| QEMU | 242 | pbs-katra | stopped | 1 | order=50,up=30,down=60 |
| QEMU | 260 | pbs-core | stopped | 1 | order=3,up=60 |
| LXC | 243 | time-lore | stopped | 1 | order=1,up=10 |
| LXC | 245 | ntfy-lore | stopped | 1 | order=1,up=10 |
| LXC | 246 | lxc-lore-headscale | stopped | 1 | order=2,up=20 |
| LXC | 247 | lxc-lore-monitor | stopped | 1 | order=3,up=20 |
| LXC | 248 | lxc-lore-www | stopped | 1 | order=4,up=20 |
| LXC | 249 | vaultwarden-lore | stopped | 1 | - |
| LXC | 252 | lxc-lore-dns | stopped | 1 | order=1,up=20 |

## Protected recovery boundaries and validation

- QEMU onboot=1: `100 120 130 140 142 242 260`.
- LXC onboot=1: `243 245 246 247 248 249 252`.
- Deliberately left onboot=0: VMs `141 149 150`; no other current guest was
  left disabled.
- Existing startup values were preserved exactly; startup values changed: none.
- VM 130 has no `hostpci0` or `hostpci1`; the intentional stale GPU cleanup was
  not reverted.
- VM 120 still references exactly these raw disks:
  `ata-TOSHIBA_HDWG51CUZSVA_16N2A042FWUH`,
  `ata-TOSHIBA_HDWG51CUZSVA_16X2A00KFWUH`, and
  `ata-TOSHIBA_HDWG51CUZSVA_16N2A02XFWUH` on `scsi1`–`scsi3`.
  The failed fourth 12 TB drive was not attached.
- Post-mutation `qm list` and `pct list` showed all guests still stopped;
  there was no accidental guest start/stop.
- Read-only host `zpool status` reported `jellyPool` and `rpool` ONLINE with
  zero read/write/checksum errors and no known data errors. VM 120 was stopped,
  so the optional guest `zpool status slowPool` check was not run.
- No firmware, GRUB, initramfs, kernel parameter, mpt3sas, or
  proxmox-boot-tool configuration was read for mutation or changed. The
  unresolved boot/initramfs investigation remains deferred.

No discrepancy required operator review.

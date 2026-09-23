# Lore direct Hadrian peer SSH — execution evidence

Collected: 2026-08-12, America/Detroit
Packet: [`../implementation/002-hv-lore-hadrian-peer-ssh.packet.md`](../implementation/002-hv-lore-hadrian-peer-ssh.packet.md)

## Authorized change

The operator authorized one `hv-lore` node-firewall change: allow SSH TCP/22
from Hadrian at `192.168.10.86/32` (active Wi-Fi) and `192.168.10.85/32`
(wired resilience).  No other firewall, network, service, credential, or host
configuration was changed.

## Recovery and backup

- Independent recovery/execution path verified before and after: direct
  `hv-katra` -> `hv-lore` SSH as `louis`, returning `hv-lore` and `louis`.
- Private root-owned backup on Lore:
  `/root/hv-lore-host.fw.pre-hadrian-peer-ssh-20260812T021000Z`
- Source and backup SHA-256 matched:
  `ab944e0b896e7312afcc97efda23391a5503d32a016ada29a07e8fb11b190216`.

## Applied state

The Proxmox node firewall API staged each rule disabled, re-fetched its digest,
moved it, re-fetched again, then enabled it.  The final rule digest is
`513a90090493fcdc65d52c3efc533eb7c43587a1`.

The five pre-existing SSH accepts remain positions 0--4.  New exact rules:

| Position | Action | Source | Protocol | Port | Enabled |
| --- | --- | --- | --- | --- | --- |
| 5 | ACCEPT | `192.168.10.86/32` | TCP | 22 | yes |
| 6 | ACCEPT | `192.168.10.85/32` | TCP | 22 | yes |

Web UI rules begin at position 7.  The existing `192.168.10.0/24` INPUT DROP
remains at position 14.  The effective `PVEFW-HOST-IN` chain contains each
new exact `/32` TCP/22 RETURN before that subnet drop; no broad SSH rule was
added.

## Tests

- Direct Hadrian -> Lore SSH, with no `ProxyJump`: passed (`hv-lore`, `louis`).
- Katra -> Lore recovery SSH: passed (`hv-lore`, `louis`).
- Hadrian -> Lore TCP/8006: passed.
- Wired `.10.85` live ingress: deferred because Hadrian's Ethernet link is
  physically disconnected.  The exact enabled `/32` rule and effective chain
  were verified; a live test is required when the wired link is connected.

## Result

Hadrian's active management address has a direct, working SSH path to Lore.
The paired workstation policy does not depend on Matriarch for this flow.

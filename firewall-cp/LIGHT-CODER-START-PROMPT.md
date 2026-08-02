# Light-coder starting prompt

```text
Work in /home/louis/helix-arpa/hv-cp/firewall-cp.

Read, in order:

1. /home/louis/helix-arpa/hv-cp/AGENTS.md
2. AGENTS.md
3. README.md
4. decisions/2026-07-27-firewall-control-plane-scope.md
5. docs/FIREWALL-CONTRACT.md
6. ../evidence/2026-07-27-local-hypervisor-firewall-baseline.md
7. templates/FIREWALL-CHANGE-PACKET.md

Inspect git status before editing and preserve unrelated work.

Task: prepare the first documentation-only packet at
implementation/001-hv-lore-hadrian-authority-ssh.packet.md.

The proposed outcome is exactly one flow: after Hadrian's independent VLAN-80
path is accepted, hv-lore accepts TCP/22 from Hadrian authority
192.168.80.85/32. The intended rule must appear before Lore's later subnet
drops.

Do not execute commands against a live host. Do not change Proxmox, RouterOS,
switching, NetworkManager, DNS, SSH credentials, client configuration, or any
firewall. Do not enable Katra or Matrix firewalls. Do not remove or rewrite
Lore's existing rules. Do not commit or push.

Use only established facts from the baseline. Mark unavailable exact rule IDs,
comments, exports, insertion indexes, counters, and recovery commands as
unknown. Do not invent them. Make the packet explicitly blocked until:

- Access-edge ether6 is physically confirmed as Hadrian's sole endpoint;
- Hadrian 192.168.80.85/24 is accepted on VLAN 80;
- Hadrian's own credential and direct SSH client contact are ready;
- a fresh Lore firewall before-state and backup/export are captured; and
- an independent recovery path is tested.

Define these acceptance tests:

- positive: Hadrian at .80.85 directly reaches Lore TCP/22 using Hadrian's own
  identity with no ProxyJump through Matriarch;
- negative: Hadrian Wi-Fi .10.86 does not gain authority merely because the
  VLAN-80 rule exists;
- unchanged: Matriarch's accepted access and Lore's other existing flows still
  behave as they did before the change; and
- rollback: restore the exact captured before state and re-run the same tests.

At completion run git diff --check and report:

- the file created;
- every unresolved prerequisite;
- the exact operator decision still required;
- confirmation that no live action, commit, or push occurred.
```

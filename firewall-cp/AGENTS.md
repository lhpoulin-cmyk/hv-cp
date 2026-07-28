# firewall-cp working rules

This directory inherits `/home/louis/active/hv-cp/AGENTS.md`.

- Treat `../evidence/2026-07-27-local-hypervisor-firewall-baseline.md` as the
  accepted starting summary, not as an executable configuration.
- Work on one node and one intended flow per implementation packet.
- Preserve Proxmox rule order, node/cluster scope, runtime enablement, and
  default policies as separate facts.
- Never infer a fleet policy from Lore's current rules or from Katra/Matrix
  being empty.
- Do not combine firewall work with VLAN, DNS, credential, SSH-client, Ceph,
  guest, or RouterOS changes.
- Before proposing execution, require a fresh read-only before state, an exact
  backup/export, a recovery path independent of the affected flow, positive
  and negative tests, and exact rollback.
- A packet or configuration draft is not live authority. Do not connect to or
  modify a hypervisor unless the operator separately authorizes that target
  and action.
- Inspect `git status --short`, preserve unrelated work, and do not commit or
  push unless requested.

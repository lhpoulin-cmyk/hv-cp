# Decision: hypervisor firewall control-plane scope

Date: 2026-07-27
Status: accepted design direction; no live authority
Owner: operator

## Decision

Create `firewall-cp` beneath `hv-cp` as the active method for Proxmox host
firewall planning. Use node-specific, reversible packets. Do not create a
single fleet ruleset and do not normalize runtime enablement automatically.

## Sequence

1. Prepare Lore's narrow Hadrian authority SSH allowance, blocked until
   Hadrian's VLAN-80 path and identity are accepted.
2. Record the minimum intended hypervisor management flows and recovery
   requirements without changing live state.
3. Decide Katra's policy and enrollment separately.
4. Decide Matrix's policy and enrollment separately.
5. Consider reusable generation or validation tooling only after two nodes
   independently pass the same reviewed contract.

## First boundary

The first packet may concern only TCP/22 from Hadrian's accepted authority
identity to Lore's management address. It must not:

- enable or disable a firewall;
- change cluster-wide defaults;
- remove Matriarch, Katra, or former Alpha rules;
- change Proxmox UI, SPICE, ICMP, guest, forwarding, or output policy; or
- configure Hadrian, switching, DNS, credentials, or RouterOS.

## Deferred decisions

- the final approved operator-source table after the Alpha/Matriarch merge;
- whether management-subnet access to TCP/8006 remains acceptable;
- the intended default input policy for Katra and Matrix;
- guest and VM firewall ownership;
- Ceph/workload-zone firewall policy; and
- whether configuration generation is useful after policy convergence.

These unknowns block broad firewall rollout, not preparation of the first
Lore/Hadrian packet.

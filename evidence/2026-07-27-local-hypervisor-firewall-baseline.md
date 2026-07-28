# Local hypervisor firewall baseline — 2026-07-27

Status: accepted read-only evidence summary; no firewall change
Future consumer: proposed `firewall-cp` work under hv-cp

## Scope and method

The operator authorized read-only collection for Hadrian independence and requested that the resulting firewall state be preserved for a future firewall control plane. Existing Matriarch SSH contacts queried `pve-firewall status`, the effective INPUT jump, and Proxmox node/cluster firewall API records on Lore, Katra, and Matrix.

Collection occurred on 2026-07-27 EDT. The matching Lifetap archives dated 2026-07-26 for Lore/Katra and 2026-07-27 for Matrix were checksum-verified and used for host/interface identity. No firewall state was modified.

## Comparative result

| Node | Runtime status | Node configuration | Cluster configuration | Hadrian direct result |
| --- | --- | --- | --- | --- |
| `hv-lore` | enabled/running; INPUT jumps to `PVEFW-INPUT` | enabled with explicit ordered rules | enabled; default input DROP, output ACCEPT; no cluster rules | `.10.86` SSH timed out |
| `hv-katra` | disabled/running; INPUT policy ACCEPT | empty | empty | network contact reached SSH; authentication failed because Hadrian's configured identity file is absent |
| `hv-matrix` | disabled/running; INPUT policy ACCEPT | empty | empty | stopped on missing Hadrian host-key trust |

## Lore rule order

Lore's node rules are materially significant:

1. SSH accept from Matriarch management `192.168.10.80`.
2. SSH accept from Matriarch authority `192.168.80.80`.
3. SSH accept from Katra management `192.168.10.21`.
4. SSH accept from former Alpha management `192.168.10.84`.
5. Proxmox UI `8006/tcp` accept from management and authority subnets.
6. Narrow SPICE/ICMP accepts for established operator/monitoring sources.
7. Drop management, authority, and flat-fabric subnets.

Neither Hadrian's current `.10.86` nor planned `.80.85` is in the SSH accepts, so the later subnet drops explain the direct timeout. The old Alpha `.10.84` exception remains during the operator-confirmed Alpha/Matriarch merge.

## Control-plane implications

A future `firewall-cp` under hv-cp should begin here but must not normalize the three nodes blindly:

- record intended policy separately from runtime enablement;
- preserve ordered-rule semantics and default policy;
- use named operator identities rather than copying another node's addresses;
- test positive SSH/UI flows and negative subnet flows;
- separate host firewall changes from credential, DNS, and switch changes;
- retain an out-of-band or independent management route; and
- publish node-specific results back to canonical and private records.

This record is evidence, not an instruction to enable Katra/Matrix firewalls or edit Lore.

# Hypervisor firewall control plane

> **Bottom line up front:** `firewall-cp` turns observed Proxmox firewall state
> into one-node, reversible change packets. It does not enable, disable, or
> normalize a firewall by itself.

## Immediate objective

Make Hadrian an independent authority endpoint without broadening access or
changing Katra and Matrix merely to resemble Lore.

The first proposed change is narrow: after Hadrian's VLAN-80 path is accepted,
prepare Lore to accept SSH from Hadrian's authority address. That change must
remain separate from switch, DNS, credential, and client configuration.

## Start here

1. Read [the scope decision](decisions/2026-07-27-firewall-control-plane-scope.md).
2. Read [the firewall contract](docs/FIREWALL-CONTRACT.md).
3. Review [the source evidence](../evidence/2026-07-27-local-hypervisor-firewall-baseline.md).
4. Use [the packet template](templates/FIREWALL-CHANGE-PACKET.md).
5. Give a light coder [the bounded starting prompt](LIGHT-CODER-START-PROMPT.md).

## Simple operating loop

```text
observe one node -> decide one intended flow -> prepare one packet
-> approve -> change -> test allowed and denied flows -> record or roll back
```

## Current node posture

| Node | Observed posture | Present conclusion |
| --- | --- | --- |
| `hv-lore` | Firewall enabled; ordered accepts followed by subnet drops. | Hadrian is not allowed. Prepare one narrow SSH packet only. |
| `hv-katra` | Firewall disabled; node and cluster rules empty. | Do not enable it until its intended policy and recovery path are decided. |
| `hv-matrix` | Firewall disabled; node and cluster rules empty. | Do not enable it merely because it is a clean node. |

## Ownership boundary

`firewall-cp` owns firewall planning, reviewed summaries, packet structure, and
acceptance criteria for hypervisor host firewalls. It does not own:

- Netbrain firewall or routing policy;
- Access-edge VLAN configuration;
- DNS publication or resolver configuration;
- SSH credentials, certificates, or client trust;
- guest firewall policy, Ceph segmentation, or general egress policy; or
- live Proxmox configuration before an exact operator-approved packet.

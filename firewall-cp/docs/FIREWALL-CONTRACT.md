# Hypervisor firewall contract

Status: design contract; no live authority

## Always-works requirements

1. At least one independently verified recovery path remains available before,
   during, and after a host-firewall change.
2. One packet changes one node and one intended flow.
3. Every allow names source identity, source address, destination node,
   destination address, protocol, and port.
4. Node rules, cluster rules, runtime enablement, default policy, and effective
   packet-filter behavior are captured separately.
5. Rule order is part of the configuration. An allow must be validated in its
   effective position before later drops.
6. Acceptance requires both a positive test and a relevant negative test.
7. Rollback restores the exact captured before state, not an approximation of
   the intended policy.

## Required before-state record

| Field | Required evidence |
| --- | --- |
| Identity | Hostname, management address, and Proxmox node identity. |
| Runtime | Firewall service/runtime status and effective INPUT path. |
| Configuration | Node options/rules, cluster options/rules, rule order, and default policies. |
| Access | Current successful operator path and independent recovery path. |
| Dependency | Required VLAN, route, DNS, credential, and client-trust state, each marked accepted or blocked. |
| Recovery | Exact export/backup location and tested method to restore it. |

## Packet acceptance

A firewall packet is execution-ready only when it contains:

- the exact hv-cp commit supplying the method;
- one target node and one flow;
- fresh, dated before-state evidence;
- an exact proposed diff with insertion position;
- prerequisites and stop conditions;
- positive and negative tests;
- exact rollback commands or a verified restore procedure;
- canonical and private evidence destinations; and
- explicit operator approval for execution.

## Current intended identities

| Identity | Address | Status |
| --- | ---: | --- |
| Matriarch authority | `192.168.80.80/32` | Observed and currently accepted. |
| Hadrian authority | `192.168.80.85/32` | Planned; not accepted live. |
| Matriarch management | `192.168.10.80/32` | Observed transitional source; final role undecided. |
| Hadrian Wi-Fi | `192.168.10.86/32` | Observed client/recovery path; not automatically an authority source. |
| Former Alpha management | `192.168.10.84/32` | Existing Lore exception; disposition deferred during merge. |

This table records identity state. It is not an allowlist.

## Explicit exclusions

RouterOS, switching, DNS, credentials, client SSH configuration, guest
firewalls, Ceph networking, Helix zone policy, and outbound application policy
require their own owners and packets. A dependency may block firewall work; it
does not become part of the firewall mutation.

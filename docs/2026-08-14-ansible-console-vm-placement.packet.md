# Ansible console VM placement packet

Status: `APPROVED_FOR_REALIZATION — REALIZED`

This packet records the bounded VM request for the first Helix automation
console. Semaphore remains an implementation detail of `ansible-cp`; this is
not a new authority or service repository.

## Requested manifest

| Field | Requested value |
| --- | --- |
| Durable service identity | `ansible.home.arpa` |
| Guest name | `ansible-console` |
| Guest type | QEMU VM |
| OS | Debian 13 minimal, current approved cloud-image method |
| vCPU | 2 |
| RAM | 2 GiB |
| Root disk | 20 GiB |
| Network | one virtio interface on the current internal service network |
| Database | none external; SQLite inside guest |
| Containers | none required |
| VMID | `100` |
| IP | `192.168.10.250` (`network-cp` allocation) |
| Prefix | `/24` |
| Gateway | `192.168.10.1` |
| DNS | `192.168.10.251`, `192.168.10.252` |
| NTP | `192.168.10.243`, `192.168.10.244` |
| Storage | `local-zfs` on `hv-lore` |
| Bridge | `vmbr0` |
| Placement | `hv-lore` |
| Placement authority | explicit operator decision, continuation drive 2026-08-14 |

## Candidate evidence

Read-only Proxmox discovery on 2026-08-14 found:

- `hv-matrix`: approximately 49.9 GiB available RAM and 116.9 GiB available
  `local-zfs` capacity;
- `hv-lore`: approximately 73.2 GiB available RAM and 343.5 GiB available
  `local-zfs` capacity; and
- `hv-katra`: approximately 4.4 GiB available RAM and 97.6 GiB available
  `local-zfs` capacity.

The operator explicitly selected `hv-lore` for this service. VMID `100` was
verified as the next free identifier on the host before creation. The VM is
realized with the requested Debian 13, 2-vCPU, 2-GiB, 20-GiB baseline on
`local-zfs` and `vmbr0`.

The realized VM remains a service implementation surface of `ansible-cp`;
Semaphore owns no desired state and no fleet configuration was applied.

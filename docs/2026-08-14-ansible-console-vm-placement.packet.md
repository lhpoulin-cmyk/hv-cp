# Ansible console VM placement packet

Status: `PLACEMENT_BLOCKED — candidate prepared; VM not created`

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
| VMID | unallocated |
| IP | unallocated by `network-cp` |
| Storage | `local-zfs` on selected host, subject to owner validation |

## Candidate evidence

Read-only Proxmox discovery on 2026-08-14 found:

- `hv-matrix`: approximately 49.9 GiB available RAM and 116.9 GiB available
  `local-zfs` capacity;
- `hv-lore`: approximately 73.2 GiB available RAM and 343.5 GiB available
  `local-zfs` capacity; and
- `hv-katra`: approximately 4.4 GiB available RAM and 97.6 GiB available
  `local-zfs` capacity.

`hv-matrix` is the leading candidate by current isolated-service capacity,
but the reusable hv-cp doctrine does not currently declare a generic small
service placement rule. Capacity observation is not, by itself, placement
authority. The operator or an owning hv-cp decision must select the host
before creation.

No VM, disk, bridge, or guest configuration was changed by this packet.

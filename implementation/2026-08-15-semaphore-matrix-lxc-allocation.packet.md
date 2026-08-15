# Semaphore Matrix temporary LXC allocation

Status: `ALLOCATED_FOR_REALIZATION — BASE_LXC_NOT_CREATED`

This packet records the operator-authorized temporary Semaphore build surface.
It is an unprivileged LXC implementation node, not a durable service identity
or authority. The future dedicated VM remains a rebuild/restore operation.

## Allocation

| Field | Resolved value |
| --- | --- |
| Host | `hv-matrix` |
| CTID | `149` |
| Classification | `TEMPORARY_SERVICE_BUILD` |
| Purpose | temporary Semaphore / Helix-ARPA Ansible operator surface |
| Intended permanent form | dedicated VM after Ceph stabilization |
| Migration method | rebuild/restore, not container conversion |
| Storage | `local-zfs` |
| Bridge | `vmbr0` |
| CPU / RAM / rootfs | 2 vCPU / 2048 MiB / 20 GiB |
| OS | Debian 13 |
| Staging address | `192.168.10.149/24` |
| Gateway | `192.168.10.1` |
| DNS | `192.168.10.251`, `192.168.10.252` |
| NTP | `192.168.10.243`, `192.168.10.244` |
| Hostname | `semaphore-matrix-stage` |
| Autostart during staging | `NO` |
| Unprivileged | `YES` |
| Nesting | `NO` |
| Host mounts / passthrough | `NONE` / `NONE` |
| Ceph dependency | `NONE` |

## Allocation validation

Read-only PVE inspection on 2026-08-15 at hv-cp HEAD `8e36bda` found:

- CTID `149` absent from `nodes/hv-matrix/lxc/149.conf`;
- VMID `149` absent from `nodes/hv-matrix/qemu-server/149.conf`;
- CTID/VMID `149` absent from the current PVE cluster resource inventory;
- `local-zfs` active with approximately 116.9 GiB available;
- `vmbr0` up on `192.168.10.22/24`.

The current cluster also contains VM310 only on hv-matrix. The old Lore
VM100 allocation is not reused or changed.

## Required realization boundary

Create one LXC only after acquiring an approved Debian 13 template. The
realization must keep the isolation values above, configure `.149`, install
only `openssh-server` and `qemu-guest-agent`, and prove governed strict SSH
before Semaphore installation. No secrets, SQLite, DNS publication, or fleet
Ansible execution belongs to this packet.

## Rollback

Before service configuration, stop and remove only CT149 through the PVE
control plane if base validation fails. Do not remove any other guest or alter
storage, Ceph, Lore, VM100, or the durable `.250` identity.

## Evidence and canonical outputs

| Path | Disposition |
| --- | --- |
| this packet | create |
| `runbooks/CONTROLLED_CHANGE.md` | governing runbook |
| Matrix CT149 configuration | create during realization |
| arpa-docs temporary node record | update in peer authority after creation |
| network-cp IPAM `.149` | already allocated and collision-verified |

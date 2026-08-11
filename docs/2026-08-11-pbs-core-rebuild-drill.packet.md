# VM260 pbs-core rebuild drill — hv-cp placement packet

Status: planning packet; separate execution authorization required
Date: 2026-08-11
Runbook: [pbs-core rebuild validation](../../pbs-cp/docs/runbooks/pbs-core-rebuild-validation.md) (cross-control-plane design reference)

This packet reserves no live object. It records the bounded future PVE
realization for the pbs-core rebuild drill:

- host: `hv-matrix`;
- temporary VMID/name: `9260` / `restore-test-pbs-core`;
- storage: newly allocated `local-zfs` 64 GiB boot disk plus 1 MiB EFI disk;
- shape: q35, OVMF, 4 vCPU, 8192 MiB, virtio-scsi-single;
- boot/onboot: stopped until explicitly started for installation; `onboot=0`;
- devices: no network, PCI, USB, raw disk, or mount attachment.

Discovery found VMID 9260 absent from all three current hypervisors, 46 GiB
available memory and about 109 GiB free `local-zfs` capacity on `hv-matrix`.
The temporary appliance must use a freshly generated SMBIOS UUID/vmgenid; it
must not copy VM260 identifiers or attach to either production bridge.

The source installer is the existing PBS 4.2-1 ISO on hv-katra, SHA-256
`2fb299deac3929253712c9c3dfc9237edbe70af83c8848467616b771a1d5453e`. A future
execution packet must copy and verify it as a temporary `hv-matrix:local` ISO,
then remove it during guarded cleanup.

The drill intentionally uses configuration-only datastore-adoption readiness.
It must not add a storage NIC, mount the TrueNAS export, define a datastore
against the live path, or use production token/TLS/DNS identity. VM260 remains
the sole active writer and service identity. Production placement remains
deferred to Ceph VM rework; this temporary design decides neither topology nor
failover placement.

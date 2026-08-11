# pbs-core VM260 recovery contract

Date: 2026-08-11
Status: design input; not an execution packet

VM260 `pbs-core` on `hv-lore` is a rebuildable PBS appliance, not an
appropriate self-backup client of its served datastore. Current PVE realization
is q35/OVMF, 4 vCPU, 8192 MiB RAM, a 64 GiB local-zfs boot disk plus EFI, and
management/storage NICs on vmbr0/vmbr1.

For boot-disk or VM loss with an intact datastore, hv-cp supplies a dated,
separate implementation packet to recreate the VM appliance and local boot
storage. It must not recreate, modify, or replace the TrueNAS datastore.
Cross-host recovery requires a fresh placement packet that verifies target
capacity and both network attachments; no automatic failover or permanent
alternate placement is declared.

The guest's existing service IPs may be reused only after the source appliance
is proven unavailable and network-cp validates identity reuse. PBS
configuration, auth/TLS/token state, datastore adoption, and backing storage
remain owned by pbs-cp, auth/Foundation, and truenas-cp respectively.

This is not a VM260 recovery execution authorization. Placement realization is
deferred to future Ceph VM rework, but current appliance reconstruction inputs
must be maintained independently of that future decision.

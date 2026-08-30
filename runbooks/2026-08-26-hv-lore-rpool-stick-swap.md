# hv-lore rpool stick swap runbook

Status: superseded by the completed 2026-08-29 P3 migration

This runbook implements the dated stick-swap packet. It is not reusable
authority for any other disk, host, archive, secret, or installer operation.

## Stage A — immutable identity gates

Prove Lore, ONLINE old rpool, VM120/VM260 configuration, all mandatory-preserve
serials, exact P3 serials, Matrix, and Seagate serial/UUID. Require Seagate
unmounted and enough free capacity. Stop on mismatch or active conflicting
backup/maintenance work.

## Stage B — local recovery seed

Mount Seagate exFAT at its established root-only Matrix path with restrictive
`rw,nosuid,nodev,noexec`. Create only a new dated directory. Stream snapshot
`vzdump --stdout --compress zstd` archives for VM120 and VM260 to unique
`.part` files, require both producer and receiver success, sync, and promote
only completed files. VM120 must include only EFI and its managed system disk;
its three raw Toshiba disks remain `backup=no`.

Run `zstd -t`, then stream each archive through `vma config` and `vma list`.
Compare embedded configuration and qmdump device maps with current PVE config.
Stop if VM120 includes a Toshiba device or either archive lacks a required
disk.

## Stage C — configuration and checksums

Create a bounded host bundle containing the named network, resolver, PVE
storage/jobs/user/firewall, guest config, VFIO/module, kernel, hostname, boot,
PCI, and stable-disk evidence. Include only the required `pbs-core-lore`
private storage files from `/etc/pve/priv/storage`. Stream the tar payload
directly through `zstd` and `age` to the lab's three established recovery
recipients; no plaintext archive may exist on Seagate or intermediary disk.

Prove ciphertext decryptability with an authorized age identity by listing
filenames only. Hash VM120, VM260, ciphertext, and the existing pbs-core stream
using its already accepted hash when file size and metadata agree. Verify
`SHA256SUMS`, sync, and unmount Seagate.

## Stage D — final destructive gate

Reprove Lore, ONLINE/error-free old rpool, boot state, guest inventory, storage,
P3 identities, mandatory-preserve identities, seed hashes, and encrypted
secret recovery. Set destructive authorization only when every result passes.

Gracefully stop guests in dependency order, sync, prove the old rpool remains
ONLINE/error-free, and power off. No forced QEMU termination is permitted.

## Stage E — attended physical/install handoff

The operator physically removes both old-rpool NVMes and isolates all other
preserve disks where practical. Record exact disconnected serials. Install PVE
UEFI/ZFS mirror only on the two authorized P3 serials. First boot occurs with
the old rpool absent. Stop if target identity or mirror topology differs.

## Stage F — bootstrap and restoration

Verify the seed hashes from fresh PVE. Locally `qmrestore` VM120 first, reattach
the three Toshiba disks only by stable ID, and validate existing slowPool and
its PBS dataset without initialization. Then locally restore VM260, start it,
adopt the existing datastore without creation, decrypt the bounded reconnect
bundle, restore `pbs-core-lore`, and prove the catalog.

Restore remaining guests in bounded service-tested groups. Import only the
known jellyPool. Reconstruct VM140 against its preserved raw NVMe and freshly
identified P6000 BDF. Restore backup policy with `exclude=260`, capacity alerts,
and full service acceptance.

## Stage G — boot redundancy and acceptance

With production guests stopped, prove each P3 independently boots a DEGRADED
mirror, reconnect both, and finish ONLINE. Keep the original NVMe pair offline
and untouched as rollback authority. Acceptance requires every condition in
the operator packet; otherwise use the physical rollback sequence.

# Implementation packet: hv-lore old-rpool disk-image inventory

Status: superseded by the completed 2026-08-29 read-only old-rpool migration;
the blocked inventory result below remains historical evidence

Date: 2026-08-28
Host: `hv-lore` (`192.168.10.20`)
Play: `HV-LORE-OLD-RPOOL-IMAGE-INVENTORY`
Authority: explicit operator request dated 2026-08-28
Runbook: [old-rpool disk-image inventory](../runbooks/2026-08-28-hv-lore-old-rpool-image-inventory.md)

## Objective

Import the historical Lore root pool from the two exact Timetec NVMe devices
without writing pool metadata or data, mount only its old root and
`var-lib-vz` datasets read-only, and enumerate every guest disk image visible
through both ZFS volumes and file-backed storage.

## Repository and target identity

- hv-cp execution commit: `7d7a9d97ecc1583e575c7a3a6885d89281d1308e`.
- Freshly fetched `origin/main`:
  `e615f0c8581b0ef18aa5ad9c8a9088a6c004928d`; it is an ancestor of the
  execution commit.
- Active production pool: P3 mirror `rpool`, not in scope for mutation.
- Historical pool GUID: `8921639095104950851`.
- Historical members:
  `nvme-Timetec_PCIe_SSD_TP250913B5D3323` and
  `nvme-Timetec_PCIe_SSD_TP250913B5D1797`.
- Temporary import name: `hv-lore-old-rpool-readonly`.
- Alternate root: `/mnt/hv-lore-old-rpool-readonly`.

Linux names such as `/dev/nvme0n1` and `/dev/nvme1n1` are observations only.
Execution selects the stable serial-based paths and the exact ZFS GUID.

## Authorized live changes

1. Create the root-owned alternate-root directory.
2. Import only GUID `8921639095104950851` with `readonly=on`,
   `cachefile=none`, `-N`, the alternate root, and the temporary name.
3. Mount only the old `ROOT/pve-1` and `var-lib-vz` datasets with `-o ro`.
4. Leave the bounded import mounted read-only after successful inventory so
   the operator can inspect the recovered images.

No guest start/restore, PVE storage registration, pool repair, scrub, resilver,
property change, label write, filesystem write, or active-rpool change is
authorized. Do not use `-f` unless read-only discovery proves the exact GUID
requires it solely because the pool was last active on another system; if it
is required, rerun the same import with `-f` and all other safeguards intact.

## Required inventory

- `zfs list -t volume` for all zvol-backed VM images, including logical and
  allocated sizes;
- regular files with disk/archive/media extensions under the mounted old root
  and `/var/lib/vz`: `raw`, `qcow2`, `vmdk`, `vdi`, `img`, `vhd`, `vhdx`,
  `vma`, compressed VMA variants, and `iso`;
- old PVE QEMU and LXC configuration references when present, without
  interpreting missing configuration as proof that an image is unused; and
- final proof that the historical pool remains `readonly=on`,
  `cachefile=none`, healthy, and mounted only with read-only VFS options.

## Rollback

Unmount the two explicitly mounted datasets in reverse order, export only
`hv-lore-old-rpool-readonly`, and remove the empty alternate-root directory.
Never export or alter the active production `rpool`.

## Evidence and canonical outputs

| Path | Disposition |
| --- | --- |
| `evidence/2026-08-28-hv-lore-old-rpool-image-inventory.md` | create with reviewed non-secret results |
| `implementation/2026-08-28-hv-lore-old-rpool-image-inventory.packet.md` | create |
| `runbooks/2026-08-28-hv-lore-old-rpool-image-inventory.md` | create |
| `/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-lore/CURRENT_STATE.md` | update after accepted live mount |
| `/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-lore/VALIDATION.md` | update after accepted live validation |
| `/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-lore/TODO.md` | update only if cleanup or image classification remains open |
| Other node identity/network records | not affected; no identity or network change |

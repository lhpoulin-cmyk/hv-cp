# Runbook: hv-lore old-rpool disk-image inventory

Status: superseded by the completed 2026-08-29 read-only old-rpool migration

Date: 2026-08-28
Packet: [old-rpool disk-image inventory packet](../implementation/2026-08-28-hv-lore-old-rpool-image-inventory.packet.md)

## Preconditions

Run as the governed privileged identity on `hv-lore`. Capture all output in
`evidence/2026-08-28-hv-lore-old-rpool-image-inventory.md`. Stop before import
unless every identity and collision check passes.

```bash
hostname
id
pveversion --verbose
findmnt -no SOURCE,FSTYPE,OPTIONS /
zpool list -H -o name,guid,health
lsblk -e7 -o NAME,PATH,SIZE,MODEL,SERIAL,TYPE,FSTYPE,LABEL,MOUNTPOINTS
readlink -f /dev/disk/by-id/nvme-Timetec_PCIe_SSD_TP250913B5D3323
readlink -f /dev/disk/by-id/nvme-Timetec_PCIe_SSD_TP250913B5D1797
zpool import -d /dev/disk/by-id/nvme-Timetec_PCIe_SSD_TP250913B5D3323 \
  -d /dev/disk/by-id/nvme-Timetec_PCIe_SSD_TP250913B5D1797
```

Require host `hv-lore`; active `/` on the P3 `rpool`; both Timetec serials;
historical GUID `8921639095104950851`; and no imported pool already using that
GUID or temporary name.

## Collision-safe read-only import

```bash
install -d -o root -g root -m 0700 /mnt/hv-lore-old-rpool-readonly
zpool import -N -o readonly=on -o cachefile=none \
  -R /mnt/hv-lore-old-rpool-readonly \
  -d /dev/disk/by-id/nvme-Timetec_PCIe_SSD_TP250913B5D3323 \
  -d /dev/disk/by-id/nvme-Timetec_PCIe_SSD_TP250913B5D1797 \
  8921639095104950851 hv-lore-old-rpool-readonly
zpool get -H -o property,value guid,readonly,cachefile,health \
  hv-lore-old-rpool-readonly
zfs list -r -o name,type,mountpoint,mounted,readonly,used,refer,volsize \
  hv-lore-old-rpool-readonly
zfs mount -o ro hv-lore-old-rpool-readonly/ROOT/pve-1
zfs mount -o ro hv-lore-old-rpool-readonly/var-lib-vz
```

If import reports that the exact pool was last active on another system, first
reconfirm the GUID and both stable device identities. Then add only `-f` to the
same guarded import. Do not use recovery flags, rewind, repair, or writable
import options.

## Enumerate all disk images

Zvol-backed images:

```bash
zfs list -H -p -t volume -r \
  -o name,volsize,used,refer,readonly,origin \
  hv-lore-old-rpool-readonly
```

File-backed images, backup archives, and installer media:

```bash
find /mnt/hv-lore-old-rpool-readonly \
  /mnt/hv-lore-old-rpool-readonly/var/lib/vz \
  -xdev -type f \
  \( -iname '*.raw' -o -iname '*.qcow2' -o -iname '*.vmdk' \
     -o -iname '*.vdi' -o -iname '*.img' -o -iname '*.vhd' \
     -o -iname '*.vhdx' -o -iname '*.vma' -o -iname '*.vma.gz' \
     -o -iname '*.vma.zst' -o -iname '*.iso' \) \
  -printf '%s\t%TY-%Tm-%TdT%TH:%TM:%TS%Tz\t%p\n' | sort -k3,3
```

Configuration references, when present:

```bash
find /mnt/hv-lore-old-rpool-readonly/etc/pve \
  -xdev -type f \( -path '*/qemu-server/*.conf' -o -path '*/lxc/*.conf' \) \
  -print -exec sed -n \
  '/^name:/p;/^hostname:/p;/^\(ide\|sata\|scsi\|virtio\|efidisk\|tpmstate\|rootfs\|mp[0-9]\+\):/p' {} \;
```

## Read-only acceptance

```bash
zpool get -H -o property,value guid,readonly,cachefile,health \
  hv-lore-old-rpool-readonly
findmnt -rn -o TARGET,SOURCE,FSTYPE,OPTIONS \
  | grep -F '/mnt/hv-lore-old-rpool-readonly'
zpool status -P hv-lore-old-rpool-readonly
zpool status -P rpool
```

Acceptance requires the exact old GUID, `readonly=on`, `cachefile=none`, no
pool errors, `ro` on every old-rpool mount, and the active P3 `rpool` still
ONLINE and unchanged.

## Cleanup when requested

```bash
zfs unmount hv-lore-old-rpool-readonly/var-lib-vz
zfs unmount hv-lore-old-rpool-readonly/ROOT/pve-1
zpool export hv-lore-old-rpool-readonly
rmdir /mnt/hv-lore-old-rpool-readonly
zpool list -H -o name,guid,health
```

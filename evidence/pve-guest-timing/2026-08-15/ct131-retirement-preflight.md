# CT131 retirement preflight

Date: 2026-08-15
Host: `hv-katra`
CTID: `131`
Hostname: `lxc-katra-jellyfin`

Final configuration captured before destruction:

```text
status: stopped
arch: amd64
cores: 2
hostname: lxc-katra-jellyfin
memory: 2048
mp0: /mnt/truenas/secure-rw/jellyfin-media,mp=/media/private
nameserver: 192.168.10.251
net0: name=eth0,bridge=vmbr0,gw=192.168.10.1,hwaddr=BC:24:11:8F:03:63,ip=192.168.10.131/24,type=veth
net1: name=eth1,bridge=vmbr1,hwaddr=BC:24:11:2D:2B:83,ip=192.168.100.131/24,mtu=9000,type=veth
onboot: 0
ostype: debian
rootfs: local-zfs:subvol-131-disk-0,size=16G
searchdomain: arpa
startup: order=40,up=20,down=30
swap: 512
```

Inspection results:

- Snapshots: none (`current` only).
- HA membership: none.
- Replication membership: none.
- Backup-job references: none; the inspected Katra vzdump job covered CT249,
  VM320, CT251, and CT244 only.
- Local storage ownership: exactly one local volume,
  `local-zfs:subvol-131-disk-0`, a 16 GiB rootdir volume owned by CT131.
- External mount: `mp0` points to the existing TrueNAS path and is not local
  CT131 data. It was not repaired or accessed for this retirement.
- No additional local volumes or unreferenced disks uniquely attributable to
  CT131 were found.

Reason for retirement: superseded/stale Jellyfin LXC; its external mount
prevented startup, and it is no longer part of the desired Katra fleet.

The prior failed timing attempt remains preserved in the calibration summary;
this record does not reinterpret that failure as a successful measurement.

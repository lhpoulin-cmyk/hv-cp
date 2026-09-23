# Lore upgrade inspection — 2026-09-11

Read-only SSH observation requested by the operator. Repository HEAD:
`61cab3416294ebbd9d8eda2ccff2403fc20ab56d`. No template or implementation
packet used; remote repository currency was not checked. Existing dirty work
was preserved. Host timestamp: `2026-09-11T00:26:41-04:00`.

Collection used the existing Louis SSH configuration and noninteractive sudo
for host inventory, PVE inventory, DMI memory, ZFS status and VM120 disk
bindings. No host configuration, package index or package was changed.

## Observed hardware

- HP Z840, BIOS M60 v02.62; two Xeon E5-2680 v4 CPUs, 28 cores / 56 threads.
- DMI reports eight 16 GB and eight 8 GB DIMMs: 192 GB installed, 188 GiB
  visible to Linux. This inspection did not establish the prior DIMM capacity.
- Four 12 TB Toshiba disks are visible. Serial `46K2A0JWF1HJ`, model
  `HDWG51CUZSVB`, is additional to the three disks in the August 26 discovery.
  VM120 still maps only the original three Toshiba serials. No allocation or
  data-pool membership was inferred for the additional disk.
- Quadro P6000, four Timetec 512 GB-class NVMe devices, dual-port Intel 82599ES
  10GbE, two P3-256 boot disks and one P3-512 remain visible.
- P3 rpool mirror and jellyPool are ONLINE, with zero read/write/checksum
  errors and no known data errors. jellyPool reports disabled newer features.

## Software and workload observations

- Installed PVE manager: 9.2.2; running kernel: 7.0.2-6-pve. These are older
  than the pre-reinstall August 26 capture; current live values take precedence.
- Cached `apt list --upgradable` reports 134 package entries. Highlights:
  pve-manager 9.2.2 -> 9.2.18; proxmox-kernel-7.0 7.0.2-6 -> 7.0.14-16;
  pve-qemu-kvm 11.0.0-3 -> 11.0.3-3; ZFS 2.4.2-pve1 -> 2.4.4-pve1.
  The update-success-stamp is absent; index freshness is unverified.
- Six VMs and six CTs are running. VM242 pbs-katra and CT249 vaultwarden-lore
  are stopped, unlike the retained August 29 inventory. No start attempted.

This is an observation, not upgrade acceptance, a storage allocation decision,
or authorization to replay commands. No accepted node change occurred, and
canonical node records were not rewritten.

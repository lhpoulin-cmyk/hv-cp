# hv-lore full host inventory — 2026-09-12 EDT

Classification: sanitized immutable observation, not configuration acceptance.
Collection: 2026-09-12 21:50:23–21:50:59 EDT (2026-09-13 01:50:23–01:50:59 UTC),
with subsequent narrow boot-pool/KVM confirmation. Source hv-cp HEAD:
`9e6638bc618df2cc3eaab9c37f4baf299a84e7a1`. No template or mutation packet used.

## Primary findings

The host is running the historical Timetec NVMe rpool, GUID
`8921639095104950851`, rather than the documented accepted P3 mirror GUID
`4137356908105663872`. findmnt confirms / on rpool/ROOT/pve-1; active zpool
members are Timetec NVMe partitions. Both P3-256 devices remain physically
visible with rpool member labels. No alternate pool was imported for inspection.

The currently presented ED25519 key matches the existing trusted hv-lore.arpa
entry (SHA256:kwxbCuVmfZz91HFmUANA1pUvf7J3E1xrSlDc4gM9cnc), while the IP entry
retains the documented post-reinstall key. Invocation-only HostKeyAlias and
ED25519 selection preserved strict SSH verification. Reauth's login certificate
does not resolve this different boot environment's host identity. No trust file
was changed. The old boot pool provides a concrete explanation for the drift.

Only RTX 5060 is enumerated; no P6000 or Arc A750 appears in the complete PCI
inventory. VMX is disabled by BIOS according to the current-boot kernel;
/dev/kvm and the kvm_intel module directory are absent. No IOMMU groups are
reported for inventoried PCI endpoints. No firmware change was attempted.

## Platform and hardware

| Component | Observed |
| --- | --- |
| Chassis | HP Z840 Workstation |
| Firmware | M60 v02.62, 2024-01-04; UEFI boot, BootCurrent 000C |
| CPU | 2 × Xeon E5-2680 v4 @ 2.40 GHz; 28 cores / 56 threads |
| RAM | 192 GB installed: 8 × 16 GB + 8 × 8 GB; 188.79 GiB Linux-visible |
| Memory usage | Approximately 5.67 GiB used at capture; swap 8 GiB, unused |
| GPU | RTX 5060, 10de:2d05, 09:00.0; no bound graphics driver |
| GPU audio | 09:00.1, 10de:22eb; snd_hda_intel |
| Storage HBA | LSI SAS2308, 01:00.0, 1000:0086 |
| NVMe controllers | Four Phison PS5015-E15 endpoints, 05:00.0 through 08:00.0 |
| Networking | Intel 82599ES dual 10GbE; Intel I218-LM and I210 gigabit |
| Optical | HP HLDS DVDRW GUD1N; no media read/test performed |

## Software and boot

Debian 13; PVE manager 9.2.6; kernel 7.0.14-8-pve; qemu-server 9.2.1;
PVE QEMU 11.0.3-1; ZFS userspace 2.4.3-pve1. Last boot timestamp from uptime:
2026-09-12 21:43:37 EDT. These are observations of the older boot environment,
not proof that the accepted P3 installation was upgraded or downgraded.
763 installed package entries captured. Cached apt output lists 54 upgradable
entries; index freshness is unknown and no refresh/install was run.
No Corosync configuration: pvecm status returned 2, consistent with standalone
operation. Sensors utility absent: temperatures outside available SMART are
UNKNOWN. No package was installed to fill a gap.

## Physical storage and health

| Device group | Capacity / observation |
| --- | --- |
| Toshiba HDDs | 4 × 12,000,138,625,024 bytes; three ZSVA devices carry slowPool labels, fourth ZSVB has no partition/filesystem label observed |
| P3-256 SATA SSDs | 2 × 256,060,514,304 bytes; both carry rpool member labels, neither is in the currently active rpool |
| P3-512 SATA SSD | 512,110,190,592 bytes; no partition/filesystem label observed |
| Timetec NVMe | 4 × 512,110,190,592 bytes; two active old rpool members, one jellyPool member, one Fedora/btrfs guest disk |
| Active rpool | ONLINE; 472 GiB raw pool size, about 129.29 GiB allocated / 342.71 GiB free; zero read/write/checksum errors |

All 11 physical non-USB disks returned SMART health PASSED, exit 0. All four
Toshibas report zero reallocated, pending and offline-uncorrectable sectors.
NVMe critical warnings and media/data-integrity errors are zero; temperatures
30–33 C; two devices report 2% used, two 0%. No SMART self-test was launched.
Virtual zvol SMART probes returned unsupported-device errors and do not imply
physical disk failure; the reusable collector now excludes them.

PVE storage observations: arpa-vzdump NFS active at 99.82% used; local and
local-zfs active; jelly-zfs and both enabled PBS destinations inactive; legacy
pbs-lore disabled. NFS server availability does not prove backup integrity.
TrueNAS slowPool was not imported or inspected internally; TrueNAS VM was stopped.

**Collection caveat:** pvesm status attempted automatic activation of jellyPool.
ZFS refused because the pool was last used by a different host ID (last access
2026-09-12 10:53:24). The command exited 0 but included activation errors. No
force import was attempted; a later zpool status still lists only rpool. The
reusable helper now omits pvesm status to avoid this side effect. No successful
pool import, explicit host configuration change or guest action was performed.
proxmox-boot-tool status reported its normal private mount namespace operation.

## Guests at inventory capture

All ten VMs were stopped. Five of seven containers were running. These are
capture-time states; later network observation included veth devices for CT248
and CT249, so their state may have changed independently during the session.
No guest was started or stopped by this inventory.

| ID | Type | Name | State | Configured RAM MiB | Cores | Onboot |
| --- | --- | --- | --- | --- | --- | --- |
| 100 | VM | ansible-console | stopped | 2048 | 2 | 1 |
| 120 | VM | truenas-lore | stopped | 32768 | 4 | 1 |
| 130 | VM | jellyfin-lore | stopped | 16384 | 4 | 1 |
| 140 | VM | ws-lore-agent | stopped | 32768 | 8 | 1 |
| 141 | VM | ws-lore-apropos | stopped | 32768 | 8 | 0 |
| 142 | VM | eq-lore | stopped | 8192 | 4 | 1 |
| 149 | VM | ws-matriarch-gauntlet | stopped | 32768 | 8 | 0 |
| 150 | VM | wow-unbound-prod | stopped | 24576 | 8 | 0 |
| 242 | VM | pbs-katra | stopped | 8192 | 4 | 1 |
| 260 | VM | pbs-core | stopped | 8192 | 4 | 1 |
| 243 | CT | time-lore | running | 512 | 1 | 1 |
| 245 | CT | ntfy-lore | running | 512 | 1 | 1 |
| 246 | CT | lxc-lore-headscale | running | 1024 | 1 | 1 |
| 247 | CT | lxc-lore-monitor | running | 2048 | 2 | 1 |
| 248 | CT | lxc-lore-www | stopped | 512 | 1 | 1 |
| 249 | CT | vaultwarden-lore | stopped | 2048 | 2 | 1 |
| 252 | CT | lxc-lore-dns | running | 512 | 2 | 1 |

VM140's stored hostpci0/1 target 06:00.0 and 06:00.1. Current 06:00.0 is an NVMe
controller; the GPU is 09:00.0/1. This is stale hardware binding, not a safe guest
start configuration. No attempt was made to execute or repair that assignment.
Allowlisted guest device/resource configurations are retained privately.
Guest applications, internal filesystems and service health were not probed.

## Network and services

Management vmbr0: 192.168.10.20/24, nic0 bridge member, MTU 1500, link up.
Storage vmbr1: 192.168.100.20/24, nic2 bridge member, MTU 9000, link up.
Default route via 192.168.10.1 on vmbr0. eno1 and nic1 were down. Complete
addresses, routes, bridge/VLAN state, listening sockets and device drivers are
in the private capture. Network policy remains network-cp authority.

PVE firewall reports enabled/running. One failed service:
zfs-import-cache.service. Kernel warning collection includes VMX disabled,
ACPI firmware errors and CPU mitigation notices. Complete current-boot excerpts,
running service list, timers and recent PVE task outcomes were captured; none
was restarted or changed. This is an inventory, not whole-host health acceptance.

## Evidence and validation

Private source: `inbox/hv-lore-inventory-20260912-w5zjmodh/`, 0700 directory,
0600 files, local ignore rule, SHA256SUMS. inventory.json contains exact argv,
per-command exit code/status and private identity details; collector.py preserves
the executed version. boot-confirmation.json independently proves active pool,
root mount and KVM absence. SSH transport exited 0; all 17 guest config queries
succeeded. No credentials or full unrestricted configuration dumps were collected.

The [runbook](../runbooks/2026-09-12-hv-lore-readonly-inventory.md) describes the
collection boundary and subsequent helper corrections. AST syntax, links and
whitespace checks pass. Unrelated work remains preserved. No accepted node
change occurred, so canonical accepted-state records were not overwritten with
this unexpected older boot environment. No commit or push requested for this task.

## Collection return codes

Optional absence/unsupported probes are UNKNOWN, not failed host hardware.
A zero command exit does not erase stderr findings, particularly storage activation.

| Collector | Exit/status |
| --- | --- |
| identity | 0 |
| time | 0 |
| boot | 0 |
| uptime | 0 |
| kernel | 0 |
| pve_version | 0 |
| nodes | 0 |
| vms | 0 |
| containers | 0 |
| vm_list | 0 |
| ct_list | 0 |
| storage | 0 |
| cpu | 0 |
| memory | 0 |
| dmi | 0 |
| pci | 0 |
| pci_tree | 0 |
| usb | 0 |
| usb_tree | 0 |
| block | 0 |
| mounts | 0 |
| space | 0 |
| pools | 0 |
| pool_capacity | 0 |
| datasets | 0 |
| boot_config | 0 |
| efi | 0 |
| addresses | 0 |
| links | 0 |
| routes | 0 |
| bridges | 0 |
| vlans | 0 |
| listeners | 0 |
| cluster | 2 |
| node_status | 0 |
| failed | 0 |
| services | 0 |
| timers | 0 |
| pve_firewall | 0 |
| kernel_warnings | 0 |
| kernel_hardware | 0 |
| sensors | UNKNOWN: tool absent |
| packages | 0 |
| cached_updates | 0 |
| tasks | 0 |
| smart_sda | 0 |
| smart_sdb | 0 |
| smart_sdc | 0 |
| smart_sdd | 0 |
| smart_sde | 0 |
| smart_sdf | 0 |
| smart_sdg | 0 |
| smart_zd0 | 1 |
| smart_zd16 | 1 |
| smart_zd32 | 1 |
| smart_zd48 | 1 |
| smart_zd64 | 1 |
| smart_zd80 | 1 |
| smart_zd96 | 1 |
| smart_zd112 | 1 |
| smart_zd128 | 1 |
| smart_zd144 | 1 |
| smart_zd160 | 1 |
| smart_zd176 | 1 |
| smart_zd192 | 1 |
| smart_zd208 | 1 |
| smart_zd224 | 1 |
| smart_zd240 | 1 |
| smart_nvme1n1 | 0 |
| smart_nvme3n1 | 0 |
| smart_nvme2n1 | 0 |
| smart_nvme0n1 | 0 |
| smart_zd256 | 1 |
| smart_zd272 | 1 |
| smart_zd288 | 1 |

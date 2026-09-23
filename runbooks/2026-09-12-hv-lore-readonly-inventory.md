# hv-lore read-only full inventory

Operator request: run a full inventory of hv-lore. No live changes authorized.
Stream [host-readonly-inventory.py](helpers/host-readonly-inventory.py) through
strict SSH to hv-lore as existing louis, `sudo -n python3 - hv-lore`.

Collection boundary: host identity/firmware/CPU/DIMMs/PCI/USB/IOMMU, OS/PVE,
block and ZFS/mount/boot metadata, SMART identity/health without self-tests or
intentional standby spin-up, network addresses/routes/bridges/listeners,
Proxmox guest inventory and allowlisted hardware/resource settings, services,
timers, recent task outcomes and current-boot kernel logs. Optional installed
sensors and Ceph status are queried where available. Cached package updates
are queried without refreshing indexes. No credentials or full config dumps.
No guest login, workload test, disc read, network probe, mount, pool import,
scrub, guest start/stop, package install or host modification occurs.

Each command records exit code or UNKNOWN for tool absence/timeout. Retain raw
JSON privately under inbox with restrictive permissions and local ignore rule;
checksum capture and write a separately reviewed evidence summary. Historical
node records are compared as dated observations, not silently rewritten.


Collection finding: do not use `pvesm status` in a strict observation helper.
The original capture showed it attempting automatic activation of jellyPool;
ZFS refused the import due to a different last-used host ID. The reusable
helper now omits that command and excludes virtual zvols from SMART probing.
Use existing zpool/lsblk/findmnt/df observations; no import is authorized.

For this session, the IP-based SSH key differed, but the presented ED25519 key
matched the existing hv-lore.arpa known_hosts entry. An invocation-only
HostKeyAlias=hv-lore.arpa with HostKeyAlgorithms=ssh-ed25519 preserved strict
verification; no known_hosts, SSH configuration or credentials were changed.
The resulting inventory proved the older Timetec boot environment was active.

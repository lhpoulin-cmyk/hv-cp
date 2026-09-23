# Matrix LG native passthrough acceptance — 2026-09-12

Classification: sanitized immutable observation and execution summary.
Authority: operator “we need the lg passed through”; LG-only resumption.
Packet: [LG realization](../implementation/2026-09-12-matrix-lg-passthrough.packet.md).
Private source: ignored `inbox/optical-status-20260912-63touje1/`, mode 0700,
files 0600, SHA256SUMS. Host logs use EDT; guest uses UTC. Shutdown/start
occurred around 00:27–00:28 EDT / 04:27–04:28 UTC on September 12.

## Before and change

Strict management SSH established hv-matrix, PVE 9.2.2, VM310 b70-encode.
Before config exactly matched September 11, with no pending changes. Guest
hostname and SMBIOS UUID matched. LG WH16NS60 was the only block descendant
of ASMedia 03:00.0, sole member of IOMMU group 36, with reset advertised.
HP shares Intel 00:17.0 with both host rpool members and remained excluded.
Root optical inventories, services/timers/jobs, processes, cron metadata,
container absence and GPU handles qualified the bounded clean shutdown.
No optical mounts, guest optical handles or active encode/rip work were found.

`qm shutdown 310 --timeout 60 --forceStop 0` succeeded. Stopped-state capture
proved LG handles released and unchanged configuration. PVE digest-guarded
`qm set` added `hostpci2: 0000:03:00.0,pcie=1`, removed ide2 and changed boot
from `order=scsi0;ide2` to `order=scsi0`. Full-property comparison passed before
`qm start 310`, which succeeded. Both GPU properties, USB, disks and all other
settings remained exact. No pending properties remain.

## Accepted observations

| Physical drive | Guest block / generic SCSI | Identity and transport |
| --- | --- | --- |
| LG WH16NS60 | /dev/sr1 / /dev/sg3 | Exact preflight SATA serial matches; native ASMedia ahci |
| USB BP50NB40 | /dev/sr0 / /dev/sg2 | Exact host/guest USB serial and vendor/product match; retained usb0 |
| HP GUD1N | Absent | Retained on host Intel ahci with rpool disks |

No QEMU DVD-ROM remains. Host ASMedia uses vfio-pci; guest ASMedia initializes
with ahci and enumerates the LG ATAPI device. Host logs show PVE-managed reset
completion. New guest boot ID confirms the clean stop/start. VM remains running.
Guest xe and snd_hda_intel drivers remain, renderD128 exists, and louis has
read/write access by permission check. All five /mnt/media mountpoints survived
startup; no optical media is mounted. Guest reports zero failed systemd units.
Direct vmbr0/192.168.10.22 SSH, routes and host rpool remain healthy.

## Limits

PVE/QEMU start emitted: `BAR 5: failed to create dma-buf: PCI BAR IOMMU mappings
may fail: Invalid argument`. Start returned zero; AHCI initialization, SATA link,
physical identity and sr/sg enumeration succeeded. The captured guest optical
kernel excerpt contains no LG initialization failure. The warning is retained,
not declared repaired or harmless for untested operations.

No disc read/rip/write/eject/mount, encode, ARM/Docker change, host reboot,
manual GPU reset or additional VFIO lifecycle test was performed. PVE itself
reset assigned devices during the ordinary authorized guest start. Persistent
configuration and initial startup are proven, not repeated restart behavior or
host reboot acceptance. PBS was already unreachable; no backup/restore claim.
HP recabling and three-drive acceptance remain deferred. Rollback was not needed.

Canonical projection: Matrix CURRENT_STATE, VALIDATION, TODO and README updated;
heartbeat-profile documentation validator passed. Existing unrelated dirty
history was preserved. No commit or publication was requested.

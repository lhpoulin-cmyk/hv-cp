# Lore PCI passthrough removal — 2026-09-14

Result: PASS. Explicit operator request executed using existing strict SSH and
sudo -n, under [packet](../implementation/2026-09-14-hv-lore-remove-pci.packet.md)
and [runbook](../runbooks/2026-09-14-hv-lore-remove-pci.md).
Source HEAD 9e6638bc618df2cc3eaab9c37f4baf299a84e7a1; fresh origin/main
704db7564b054ea3aee5e9108f734fde8c9de312. No commit or push.

## Backup and change

Root-only directory `/root/hv-lore-pci-removal-20260914` (0700) contains original
130.conf and 140.conf (0600), plus private before.json with all ten raw VM
configs, pending API observations, runtime states/PIDs and host boot ID.
Backups were saved before shutdown or configuration changes.

| File | SHA256 |
| --- | --- |
| 130.conf | 2fd6c1b184f701a3ebec245c04e422ab8b8d63380605df24a52ce11195da7950 |
| 140.conf | 454416e9733109dd9fc0ccb69005657ce4d98e5fec3b8cdfdca52c9a2de38298 |

VM130 was running. `qm shutdown 130 --timeout 120 --forceStop 0` returned
success and stopped state was confirmed. VM140 was already stopped. Exact
configuration equality was checked against backup before and after shutdown.
`qm set 130 --delete hostpci0 --digest <current SHA1>` removed 09:00.0/1;
`qm set 140 --delete hostpci0,hostpci1 --digest <current SHA1>` removed
04:00.0/1. Both operations succeeded. No direct writes to /etc/pve occurred.
Both target VMs remain stopped. No VM was restarted and no host reboot occurred.

## Validation

Fresh strict SSH verification passed all assertions:

- All ten VM raw config files have no hostpci lines, including any sections.
  Preflight found no snapshot or pending sections in these files.
- Every VM's PVE pending API returns no hostpci key, either current or pending.
- All ten configuration files are byte-identical to before-state after omitting
  only the three authorized target hostpci lines. Autostart, startup order,
  disks, NICs, guest drivers and every other setting were preserved.
- Every unrelated VM retains the same runtime state and process ID. NAS VM120
  truenas-lore remains running with PID 4912. Its guest-agent read-only
  `systemctl is-active middlewared nfs-server smbd` returned three active
  results and guest exit 0. No NAS setting, disk or service was modified.
- Host boot ID is unchanged. Management SSH remains available.

Backup, mutation, verification and NAS inspection SSH commands exited zero.
This proves configuration removal and bounded service continuity, not a NAS
client I/O workload test. No GPU driver rebind or physical power action occurred.
Historical GPU attachment/transcode acceptance is superseded by removal;
Jellyfin is stopped and hardware transcoding is unavailable without reassignment.

Canonical README, CURRENT_STATE, VALIDATION and TODO project this result;
prior dated observations are retained as historical. The hv-cp current-work
record also links this result. No unrelated dirty work was discarded.

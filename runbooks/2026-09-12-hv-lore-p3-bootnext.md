# Lore permanent P3 boot

Use only with the [authorized packet](../implementation/2026-09-12-hv-lore-p3-bootnext.packet.md).
Use strict SSH with the already trusted hostname key before reboot and the
already trusted P3 IP key afterward; no key replacement or verification bypass.

Capture `efibootmgr -v`, lsblk identities and udev paths, zpool GUID/health,
boot ID, qm list, pct list, PVE active tasks and systemd jobs. Read installed
pvesh/pct/efibootmgr help where needed. Correlate P3 hardware path to existing
Boot0021 before using it. Retain exact BootOrder and BootNext absence.

After active task/workload gate, run `pct shutdown ID --timeout 60 --forceStop 0`
for each captured running CT, verifying stopped. Require all VMs/CTs stopped
before boot selection. Never use forced termination or alter onboot properties.
Set `efibootmgr --bootorder ORDER` with 0021 first and all other original entries
in their original relative order. Set `efibootmgr --bootnext 0021`; verify both,
then normal `systemctl reboot`. Existing destination autostart policy remains
in effect; observe outcomes without repairing it in this task.

Poll management with bounded SSH attempts and strict known host keys. Keep
operator informed; confirmed console is the recovery path if SSH does not return.
Require the intended rpool GUID and member identities, healthy mirror, new boot
ID, BootCurrent, consumed BootNext, management path and PVE service state.
Use zpool/findmnt observations, not pvesm status (which may activate a pool).
Record KVM and guest limitations separately from successful boot selection.

Rollback before reboot: delete only newly set BootNext and restore the exact
original BootOrder. Failed boot: operator
console boot menu, P3 entry or captured original NVMe path. Do not create/delete
boot entries, make other order changes, force-import pools or modify drivers.
Write immutable evidence, update declared node records, validate documentation.

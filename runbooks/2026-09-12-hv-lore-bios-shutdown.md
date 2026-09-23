# Lore clean power-off for BIOS maintenance

Use the [authorized packet](../implementation/2026-09-12-hv-lore-bios-shutdown.packet.md).
Strict SSH, existing louis sudo. Confirm hostname, P3 GUID, empty active task
list and captured guest states. Run pct shutdown ID --timeout 60 --forceStop 0
for CT248,247,246,245,243,252, verifying each stopped. Abort forced termination.
Require all QEMU and LXC guests stopped, then systemctl poweroff. Save command
exits locally. Check SSH loss after a bounded interval; physical power-state
confirmation belongs to the operator at the already confirmed console.
No reboot, firmware edit or Wake-on-LAN. Preserve P3 permanent preference.
Record evidence and canonical maintenance state; validate documentation.

# Lore clean shutdown for BIOS maintenance — 2026-09-12 EDT

Operator: “ok shut him down” following the VT-x/VT-d console work discussion.
[Packet](../implementation/2026-09-12-hv-lore-bios-shutdown.packet.md),
[runbook](../runbooks/2026-09-12-hv-lore-bios-shutdown.md).

Exact host identity and expected P3 rpool GUID confirmed. Active PVE tasks empty.
All ten VMs already stopped; CT249 already stopped. CT248,247,246,245,243,252
were each cleanly shut down with pct shutdown --timeout 60 --forceStop 0;
all commands exited 0 and each stopped state was verified. Final PVE QEMU/LXC
queries confirmed every guest stopped. systemctl poweroff returned 0.

Private commands, UTC timestamps, exits, verification and SHA256SUMS:
`inbox/lore-bios-shutdown-vuymolym/`. SSH subsequently became unavailable;
this is management-path evidence, not independent chassis power telemetry.
Physical console/power confirmation remains with the operator.

No forced stop, automatic power-on, boot-order change, firmware setting edit,
package/driver/storage change or GPU assignment occurred. The saved P3-first
preference remains unchanged by this task. Operator will power on for BIOS
VT-x/VT-d changes; subsequent KVM/IOMMU/5060 checks are pending.

Canonical CURRENT_STATE, VALIDATION, TODO and README updated with maintenance
state, preserving existing work. Heartbeat-profile validator and whitespace
checks passed. No commit or push requested.

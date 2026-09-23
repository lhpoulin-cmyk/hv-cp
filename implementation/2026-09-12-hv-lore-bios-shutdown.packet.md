# Lore shutdown for operator BIOS work — 2026-09-12 EDT

Status: completed; guests cleanly stopped and host power-off accepted

Authority: “ok shut him down,” following the VT-x/VT-d console discussion.
Target: hv-lore, strict existing SSH at 192.168.10.20, accepted P3 root GUID
4137356908105663872. Source HEAD 9e6638bc618df2cc3eaab9c37f4baf299a84e7a1;
origin fetched this session, main 704db7564b054ea3aee5e9108f734fde8c9de312.
Unrelated dirty work is preserved. [Runbook](../runbooks/2026-09-12-hv-lore-bios-shutdown.md).

Before: ten VMs stopped; CT243,245,246,247,248,252 running; CT249 stopped.
No active PVE tasks. P3 root healthy. Refresh identity/tasks before execution.
Cleanly shut down only the six running CTs with pct shutdown, timeout 60,
forceStop 0. Require all guests stopped, then systemctl poweroff. No forced
stop, boot-order edit, firmware setting change, driver change or guest repair.
Operator has confirmed local console access and will power on for BIOS setup.
Recovery from a cancelled/failed shutdown is bounded inspection; no forced stop.
Power-on is physical operator action, not an automatic reboot or remote wake.

Private exact logs: fresh ignored inbox/lore-bios-shutdown-* directory.
Create evidence/2026-09-12-hv-lore-bios-shutdown.md. Canonical root
/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-lore/:
update CURRENT_STATE.md, VALIDATION.md, TODO.md and README.md with maintenance
shutdown and pending BIOS/readiness validation. command-log/README.md,
outputs/README.md, NOTIFICATION_IDENTITY.md and NTFY_HEARTBEAT_MODE.md not
affected: no classification, identity or notification configuration change.
Run live-mutation runbook audit before execution and heartbeat-profile node
validator after projection. SSH disappearance is not independent chassis-power
telemetry; describe that limit. No commit or push requested.

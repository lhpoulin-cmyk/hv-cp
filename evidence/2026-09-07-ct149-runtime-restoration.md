# CT149 runtime restoration — 2026-09-07 EDT

Operator explicitly requested restoration. `pct start 149` on hv-matrix
returned success with one Systemd 257/nesting advisory. Container boot journal
timestamp: 2026-09-08 00:13:19 (guest clock display). No backup was restored,
disk replaced, isolation relaxed, network changed, or task launched.

Before: stopped, local-zfs active, existing rootfs mounted, database quick_check
ok, 33 templates, no schedules. Task states were exclusively completed
success/error/stopped; no pending automation. Host boot date was September 3;
onboot=0 is a plausible reason the CT remained stopped, not a proven cause.

After: CT running; hostname semaphore-matrix-stage; eth0 192.168.80.149/24;
Semaphore service active; loopback HTTP port 3000 returns 200. Read-only
database inventory confirms 33 templates, two inventories, and existing
observer/executor credential references without accessing secret fields.
PVE configuration is unchanged, including onboot=0, nesting=0, unprivileged=1.

Container health limitation: dev-mqueue.mount, run-lock.mount and tmp.mount
failed with already-mounted/busy messages. /tmp and /run/lock exist with mode
1777. No claim of a fully healthy systemd state or successful fleet task run.
Enabling nesting would alter isolation and was not used as a workaround.

Follow-up Wowzer transport probes from CT149: TCP22 and TCP5986 timeout;
TCP5985 returned an OS-level connection error. No admitted Wowzer task found.
Restoring Semaphore does not prove remote management access to Wowzer.

Runtime restoration PASS, with mount-unit warnings and auto-start unchanged.
No secret contents were printed or copied. Lore's VM100 was left untouched.

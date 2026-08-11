# hv-katra bounded pbs-core restore drill

Date: 2026-08-11
Scope: temporary PVE CT lifecycle only

One accepted `pbs-core-katra` backup of CT244 `time-katra` was restored on
`hv-katra` to temporary CT9244 `restore-test-time-katra` on `local-zfs`.

- Restore: `UPID:hv-katra:0007EAC5:0165B94C:6A7B483D:vzrestore:9244:root@pam:`
  — `OK`, 2026-08-11T12:05:17-04:00 to 2026-08-11T12:06:31-04:00.
- The target remained stopped with `onboot: 0`. Its inherited `net0` was
  removed before offline inspection. No boot, production-network attachment,
  PCI/USB/raw-device attachment, or source-guest mutation occurred.
- PVE mounted the target once for bounded offline validation, then unmounted it.
- Cleanup: `UPID:hv-katra:0007F306:0165FE85:6A7B48EF:vzdestroy:9244:root@pam:`
  — `OK`. The guarded target CT and its restore-created local-zfs volume are
  absent afterward.
- Production CT244 remained running with its original configuration.

The temporary lifecycle proves only PVE realization and cleanup for this
offline restore drill. PBS recovery semantics remain owned by `pbs-cp`; this
does not create a permanent CT placement or authorize an isolated boot.

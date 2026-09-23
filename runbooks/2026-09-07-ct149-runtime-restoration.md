# Restore existing CT149 runtime

Use only with the same-date authorized implementation packet.
Confirm hv-matrix hostname and CT149 stopped state, expected rootfs and .80.149
identity, active local-zfs, healthy read-only database and no schedules or
queued mutating tasks. Preserve unrelated guests and onboot=0.

Run `sudo -n pct start 149` on hv-matrix. Observe through `pct status` and
`pct exec`: hostname, ip -br address, systemctl is-active semaphore, local
HTTP response and read-only database counts. Never launch an APPLY template.
If unsafe unexpected behavior appears, `pct shutdown 149 --timeout 60` is the
bounded rollback; do not destroy, recreate, force-stop or overwrite its disk.
Record the result and canonical dated runtime status.

# LG disc-I/O qualification — sudo gate, 2026-09-12

Classification: immutable sanitized read-only observation. Result: BLOCKED.
Operator authorized only guest /dev/sr1 and /dev/sg3, prohibited device writes,
package installation, mount/config/account/service changes and other drives,
and explicitly required stopping if elevation was necessary.

Private capture: `inbox/optical-lg-disc-20260912-rhvmadgx/`, SHA256SUMS.
No sudo, PVE guest-agent root execution or alternate privileged path was used.

## Established

Unprivileged strict SSH reaches b70-encode-matrix as louis, member of cdrom.
`test -r /dev/sr1` and `test -r /dev/sg3` each returned 0; both are root:cdrom
mode 0660. `readlink -f /sys/class/block/sr1/device` and
`readlink -f /sys/class/scsi_generic/sg3/device` identify the same SCSI target
10:0:0:0 behind guest ASMedia 03:00.0/ata8. Udev serial matches the exact LG
WH16NS60 serial in the previous physical identity capture.

`udevadm info --query=property --name=/dev/sr1` reports media present,
Blu-ray, complete, one data track/session, UDF 2.50, 2048-byte filesystem blocks,
label BACK_TO_THE_FUTURE_PART_II. These are udev metadata observations; no fresh
media probe or block read was completed. Capacity and current mount state were
not checked in this qualification before the gate.

`command -v sg_inq blkid dd timeout` found all four; `sg_inq --help` displayed
its existing inquiry interface. No SCSI inquiry was sent. Guest
`journalctl -k -n 1 --no-pager` returned a kernel entry successfully.
These discovery commands ran in one SSH command list with overall exit 0;
individual exit codes were not separately captured (except access tests).

## Gate and exact evidence

On hv-matrix, unprivileged `id; journalctl -k -n 1 --no-pager` returned overall
exit 0, but id lists only louis/sudo groups. Journalctl reports:

> You are currently not seeing messages from other users and the system.
> Users in groups 'adm', 'systemd-journal' can see all messages.

It then reports `-- No entries --`. This is unavailable log visibility, not
proof of no host errors. Guest kernel logs cannot establish absence of host
VFIO/BAR failures. Per the operator's explicit gate, work stopped here.

Required command on hv-matrix for a bounded test window:

```bash
sudo -n journalctl -k --since '5 minutes ago' --no-pager --utc
```

Not executed. Run promptly after the proposed <=30-second read test, retaining
exact start/end timestamps for filtering and comparison. The planned block
command is `timeout 30s dd if=/dev/sr1 of=/dev/null bs=1M count=16 iflag=direct,fullblock`.
This command was not executed; it would discard at most 16,777,216 read bytes.
Optional inquiry would use existing `sg_inq --only /dev/sg3`; no inquiry ran.

Bytes successfully read by the bounded block test: 0 (test not started).
No mount, disc, USB, HP, host configuration, passthrough, service or account
was changed. Qualification PASS is not claimed. Prior passthrough-enumeration
acceptance remains unchanged; this is a separate incomplete disc-I/O test.

BLOCKER=host kernel-log visibility requires elevation
operation=unprivileged journalctl -k on hv-matrix
observed=exit 0 with access warning and no visible entries
expected=system kernel messages covering the bounded test window
authority=operator requires stopping at the sudo gate
why_not_ordinary_debugging=privileged access would cross an explicit operator stop condition

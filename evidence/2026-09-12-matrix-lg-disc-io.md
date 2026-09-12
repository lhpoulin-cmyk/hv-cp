# LG WH16NS60 read-only disc-I/O qualification — 2026-09-12

Classification: sanitized immutable acceptance evidence. **PASS** for bounded
LG disc I/O, including read-only SCSI inquiry. This supersedes the earlier
[sudo-gate result](2026-09-12-matrix-lg-disc-io-gate.md) for this qualification.
Authority: operator's six-point LG-only read scope, followed by “you may elevate”.
No device writes, mounts, installation, configuration/account/service changes,
ripping or encoding. USB and HP were not probed. Elevated access was used only
for host kernel journal collection; guest device operations ran as louis.

Procedure: [read-only runbook](../runbooks/2026-09-12-matrix-lg-disc-readonly.md).
Private exact argv, results, timestamps, helper source and SHA256SUMS:
`inbox/optical-lg-io-20260912-l0i5dqz4/`. Initial discovery/probe commands are
in `guest-result.json`; outer SSH exits are in `guest-transport.json`.
The aligned read and its source are `aligned-read.json` / `aligned-read.py`.
All captures are local, ignored, mode 0600 under a 0700 directory. No disc
payload was saved; the direct read used anonymous memory that was discarded.

## Physical identity and disc

`/sys/class/block/sr1/device` and `/sys/class/scsi_generic/sg3/device` resolve
to the same SCSI target `10:0:0:0`, guest ASMedia `0000:03:00.0`, ata8.
Udev identifies HL-DT-ST WH16NS60, revision 1.02; exact serial equals the
previous host/guest physical LG capture. Serial retained privately.

Media present: udev `ID_CDROM_MEDIA=1`, `ID_CDROM_MEDIA_BD=1`, complete, one
session/data track. Fresh block capacity and filesystem probes succeeded:

- Disc type: Blu-ray; exact BD-ROM/recordable subtype not independently queried.
- Capacity: **86,710,419,456 bytes**, approximately **80.76 GiB**. Kernel sysfs
  sectors × 512 and `blockdev --getsize64` agree.
- Filesystem: **UDF 2.50**, logical block size 2048 bytes.
- Label: **BACK_TO_THE_FUTURE_PART_II**, confirmed by fresh blkid probe.
- Mount state: **unmounted** in the guest namespace. Both mountinfo captures
  contain no entry matching sr1's device number 11:1; no mount was changed.

## Exact commands and outcomes

Guest execution through existing strict SSH to `b70-encode-matrix` as louis:

| Exact command | Exit | Outcome |
| --- | --- | --- |
| `udevadm info --query=property --name=/dev/sr1` | 0 | LG serial/model correlation and media metadata |
| `timeout 15s blockdev --getsize64 /dev/sr1` | 0 | 86710419456 bytes |
| `timeout 15s blkid -p -o export /dev/sr1` | 0 | UDF 2.50 and volume label above |
| `timeout 15s sg_inq --only /dev/sg3` | 0 | Standard SCSI INQUIRY: HL-DT-ST, BD-RE WH16NS60, revision 1.02, peripheral cd/dvd |
| `timeout 30s dd if=/dev/sr1 of=/dev/null bs=1M count=16 iflag=direct,fullblock` | 1 | `dd: IO error: Invalid input`; no byte count emitted |
| `dd --version` | 0 | dd (uutils coreutils) 0.8.0 |
| `timeout 30s python3 -` with the linked aligned helper on stdin | 0 | **16,777,216 bytes read**, 2.491344554 seconds |

The exact successful read implementation is
[lg-aligned-read.py](../runbooks/helpers/lg-aligned-read.py):
`os.open('/dev/sr1', os.O_RDONLY | os.O_DIRECT)`, anonymous page-aligned 1 MiB
`mmap`, and sixteen `os.preadv(fd, [buf], offset)` calls for offsets
0, 1048576, …, 15728640. Each returned exactly 1,048,576 bytes. The read
covered byte range 0–16,777,215, bypassed the OS page cache, and changed no
device setting. The controller/drive's own caching is not excluded.

Successful block-read byte count: **16,777,216**. The failed dd command emitted
no count; its transferred bytes are UNKNOWN, not claimed as zero. Metadata and
inquiry transfer sizes are not included in this block-read count.

The immediate dd error is retained as a failed test method. The subsequent
aligned direct read proves the same bounded device operation succeeds. The
difference is consistent with a userspace direct-I/O implementation/alignment
issue; its precise cause was not established and no package was changed.

## Kernel evidence and time bounds

Initial probe/read attempt: 05:01:34.907847–05:01:42.835228 UTC.
Aligned read SSH invocation: 05:02:55.565664–05:02:58.597190 UTC
(01:02:55–01:02:58 EDT); device read duration 2.491344554 seconds.

Before each interval, capture a kernel journal cursor:

```bash
# Guest, unprivileged
journalctl -k -n 1 --show-cursor --no-pager --utc
# Host hv-matrix, operator-authorized elevation
sudo -n journalctl -k -n 1 --show-cursor --no-pager --utc
```

After each interval, capture entries after that machine's exact saved cursor:

```bash
# Guest
journalctl -k --after-cursor="$guest_cursor" --no-pager --utc -o short-iso-precise
# Host
sudo -n journalctl -k --after-cursor="$host_cursor" --no-pager --utc -o short-iso-precise
```

Every log command exited **0**, without access warnings. All four after-cursor
collections returned `-- No entries --`. Exact expanded cursor arguments are
in the private JSON command records. Therefore **no new controller/SATA reset,
I/O error, optical error or BAR failure appeared during either test interval**.
The host's last pre-test entry was the historical 04:28:12 USB startup reset;
the guest's pre-test entry was an unrelated AppArmor denial for `who`. Neither
is a test-time LG error. The prior QEMU startup BAR 5 warning is not erased or
claimed repaired; no recurrence during this test is observed.

## Acceptance boundary

PASS: exact physical LG correlation, media detected, bounded direct reads
succeeded, SCSI inquiry succeeded, no corresponding kernel failure/reset.
This establishes reading the tested 16 MiB only, not a full-disc scan, media
integrity, decryption, rip/encode readiness or repeated passthrough lifecycle.
The earlier dd exit 1 remains explicitly recorded and does not establish a
controller/device I/O failure in light of successful aligned O_DIRECT reads.

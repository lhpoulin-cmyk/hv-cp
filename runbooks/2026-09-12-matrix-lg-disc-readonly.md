# Matrix LG read-only disc qualification

Authority: operator explicitly authorized read-only qualification of guest
/dev/sr1 and /dev/sg3, subsequently stating “you may elevate” for required log
access. This runbook grants no write, configuration, mount or service authority.

Use existing strict SSH to b70-encode-matrix as louis. Capture a host kernel
journal cursor first using strict management SSH to hv-matrix, with
`sudo -n journalctl -k -n 1 --show-cursor --no-pager --utc`.

Stream [lg-disc-readonly.py](helpers/lg-disc-readonly.py) to guest `python3 -`
with the previously verified LG serial as its sole argument. Retain private
JSON locally in a fresh ignored optical-prefixed inbox directory. The helper
checks only LG sysfs/udev identity, media metadata, capacity and matching-device
mountinfo; executes installed optional blockdev/blkid/sg_inq tools; and reads
16 MiB using O_DIRECT dd into /dev/null, with a 30-second timeout. It captures
guest kernel logs around all device probes. No media data is retained. Optional
tool absence or unsupported inquiry is UNKNOWN, not a qualification failure.

After the guest helper completes, capture host kernel messages after the saved
cursor with sudo journalctl. Retain timestamps, exact argv, exit codes, read
byte count, both log streams and checksums. Investigate any LG/ASMedia reset,
I/O/optical error or host BAR failure in this interval. Do not conflate old
startup warnings with new test failures. PASS requires exact LG identity,
media detection, successful bounded block reads and no controller reset or I/O
failure during the test. Missing required evidence or failed required checks
is BLOCKED. Stop without media/device/configuration repair. USB and HP are not
probed. No packages, rip, encode, mount or configuration changes are allowed.

## Aligned direct-read fallback

On this guest uutils dd 0.8.0 returned `IO error: Invalid input` with
iflag=direct,fullblock and emitted no byte count. Do not treat this as a passed
read or infer a controller fault without evidence. If this immediate failure
has no corresponding kernel error, capture fresh host/guest kernel cursors and
stream [lg-aligned-read.py](helpers/lg-aligned-read.py) to guest
`timeout 30s python3 -`. It uses O_RDONLY|O_DIRECT, a page-aligned anonymous
1 MiB mmap buffer and 16 positioned reads from offset zero. Every read must
return 1 MiB; record partial bytes and error if not. Capture both kernel logs
afterward. Retain the original failed command as well as the successful retry.
This changes the userspace read implementation only, not the device settings.

# Lore RTX 5060 → Jellyfin VM130 — 2026-09-12 EDT

Result: PASS for host passthrough and guest PCI enumeration; Jellyfin service
recovered. GPU driver/hardware transcoding NOT READY: Nouveau initialization
failed, no NVIDIA driver binding, nvidia-smi absent. No transcode test run.

Authority: operator request to pass the 5060 through to Jellyfin, followed by
operator firmware work. Governing [packet](../implementation/2026-09-12-hv-lore-jellyfin-5060.packet.md)
and [runbook](../runbooks/2026-09-12-hv-lore-jellyfin-5060.md).
Source HEAD 9e6638bc618df2cc3eaab9c37f4baf299a84e7a1; fetched origin/main
704db7564b054ea3aee5e9108f734fde8c9de312. No publication in this task.

## Verified before attachment

Strict existing SSH reached hv-lore on accepted P3 rpool GUID
4137356908105663872, ONLINE. /dev/kvm returned after operator firmware work;
VT-d and x2APIC interrupt remapping enabled. BootCurrent and first BootOrder
entry remained 0021 across this operator restart. RTX 5060 graphics
0000:09:00.0 (10de:2d05, PNY 196e:1448) and audio 0000:09:00.1 (10de:22eb)
were the only members of IOMMU group 99. No VM claimed either function.
Jellyfin VM130 ran Ubuntu 26.04, SeaBIOS/machine pc with standard virtual VGA;
service active and no ffmpeg process found in bounded checks.

## Exact mutation and outcomes

All commands executed through existing strict SSH and sudo -n:

| Command | Exit | Result |
| --- | --- | --- |
| `qm shutdown 130 --timeout 60 --forceStop 0` | 0 | Clean shutdown; stopped state explicitly checked before assignment. |
| `qm set 130 --hostpci0 '0000:09:00.0;0000:09:00.1,pcie=0' --digest 994c368057f5ed4d678ad3fba380538db3227b19` | 0 | Both functions assigned. |
| `qm start 130` | 0 | VM running, host both functions bound to vfio-pci. |

Config comparison, excluding derived digest, proved hostpci0 was the sole
change. Machine, firmware, console, disks, NICs and startup settings preserved.
Other VM process IDs and guest running/stopped states were unchanged. All
imported pools healthy and fresh strict SSH/P3 identity verified after change.

## Guest and kernel acceptance

Initial QGA attempts during boot returned “QEMU guest agent is not running”;
standalone retry exit 255 is preserved. Read-only QEMU monitor status/registers/
PCI showed running Linux and assigned BARs. Subsequent qm guest exec returned
outer and guest exit 0: guest jellyfin-lore sees graphics 00:10.0 and audio
00:10.1 with the exact physical PCI IDs. Final 22:47:52 EDT checks:

- `systemctl is-active jellyfin`: active, exit 0.
- `curl -fsS --max-time 5 http://127.0.0.1:8096/health`: Healthy, exit 0.
- `command -v nvidia-smi`: absent, exit 127 in guest shell.
- `readlink /sys/bus/pci/devices/0000:00:10.0/driver`: exit 1, no binding.
- Guest Nouveau GSP initialization/probe failed with -22 at 02:46:54 UTC;
  NVIDIA hardware encoding/decoding cannot be accepted from enumeration.

Host kernel window starts 22:44:48 EDT: normal VFIO initialization resets all
completed with “reset done”; no reset failure, IOMMU fault or BAR allocation
failure observed. Host snd_hda_intel reported GPU sound “probed, but not
operational” during transition; both functions subsequently bound to VFIO and
guest audio bound to snd_hda_intel. This warning is retained, not hidden.
Later kernel window 22:46:28–22:47:52 returned no entries. Transferring the
physical VGA deactivated its host VGA console; host SSH remained usable and
VM standard virtual display remains configured. Host firmware console remains
a recovery path before assignment; a live host text display on this GPU is not
promised. No host reboot or host module configuration change was performed.

## Evidence and limits

Exact commands, stdout, stderr and SSH exit codes are private ignored JSONs in
inbox/lore-5060-assignment-rh46mbvq/: baseline, source-check, shutdown, attach,
start, after, guest-check, boot-inspect, guest-check2, final-health. Combined
inspection commands retain their component output; outer exit 0 does not imply
every component passed (notably the first QGA call). No packages installed,
Jellyfin configuration changed, media read/ripped/encoded, or unrelated guest
modified. VM140's pre-existing stale 04:00 mappings remain a separate review.
Canonical CURRENT_STATE, VALIDATION, TODO and README project attachment and
remaining driver work. No broad guest-fleet or media-playback acceptance.

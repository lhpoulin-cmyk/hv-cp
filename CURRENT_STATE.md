# hv-cp current work

## Jellyfin GPU tests passed — 2026-09-22

RTX 5060 qualification passed as the jellyfin service user using bundled FFmpeg:
H.264 CUVID and enhanced CUDA decode (60 frames each), HEVC Main10 CUVID
(30 frames), H.264 NVENC transcode (60 frames), HEVC Main10 NVENC transcode
(30 frames). Both encoded outputs passed independent software decode, codec,
resolution and frame-count checks. No reported FFmpeg errors or dropped frames.
Jellyfin configuration is nvenc with enhanced NVDEC true; service stayed
Healthy with PID 1330. No new matching GPU errors, host boot/config unchanged,
P3 pool ONLINE. Synthetic 1280x720 clips only; temporary files cleaned up.
Evidence: hv-cp/evidence/2026-09-22-hv-lore-jellyfin-gpu-test.md.
This supersedes the earlier untested decode/encode limitation. Client playback,
HDR/tone mapping, other codecs and sustained capacity remain untested.

## RTX 5060 reassigned to Jellyfin — 2026-09-22 16:23 EDT

Completed: VM130 jellyfin-lore is running with RTX 5060 graphics/audio at
host 09:00.0/1 through hostpci0 (conventional PCI). This supersedes the
September 14 removal for VM130 only. Guest nvidia-smi as jellyfin reports
RTX 5060, driver 595.91.07, 8151 MiB; NVIDIA binds guest 00:10.0.
Jellyfin is active and /health is Healthy; RefuseManualStop remains yes.
The first HTTP probe preceded startup completion; subsequent health passed
without service intervention. No playback/decode/encode workload was tested
in this reassignment; September 12 decode qualification remains historical.

Exact config comparison passed: only VM130 hostpci0 was added. All unrelated
VM configuration bytes and states/PIDs stayed unchanged, including TrueNAS
VM120. VM140 is running with no PCI passthrough. Host boot ID is unchanged,
P3 rpool is ONLINE with no known data errors, and fresh strict SSH passed.
No host reboot, package, guest application configuration, disk or network change.
Rollback backup: /root/lore-5060-reassign-20260922T202005Z/130.conf.
Evidence: hv-cp/evidence/2026-09-22-hv-lore-jellyfin-5060.md.
Remaining: client playback and sustained transcode acceptance are untested;
prior pending unattended P3 boot acceptance is unchanged.

## Lore recovered on P3; persistent boot settings saved — 2026-09-22 EDT

Lore is online on rpool/ROOT/pve-1, pool GUID 4137356908105663872.
Both P3 mirror members are ONLINE with zero reported read/write/checksum
errors and no known data errors. BootCurrent is 001B and saved BootOrder
still starts with 001B. Boot ID: b8080a8f-47a0-4aa2-a1fb-24f21452a89d.
Operator observed the repaired menu and successful PVE web UI access.
Ordinary strict SSH and nonissuing `reauth --check hv-lore` passed.
pveproxy, pvedaemon and pve-cluster are active; no failed systemd units listed.

Successful boot omitted quiet, video=vesafb:off, video=efifb:off and
initcall_blacklist=sysfb_init. The individual causal parameter remains
unisolated. The same combination is now persisted in /etc/default/grub with
GRUB_TIMEOUT=15, preserving IOMMU and root arguments. The installed
proxmox-boot-tool refresh succeeded for both registered P3 ESPs D24B-0CBC
and D24B-C1DB. Read-only checks passed GRUB syntax, menu timeout (15 seconds
normally, 30 on its existing failure branch), root selection and kernel
parameters on both ESPs. The firmware's separate zero-second timeout is
unchanged. Backup: /root/lore-boot-recovery-20260922T054515Z/grub.before.

Remaining acceptance: an unattended reboot using the persisted configuration
has not yet been performed. Lore remains running; the successful boot used
an equivalent one-time editor change. Do not represent this as an unattended
reboot test or proof against firmware resets. USB inspection did not force
import any pool, rewrite an initramfs or reinstall. No trust/credential change.

Guest snapshot: VMs 120, 130 and 260 running; CTs 243, 245, 246, 247, 248 and
252 running; CT249 and other listed VMs stopped. Guest application health
was not independently accepted by this recovery. Earlier stopped-state
statements below are dated historical observations.
Evidence: hv-cp/evidence/2026-09-22-hv-lore-p3-recovery-online.md.

## Historical Lore PCI passthrough removal — 2026-09-14

VM130 was gracefully shut down; VM140 was already stopped. Both were left stopped
at that inspection; the September 22 observations above supersede that state.
All their hostpci entries were removed after root-only configuration backups.
All ten Lore VM configurations and pending APIs are free of hostpci entries;
unrelated settings and VM processes were preserved. TrueNAS middleware, NFS
and SMB remain active. Host was not rebooted.
See [verified result](evidence/2026-09-14-hv-lore-remove-pci.md).


## Matrix LG optical passthrough — 2026-09-12

Status: LG-only realization accepted. VM310 `b70-encode` is running with the
physical LG WH16NS60 through isolated ASMedia `03:00.0` in `hostpci2`.
Guest LG is `/dev/sr1` + `/dev/sg3`; the retained USB BP50NB40 is
`/dev/sr0` + `/dev/sg2`. Both physical identities match private preflight.
The former virtual DVD `ide2` and its boot entry were removed. GPU mappings,
USB configuration, disks and all other properties are unchanged.

The operator resumed LG-only work on September 12. One clean guest shutdown
and start passed. Host management/rpool, guest GPU drivers/render access and
media mounts passed. PVE emitted a BAR 5 dma-buf mapping warning; controller
initialization and drive enumeration passed. Subsequent
[read-only disc qualification](evidence/2026-09-12-matrix-lg-disc-io.md) read
16 MiB successfully with aligned O_DIRECT and passed SCSI inquiry without new
host/guest kernel errors. Initial uutils dd direct mode failed with Invalid input;
the aligned retry passed. Full-disc I/O and repeated VFIO cycles remain untested. No host restart or application change.

The three-drive [desired state](docs/MATRIX_OPTICAL_DESIRED_STATE.md) remains
incomplete: HP GUD1N shares Intel `00:17.0` with both rpool disks and is still
absent from the guest. Its recabling remains deferred with no maintenance
window. A future physical move requires a separately approved powered-off plan.

See [LG packet](implementation/2026-09-12-matrix-lg-passthrough.packet.md),
[runbook](runbooks/2026-09-12-matrix-lg-passthrough.md), and
[accepted evidence](evidence/2026-09-12-matrix-lg-passthrough.md).

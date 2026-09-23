# Jellyfin RTX 5060 driver and decode qualification — 2026-09-12 EDT

Result: PASS. NVIDIA 595.91.07 initialized the RTX 5060 after a clean VM
power cycle; bounded hardware decoding passed as the jellyfin service user.
Jellyfin /health returned Healthy; Arc userspace driver/tool/compiler cleanup
passed. This supersedes the driver-not-ready finding in the earlier attachment
evidence, which remains immutable. No client playback or hardware-encode test
is claimed: operator explicitly requested decode acceptance.

Authority and method: [packet](../implementation/2026-09-12-hv-lore-jellyfin-nvidia-driver.packet.md),
[runbook](../runbooks/2026-09-12-hv-lore-jellyfin-nvidia-driver.md).
Source HEAD 9e6638bc618df2cc3eaab9c37f4baf299a84e7a1; freshly fetched main
704db7564b054ea3aee5e9108f734fde8c9de312. Target only VM130 jellyfin-lore on
hv-lore through strict existing SSH and sudo qm guest exec. Host P3 rpool GUID
4137356908105663872 remained ONLINE; existing PCI assignment unchanged.
Other running VM process IDs unchanged; no host restart or host driver change.

## Packages and configuration

Ubuntu's installed ubuntu-drivers hardware detection recommended the 595-open
branch. NVIDIA documents that Blackwell requires open kernel modules. Selected
Ubuntu headless packages at 595.91.07-0ubuntu0.26.04.1 with decode/encode runtime
libraries; no desktop stack, third-party installer or general system upgrade.
The existing Jellyfin ffmpeg7 7.1.3-6-resolute package remained in place.

Exact installation (guest apt process exit 0):

```sh
DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=l apt-get -y --no-install-recommends install nvidia-headless-595-open nvidia-utils-595 libnvidia-decode-595 libnvidia-encode-595 intel-gpu-tools- igt-gpu-tools- intel-media-va-driver-non-free- intel-opencl-icd- intel-opencl-icd-legacy-
```

Reviewed simulation: 38 new packages, five removals, zero upgrades. DKMS built
and installed modules for both 7.0.0-30-generic and running 7.0.0-31-generic.
Follow-up reviewed purge (exit 0):

```sh
DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=l apt-get -y purge intel-gpu-tools igt-gpu-tools intel-media-va-driver-non-free intel-opencl-icd intel-opencl-icd-legacy libigc1 libigc2 libigdfcl1 libigdfcl2 libigdgmm12
```

All ten named packages were subsequently verified absent, including residual
configuration; only nvidia.icd remained in /etc/OpenCL/vendors. No blanket
autoremove. CPU microcode, common OpenCL loader, shared DRM libraries and
kernel/distribution-owned Intel firmware retained; linux-firmware requires the
Intel graphics firmware package. These retained components are not an active
Arc userspace driver stack. dpkg --audit produced no issues.

Encoding XML was backed up privately before work. Exact semantic comparison
proved only HardwareAccelerationType qsv→nvenc and clearing the two old
VaapiDevice/QsvDevice render paths. Enhanced NVDEC=true, existing supported
codec selections and hardware-encoding preference retained. In Jellyfin the
NVIDIA backend is named nvenc even when qualifying its decoding path.

Initial manual service stop was refused (guest exit 4), leaving configuration
unchanged. Existing infrastructure maintenance instructions expressly permit
a temporary override of RefuseManualStop. A unique /run drop-in allowed clean
maintenance, then was removed with cleanup trap and daemon-reload. Permanent
guard unchanged and RefuseManualStop=yes verified after maintenance and reboot.
Configuration maintenance guest exit 0, service active.

## Activation retry preserved

qm reboot 130 --timeout 60 returned 255, “VM quit/powerdown failed - got
timeout”; boot ID remained bd357f31-25a8-4a24-8369-edc5bbcde8d8. QGA remained
available and no systemd shutdown jobs were running. A pre-restart nvidia-smi
reported no devices; kernel recorded WPR2 already up / GSP RmInitAdapter failure
following earlier Nouveau initialization. These are preserved failures, not
part of the successful decode window.

Normal guest systemctl poweroff via asynchronous qm guest exec reached
stopped without force. qm start 130 returned 0; fresh boot ID
3a31c922-194b-4ce9-94da-0b6250e52473 and nvidia-smi reported RTX 5060,
595.91.07, 8151 MiB at guest 00:10.0. Proxmox's normal VFIO resets all completed.
Current boot shows expected unsigned out-of-tree module taint notices, followed
by successful nvidia-drm initialization. No subsequent GSP failure, Xid,
IOMMU fault or BAR/reset failure appeared in the captured final window.

## Actual GPU decoding

The [read-only helper](../runbooks/helpers/jellyfin-nvdec-readonly.sh) ran as
jellyfin using bundled /usr/lib/jellyfin-ffmpeg/ffmpeg. Synthetic 1280×720
fixtures were generated with software libx264/libx265 solely for this test;
no library media was touched. /tmp fixtures were recreated after reboot.
Mandatory CUDA hardware frames followed by hwdownload rejects software fallback.

| Decode path | Frames decoded | Decode errors | Exit |
| --- | ---: | ---: | ---: |
| h264_cuvid, 8-bit H.264 → CUDA → NV12 | 60 | 0 | 0 |
| hevc_cuvid, HEVC Main 10 → CUDA → P010 | 30 | 0 | 0 |
| Enhanced native H.264 decoder + CUDA NVDEC → NV12 | 60 | 0 | 0 |

Exact helper flags and commands are Git-readable in the linked helper. Output
was null/wrapped frames, not an encoded media asset. Logs explicitly report
CUDA pixel format, decoded frame totals and zero decode errors; overall guest
exit 0 with untruncated captured output. Bounded clips establish functioning
hardware decode and service-user access, not sustained capacity, all codecs,
HDR tone mapping, client playback or complete transcode qualification.

Final guest check at 03:10:46 UTC / 23:10:46 EDT: nvidia-smi exit 0,
Jellyfin active, HTTP /health Healthy (curl exit 0), guard restored, exact
encoding delta verified, Arc package assertions passed, dpkg audit clean.
Host check 23:11 EDT: strict SSH, intended P3 root, VM running, passthrough
configuration and unrelated VM process continuity intact.

## Evidence custody and documentation

Private ignored inbox/lore-5060-assignment-rh46mbvq/driver-*.json records exact
SSH command, output/error and outer exit, with nested guest result/exit codes.
Long installation and purge used QGA process IDs 1616 and 32604; their final
exec-status records both prove exit 0. Root-only rollback directory is recorded
inside guest /root/lore-nvidia-qualification-path, containing original XML,
package list and apt logs. No credentials or private raw output committed.
Canonical Lore CURRENT_STATE, VALIDATION, TODO and README project accepted
NVIDIA decode and Arc cleanup. No commit/push performed.

References: [NVIDIA open kernel modules](https://download.nvidia.com/XFree86/Linux-x86_64/610.43.02/README/kernel_open.html)
for the Blackwell module requirement; [Jellyfin NVIDIA guide](https://jellyfin.org/docs/general/post-install/transcoding/hardware-acceleration/nvidia/)
for backend/runtime libraries. Current installed Ubuntu metadata selected the
actual branch; live decode tests establish this installed FFmpeg's compatibility.

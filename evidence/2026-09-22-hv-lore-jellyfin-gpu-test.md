# Jellyfin RTX 5060 GPU tests — 2026-09-22

Result: PASS for bounded synthetic GPU decode and encode as jellyfin on VM130.
Authority: operator “please test” after reassignment.
[Packet](../implementation/2026-09-22-hv-lore-jellyfin-gpu-test.packet.md),
[runbook](../runbooks/2026-09-22-hv-lore-jellyfin-gpu-test.md).
Source HEAD 9e6638bc618df2cc3eaab9c37f4baf299a84e7a1; freshly fetched
origin/main 704db7564b054ea3aee5e9108f734fde8c9de312. No commit/push.

## Test boundary and results

Existing strict SSH to hv-lore, QGA to jellyfin-lore. All fixture generation,
GPU operations and output checks ran as jellyfin with installed
/usr/lib/jellyfin-ffmpeg/{ffmpeg,ffprobe}, NVIDIA 595.91.07 / RTX 5060.
Selected config readback: HardwareAccelerationType=nvenc,
EnableEnhancedNvdecDecoder=true. No credentials or library media inspected.
Generated 1280x720, 30 fps testsrc2 clips in a unique /tmp directory.
Each subprocess timeout 90 seconds. All test commands returned zero with
empty error-level stderr. GPU decode mandated CUDA frames and hwdownload,
preventing silent software fallback; encode explicitly selected NVENC.

| Test | Frames | Result |
| --- | ---: | --- |
| H.264 h264_cuvid → CUDA → NV12 | 60 | PASS |
| HEVC Main10 hevc_cuvid → CUDA → P010 | 30 | PASS |
| Enhanced H.264 native decoder + CUDA → NV12 | 60 | PASS |
| H.264 CUDA decode → h264_nvenc High | 60 | PASS |
| HEVC Main10 CUDA decode → hevc_nvenc Main10 | 30 | PASS |
| Independent software decode of H.264 output | 60 | PASS |
| Independent software decode of HEVC output | 30 | PASS |

FFprobe independently matched output codecs, 1280x720 dimensions and exact
60/30 decoded-frame counts; HEVC remained Main10/yuv420p10le. Progress reports
showed no duplicate/dropped frames. The short transcode speed readings are not
a sustained performance benchmark. Guest test exit zero, QGA untruncated.
Temporary directory cleanup completed in finally.

## Continuity and limitations

Jellyfin active, HTTP /health Healthy and PID 1330 before and after; no restart.
VM130 configuration and host boot ID unchanged. Fresh final SSH and guest GPU
access passed. P3 rpool ONLINE, both members zero error counters, no known errors.
No matching new Xid/NVRM/GPU fault entries. The wrapper initially treated
journalctl grep exit 1 (no entries) as failure after all tests had passed;
this was reviewed as a negative result, and final read-only service/pool checks
completed successfully without repeating workloads.
No package, service configuration, host or other VM mutation. Synthetic files
were the only guest writes from the harness. Client playback, audio, subtitles,
HDR/tone mapping, other codecs and sustained capacity are not accepted here.

## Evidence and delivery

Ignored inbox/lore-gpu-test-20260922/ contains guest-test.py, host-test.py,
results.log, final-check script and final.log. Canonical Lore README,
CURRENT_STATE, VALIDATION and TODO plus hv-cp CURRENT_STATE updated.
Runbook audit passed before execution. Canonical heartbeat validator and
whitespace/diff review passed after projection. Live tests accepted;
documentation remains local/uncommitted, with unrelated dirty work preserved.

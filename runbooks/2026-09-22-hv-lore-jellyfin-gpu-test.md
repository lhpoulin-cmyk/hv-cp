# Jellyfin GPU test

Requires [packet](../implementation/2026-09-22-hv-lore-jellyfin-gpu-test.packet.md).

1. Strict SSH hv-lore; snapshot VM130 config, host boot ID and VM status.
   QGA confirms jellyfin-lore, service Healthy, NVIDIA device and service PID.
   Read only HardwareAccelerationType and EnableEnhancedNvdecDecoder in XML.
2. Run a bounded Python harness through QGA as jellyfin. Create a private
   temporary directory; generate 60-frame H.264 and 30-frame HEVC Main10
   1280x720 synthetic testsrc2 clips with installed Jellyfin FFmpeg.
3. Decode with h264_cuvid and hevc_cuvid using mandatory CUDA frames,
   hwdownload and matching nv12/p010le output. Also test enhanced H.264 CUDA
   decode. Use explicit h264_nvenc and hevc_nvenc encoders on CUDA frames;
   encode H.264 60 and HEVC Main10 30 frames. Independently software decode
   and ffprobe-count each output. Fail on error or wrong frame count.
4. Finally remove only the newly created fixture directory. Capture command
   exits, stderr and frame-count checks privately; require untruncated QGA output.
   Check new GPU kernel errors, unchanged Jellyfin PID/config and Healthy.
5. Write immutable result and canonical projections, run node validator and
   diff checks. Distinguish synthetic FFmpeg qualification from client playback.

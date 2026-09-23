# Jellyfin guest NVIDIA driver and NVDEC acceptance

Use the [authorized packet](../implementation/2026-09-12-hv-lore-jellyfin-nvidia-driver.packet.md).

1. Strict SSH hv-lore; confirm VM130 guest hostname, GPU IDs and service.
   Capture packages, ubuntu-drivers devices, apt policy, module configuration,
   and selected non-secret encoding.xml GPU settings. Preserve private logs.
2. Use installed Ubuntu driver hardware recommendation and NVIDIA requirement
   that Blackwell uses open kernel modules. Simulate installation/removal;
   require only expected driver dependencies and explicit Arc package removal.
   Save before package versions and root-only encoding.xml backup. Install
   through apt without general upgrade or autoremove. Record exact selections.
3. Inspect DKMS/prebuilt module outcome and matching kernel. Cleanly reboot
   VM130 via qm reboot if needed, then verify QGA, nvidia-smi, module binding
   and service. Inspect failures and repair within the same guest scope.
4. Generate a small synthetic H.264 fixture in a unique /tmp directory using
   bundled FFmpeg software encoder. As jellyfin, explicitly use h264_cuvid
   with CUDA hardware frames, decode to null with bounded frame count. This
   must fail rather than silently falling back. Save output and exact exit.
5. Back up encoding.xml; stop Jellyfin briefly and change only acceleration
   backend/Arc-specific options needed for NVDEC. Preserve unrelated settings
   and existing hardware-encoding preference. Restart and verify /health,
   selected persisted settings and absence of driver errors. No library media
   or playback-session material is needed for synthetic acceptance.
6. Record package changes, decode proof and limits, update canonical node
   records and validate the heartbeat documentation contract. Keep rollback
   backups private, no source publication unless separately requested.

References consulted 2026-09-12: NVIDIA open kernel modules documentation
https://download.nvidia.com/XFree86/Linux-x86_64/610.43.02/README/kernel_open.html
and Jellyfin NVIDIA guide
https://jellyfin.org/docs/general/post-install/transcoding/hardware-acceleration/nvidia/.
Installed Ubuntu package metadata determines the actual selected version.

Read-only helper: [jellyfin-nvdec-readonly.sh](helpers/jellyfin-nvdec-readonly.sh)
reads only prepared synthetic H.264/HEVC fixtures and decodes 60/30/60 frames
to null using explicit CUVID and enhanced NVDEC paths. Run as jellyfin. The
mandatory hwdownload filter rejects software-frame fallback. It performs no
package, media, configuration or persistent-output writes.

Jellyfin's permanent RefuseManualStop guard is intentional. Follow its existing
maintenance operating note: temporary unique /run drop-in setting false,
daemon-reload, clean stop, bounded encoding.xml change, then remove only that
temporary drop-in, daemon-reload and start. Trap cleanup on failure; restore
configuration backup if the edit failed. Verify permanent guard still yes.

Observed reboot retry: qm reboot 130 --timeout 60 returned timeout and the
same guest boot ID remained. Guest QGA still worked. A normal guest
`systemctl poweroff` via qm guest exec (no force) reached stopped; then
`qm start 130` supplied a clean VFIO reset and boot. Preserve failed reboot
and pre-reset NVIDIA GSP initialization errors separately from final tests.

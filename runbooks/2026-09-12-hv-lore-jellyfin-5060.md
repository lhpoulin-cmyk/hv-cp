# Lore Jellyfin RTX 5060 attachment

Execute only under the [packet](../implementation/2026-09-12-hv-lore-jellyfin-5060.packet.md).

1. Confirm strict SSH identity, P3 root GUID, /dev/kvm, GPU PCI IDs, isolated
   group containing exactly 09:00.0/1, enabled IRQ remapping, no competing VM
   assignments. Capture qm config and pvesh config digest for VM130 privately.
   Inspect Jellyfin service and ffmpeg processes via qm guest exec; no active
   ffmpeg was found in the initial check. Recheck before interruption.
2. `qm shutdown 130 --timeout 60 --forceStop 0`; require stopped. Use captured
   config digest with `qm set 130 --hostpci0 '0000:09:00.0;0000:09:00.1,pcie=0' --digest DIGEST`.
   Both functions are explicit, using the installed qm help set syntax. Keep SeaBIOS, machine pc and standard virtual display.
3. `qm start 130`; capture command exit. Inspect qm status, guest agent,
   guest lspci/sysfs PCI IDs and driver binding, service health and bounded
   kernel logs on host and guest for VFIO/IOMMU/reset/BAR failures. Verify
   fresh SSH, healthy P3 pool, exact intended VM config delta and other guest
   state continuity. Distinguish attachment from NVIDIA driver and transcode.
4. If attachment prevents boot, clean shutdown if responsive, then
   `qm set 130 --delete hostpci0` and `qm start 130`. Do not force-stop,
   manually reset PCI devices or reboot host without resolving the risk.
5. Write immutable dated evidence and update four canonical node documents;
   run heartbeat node-documentation validator and git diff --check. Preserve
   all unrelated work and prior captures. No publication authorized.

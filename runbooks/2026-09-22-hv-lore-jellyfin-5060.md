# Lore Jellyfin RTX 5060 reassignment

Requires [authorized packet](../implementation/2026-09-22-hv-lore-jellyfin-5060.packet.md).

1. Strict SSH and sudo -n: verify packet identity, root pool, KVM/IRQ remapping,
   exact PCI IDs and isolated group, no competing assignments or pending config.
   Inspect installed qm help set and PVE task API help. Capture original config,
   unrelated VM states/PIDs and boot ID. Check guest Jellyfin health and ffmpeg.
2. Save root-only before-state/config backup. Recheck target digest, GPU
   ownership and active management/backup tasks. Cleanly shut down only VM130:
   `qm shutdown 130 --timeout 120 --forceStop 0`. Require stopped state.
3. With unchanged before config and fresh digest, set only hostpci0 via qm:
   `qm set 130 --hostpci0 '0000:09:00.0;0000:09:00.1,pcie=0' --digest DIGEST`.
   Start using `qm start 130`. If start fails, inspect and apply the packet's
   bounded rollback; no forced stop or host reboot.
4. Fresh SSH: verify exact intended config delta, unchanged host boot ID and
   unrelated VM config/states/PIDs, ONLINE P3 pool. QGA checks guest PCI,
   nvidia-smi as jellyfin, Jellyfin service and localhost /health, bounded host
   and guest kernel errors. Do not claim transcode acceptance from nvidia-smi.
5. Write immutable evidence and project four canonical docs plus hv-cp status;
   run heartbeat node validator, runbook audit and whitespace/diff checks.

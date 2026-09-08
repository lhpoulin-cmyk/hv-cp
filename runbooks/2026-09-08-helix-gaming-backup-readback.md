# Temporary encrypted backup readback

1. Confirm hv-lore identity, existing sudo and absence of the unique mountpoint.
2. Create /mnt/helix-gaming-readback-20260908T045622Z mode 0700. Mount
   192.168.10.111:/mnt/slowPool/steam.incoming there using NFS4 and
   ro,nosuid,nodev,noexec. This uses the existing NAS export, with no admission
   or service changes. Preserve any unrelated mounts and jobs.
3. Read a bounded 32 MiB sample of
   .helix-gaming-fs-20260908T045622Z/boot.tar.zst.age through pinned SSH to
   Hadrian. If useful, stream exact completed encrypted payloads through the
   same path for local authenticated decryption and isolated restore.
4. No recovery private key or plaintext archive is transferred to hv-lore.
5. After readers exit, unmount the exact path and rmdir the empty mountpoint.
   Verify no run mount remains. On failure retain evidence; do not modify
   exports, network, VMs, or Windows jobs to accommodate this temporary client.

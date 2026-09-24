# One bounded VM120 QGA recovery

This runbook grants no authority. Use only with its dated packet and the
operator's exact restart approval. The operator executes guest console steps
because this agent has no connected UI capability; this agent performs host
verification through the existing strict SSH profile.

1. Confirm no other investigation is changing VM120. In the existing guest
   console confirm hostname is truenas-lore. Read:

   ```bash
   hostname
   systemctl status qemu-guest-agent --no-pager -l
   sudo systemd-cgls --unit=qemu-guest-agent.service --no-pager
   ```

   Proceed only if the cgroup contains qemu-ga alone, with no child jobs,
   and the console remains responsive. Unexpected membership is a stop for
   diagnosis. Preserve the already collected unit logs, wait state and fd map.
2. Only after explicit approval and that precondition, execute exactly once:

   ```bash
   sudo systemctl restart qemu-guest-agent.service
   systemctl status qemu-guest-agent --no-pager -l
   ```

   If restart fails or stalls, do not kill, retry, reboot or alter the unit.
   Preserve the result and diagnose through the console.
3. Agent uses existing strict fresh hv-lore SSH, sudo -n -k:
   qm agent 120 ping; qm guest exec 120 --timeout 10 -- /usr/bin/true.
   Require ping exit 0 and returned guest exitcode 0. Check both VM120/VM130
   running and VM130 ping exit 0. Record results independently of service status.
4. After QGA recovery, coordinate read-only inspection of exactly
   /mnt/slowPool/jellyfin/shows.incoming/.helix-qual-backend-20260924-a
   and result.json/retained case receipts. Do not rerun the dispatcher or any
   scripts found there, delete fixtures or publish media. Missing result does
   not prove nonexecution. Keep outcomes UNKNOWN unless evidence supports a
   narrower conclusion. Preserve B70 discovery grant unchanged.
5. Capture recovery evidence, update declared canonical paths and run both
   documentation validators. Report actual Live effects, including the restart
   even if unsuccessful. Root cause may remain unknown after functional recovery.

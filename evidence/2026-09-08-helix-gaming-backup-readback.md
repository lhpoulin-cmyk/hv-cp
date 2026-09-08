# Helix-gaming backup readback transport test

Under the run-specific packet, mounted the existing Lore steam.incoming NFS
export read-only at /mnt/helix-gaming-readback-20260908T045622Z on hv-lore.
Read only 32 MiB samples of this run's encrypted boot archive over pinned SSH.
The working Hadrian 192.168.10.86 path returned a sample in 1.62 seconds;
192.168.80.85-bound SSH to hv-lore timed out without authentication or mutation.
No network or authentication change was attempted.

Bazzite's existing Lore automount plus direct wired SSH was faster (32 MiB in
0.96 seconds) and selected for the full restore, keeping private recovery
custody on Hadrian. The temporary hv-lore NFS mount was unmounted and its exact
empty mountpoint removed successfully. No host or VM configuration, persistent
storage definition, export, service, or Windows job changed.

Fetched origin before using the runbook; HEAD and origin/main have zero
divergence at 864bc35468ff42f7b28dc4de6494169eeca91f3e. Existing dirty work
was preserved. The live-mutation runbook-link audit and git diff --check passed.
This is transport-test evidence, not backup acceptance; ws-cp owns that receipt.

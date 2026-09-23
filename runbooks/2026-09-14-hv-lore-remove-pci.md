# Lore PCI removal runbook

Use the [authorized packet](../implementation/2026-09-14-hv-lore-remove-pci.packet.md).

1. Strict SSH to hv-lore, verify identity, target VM states and NAS VM120.
2. Save root-only raw 130.conf and 140.conf backups with SHA256 hashes;
   retain all VM configuration/pending observations and runtime PIDs privately.
3. Inspect all config sections and pending entries. For each target, require
   unchanged config, gracefully shut down if running using
   `qm shutdown ID --timeout 120 --forceStop 0`, and prove stopped state.
4. Use `qm set ID --delete hostpci0[,hostpci1...] --digest SHA1` for the
   observed entries. Never directly rewrite PVE configuration files. If pending
   or snapshot sections need separate treatment, inspect installed PVE semantics
   before changing them; preserve unrelated pending settings and snapshot data.
5. Check every VM raw configuration section and PVE pending API. Require zero
   hostpci assignments. Compare exact config bytes against the originals with
   only target hostpci lines omitted. Verify all unrelated VM PIDs/states and
   host boot ID unchanged, including NAS VM120. Leave targets stopped.
6. Record backup paths, hashes, changes and validation; project canonical node
   docs and run the documentation validator. No reboot or guest restart.

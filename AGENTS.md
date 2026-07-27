# hv-cp project rules

This project maintains a durable, reusable hypervisor control-plane pattern.
Katra is its first documented instance; each future host receives its own
verified identity, evidence, and implementation packet. This is planning and
implementation work, not permission to change a live host.

- Keep raw recovered artifacts in `inbox/`; do not add binaries, archives, or
  credential-bearing installer sources to Git.
- Keep immutable capture summaries in `evidence/` and do not rewrite them.
- Treat `templates/` as sanitized starting points, never as a record of a
  deployed node.
- A runbook describes an action; it does not authorize that action. Create a
  dated implementation packet before changing a host, network, DNS, storage,
  Git hosting, or credentials.
- Use SSH for ordinary OS and VM work. Reserve a graphical console for
  firmware, installer, and break-glass recovery.
- Stage only this project's files when committing.

## Post-install scope

After a node passes installer acceptance, `hv-cp` is the active-work method
for local hypervisor maintenance, cluster operations, Ceph planning, recovery
drills, and reusable operational tooling.

- Keep node-specific observed state in the private node record; keep shared,
  non-secret operational facts in canonical infrastructure.
- Treat Ceph membership, OSD/device preparation, monitor changes, pool changes,
  network changes, and quorum-affecting work as separate live changes.
- Before a Ceph change, record current cluster health, quorum, PG state, exact
  device identity, rollback boundary, and evidence destination.
- Keep install-media creation separate from post-install operations; a passed
  installer does not authorize later storage or cluster mutations.

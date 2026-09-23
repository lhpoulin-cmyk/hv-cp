# hv-cp project rules

This project maintains a durable, reusable hypervisor control-plane pattern.
Katra is its first documented instance; each future host receives its own
verified identity, evidence, and implementation packet. This is planning and
implementation work, not permission to change a live host.

For cross-repository workstation coordination, treat `ws-matriarch` and
`ws-hadrian` as the paired workstations owned by the `ws-cp` peer authority.

- Keep raw recovered artifacts in `inbox/`; do not add binaries, archives, or
  credential-bearing installer sources to Git.
- Keep immutable capture summaries in `evidence/` and do not rewrite them.
- Treat `templates/` as sanitized starting points, never as a record of a
  deployed node.
- Before using a template or creating a packet, record the hv-cp commit. For an
  online checkout, fetch and compare `HEAD` with `origin/main`; a clean status
  against a locally cached remote ref does not prove currency. For an offline
  bundle checkout, verify the exact approved commit and state that updates are
  unavailable.
- A runbook describes an action; it does not authorize that action. Create a
  dated implementation packet before changing a host, network, DNS, storage,
  Git hosting, or credentials.
- An execution-ready live-mutation packet must link to its separate runbook in
  `runbooks/`. When repeatable multi-command collection is needed, use a
  narrow, read-only helper in `runbooks/helpers/`; record its purpose and
  collection boundary in the runbook. Run
  `tools/audit-live-mutation-runbooks.sh` before marking a packet
  execution-ready. The audit verifies the documentary link, not live authority.
- Use SSH for ordinary OS and VM work. Reserve a graphical console for
  firmware, installer, and break-glass recovery.
- Stage only this project's files when committing.

## Matrix / Proxmox VE 9.2 operating loop

On `hv-matrix`, move quickly by separating observation from mutation. Start a
new operational session with a compact, read-only orientation pass; do not
rediscover the entire host or reach for a browser by default:

```bash
hostnamectl
pveversion --verbose
pvesh get /nodes
qm list
pct list
pvesm status
ip -br link
ip route show
```

State the observed result, one bounded next action, its owner, and its evidence
destination. A short negative result is useful evidence; do not widen the task
to “fix the host” when a targeted check answers the question.

### Source and command ladder

Use the closest local source before downloading or browsing:

1. this file, the governing implementation packet, linked runbook, and newest
   Matrix evidence in `evidence/`;
2. `docs/CONTROL_PLANE.md`, `docs/CANONICAL_NODE_DOCUMENTATION_CONTRACT.md`,
   and the relevant local node record;
3. installed PVE 9.2 interfaces and help: `pveversion --verbose`, `pvesh
   usage`, `qm help`, `pct help`, `pvesm help`, `pvecm help`, package manpages,
   and `/usr/share/doc/`; and
4. a locally registered, version-matched PVE reference when one is available.

Do not curl a manual merely to avoid checking local material. If the needed PVE
9.2 reference is absent locally, say so, record the documentation gap, and ask
before retrieving external material. When an external source is explicitly
approved, record its version, URL, retrieval date, and local durable location;
do not rely on a transient browser result.

### PVE ownership boundaries

Use the control plane that owns the object. Prefer PVE interfaces over editing
PVE-managed state behind its back:

- host and node status: `pvesh`, `pveversion`, `systemctl`, `ip`, and
  targeted Linux tools;
- QEMU guests: `qm`; containers: `pct`; storage definitions: `pvesm`;
- cluster state: `pvecm`; Proxmox-managed Ceph: the PVE/Ceph tools named in an
  approved packet; and
- host network, boot, kernel, GPU, and physical recovery: a host-specific
  packet with a console/SSH rollback path.

Never directly rewrite `/etc/pve` content, create/join a cluster, alter Ceph,
prepare a disk, change a bridge/VLAN, move a guest, or change storage merely
because the corresponding command is available. These are separate live
decisions with separate rollback and evidence requirements.

### Matrix-specific working facts

Treat the dated Matrix evidence as the current starting point, not permanent
truth. The normal management and recovery path is `vmbr0` / `192.168.10.22`;
the current 10GbE work is governed by Packet 008 and its runbook. Before
touching either plane, reread the newest Matrix preflight and confirm the host
identity, active addresses, routes, bridge members, and console path.

For a small approved host or guest task, use this cadence:

1. read the narrow before state;
2. compare it to the approved packet, stopping on a mismatch;
3. apply one bounded change only when the packet and operator approval cover
   it;
4. validate the named positive test, negative boundary, and independent
   management path; and
5. write the reviewed evidence and canonical-documentation handoff before
   calling it complete.

## Post-install scope

After a node passes installer acceptance, `hv-cp` is the active-work method
for local hypervisor maintenance, cluster operations, Ceph planning, recovery
drills, and reusable operational tooling.

- Keep node-specific observed state in the private node record; keep shared,
  non-secret operational facts in canonical infrastructure.
- Apply `docs/CANONICAL_NODE_DOCUMENTATION_CONTRACT.md` after every accepted
  node change. Reuse its schema, never another node's facts. Do not report the
  control-plane task complete until its declared canonical paths are updated
  and the documentation validator passes.
- Treat Ceph membership, OSD/device preparation, monitor changes, pool changes,
  network changes, and quorum-affecting work as separate live changes.
- Before a Ceph change, record current cluster health, quorum, PG state, exact
  device identity, rollback boundary, and evidence destination.
- Keep install-media creation separate from post-install operations; a passed
  installer does not authorize later storage or cluster mutations.

<!-- BEGIN HELIX_GITHUB_REFERENCE_FALLBACK -->
## Missing local references: canonical GitHub fallback

For authorized work, a missing local peer checkout or referenced file is a
lookup step, not by itself a blocker. Follow explicit repository/file URLs in
the task, handoffs, README, ownership/provenance records and repository registry;
use the owning repository's verified GitHub remote when a relative link or
local path is unavailable. Do not guess repository identity from a host name
or assume every peer is hosted on GitHub.

Check the exact referenced path and revision first through the available GitHub
connector/API or other already-authorized read-only access. Prefer targeted
file/tree/history reads over cloning or broad searches. If the file moved or
is absent at that revision, inspect the owning repository's default branch and
path history; distinguish historical evidence from current governing material.
Cite the canonical URL, exact source commit and path for findings. Preserve
pinned revisions and report local/remote differences; never silently substitute
a newer document for a pinned contract or rewrite pins to make checks pass.

Do not ask the operator to paste a document or grant permission again when
existing authorized access can retrieve it. For private repositories, use the
existing approved connection; do not inspect credentials, change identity,
expand access, or disclose private content across trust boundaries. Treat 403/404
as potentially denied access, not proof the repository/file does not exist.
If permitted routes fail, report the exact repository/path/ref, methods tried
and access or absence result, and continue independent work.

This is development-agent read-only reference discovery. It grants no peer
write, publication, enrollment, runtime execution or live-mutation authority;
existing secret restrictions and runtime CLI network prohibitions still apply.
<!-- END HELIX_GITHUB_REFERENCE_FALLBACK -->

<!-- BEGIN HELIX_AGENT_WORK_CONTRACT -->
## Required Helix agent work contract

Before substantive work, read and apply
[HELIX_AGENT_WORK_CONTRACT_V1, release 1.0.0](https://github.com/lhpoulin-cmyk/repo-cp/blob/4ede9b73501b38a2b0ba5a50c9c32875a2d0eb19/docs/AGENT_WORK_CONTRACT.md).
Source commit: `4ede9b73501b38a2b0ba5a50c9c32875a2d0eb19`.
Content SHA-256: `a4838c4bfd8e1d27ed794c48ca1d475d76929309fabc212368234c4073df7674`.
Use a local copy only when its bytes match this pin; otherwise retrieve the exact
canonical source through existing authorized GitHub access. Do not substitute a
newer revision silently or ask the operator to paste accessible documentation.
Read the governing task-specific documents, record source identity, test failed
assumptions with bounded experiments, and complete supported remedies in scope.
Follow the contract's precedence and acceptance rules. Report scoped evidence,
actual delivery stage and `Live effects:` including remote writes. This adoption
changes agent working instructions, not peer ownership, credentials, enrollment
or live authority. Existing stricter safety and secret boundaries remain in force.
<!-- END HELIX_AGENT_WORK_CONTRACT -->

# VM120 guest-agent recovery

Status: executed; recovery verified, read-only reconciliation completed

Execution receipt: [recovery result](../evidence/2026-09-24-vm120-qga-recovery-result.md).
The prospective approval/precondition statements below preserve the prepared
scope; operator approval, sole-process cgroup verification and one restart were
subsequently completed as recorded in that receipt. No repeat authorization.

Method: hv-cp d66c6f6a09bacb9326309caae316df987824838b.
Fetched origin on 2026-09-24 UTC: origin/main
92256bc1ed7f6dc5bcefcb066096195f49e352f6; HEAD has 7 unique commits,
origin/main has 5. Governing controlled-change and canonical-documentation
contracts match; AGENTS differences retain additional local coordination and
reference-discovery guidance. No silent revision substitution or merge.
TrueNAS owner source: da5b77473b58c536243b3762f050f5717b728bde plus previously
recorded local control-plane method. Preserve unrelated work.

Target: existing hv-lore VM120 truenas-lore, qemu-guest-agent.service only.
Host management: existing strict hv-lore SSH at 192.168.10.20; guest route:
operator's existing authenticated TrueNAS console. hv-cp coordinates this
recovery, truenas-cp owns guest service semantics. No parallel owner mutations.
Operator approval of console reads is present; restart approval is NOT yet present.

Intended mutation: one restart of the existing qemu-guest-agent.service after
fresh confirmation that its cgroup contains only qemu-ga and no child jobs.
Expected result: QGA ping and no-op resume. This is a bounded recovery attempt,
not proof of a particular daemon defect. Preserve pre-restart evidence.

Runbook: [VM120 QGA recovery](../runbooks/VM120_QGA_RECOVERY_20260924.md).
Evidence: [guest observations](../evidence/2026-09-24-vm120-guest-console-observation.md)
and initial handoff. Operator's subsequent stack output confirms
clock_nanosleep, MainPID 2271, TimeoutStopUSec 90 seconds,
KillMode control-group, with no ExecStop value supplied. Sleep cause remains
unknown. KillMode means child jobs would also be terminated; do not restart
if any are present or service membership cannot be established.

Rollback boundary: no persistent configuration is changed; the old process
cannot be restored. A failed restart requires new diagnosis, not repeated
restart, manual kill, device reset, VM/NAS reboot or credential change.
Retain the independent console throughout. No promise of zero service impact;
the agent channel is interrupted during the restart.

Canonical output paths, after an accepted repair:
- create evidence/2026-09-24-vm120-qga-recovery-result.md in hv-cp;
- update helix-arpa-private/nodes/local-compute/hv/hv-lore/CURRENT_STATE.md,
  VALIDATION.md and TODO.md with recovery result and limitations;
- update helix-arpa-private/nodes/local-compute/truenas/truenas-lore/CURRENT_STATE.md,
  VALIDATION.md and TODO.md with service recovery and reconciliation boundary;
- other identity, hardware, network, storage/export and B70 grant records:
  not affected, because none of those settings changes;
- private task publication HANDOFF.md: publication-owner reconciliation handoff,
  preserving the old UNKNOWN attempt until exact evidence resolves it.

Run hv-cp canonical-node and truenas-cp appliance-record validators after those
updates. Runtime success alone is not completion. No publication or Git push
authorized by this packet. Live effects so far: NONE; local fetch only.

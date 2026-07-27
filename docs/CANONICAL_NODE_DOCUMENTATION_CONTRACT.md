# Canonical node documentation contract

## Purpose

Every accepted hypervisor must project its non-secret observed state into the
canonical `infrastructure` repository. Contract-equivalent means the same
required files, sections, classifications, and completion checks. It does not
mean copying another node's addresses, identifiers, hardware facts, receipts,
or operational history.

Runtime acceptance and documentation acceptance are separate gates. A live
change may be technically successful while its control-plane work remains
incomplete because the canonical projection is missing, stale, or internally
contradictory.

## Base projection

For `nodes/<node>/`, the minimum hv-cp projection is:

| Path | Required content |
| --- | --- |
| `README.md` | Current role, platform, concise status, and routes to detailed records. |
| `CURRENT_STATE.md` | Verification date, observed state, intended state, gaps, and evidence boundary. |
| `VALIDATION.md` | Explicit recovery confidence, dated checks, evidence references, and limitations. |
| `TODO.md` | Open work separated from completed or historical work. |
| `command-log/README.md` | Evidence classification and a warning that logs do not authorize repetition. |
| `outputs/README.md` | Generated-evidence classification and a warning that output is not current truth by itself. |

The node identity must also appear in `LAB_IPS.md` and
`standards/IP_ADDRESSING.md`. When a predecessor or planning alias has been
retired, those shared records must describe the deployed identity rather than
continuing to present the old plan as current work.

Role-specific records such as `RUNBOOK.md`, `HARDWARE.md`, `NETWORKING.md`,
`STORAGE.md`, recovery procedures, and service records remain required when the
node's role or the canonical infrastructure standard calls for them. The base
projection is a floor, not permission to remove richer existing records.

## Notification projection

Once a node receives an immutable notification identity, it must have
`NOTIFICATION_IDENTITY.md` with these sections:

- `Stable control-plane identifier` containing the immutable `node_id`, current
  display/host name, and assignment date;
- `Observed binding evidence` distinguishing stable physical binding evidence
  from rebuildable operating-system evidence; and
- `Notification boundary` stating that identity assignment alone does not
  authorize enrollment, access, or a canary.

Keep this file identity-only. Enrollment state, transport acceptance, receipts,
defects, and rollback history belong in dated packets, command logs,
`CURRENT_STATE.md`, and `VALIDATION.md`.

If the ntfy heartbeat stack is installed, the node must also have
`NTFY_HEARTBEAT_MODE.md`. It records normal and fast cadence, automatic expiry,
the mode command, a dated bounded validation result, and the statement that the
heartbeat is not a health guarantee or subscriber receipt.

## Packet requirements

Before execution, every node-specific packet must list exact canonical output
paths, not only a repository or generic "node record" destination. Mark each
path as `create`, `update`, or `not affected` with a reason.

After execution:

1. Preserve the dated packet and immutable evidence.
2. Update every declared canonical path with non-secret results.
3. Reconcile hv-cp status statements that the result supersedes.
4. Reconcile cross-node inventory when identity, address, role, or service
   publication changed.
5. Run the canonical-node validator for the named node.
6. Inspect the relevant diffs and unresolved placeholders or stale status
   language.

Do not mark the control-plane task complete until both runtime validation and
documentation validation pass. If canonical publication is intentionally
deferred, record the exact missing paths and report the task as incomplete.

## Validation

From this repository:

```bash
tools/validate-node-documentation-contract.sh \
  --profile heartbeat \
  /home/louis/infrastructure hv-katra hv-lore hv-matrix
```

The check is static. It proves required documentation structure and guardrail
language, not live-host state, delivery, backup validity, or restore success.

# hv-cp: hypervisor control plane

> **Bottom line up front:** hv-cp v1.2.0 is documented, human-supervised control
> for independent hypervisor work with proven first-article workflows; it grants
> no live-host authority. Static canonical-node conformance is now enforced;
> live-state enforcement, advanced tooling, and metrics remain under development.

`hv-cp` is the durable, reusable control plane for independent hypervisors.
It began by recovering the `hv-katra` installation method; Katra and Lore are
its first proven instances. Matrix is now an operational consumer with its own
verified identity, standalone checkout, and post-install Lifetap baseline.

## What this project owns

- the operating model, runbooks, and sanitized node templates;
- the source-recovery evidence and decisions that explain what was adopted or
  intentionally excluded; and
- implementation packets for future, separately authorized changes.

It does **not** own live credentials, generated install media, raw firmware
tools, large archives, or the private node record.

## Control-plane boundaries

| Need | Durable home | Rule |
| --- | --- | --- |
| Private hardware, management, and Lifetap baseline | `helix-arpa-private/nodes/local-compute/hv/<node>/` | Private authority; archive checksum required. |
| Shareable operational node facts | canonical `infrastructure` repository | Non-secret, reviewable changes only. |
| Recovery method and reusable templates | this active project | Planning and implementation; no direct live authority. |
| Live host state | the named hypervisor itself | Inspect over SSH and capture dated evidence before inference. |

## Start here

1. Read [the control-plane design](docs/CONTROL_PLANE.md).
2. Read [the source recovery record](docs/SOURCE_RECOVERY.md) before reusing
   any recovered installer material.
3. Use [the operator SSH runbook](runbooks/OPERATOR_SSH.md) for normal access.
4. Use [the controlled-change runbook](runbooks/CONTROLLED_CHANGE.md) before
   any live mutation.
5. For a new PVE installation, begin with the
   [PVE auto-install contract](templates/pve-auto-install/README.md).
6. Begin a new node with the templates in `templates/`, then create a
   node-specific implementation packet.
7. Before completion, apply the
   [canonical node documentation contract](docs/CANONICAL_NODE_DOCUMENTATION_CONTRACT.md)
   and run its validator.

Before step 5 or 6, fetch the online checkout and record the exact hv-cp commit
used. A clean checkout with a stale cached `origin/main` is not current proof;
offline bundle checkouts must name their approved commit and limitation.

## Current facts

`hv-katra` is a PowerSpec G434 node, not an HP Z4 G4. Katra and Lore have
receipt-confirmed loopback-only Postfix/Fastmail relays and a daily outbound
mail canary; see [the reusable standard](docs/FASTMAIL_DAILY_CANARY_STANDARD.md).
Their full Lifetap baselines and management records live in their private node
records. Matrix passed its first post-install virtualization baseline and
separately completed Fastmail, Discord, and ntfy outbound-plane acceptance on
2026-07-27. That result does not imply cluster, Ceph, guest, or workload
enrollment. The recovered first-boot sources are evidence of a prior
installation path, not approved production automation.

For a sanitized Matrix-style post-install notification sequence, including
fictional `hv-dog` and `hv-cat` examples, see
[the notification enrollment example](docs/POSTINSTALL_NOTIFICATION_ENROLLMENT_EXAMPLE.md).

# hv-cp: hypervisor control plane

> **Bottom line up front:** hv-cp v1.2.0 is the documented, human-supervised
> control plane for every independent Helix-ARPA hypervisor: Lore, Katra,
> Matrix, and future nodes. It grants no live-host authority. Static
> canonical-node conformance is now enforced; live-state enforcement, advanced
> tooling, and metrics remain under development.

`hv-cp` is the durable, reusable control plane for independent hypervisors.
Every host has its own verified identity, private node record, evidence,
implementation packets, and recovery path. No host is the template, transit,
or authority for another. Recovered Katra-related installation material is
first-article evidence for reusable method only; it does not give Katra a
special operational role. Matrix, Lore, and Katra are equal consumers of the
same control-plane method.

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
8. For Proxmox host-firewall planning, begin with the bounded
   [firewall control plane](firewall-cp/README.md). It does not authorize live
   firewall changes.

Before step 5 or 6, fetch the online checkout and record the exact hv-cp commit
used. A clean checkout with a stale cached `origin/main` is not current proof;
offline bundle checkouts must name their approved commit and limitation.

## Current hypervisor portfolio

| Host | Control-plane posture | Boundary |
| --- | --- | --- |
| Lore | Independently documented hypervisor with its own private baseline, implementation packets, and recovery record. | Its firewall, identity, storage, and service work remain Lore-specific decisions. |
| Katra | Independently documented hypervisor; recovered installation material informs reusable method only. | It is a PowerSpec G434, not an HP Z4 G4; no Katra fact is inherited by another host. |
| Matrix | Independently documented hypervisor with verified identity, standalone checkout, and post-install Lifetap baseline. | Its 2026-07-27 notification-plane acceptance does not imply cluster, Ceph, guest, or workload enrollment. |

Each host's full Lifetap baseline and management record live in its private
node record. Lore and Katra have receipt-confirmed loopback-only
Postfix/Fastmail relays and a daily outbound mail canary; see [the reusable
standard](docs/FASTMAIL_DAILY_CANARY_STANDARD.md). The recovered first-boot
sources are evidence of a prior installation path, not approved production
automation.

For a sanitized Matrix-style post-install notification sequence, including
fictional `hv-dog` and `hv-cat` examples, see
[the notification enrollment example](docs/POSTINSTALL_NOTIFICATION_ENROLLMENT_EXAMPLE.md).

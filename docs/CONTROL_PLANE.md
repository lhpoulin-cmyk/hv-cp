# Node control-plane design

## Purpose

A node control plane is the smallest durable set of records and routines that
lets an operator answer four questions without relying on memory:

1. What is this machine and how is it reached?
2. What evidence supports its current state?
3. What change is proposed, who authorized it, and how is it reversed?
4. Where does the resulting evidence belong?

## Five durable layers

| Layer | Content | Location | Update discipline |
| --- | --- | --- | --- |
| Identity | hostname, role, management boundary, hardware identity | private node record | Change only after observed verification. |
| Evidence | Lifetap archive, checksums, dated captures, Ceph health/quorum/PG state, exact device identity, and recovery-drill results | private node record | Append dated captures; preserve originals. |
| Canonical operations | non-secret service/node facts and shared standards | `infrastructure` | Reviewable Git commits; never automatic credential sync. |
| Active method | templates, decisions, runbooks, implementation packets | this project | Small commits; safe to evolve. |
| Live execution | services, disks, networking, and access | node itself | Only after explicit target, rollback, and evidence destination. |

The canonical operations layer follows
[the canonical node documentation contract](CANONICAL_NODE_DOCUMENTATION_CONTRACT.md).
Every packet names exact canonical output paths, and runtime success does not
close a task whose documentation projection remains incomplete.

## Checkout currency

Repository cleanliness and repository currency are different checks. Before a
template or packet is used from an online checkout, fetch `origin` and compare
the checked-out commit with the intended upstream branch. Two clean checkouts
can report `main...origin/main` while their locally cached `origin/main` refs
point to different commits.

Record the exact hv-cp commit in every implementation packet. An intentionally
offline checkout, including a verified Git-bundle checkout, must compare
against the explicitly approved commit and state that it cannot establish
remote currency. Do not silently mix packet sources from separate checkouts.

## Required operator path

Use SSH as the normal path for host and virtual-machine work. It supports
reliable paste, shell history, exact commands, and easy evidence capture. Use
VNC/IPMI/local console only for firmware, installers, boot failure, or when
SSH is unavailable.

For a local QEMU rehearsal, prefer a loopback-only forwarded SSH port. For a
physical node, use its management address and a named SSH host entry. Do not
make a VNC viewer the normal administrative interface.

## DNS validation without resolvectl

`resolvectl` is not a required dependency for a hypervisor. Validate the
configured name-service path with built-in `getent ahostsv4` against a declared
DNS-only probe record. The probe must be verified absent from the node's
`/etc/hosts`; resolving the node's own FQDN may only prove a local hosts entry.
Record the selected probe in the node manifest and retain the result as
evidence. On Katra, `ws-matriarch.arpa` was verified as a DNS-only probe on
2026-07-26; re-verify that property for every new node.

## Notification-service control

`hv-cp` controls all hypervisor-facing notification work. The reusable
notification kernel and lane design belong to the shared `helix-arpa-ntfy`
deployment; node identity, mailbox routing, and resulting evidence belong to
the private hypervisor record. `ntfy-lore` is historical hosting/endpoint
context, not a Lore-only service label. Neither location grants authority to
send a message or install a notification agent.

Before a notification canary, create a dated `hv-cp` implementation packet
that names one node, exact SSH path, endpoint, logical lane, transport/auth
boundary, fixed non-secret event, rate limit, expected receipt, stop condition,
rollback, and evidence destination. Start only with the `ntfy-canary` lane.
`ntfy-comms` is a later human-facing status lane; it cannot accept commands or
authorize changes.

Katra and Lore now establish one approved outbound-mail baseline: loopback-only
Postfix relaying via Fastmail, a user-created PVE test endpoint with display
author `Helix-Arpa-Cluster`, and a daily persistent mail canary to
`cluster_admin@poulin-arpa.com`. The full reusable standard is
[FASTMAIL_DAILY_CANARY_STANDARD.md](FASTMAIL_DAILY_CANARY_STANDARD.md).
This observed two-node result does not enroll any other node or authorize a
new scheduler, Fastmail credential, or fleet rollout without a node-specific
packet and operator approval.

The current integration design is
[NTFY_HYPERVISOR_INTEGRATION.md](NTFY_HYPERVISOR_INTEGRATION.md). Lore, Katra,
and Matrix are proven publishers with separately assigned immutable identities,
node-specific packets, and receipt evidence. This does not authorize another
node or a fleet rollout.

The reusable post-install method is documented in
[POSTINSTALL_NOTIFICATION_ENROLLMENT_EXAMPLE.md](POSTINSTALL_NOTIFICATION_ENROLLMENT_EXAMPLE.md).
It uses fictional `hv-dog` and `hv-cat` to show why Fastmail, Discord, and
ntfy may have different approval and acceptance paths on the same host.

## Node lifecycle

```text
Observe → record identity/evidence → plan → approve → change → validate runtime
                                      ↑                                 ↓
                              rollback boundary       publish + validate canonical state
```

Each arrow is intentional. A script does not skip the planning or approval
step merely because it exists. Completion requires both the runtime gate and
the canonical-documentation gate.

## Cluster and Ceph change contract

A successful node install does not authorize cluster or storage work. Before a
Ceph membership, OSD/device-preparation, monitor, pool, network, or
quorum-affecting change, create an implementation packet containing:

| Field | Required content |
| --- | --- |
| Current state | dated Ceph health, quorum, PG state, and affected-node evidence |
| Exact target | node, disk serial/WWN, network, pool, or monitor being changed |
| Intended mutation | one concrete change and its expected cluster effect |
| Safety boundary | rollback path, or an explicit irreversibility statement and stop condition |
| Authority | operator approval and scope |
| Evidence destination | private node record, canonical infrastructure, or both |
| Validation | post-change health, quorum, PG, and workload checks |

Capture the baseline before change and the resulting state after validation.
Never infer storage identity from a model name, capacity, or another node's
inventory.

## Reuse for future hypervisors

Reuse the structure, validation gates, SOPS procedure, SSH-first access, and
evidence destinations. Do not reuse Katra's IP, NIC selector, disk selector,
firmware facts, passwords, public-key labels, or assumptions about its
PowerSpec platform. Matrix was built from its own verified identity and
encrypted inputs; future nodes require the same separation. This pattern
applies to independent PVE hosts, future clusters, and Ceph planning; it does
not authorize a cluster join, storage mutation, or other live action.

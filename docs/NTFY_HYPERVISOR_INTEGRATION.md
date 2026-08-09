# ntfy hypervisor integration

> **Deployment naming (2026-07-26):** `helix-arpa-ntfy` is the shared ntfy
> service deployment. `ntfy-lore` is historical hosting and endpoint context;
> it is not a Lore-only service label, a notification lane, or a retirement
> decision. The Lore/Katra heartbeat remains a bounded testing/operations
> facility; all broader integration still requires node-specific approval.

## Scope

This is the control-plane design proven first on `hv-lore` and `hv-katra` and
reusable by future hypervisors. Matrix is now operational and has a verified
post-install baseline, but no evidence in this repository establishes its ntfy
enrollment. The goal is to make notification enrollment idempotent when a node
is ready, not to infer it from host installation. A successful Lore or Katra
canary does not authorize Matrix enrollment.

## Identity rule

Every event carries a `node_id` taken from a durable, immutable identifier in
the enrolled host's canonical record. It must not be derived from the current
hostname, FQDN, IP address, display name, or DNS alias. Those changeable values
are descriptive metadata, not the idempotency anchor.

If a node's canonical record does not yet contain such an identifier, its
canary packet stops before publication and asks the operator to assign one.
This is intentional: a rename must not create a new notification identity.

Current assigned identities:

| Current host name | Immutable `node_id` | Canonical binding record |
| --- | --- | --- |
| `hv-lore` | `helix-node-05368cc1-41b9-483c-97a1-d555c9c054f1` | private `nodes/local-compute/hv/hv-lore/NOTIFICATION_IDENTITY.md` |
| `hv-katra` | `helix-node-8501120a-6cd8-46ec-bbd7-dc76b5c71f84` | private `nodes/local-compute/hv/hv-katra/NOTIFICATION_IDENTITY.md` |

The publisher derives its idempotency key from:

```text
node_id + event_class + observed_at_utc + packet-run identifier
```

That makes a rerun observable and bounded while avoiding a hard-coded
reference to `hv-matrix` or any provisional future name.

## Route and lane model

| Stage | Source | Topic/lane | Permitted event | Result |
| --- | --- | --- | --- | --- |
| 1 | One of `hv-lore` or `hv-katra` | `ntfy-canary` | Fixed synthetic `canary.delivery` event | A one-node, one-route receipt record. |
| 2 | The other existing hypervisor | `ntfy-canary` | Its own fixed synthetic event | Separate receipt record; no fleet inference. |
| 3 | Individually accepted existing hypervisor | Future `ntfy-comms` topic/lane | Approved concise lifecycle classes only | Operator-facing status, still best effort. |

The LXC currently hosting `helix-arpa-ntfy` has its own heartbeat. That is a
local service signal only; it is not a hypervisor event and is not evidence of
an end-to-end receipt.

The current `helix-arpa-ntfy` endpoint is reachable over the management LAN at
`http://ntfy-lore.arpa`. The endpoint's legacy hostname does not constrain its
publishers. A packet must revalidate DNS and local HTTP before a publish.
Current default topic access is recorded as `read-write`; topic ACLs are a
separate hardening/promotion change and are not implied by this plan.

## Minimal publisher contract

Each node-specific packet may install or invoke one bounded publisher only if
it meets all of these requirements:

- sends a fixed, non-secret envelope to the exact approved topic;
- validates all event fields locally; user-supplied message text is never shell
  input;
- uses a short connection timeout and no ambient retries;
- exits without blocking PVE, storage, SSH, VM start/stop, backup, or recovery;
- records a non-secret local result and a receipt/evidence destination; and
- has an idempotent install/update path and a rollback that removes only its
  own artifact.

No host timer, daemon, webhook listener, inbound topic consumer, or command
channel is authorized by this design.

## Required packet sequence

1. Create a dated Lore canary packet; verify its current management path,
   source identity, route, payload, timeout, evidence destination, and
   rollback.
2. Execute only after a specific operator approval; record the receipt or
   failure.
3. Repeat from scratch for Katra. Do not copy Lore's current state or receipt
   as Katra evidence.
4. Review both records before proposing one `ntfy-comms` lifecycle use case.
5. Before any future hypervisor is enrolled, assign or verify its durable
   canonical `node_id` and then create a new packet. Do not reuse an old
   hostname as its `node_id`.

## Current state

Lore and Katra each have a separately authorized lab-only `ntfy-canary`
heartbeat timer. It sends only hostname and uptime in normal five-minute mode;
bounded fast-test mode is five seconds and expires after 15 minutes. It is not
a `ntfy-comms` promotion or a durable health signal. Its packets define the
exact local implementation and rollback. No credentials, ACL, DNS record,
firewall rule, topic subscription, or inbound consumer has been changed.

Matrix completed the same separately authorized publisher and five-minute
heartbeat profile on 2026-07-27. Its manual seed, first automatic run, and
later operator-visible one-shot receipt are preserved in the Matrix packets
and evidence. Matrix's acceptance does not broaden the lane or authorize a
future node.

# HAD-SVC-02C: Lore Ntfy canonical endpoint consumer migration

Status: execution-ready

## Authority and target

This packet changes only the bounded Lore hypervisor heartbeat consumer.
`hv-cp` owns that consumer and the `hv-lore` execution boundary.  `ntfy-cp`
owns the Ntfy service endpoint and `network-cp` owns its DNS publication.
The target is `hv-lore` only, using the existing
`ntfy-hypervisor-canary-heartbeat` helper:

```text
previous endpoint: http://ntfy-lore.arpa/ntfy-canary
canonical endpoint: http://ntfy.helix.home.arpa/ntfy-canary
```

The heartbeat remains best effort, unauthenticated, non-secret, and unable to
block PVE, storage, SSH, VM operation, backup, or recovery.  Katra, Matrix,
observability producers, topic policy, CT245, service configuration, DNS,
TLS, and legacy alias retirement are out of scope.

## Preconditions

Follow [the controlled node-change runbook](../runbooks/CONTROLLED_CHANGE.md).
Before mutation, require fresh evidence that:

1. `network-cp` direct DNS validation passes for `ntfy.helix.home.arpa` on
   both `.251` and `.252` at `192.168.10.245`;
2. `ntfy-cp` validates canonical HTTP and the retained legacy HTTP endpoint;
3. the Lore timer is active and the current helper contains only the previous
   Ntfy URL; and
4. a checksum and exact backup of `/usr/local/libexec/ntfy-hypervisor-canary-heartbeat`
   are captured before edit.

## Mutation, validation, and rollback

Replace only the exact helper URL with the canonical endpoint, preserving its
payload, timeout, retry, systemd unit, timer cadence, and hardening.  Execute
one bounded service run and require success; then show the timer remains active
and the helper contains the canonical URL.  Validate legacy Ntfy HTTP through
the service-owner evidence; do not repoint or remove the legacy alias.

On any failure, restore the exact helper backup, preserve mode/ownership,
execute one bounded prior-endpoint service run, verify the timer remains
active, record the result, and stop.  Do not alter DNS, hosts files, CT245,
Ntfy configuration, topic ACLs, TLS, certificates, or other consumers.

## Canonical output paths

- `implementation/2026-08-09-hv-lore-ntfy-canonical-endpoint.packet.md`:
  create; records this bounded consumer migration.
- `/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-lore/NTFY_HEARTBEAT_MODE.md`:
  update after success with the endpoint and dated bounded validation.
- `/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-lore/CURRENT_STATE.md`:
  update after success with the changed heartbeat endpoint only.
- `/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-lore/VALIDATION.md`:
  update after success with the canonical and legacy service acceptance
  references.

Run the heartbeat-profile canonical-node documentation validator after the
declared projections are updated.

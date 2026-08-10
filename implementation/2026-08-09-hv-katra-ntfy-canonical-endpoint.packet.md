# HAD-SVC-02D: Katra Ntfy canonical endpoint consumer migration

Status: execution-ready

## Authority and target

`hv-cp` owns Katra's bounded heartbeat helper and timer.  `ntfy-cp` owns the
Ntfy service identity; `network-cp` owns canonical DNS.  This packet changes
only the Katra helper endpoint:

```text
previous endpoint: http://ntfy-lore.arpa/ntfy-canary
canonical endpoint: http://ntfy.helix.home.arpa/ntfy-canary
```

The helper's initial SHA-256 is
`84b56c0ed49e155e3495bfc10d805055ee3eb88093ed3b9f08287c29e042bfb9`.
Its timer is active/enabled and its last recorded run succeeded at
2026-08-09 21:06:51 EDT.  No cadence, topic/path, payload, authentication,
timeout, retry behavior, unit hardening, PVE state, DNS, Ntfy service state,
or legacy alias changes are in scope.

## Preconditions

Follow [the controlled node-change runbook](../runbooks/CONTROLLED_CHANGE.md).
Require fresh direct canonical DNS answers from `.251` and `.252` at
`192.168.10.245`, and canonical plus legacy HTTP `200` from CT245.  Capture an
exact root-owned backup and checksum of
`/usr/local/libexec/ntfy-hypervisor-canary-heartbeat` before editing.

## Mutation, validation, and rollback

Replace only the exact legacy URL in the Katra helper.  Run one bounded
heartbeat service execution and require success.  Verify the helper has the
canonical URL, no longer has the legacy URL, and the timer remains
active/enabled.  Validate retained legacy HTTP through the shared service gate.

On any failure, restore the exact helper backup, preserve owner/mode, execute
one bounded prior-endpoint service run, verify the timer remains active, record
the result, and stop all additional consumer mutations.  Do not alter CT245,
DNS, hosts files, topic history, certificates, or other consumers.

## Canonical output paths

- `implementation/2026-08-09-hv-katra-ntfy-canonical-endpoint.packet.md`:
  create; records the bounded Katra change and its outcome.
- `/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-katra/NTFY_HEARTBEAT_MODE.md`:
  update after success with endpoint and dated validation.
- `/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-katra/CURRENT_STATE.md`:
  update after success with the heartbeat endpoint only.
- `/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-katra/VALIDATION.md`:
  update after success with canonical/legacy service acceptance references.

# HAD-SVC-02D: Katra Ntfy canonical endpoint consumer migration

Status: complete

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

## Result

The shared service gate passed immediately before the change: both resolvers
answered the canonical and retained legacy names at `192.168.10.245`, and both
HTTP endpoints returned `200`.  The exact rollback copy is
`/var/backups/had-svc-02d/ntfy-hypervisor-canary-heartbeat.before`, with the
same SHA-256 as the captured before-state.

Only the helper URL changed.  One bounded heartbeat run succeeded at
2026-08-09 21:10:12 EDT with exit status `0`; the resulting helper SHA-256 is
`9100537c8207cea5d49fae7bf36c0ab292cee4997091c298d4823fa79f8afc99`.
The timer remains active/enabled.  No rollback was required.  Matrix and all
non-hypervisor consumers remain unchanged.

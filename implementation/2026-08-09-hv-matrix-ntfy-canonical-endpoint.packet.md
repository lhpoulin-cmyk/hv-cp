# HAD-HV-02B: Matrix Ntfy canonical endpoint consumer migration

Status: complete

## Authority and scope

`hv-cp` owns Matrix's heartbeat integration. `ntfy-cp` owns the service and
`network-cp` owns DNS. This packet changed only the endpoint in
`/usr/local/libexec/ntfy-hypervisor-canary-heartbeat`:

```text
before: http://ntfy-lore.arpa/ntfy-canary
after:  http://ntfy.helix.home.arpa/ntfy-canary
```

No timer cadence, service definition, payload, retry behavior, execution
identity, Ntfy server state, DNS, RouterOS, certificate, or legacy alias was
changed.

Follow [the controlled node-change runbook](../runbooks/CONTROLLED_CHANGE.md).

## Fresh preflight

Both canonical resolvers answered `ntfy.helix.home.arpa` as `192.168.10.245`.
Canonical and retained legacy HTTP endpoints each returned `200`. The helper
was `root:root`, mode `0755`, with SHA-256
`84b56c0ed49e155e3495bfc10d805055ee3eb88093ed3b9f08287c29e042bfb9`.
The heartbeat timer was enabled, active, and waiting; the static service's last
result was `success`.

## Backup, mutation, and validation

The exact pre-change helper was copied with preserved metadata to
`/var/backups/had-hv-02b/ntfy-hypervisor-canary-heartbeat.before`; its checksum
matches the before state. The only substitution replaced the one legacy URL.

The resulting helper is still `root:root`, mode `0755`, passes `bash -n`,
contains the exact canonical endpoint once and no legacy endpoint, and has
SHA-256 `9100537c8207cea5d49fae7bf36c0ab292cee4997091c298d4823fa79f8afc99`.
One bounded `ntfy-hypervisor-canary-heartbeat.service` run completed with
`ExecMainStatus=0` and `Result=success`; the timer remains enabled, active, and
waiting. Both canonical and legacy HTTP endpoints remained `200` afterward.
No rollback was needed.

## Canonical output paths

- `implementation/2026-08-09-hv-matrix-ntfy-canonical-endpoint.packet.md`:
  create; records bounded mutation and rollback evidence.
- `/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-matrix/NTFY_HEARTBEAT_MODE.md`:
  update; records the accepted endpoint.
- `/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-matrix/CURRENT_STATE.md`:
  update; records the current integration state.
- `/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-matrix/VALIDATION.md`:
  update; records bounded canonical transport acceptance.

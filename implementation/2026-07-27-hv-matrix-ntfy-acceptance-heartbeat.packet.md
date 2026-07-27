# Implementation packet: hv-matrix ntfy acceptance and heartbeat

**Target:** `hv-matrix` (`192.168.10.22`) and the shared `helix-arpa-ntfy`
endpoint reached as `http://ntfy-lore.arpa/ntfy-canary`.

**Intended mutation:** invoke Matrix's existing one-shot ntfy canary exactly
once, then install the byte-verified Lore/Katra heartbeat stack and enable it
in slow mode. The persistent heartbeat publishes only short hostname and
human-readable uptime every five minutes. Run the installed heartbeat service
once for acceptance; leave the fast-mode expiry timer installed but disabled
and inactive.

**Service impact:** the shared ntfy service will receive one `canary.delivery`
event, one initial heartbeat acceptance event, and thereafter one best-effort
Matrix heartbeat approximately every five minutes. No ntfy service restart,
topic read, ACL, credential, listener, or subscriber change is authorized.

**Authority:** operator request on 2026-07-27 to match Lore and Katra's proven
ntfy outbound plane on Matrix.

**Established preconditions:** Matrix identity and immutable node ID match the
canonical record; `ntfy-lore.arpa` resolves to `192.168.10.245`; the endpoint
root returns HTTP `200`; Matrix's existing root-only one-shot configuration
targets only the expected base URL and `ntfy-canary` with no access token; no
heartbeat/mode/expiry component exists on Matrix; the accepted non-secret
Lore/Katra components are byte-identical; and PVE/SSH/DNS health is accepted.

**Stop conditions:** stop on an unexpected identity, DNS answer, route result,
one-shot configuration, token, digest, file collision, unit-verification
failure, or host-health result. Do not retry either bounded acceptance event.
Do not inspect topic history.

**Validation:** require server acceptance of the one-shot event and capture
only its non-secret receipt ID. Require systemd verification of the heartbeat
stack, one successful manual heartbeat service result, enabled/active slow-mode
timer with effective `OnUnitActiveSec=5min`, disabled/inactive fast-expiry
timer, a next-run schedule, active PVE/SSH services, and no new failed unit.
These results prove local/server acceptance, not subscriber receipt or host
health.

**Rollback:** disable and stop the heartbeat and expiry timers; remove only the
heartbeat helper, service/timer, cadence drop-in, mode helper, and expiry units;
daemon-reload. Preserve Matrix's pre-existing one-shot helper/environment and
do not alter ntfy service state or topic history. Accepted events cannot be
recalled.

**Evidence destination:** this packet, a dated non-secret Matrix command-log
record, and the canonical notification identity/state records.

**Excluded:** no credential, ACL, DNS, firewall, PVE notification target,
Fastmail, Discord, package, network, storage, cluster, Ceph, guest, topic-read,
subscriber, or Git change.

## Result

Executed and technically accepted on 2026-07-27.

- The one-shot preflight matched the packet. Matrix's existing helper ran once
  and returned a JSON response with a non-empty server receipt ID, establishing
  server acceptance. The combined execution later stopped at the initial timer
  gate before printing that already-validated ID, so the identifier is **not
  determined** from the retained transcript. The canary was not retried.
- The seven heartbeat/mode artifacts installed with the same SHA-256 values as
  Lore and Katra. Systemd verification passed. The heartbeat timer was enabled
  with the accepted five-minute cadence drop-in; fast-expiry remains disabled
  and inactive.
- On a never-run node, activating the slow timer produced no next elapse until
  the service had an activation timestamp. In accordance with this packet's
  explicit one-run acceptance scope, the heartbeat service was started once at
  `15:59:49 EDT`. The server accepted it with receipt ID `g40Yu82taOhV`.
- That one service run seeded the recurring schedule. The next run was listed
  for `16:04:49 EDT`, five minutes later, while the timer remained active and
  enabled.
- The first automatic timer run then completed successfully at `16:04:50 EDT`
  with exit status `0` and server receipt `d69pM0tWXMrn`; the following run was
  scheduled for `16:09:50 EDT`. This establishes the recurring timer path.
- Core PVE, SSH, and Postfix services remained active and no failed systemd
  units were reported.

These results establish local and ntfy-server acceptance, not subscriber
receipt or host health. No topic history was read, no acceptance event was
retried, and rollback was not required.

## Subsequent operator verification

At the operator's explicit request, the installed one-shot helper was invoked
once from the workstation at `2026-07-27T20:28:05Z`. The ntfy server returned
receipt `zbVYQkvc0jij` for topic `ntfy-canary`, the immutable Matrix node
ID, and `host=hv-matrix.arpa`. This later test does not recover the original
unretained receipt ID. The operator subsequently confirmed subscriber display
of this test, establishing the end-to-end ntfy path.

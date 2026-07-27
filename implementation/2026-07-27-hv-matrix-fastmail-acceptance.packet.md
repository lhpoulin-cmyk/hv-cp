# Implementation packet: hv-matrix Fastmail acceptance

**Target:** `hv-matrix.arpa` (`192.168.10.22`) and its existing loopback-only
Postfix/Fastmail relay.

**Intended mutation:** start the existing
`helix-arpa-daily-mail-canary.service` exactly once. This submits one fixed,
non-secret message to `cluster_admin@poulin-arpa.com` through Matrix's local
Postfix relay and Fastmail. Retain the already enabled daily timer and existing
PVE sendmail endpoint unchanged.

**Authority:** operator request on 2026-07-27 to match Lore and Katra's proven
Fastmail outbound plane on Matrix.

**Established preconditions:** Matrix identity and DNS are accepted; Postfix is
active/enabled and loopback-only; relay is `[smtp.fastmail.com]:465` with TLS
wrapper encryption, SASL authentication, `noanonymous`, and the reviewed
generic map; `libsasl2-modules` and PLAIN/LOGIN mechanisms are present;
credential/map files are root-owned mode `0600`; the reviewed helper and units
verify; the timer is active/enabled; the service has never run; the mail queue
is empty; and the user-created `fastmail-cluster-node-canary` endpoint exists.

**Stop conditions:** stop before the send if any identity, DNS, relay, TLS,
SASL, permission, helper/unit, timer, endpoint, queue, or host-health check
differs. After starting the service, do not retry automatically. Stop and
preserve the single queue/log result if Fastmail does not accept it.

**Validation:** require the oneshot service to return success, one new local
submission record, Fastmail SMTP `250`/sent acceptance for that queue item, an
empty queue, active Postfix and PVE/SSH services, and no new failed unit.
Operator-visible receipt is a separate human observation and must be recorded
before claiming end-to-end delivery.

**Rollback:** there is no configuration mutation to reverse and an accepted
message cannot be recalled. If the submission is deferred, preserve the one
queue item for diagnosis unless the operator separately authorizes its
deletion. Do not alter credentials, the timer, endpoint, or Fastmail routing.

**Evidence destination:** this packet, a dated non-secret Matrix command-log
record, and the canonical notification identity/state records.

**Excluded:** no credential, Postfix, timer, endpoint, DNS, firewall, package,
network, storage, cluster, Ceph, guest, Discord, ntfy, or Git change.

## Result

Executed once and technically accepted on 2026-07-27.

- The preflight matched the packet, including the never-run service and empty
  queue.
- At `15:55:55 EDT`, the daily canary service completed successfully and
  submitted exactly one message for `hv-matrix.arpa`.
- Matrix Postfix relayed the one queue item to Fastmail. Fastmail returned
  `250 2.0.0`; the local queue drained and remained empty.
- Postfix, core PVE services, and SSH remained active with no failed systemd
  units reported. No configuration changed and no retry occurred.

Fastmail server acceptance is established. The operator subsequently supplied
the matching Matrix message body, including host `hv-matrix.arpa` and generated
time `2026-07-27T15:55:55-04:00`, confirming receipt at `cluster_admin`.
End-to-end delivery is therefore established for this bounded canary.

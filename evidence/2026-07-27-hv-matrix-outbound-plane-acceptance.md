# hv-matrix outbound-plane acceptance

Date: 2026-07-27
Target: `hv-matrix.arpa` (`192.168.10.22`)

## Scope and authority

The operator authorized Matrix to match the separately proven Lore/Katra
outbound planes: Fastmail through loopback-only Postfix, Discord with forced
Discord-only transport, and the shared ntfy canary plus slow-mode heartbeat.
Each transport used its own implementation packet and stop boundary.

## Established technical results

| Plane | Bounded result | Retained state |
| --- | --- | --- |
| Fastmail | One daily canary at `15:55:55 EDT`; Fastmail SMTP `250 2.0.0`; operator supplied matching received body | Existing daily timer remains enabled/active |
| Discord | Original event at `15:57:41 EDT`, HTTP `204`, operator-confirmed receipt; corrected `hv-matrix Discord canary` at `16:11:17 EDT`, HTTP `204` | Accepted shared helper, root-only webhook, node-named Matrix wrapper |
| ntfy one-shot | Initial invocation returned an unretained non-empty ID; later operator test at `20:28:05Z` returned receipt `zbVYQkvc0jij` | Existing Matrix one-shot helper/environment retained |
| ntfy heartbeat | Manual seed receipt `g40Yu82taOhV`; first automatic run at `16:04:50 EDT`, receipt `d69pM0tWXMrn` | Accepted timer stack enabled in five-minute slow mode; fast expiry disabled |

The one-shot ntfy receipt ID was validated before the combined execution later
stopped at the no-initial-timer-fire gate, but it was not printed into the
retained transcript. Its exact value is therefore not determined and the event
was not retried during that packet. At the operator's later explicit request,
the installed one-shot helper was invoked once from the workstation. The
server returned receipt `zbVYQkvc0jij` for the expected Matrix node ID,
`hv-matrix.arpa`, and `2026-07-27T20:28:05Z`.

## Evidence boundary

Fastmail end-to-end receipt, both Discord events, and ntfy subscriber display
are operator confirmed. The corrected Discord title and retained ntfy receipt
`zbVYQkvc0jij` match Matrix's immutable identity. No topic history was read.
No inbound
listener, control path, notification fallback, DNS, firewall, package, PVE
workload, storage, cluster, Ceph, or guest state changed.

The superseded Matrix installer Discord files are preserved root-only at
`/var/lib/hv-cp/rollback/2026-07-27-hv-matrix-discord-profile/`.
That directory also holds the accepted-but-generic first wrapper for rollback
and provenance.

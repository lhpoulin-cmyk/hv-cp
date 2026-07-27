# 2026-07-26 Hypervisor Discord canaries

## Scope

One explicit, synthetic, Discord-only `canary.delivery` event was sent from
each existing hypervisor through its root-owned
`/usr/local/libexec/hv-cp-discord-canary` wrapper. The wrapper enforces
`ALERT_TRANSPORT=discord`, disables ntfy fallback, and bounds execution to 20
seconds.

## Result

| Host | Immutable node identifier | Local result | Time |
| --- | --- | --- | --- |
| `hv-lore` | `helix-node-05368cc1-41b9-483c-97a1-d555c9c054f1` | Discord HTTP `204` / helper `PASS` | `2026-07-26T16:28:45-04:00` |
| `hv-katra` | `helix-node-8501120a-6cd8-46ec-bbd7-dc76b5c71f84` | Discord HTTP `204` / helper `PASS` | `2026-07-26T16:28:45-04:00` |

HTTP `204` verifies Discord accepted each post. The operator supplied
operator-visible receipt evidence from `arpa-alerts`: both messages were shown
at 4:28 PM local time, with the matching Lore and Katra node identifiers and
UTC observation timestamps above. This closes the human-receipt check.

## Boundaries preserved

- No timer, daemon, PVE notification target, or inbound control path was
  created.
- ntfy fallback was disabled for both sends.
- No Fastmail, DNS, firewall, Ceph, storage, or cluster state changed.
- Katra received the existing Lore helper and root-only webhook under explicit
  operator authorization; neither credential value nor URL was recorded.

## Rollback

Remove only each host's `/usr/local/libexec/hv-cp-discord-canary` wrapper if
the canary facility is no longer wanted. The copied Katra transport material
has its node-specific rollback described in its implementation packet. Revoke
and replace the webhook through its separate credential procedure if compromise
is suspected.

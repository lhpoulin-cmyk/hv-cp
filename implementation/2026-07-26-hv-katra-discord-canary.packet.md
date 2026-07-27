# Implementation packet: hv-katra Discord canary

**Status:** executed; Discord accepted the one bounded canary on 2026-07-26.

## Target and authority

Target: `hv-katra` (`192.168.10.21`), immutable notification identity
`helix-node-8501120a-6cd8-46ec-bbd7-dc76b5c71f84`.

The operator authorized the canary work and authorized copying Lore's existing
credential for simplicity on 2026-07-26. The credential value was not read,
printed, committed, or placed in an active-work file.

## Intended mutation when unblocked

Install the same root-owned, one-shot
`/usr/local/libexec/hv-cp-discord-canary` wrapper with Katra's immutable node
identifier and execute it once. It uses explicit Discord-only mode, disables
ntfy fallback, and has a 20-second bound. The fixed synthetic payload contains
only `canary.delivery`, node identifier, short hostname, and UTC observation
time.

No timer, daemon, package, PVE target, Fastmail, ntfy route, DNS, firewall,
Ceph, or other persistent service is in scope.

## Observed transport preparation

Initial read-only inspection found that Katra had neither the documented helper
nor a local root-readable webhook. With operator authorization, Lore's existing
helper was copied to `/opt/shopgpt-sysadmin/tools/notify_ntfy.sh` and its
root-only webhook was copied to `/etc/shopgpt-sysadmin/discord-webhook-url`.
Both are root-owned; the helper is mode `0755` and webhook is mode `0600`.

Katra's root-owned `0750` wrapper is installed at
`/usr/local/libexec/hv-cp-discord-canary`. It has not yet been executed.

## Validation and rollback

Success requires local zero exit, Discord HTTP `204`, and an operator-visible
message. On failure, stop with no retry/fallback. Roll back only Katra's
wrapper and the separate transport packet's material; do not affect Lore, ntfy,
DNS, firewall, PVE, or Ceph.

## Result

At `2026-07-26T16:28:45-04:00`, the wrapper exited successfully and Katra's
local helper recorded `PASS transport=discord status=204 title=hv-cp Discord
canary`. The operator subsequently confirmed the matching Katra message was
visible in Discord channel `arpa-alerts`; the human-receipt check passed.

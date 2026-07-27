# Implementation packet: hv-lore Discord canary

**Status:** executed; Discord accepted the one bounded canary on 2026-07-26.

## Target and authority

Target: `hv-lore` (`192.168.10.20`), immutable notification identity
`helix-node-05368cc1-41b9-483c-97a1-d555c9c054f1`.

Authority: operator requested documentation, design, build, test, and
implementation of the Discord canaries on 2026-07-26. This packet is limited
to Lore's local canary wrapper and one synthetic outbound Discord event.

## Intended mutation

Install root-owned `/usr/local/libexec/hv-cp-discord-canary` from the sanitized
`hv-cp` template with Lore's immutable node identifier. Execute it once as
root. It invokes Lore's existing notification helper in explicit Discord-only
mode, with ntfy fallback disabled and a 20-second execution bound.

The fixed payload is `canary.delivery` with only the node identifier, short
hostname, and UTC observation time. No timer, daemon, package, PVE target,
Fastmail, ntfy route, DNS, firewall, Ceph, or other persistent service is in
scope.

## Preconditions and stop conditions

- Confirm SSH target and short hostname are `hv-lore`.
- Confirm the existing root-only helper and root-owned runtime webhook are
  present without reading the webhook value.
- Confirm PVE proxy is active.
- Stop before installation if the helper or local webhook is absent, or if any
  check suggests changing the credential, network, or another service.
- Stop after any non-zero wrapper result; do not retry or fall back to ntfy.

## Validation

Success requires the wrapper's local result to be zero and the existing helper
to record Discord HTTP `204`. The operator-visible Discord message is the
human receipt. Record only non-secret time, host, node identifier, and result.

## Rollback

Remove only `/usr/local/libexec/hv-cp-discord-canary` from Lore. Do not change
the existing helper, webhook, ntfy, DNS, firewall, PVE, or Ceph. If the
webhook is suspected compromised, stop the wrapper and revoke/replace it in
Discord through its separate credential procedure.

## Evidence destination

Add a dated non-secret result under `hv-cp/evidence/` and the private Lore node
record. The private Discord service record holds the durable service contract.

## Result

At `2026-07-26T16:28:45-04:00`, the wrapper exited successfully and Lore's
local helper recorded `PASS transport=discord status=204 title=hv-cp Discord
canary`. The operator subsequently confirmed the matching Lore message was
visible in Discord channel `arpa-alerts`; the human-receipt check passed.

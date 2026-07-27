# Implementation packet: hv-katra Postfix/Fastmail notification canary

**Status:** historical first-attempt record; superseded as the reusable
standard by [FASTMAIL_DAILY_CANARY_STANDARD.md](../docs/FASTMAIL_DAILY_CANARY_STANDARD.md).
Its recorded failure and rollback remain accurate historical evidence.

## Target

`hv-katra.arpa` (`192.168.10.21`), its loopback-only Postfix relay and
standalone PVE notification configuration.

## Intended mutation

Configure the existing local Postfix service as an outbound smart relay to
`smtp.fastmail.com:465` with implicit TLS and SMTP authentication. Preserve
`inet_interfaces = loopback-only`; do not open inbound SMTP. Install a
root-readable SASL map and a sender-rewrite map that present local operational
mail as `cluster_node@poulin-arpa.com`.

Create one PVE **sendmail** notification target named
`fastmail-cluster-node`, addressed to `cluster_node@poulin-arpa.com`. Run its
supported PVE test-target API exactly once. Postfix queues and retries delivery
if Fastmail is temporarily unavailable.

No package installation, mail polling, timer, public listener, DNS change,
cluster change, storage change, or workload change is in scope.

## Authority and preconditions

- Operator requested the documented Postfix/Fastmail design on 2026-07-26;
  this packet requires separate, exact Katra-canary approval before execution.
- The shared `cluster_node` delivery chain is recorded as working in the
  private hypervisor mailbox record.
- The ignored encrypted input contains the one shared Fastmail **Mail-only**
  app password named `helix-arpa-cluster`. It is never printed, committed,
  or passed as a command-line argument.
- Katra Postfix is active, enabled, loopback-only, and currently has no relay
  credential or generic sender map. Capture its existing Postfix settings
  before mutation.
- Katra may retain PVE's built-in `mail-to-root` sendmail target. No
  user-created target may exist before execution; the canary creates a separate
  `fastmail-cluster-node` target and does not overwrite the built-in target.
- If Fastmail rejects the `cluster_node` sender identity, stop and roll back;
  do not substitute a different sender without a new packet.

## Validation

1. Confirm Postfix remains loopback-only and the relay uses TLS on port 465.
2. Confirm SASL credentials are root-readable only and absent from PVE's
   notification configuration and process arguments.
3. Confirm the PVE sendmail target exists, then run its target test once.
4. Confirm one receipt at `cluster_node`; record timestamp, host, target name,
   and non-secret result only.
5. Confirm the Postfix queue drains or records a bounded, explainable retry.
6. Confirm no package, timer, DNS, service-listener, cluster, or storage state
   changed beyond the stated Postfix and PVE target configuration.

## Rollback

Delete only Katra's `fastmail-cluster-node` PVE target; restore the captured
Postfix settings; remove only the SASL and sender-map files/databases created
by this canary; and reload Postfix. The shared Fastmail app password remains
for subsequent approved nodes unless compromise is suspected. If compromise is
suspected, revoke it in Fastmail and remove the relay configuration from every
enrolled host.

## Evidence destination

`nodes/local-compute/hv/hv-katra/` in the private control-plane repository,
with a dated non-secret result note after validation.

## Result

**Executed:** 2026-07-26

The PVE target and loopback-only Postfix relay were applied and the single PVE
test notification was queued. Postfix could establish TLS to Fastmail, but it
could not authenticate because the required PLAIN/LOGIN SASL client mechanism
was unavailable on Katra. No message was delivered to Fastmail.

This packet did not authorize package installation. The canary was therefore
rolled back in full: the user-created PVE target was deleted; `main.cf` was
restored from a root-only pre-change snapshot; the SASL and generic sender-map
files/databases were removed; the temporary deployment script was removed; and
the exact deferred canary queue entry was deleted. The built-in `mail-to-root`
target remains. The Postfix queue is empty and the service remains active and
loopback-only.

The absent SASL client mechanism is a separate dependency decision. A later
packet may propose installing the appropriate package after confirming its
identity and rollback boundary; this result does not authorize that change.

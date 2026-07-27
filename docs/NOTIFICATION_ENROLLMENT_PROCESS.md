# Hypervisor notification enrollment process

Status: reusable `hv-cp` method, validated as an offline Matrix installer
render on 2026-07-26. It is a method, not standing authority to contact a
provider or change a host.

## Purpose

Give every newly accepted hypervisor the same small outbound-notification
baseline without hand-copying host files or placing credentials in Git:

```text
encrypted node notification input
  -> short-lived ISO-generation render
  -> root-only one-time first-boot state
  -> notification enrollment after account bootstrap
      -> local-only Postfix/Fastmail + daily mail timer
      -> one-shot Discord canary helper
      -> one-shot ntfy canary helper, only when approved
  -> final post-install checklist runs one bounded canary per enabled transport
  -> operator records the matching receipts
```

The account/SSH/sudo/Git bootstrap must finish first. A failed account
bootstrap leaves its state in place, and notification enrollment must not run
past that boundary.

## Node input and custody

Create one ignored, encrypted SOPS input per node from
`templates/node-notifications.sops.yaml.template`. It contains:

- a freshly assigned immutable `helix-node-<uuid>` identity;
- Fastmail SMTP login and the shared Mail-only application password;
- an approved Discord webhook; and
- ntfy enablement plus endpoint, topic, and optional bearer token only when
  that node has an approved durable ntfy lane.

The input is decrypted only in a short-lived, mode-0700 generation workspace,
embedded in sensitive generated media, then placed in a root-only one-time
state file during first boot. It is never a Git artifact, PVE configuration
value, command-line argument, evidence attachment, or canonical node record.

The current custody implementation is transitional: encrypted node inputs and
their recovery material must be copied and restore-tested in Foundation 2.
Until that procedure is complete and references are deliberately rewired, the
active working copy remains necessary. Record the custody state plainly; do
not claim a single authority that has not been restore-tested.

## First-boot enrollment

The root-only enrollment service is idempotent and removes its state only after
success. It performs these local actions:

1. installs the minimum client dependencies (`ca-certificates`, `curl`, `jq`,
   and SASL client mechanisms);
2. configures Postfix as a TLS smart relay to Fastmail while keeping
   `inet_interfaces = loopback-only`;
3. writes root-only SASL and sender-rewrite maps;
4. preserves PVE's built-in `mail-to-root` target, which now uses the local
   Postfix relay;
5. installs and starts the persistent daily email timer for the established
   `cluster_admin` receipt path;
6. installs a root-only, unscheduled Discord canary helper; and
7. installs a root-only, unscheduled ntfy canary helper only when ntfy is
   explicitly enabled in that node input.

It does **not** send an external message at first boot, create an inbound
listener, add a command channel, modify DNS/firewall/Ceph, replace an existing
PVE notification target, or configure an ntfy fallback.

## Final post-install checklist and transport acceptance

Local configuration is not end-to-end proof. The final post-install checklist
is the one automatic acceptance step after local validation: its approved run
invokes one bounded canary for every enabled transport. It must be backed by a
dated node-specific implementation packet that names the target, route, fixed
non-secret event, stop condition, rollback, and evidence destination.

| Transport | First outbound proof | Acceptance record |
| --- | --- | --- |
| Fastmail | One bounded PVE/sendmail or daily-canary test; inspect Postfix queue and Fastmail acceptance. | Operator receipt at `cluster_admin`. |
| Discord | One one-shot `canary.delivery` message with node ID, FQDN, and UTC timestamp. | HTTP acceptance and operator-visible Discord receipt. |
| ntfy | One one-shot `canary.delivery` message only after durable endpoint/lane preflight. | Local HTTP result and operator-visible receipt. |

No recurring timer is implied for Discord or ntfy. Daily mail is the only
recurring transport in this baseline; the checklist uses one-shot helpers for
the initial receipt evidence.

## Validation, rollback, and records

Before media generation, use an offline fixture test to prove the template
rejects missing fields, malformed IDs, unsafe route data, and unrendered
placeholders. The test must not contact a transport or configure a host.

If enrollment fails, retain only the root-only state needed for diagnosis or a
deliberate retry. A rollback removes only this enrollment's helpers, units,
timer, local maps, and relay settings. Rotating a shared Fastmail credential or
Discord webhook is a separate multi-node change.

Record non-secret local results in the private canonical node record and the
shared operational result where appropriate. Never copy credentials, webhook
URLs, encrypted runtime maps, or decrypted input into those records.

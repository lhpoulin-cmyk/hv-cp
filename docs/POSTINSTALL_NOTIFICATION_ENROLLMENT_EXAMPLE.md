# Post-install notification enrollment example

This is the sanitized pattern refined through Matrix's completed post-install
notification enrollment. It documents the reusable method without granting
standing authority to repeat Matrix's changes. `hv-dog` and `hv-cat` are
fictional examples only: they have no
relationship to a real hostname, address, node identifier, credential, or
service target.

The pattern deliberately separates **installation** from **outbound proof**.
First boot may place root-owned configuration and disabled one-shot canary
units. Sending a message, enabling a recurring task, or changing an external
notification service remains a node-specific approved action.

## Matrix-style sequence

```text
PVE installer acceptance
  -> operator account / SSH / sudo / Git baseline
  -> notification enrollment from an encrypted node input
  -> local configuration validation
  -> separately approved transport canaries
  -> receipt evidence and canonical-node record
```

The encrypted input is rendered only into a short-lived generation workspace,
then becomes root-only runtime material where a transport needs it. It never
belongs in PVE configuration, command lines, evidence, Git, or a node record.

## Transport decisions

| Transport | First-boot enrollment | External send at first boot | Later acceptance |
| --- | --- | --- | --- |
| Fastmail | Configure loopback-only Postfix, root-only SASL map, PVE sendmail route, and disabled daily-canary units. | No | One bounded PVE/mail canary, SMTP acceptance, and operator receipt. |
| Discord | Install a root-only, one-shot canary wrapper and root-only webhook file. | No | One fixed synthetic event, HTTP acceptance, and operator-visible receipt. |
| ntfy | Install nothing unless the shared ntfy endpoint, an approved lane, and an immutable node identifier are approved. | No | One bounded `ntfy-canary` event after route and access-policy preflight. |

Fastmail follows the proven Katra/Lore standard: Postfix remains bound to the
loopback interface and relays with TLS to Fastmail. The daily mail canary goes
to the cluster-admin mailbox only after the node's initial mail acceptance is
recorded.

Discord and ntfy are outbound-only. Neither creates an inbound listener,
command channel, automation webhook, or fallback from one transport to
another. Discord canaries explicitly disable ntfy fallback.

## Fictional example: `hv-dog`

`hv-dog` has passed its installer and post-install account acceptance. Its
node packet approves the durable Fastmail standard and a Discord canary.

1. A node-specific encrypted input provides the Fastmail SMTP credential and
   the Discord webhook. It also contains `hv-dog`'s already-assigned immutable
   notification identifier.
2. First boot configures local-only Postfix and installs disabled daily-mail
   and Discord-canary units.
3. The packet authorizes one Fastmail canary. The operator verifies SMTP
   acceptance and receipt.
4. The packet separately authorizes one Discord synthetic event. The operator
   verifies the matching Discord receipt.
5. ntfy remains absent: the shared service exists, but no lane has yet been
   approved for `hv-dog`.

The durable result is not “all alerts work forever.” It is a dated statement
that each named transport accepted one bounded event and that an operator saw
the expected receipt.

## Fictional example: `hv-cat`

`hv-cat` uses the same Fastmail setup but adds ntfy only after the shared
service route, topic policy, and immutable node identifier have been approved.

1. Its initial encrypted input contains Fastmail material only; no ntfy token
   or Discord webhook is embedded merely because another host has one.
2. A later ntfy packet validates the declared DNS-only route and confirms the
   node identifier. It adds a fixed, outbound-only publisher with a short
   timeout and no automatic retries.
3. The packet sends exactly one `ntfy-canary` event and records the local
   result plus the operator receipt.
4. A daily ntfy scheduler is not implied. If one is ever proposed, it requires
   a new packet, rate limit, retention review, rollback, and evidence plan.

This keeps `hv-cat` from silently inheriting an unapproved route or turning a
notification topic into a control channel.

## Required node input and generated artifacts

Every future node input must contain only the transport fields that have been
approved for that node. Its non-secret schema should identify:

- immutable notification identifier;
- enabled/disabled state for each transport;
- Fastmail sender and operator-recipient routing references;
- Discord webhook reference when Discord is approved; and
- ntfy endpoint, topic, and optional credential reference only when ntfy is
  approved.

The install process may generate these root-owned artifacts:

- Postfix SASL and sender-rewrite maps, mode `0600`;
- a root-only Fastmail daily-canary helper, service, and timer;
- a root-only Discord one-shot wrapper and webhook file; and
- only when specifically approved, a root-only ntfy one-shot publisher and
  its configuration file.

All generated credential-bearing artifacts are rebuilt from encrypted custody
material; they are not copied into evidence. The installer must remove its
short-lived rendered state after successful enrollment. Failed enrollment
must retain only the minimum root-only state needed for diagnosis or a
deliberate retry.

## Acceptance, rollback, and recordkeeping

Before any outbound test, create a dated implementation packet that names the
node, SSH path, exact destination, permitted payload, rate limit, stop
condition, rollback, and evidence destination.

Rollback removes only the enrollment artifacts belonging to the named
transport. It must not alter DNS, firewall policy, PVE cluster state, other
hosts' credentials, or a shared provider account. Credential revocation and
rotation are separate changes because they affect every dependent node.

Record non-secret results in the private node record and every exact canonical
path declared by the packet. Validate the canonical projection under
`CANONICAL_NODE_DOCUMENTATION_CONTRACT.md`. Preserve the packet and immutable
evidence; never replace earlier results with a later success.

# Implementation packet: hv-lore ntfy canary

**Status:** executed and accepted on 2026-07-26.

## Target

`hv-lore`, bound to immutable notification identity
`helix-node-05368cc1-41b9-483c-97a1-d555c9c054f1` in its canonical node record.

## Intended mutation

Run one explicit, non-secret synthetic publish from `hv-lore` to
`http://ntfy-lore.arpa/ntfy-canary`. The event uses class `canary.delivery`,
the immutable `node_id`, the verified current display name as metadata, a UTC
timestamp, and an idempotency key created for this one packet run.

No timer, daemon, package, credential, ACL, DNS, firewall, PVE notification
target, or persistent host artifact is in scope. The request has a short
timeout and no retry budget.

## Preconditions

- Verify the canonical node binding record and the current `hv-lore` identity.
- Verify `ntfy-lore.arpa` resolves through Lore's configured resolver.
- Verify the exact local management route returns HTTP `200` without reading a
  topic.
- Record the idempotency key and evidence destination before the one publish.

## Success and stop conditions

Success is HTTP acceptance plus a non-secret local request record. Stop on
unexpected DNS result, route failure, non-2xx response, topic/payload leakage,
or any indication that a change beyond this one request would be required.

## Rollback and evidence

There is no persistent mutation to remove. Preserve a dated non-secret result
under the Lore canonical command log and an active-work evidence note. Do not
inspect retained topic history as part of validation.

## Result

At `2026-07-26T19:47:18Z`, the preflight identity, DNS, and HTTP checks
passed. The one synthetic event was accepted by `ntfy-lore` with receipt ID
`amxww1a0tEHS`. This is server acceptance, not subscriber-receipt evidence.
No persistent Lore artifact was installed.

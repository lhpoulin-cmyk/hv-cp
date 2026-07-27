# Implementation packet: hv-matrix Discord nomenclature correction

**Target:** `hv-matrix` (`192.168.10.22`), immutable notification identity
`helix-node-f89bcbb4-c9f0-4d28-81aa-40537eb2be99`.

**Intended mutation:** replace only Matrix's installed Discord canary wrapper
with a rendered revision whose visible title is `hv-matrix Discord canary`
instead of the project-generic `hv-cp Discord canary`. Preserve the fixed
`canary.delivery` body, immutable node ID, current short hostname, UTC
timestamp, accepted shared helper, and root-only webhook. Invoke the corrected
wrapper exactly once with Discord forced and ntfy fallback disabled.

**Authority:** the operator reported on 2026-07-27 that the technically
accepted Matrix Discord event used `hv-cp` rather than `hv-matrix`
nomenclature. This packet is the bounded correction within the authorized
Matrix outbound-plane acceptance work.

**Established preconditions:** the operator confirmed visible receipt of the
original Discord event and Fastmail canary; the original Discord event's body
correctly identified Matrix but its title was hard-coded by the reusable
wrapper; Matrix's accepted shared helper and webhook digests remain unchanged;
the current wrapper hash is
`14251e0c31384d1b4cf8f119796cc71005b9d7d532bec4dd888821a2bd22dae6`;
the existing log contains exactly one accepted generic-title event; and PVE,
SSH, DNS, and Discord HTTPS resolution remain healthy.

**Stop conditions:** stop if identity, helper/webhook/wrapper digest, log count,
route, or host health differs. Stop if the rendered wrapper retains the old
title or an unresolved node-ID placeholder. After invocation, do not retry and
do not fall back to ntfy.

**Validation:** shellcheck the reusable and rendered wrappers; verify the
rendered copy differs only in its installed Matrix node ID and node-derived
title behavior; preserve the old wrapper in the existing root-only rollback
directory; require one new log entry reading
`PASS transport=discord status=204 title=hv-matrix Discord canary`; confirm the
log still contains only the original event plus this one correction event;
confirm PVE/SSH health. Operator-visible receipt of the corrected title is the
independent human check.

**Rollback:** restore the previous wrapper from the root-only rollback copy.
Do not change the shared helper, webhook, ntfy, Fastmail, or original evidence.
An accepted correction event cannot be recalled.

**Evidence destination:** this packet, the existing Matrix outbound-plane
evidence summary, canonical command log, and private outbound-plane record.

**Excluded:** no helper or credential change, ntfy fallback, timer, service,
package, PVE endpoint, Fastmail, DNS, firewall, network, storage, cluster,
Ceph, guest, or Git change.

## Result

Executed once and technically accepted on 2026-07-27.

- The reusable template now derives its title from the current short hostname.
  Its SHA-256 is
  `b32d88165648c8acc4764bde47dd583991e7c987d1b0df7d895ec21384f121e8`.
  An offline regression test now requires the node-derived expression, rejects
  the project-generic title, renders the node-ID fixture, and passes both
  `bash -n` and shellcheck.
  The rendered Matrix wrapper passed shellcheck, contained the immutable Matrix
  node ID, retained no unresolved placeholder or generic hard-coded title, and
  has SHA-256
  `b2561820a7edaaf726aef3ab6e31e36b23e01460f2508503f6def25fbfabd6b3`.
- The prior generic-title wrapper was preserved as
  `hv-cp-discord-canary.generic-title` in the existing root-only rollback
  directory. The shared helper and webhook were not changed.
- At `2026-07-27T16:11:17-04:00`, one corrected Discord-only event was accepted
  with HTTP `204`. The local result is
  `PASS transport=discord status=204 title=hv-matrix Discord canary`.
- The log contains exactly two events: the original operator-confirmed generic
  title and this one correction event. ntfy fallback remained disabled; PVE and
  SSH health remained accepted; no failed units were reported.

Technical and operator-visible acceptance of the corrected title are
established. The operator supplied the matching channel event with the
immutable Matrix node ID, `host=hv-matrix`, and
`observed_at_utc=2026-07-27T20:11:16Z`. No retry or rollback occurred.

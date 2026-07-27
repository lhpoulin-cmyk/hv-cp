# Implementation packet: hv-matrix Discord acceptance

**Target:** `hv-matrix` (`192.168.10.22`), immutable notification identity
`helix-node-f89bcbb4-c9f0-4d28-81aa-40537eb2be99`.

**Intended mutation:** normalize Matrix to the accepted Lore/Katra Discord
layout, then invoke one bounded Discord-only canary. Install the byte-verified
shared notification helper, migrate Matrix's already enrolled webhook value to
the standard root-only path without displaying or changing it, install the
node-specific `hv-cp-discord-canary` wrapper, move the superseded installer
helper/unit/environment into a root-only rollback directory, and execute the
new wrapper exactly once with ntfy fallback disabled.

**Authority:** operator request on 2026-07-27 to match Lore and Katra's proven
Discord outbound plane on Matrix.

**Established preconditions:** Matrix's existing root-only Discord environment
is present; its webhook value hashes identically to the accepted Lore/Katra
webhook file without printing the value; the accepted shared helper bytes are
available with SHA-256
`3ca0f9b7ea2af46b78974b924ca3bd1c05c8f5f2884d6c7d1acb566ee0babfa0`;
the rendered wrapper contains only Matrix's immutable ID and no unresolved
placeholder; no standard Matrix helper, webhook path, wrapper, or prior canary
log exists; PVE proxy, SSH, DNS, and external HTTPS resolution are healthy.

**Stop conditions:** stop if any identity, digest, credential hash, file
collision, helper dependency, or host-health gate differs. Do not print the
webhook. After invoking the wrapper, do not retry and do not fall back to ntfy.

**Validation:** require wrapper exit zero and a new root-owned local log entry
recording `PASS transport=discord status=204 title=hv-cp Discord canary`.
Confirm the standard files' hashes, ownership, and modes; confirm the old
installer files are only in the rollback directory; and confirm PVE/SSH remain
healthy. Operator-visible channel receipt is the independent human check.

**Rollback:** remove only the standard Matrix wrapper/helper/webhook and local
canary log, restore the moved installer helper/unit/environment from the
root-only rollback directory, daemon-reload, and revalidate. An accepted event
cannot be recalled. Credential revocation is outside this packet.

**Evidence destination:** this packet, a dated non-secret Matrix command-log
record, and the canonical notification identity/state records.

**Excluded:** no new or changed webhook value, ntfy fallback, timer, daemon,
package, PVE endpoint, Fastmail, DNS, firewall, storage, cluster, Ceph, guest,
or Git change.

## Result

Executed once and technically accepted on 2026-07-27.

- The enrolled Matrix webhook matched the Lore/Katra credential digest without
  exposing its value. It was moved into the standard root-only path.
- The shared helper was installed with SHA-256
  `3ca0f9b7ea2af46b78974b924ca3bd1c05c8f5f2884d6c7d1acb566ee0babfa0`.
  The Matrix-bound wrapper differs from Lore's accepted wrapper only by the
  immutable node ID and has SHA-256
  `14251e0c31384d1b4cf8f119796cc71005b9d7d532bec4dd888821a2bd22dae6`.
- The superseded installer helper, unit, and environment were moved to
  `/var/lib/hv-cp/rollback/2026-07-27-hv-matrix-discord-profile/`, mode `0700`.
- At `2026-07-27T15:57:41-04:00`, the wrapper ran exactly once with Discord
  transport forced and ntfy fallback disabled. The local result was
  `PASS transport=discord status=204 title=hv-cp Discord canary`.
- Core PVE services and SSH remained active with no failed units reported.

Discord HTTP acceptance is established. The operator subsequently supplied the
matching visible event, confirming receipt with the correct Matrix node ID,
host, and UTC timestamp. That event exposed a presentation defect: its title
was the project-generic `hv-cp Discord canary` rather than Matrix nomenclature.
The separately packeted nomenclature correction preserves this accepted result.
No retry occurred; rollback was not required.

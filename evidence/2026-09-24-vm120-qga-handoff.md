# VM120 QGA investigation handoff

PLAY: Restore hv-lore VM120 QGA and reconcile the retained publisher attempt.
CHECKPOINT: 2026-09-24 03:40–03:42 UTC (September 23 EDT).
STATUS: STOPPED BY EXPLICIT AUTHORITY RULE; recovery not completed.
RESULT: Existing strict SSH/sudo work; VM120 QGA still fails. No mutation applied.

## Evidence and ownership

hv-cp owns VM/channel mechanics; truenas-cp owns the appliance service.
Auth-cp's existing credential diagnosis is accepted; no renewal indicated.
Read both owner checkpoints in the operator-specified private task directory:
`/home/louis/.codex/.chatgpt-projects/g-p-6aa46e8d9bf48191a9c395c9050dfb6b/publication-work/tv-publication-dev/`.
`TRUENAS_QGA_REMEDY.md` reports its investigation stopped with no changes.
This continuation performed only reads and a no-op request, avoiding concurrent
mutation. Operator identifies auth-cp and truenas-cp as the coordinating owners;
no fresh exclusive change-owner acknowledgement has been obtained.

Fresh strict nonmultiplexed SSH to existing hv-lore profile returned
`hv-lore.helix.home.arpa`, user louis. `sudo -n -k` was used for each PVE call.
VM120 configuration: `name: truenas-lore`, `agent: enabled=1`.
At 03:40:47 UTC onward:

| Check | Result |
| --- | --- |
| `qm guest exec 120 --timeout 10 -- /usr/bin/true` | exit 255, QEMU guest agent is not running |
| `qm agent 120 ping` | exit 255, same error |
| `qm agent 130 ping` | exit 0 |
| `qm status 120` / `qm status 130` | both running |

The initial sandbox SSH invocation failed locally on system SSH configuration
permissions. The same existing strict profile succeeded through approved tool
escalation; no SSH configuration, identity, trust or credential was changed.

The prior truenas-cp checkpoint records installed PVE implementation inspection:
the generic error follows a guest-ping timeout, QGA/QMP sockets exist, the guest
has opened org.qemu.guest_agent.0, and a 20-second ping also timed out. These
are attributed prior observations, not repeated fresh checks in this continuation.
Immediate cause is an unresponsive VM120 QGA request/response path. A daemon
deadlock, process/resource blockage or guest device/kernel problem remains
unresolved; a stopped service is not proved. No supported host-config repair
is indicated by these observations.

## Exact next decision and recovery boundary

Authorize this hv-cp continuation, coordinated with truenas-cp as service owner,
to use an existing authenticated PVE VM120 console for **read-only guest
diagnostics**. A usable authenticated guest session must exist or be supplied
by the operator; no credential discovery, new login entitlement or trust change.
First inspect the actual qemu-guest-agent unit status, recent unit/kernel logs,
process wait state and virtio port. Do not send a restart through failed QGA.

If evidence isolates the existing agent service, the smallest candidate remedy
is restarting only that service. Obtain a separate exact restart decision after
diagnosis; first create the dated packet and linked runbook, check checkout
currency, audit the runbook linkage, declare canonical output paths and agree
one change owner. No NAS/VM reboot or virtual-device toggle is proposed.
After any approved repair require VM120 ping exit 0 and no-op guest exitcode 0,
with VM120/130 still running and VM130 ping successful. Then update the affected
private canonical records and run their validators. No accepted node change
occurred here, so those projections were not changed.

## Publisher reconciliation

Read HANDOFF.md, backend-dispatch-reconciliation.json and the exact dispatcher
source; did not execute the dispatcher. The sole reconciliation target is
`/mnt/slowPool/jellyfin/shows.incoming/.helix-qual-backend-20260924-a`.
After QGA returns, coordinate with the publication owner to inspect this exact
directory, result.json and retained case receipts read-only. The source writes
result.json only after its synthetic suite runs, as UID/GID 3001 with groups [].
An absent result alone does not prove nonexecution. Preserve evidence and
report partial/complete results without replay, cleanup or media publication.
Current outcome remains UNKNOWN; no guest namespace inspection was possible.
B70 Jellyfin discovery grant and unrelated fixtures/work remain untouched.

## Source identity and delivery

- hv-cp HEAD `d66c6f6a09bacb9326309caae316df987824838b`; AGENTS.md,
  README.md, docs/CONTROL_PLANE.md, runbooks/OPERATOR_SSH.md,
  runbooks/CONTROLLED_CHANGE.md and docs/CANONICAL_NODE_DOCUMENTATION_CONTRACT.md.
- truenas-cp HEAD `da5b77473b58c536243b3762f050f5717b728bde`; unrelated
  dirty work preserved. Uncommitted docs/TRUENAS_CONTROL_PLANE.md SHA256
  `53630417461ec6c819b40ef9649d033128bfe4ac24137f0a240d0a1843ae62b6`.
- arpa-docs doctrine at `e0cf21539ccad3cc1d57ebe3408c9a6d542fc7dc`.
- repo-cp work contract pin `4ede9b73501b38a2b0ba5a50c9c32875a2d0eb19`,
  verified local SHA256 `a4838c4bfd8e1d27ed794c48ca1d475d76929309fabc212368234c4073df7674`.

Local uncommitted task inputs captured 2026-09-24 approximately 03:41 UTC;
no Git base asserted for that private task workspace:

| File | SHA256 |
| --- | --- |
| AUTH_CP_TRANSPORT_CHECK.md | d5a689dccf6807d0e56c1db1ffa461c35b4c56d8a2fc75b8999f6d38f524f2cd |
| HANDOFF.md | ef93e28288665c70ac4f8cf01b625045293dbc6d70e766a38d31d8518f410c34 |
| backend-dispatch-reconciliation.json | fcc7a07a9820875db152affe3b4c618dc9c24d40f9f12af619e38281d6db0ad7 |
| TRUENAS_QGA_REMEDY.md | 137be88c35a0ae8186ef4515734bca249b1868b1b468bdbf3b910f66c42460b8 |
| TRUENAS_REMEDY_REQUEST.md | 182a0250602c207ecc7392c33cab00b0583ee96fc5f6ac850f3da873a76caf22 |
| run-backend-conformance.py | 831f104406bf22779c416e232954938292432ac6e6ac89ed50aa991555b94930 |

HEAD/status/recent history refreshed for both owners before this handoff.
No remote parity claim; no template or mutation packet used. Delivery is a
local uncommitted sanitized evidence handoff only, not recovery acceptance.

BLOCKER=Independent guest diagnostic access requires an exact operator decision
operation=Inspect VM120 guest service and determine a supported repair
observed=Configured running VM120 does not answer QGA; no independently authorized guest session established
expected=Authorized existing guest console session, service diagnosis, then separately approved remedy
authority=Operator explicitly gates materially different access routes and every service restart
why_not_ordinary_debugging=Further host retries cannot inspect the guest service; changing access route would cross the explicit decision boundary

Live effects: NONE from this continuation. Read-only SSH/PVE calls and failed
no-op request may produce ordinary audit logs. No host/service/configuration,
credential, trust, grant, fixture or media changes; no remote writes. The earlier
publisher dispatch remains UNKNOWN and is not reclassified by this statement.

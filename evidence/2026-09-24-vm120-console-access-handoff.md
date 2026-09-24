# VM120 authorized console continuation

PLAY: Read-only guest diagnostics through the existing authenticated PVE console.
CHECKPOINT: 2026-09-24 UTC, following the operator's `yes` to the exact console-access decision.
STATUS: BLOCKED ON AVAILABLE UI CAPABILITY; permission is granted.
RESULT: No browser or native application was exposed to the computer-use tool.

Continues [the QGA investigation](2026-09-24-vm120-qga-handoff.md), whose
historical access-decision blocker is superseded by the operator approval.
Service restarts remain separately gated. This continuation is the diagnostic
coordinator; no concurrent guest changes were initiated.

The computer-use inventory returned `apps: []` and `browsers: []`.
A targeted browser selection for the existing hv-lore PVE management destination
returned `No browser is available`. Thus an authenticated PVE/guest console
could not be inspected. No browser credentials, alternate proxy, virtual-device
change, console keystrokes or guest commands were attempted. Existing SSH access
does not provide a graphical guest console through the available UI capability.

The smallest missing capability is a connected browser exposing the operator's
existing PVE VM120 console, with a usable guest session. The operator should
connect that browser/session, then this task can resume read-only unit status,
logs, process wait-state and virtio-port inspection without another access
approval. No credentials should be pasted into the conversation.

VM120 ping/no-op success is still unmet; no new live probe was needed to establish
the UI capability failure. The exact prior publisher attempt remains UNKNOWN,
unreplayed and unreconciled. All fixtures, media, B70 grants and unrelated work
are preserved. No remedy has been applied or accepted.

Source: previous handoff and operator approval in this conversation; hv-cp
HEAD `d66c6f6a09bacb9326309caae316df987824838b`, truenas-cp HEAD
`da5b77473b58c536243b3762f050f5717b728bde`. HEAD, status and recent history
refreshed for both repositories. No source implementation change or remote
currency claim. Delivery: local uncommitted sanitized addendum only.

BLOCKER=Approved graphical console capability unavailable
operation=Open existing authenticated PVE VM120 console for read-only guest diagnosis
observed=Computer-use inventory empty; targeted browser selection reports No browser is available
expected=Connected browser with existing PVE and usable guest console session
authority=Read-only console access approved; no credential discovery or replacement route authorized
why_not_ordinary_debugging=Available UI tool cannot attach to any browser; guest QGA cannot provide independent console access

Live effects: NONE. No host, guest, service, trust, credential, data or remote Git
changes. The earlier UNKNOWN publisher dispatch remains separately recorded.

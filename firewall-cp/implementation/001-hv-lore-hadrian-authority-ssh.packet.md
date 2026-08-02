# Firewall change packet: Lore allows Hadrian authority SSH on TCP/22

Status: draft; execution blocked and not authorized
Owner: operator
Prepared: 2026-07-27, America/Detroit
Method commit: `5ef28c2` (`docs(firewall-cp): prepare lore Hadrian SSH change`)
Execution runbook: [`../runbooks/001-hv-lore-hadrian-authority-ssh.md`](../runbooks/001-hv-lore-hadrian-authority-ssh.md)

## Outcome

Prepare one narrow Lore node change: allow SSH TCP/22 from Hadrian authority identity `192.168.80.85/32`, and keep the packet blocked until the Hadrian authority path and host prerequisites are independently accepted.

## Exact scope

- Node: `hv-lore`
- Source identity and address: Hadrian authority, `192.168.80.85/32`
- Destination identity and address: `hv-lore` management INPUT path, `192.168.10.20`
- Protocol and port: `tcp/22`
- Proxmox scope: node
- Explicit exclusions:
  - Don’t enable/disable firewalls
  - Don’t modify cluster rules, defaults, or guest/firewall policy
  - Don’t change Katra or Matrix
  - Don’t change RouterOS, switching, DNS, credentials, client trust, or recovery tooling
  - Don’t normalize for Lore/Katra/Matriarch convergence

## Established before state

- Runtime enablement: `hv-lore` firewall enabled/running; effective INPUT currently jumps to `PVEFW-INPUT` (from baseline evidence).
- Node options and ordered rules: node rules are enabled and explicitly ordered; Lore has seven named groups in current order, including existing SSH accepts and post-accept drop management/authority/flat-fabric subnets.
- Cluster options and ordered rules: cluster firewall is enabled with default input policy `DROP`, output `ACCEPT`; no cluster rules were recorded for Lore.
- Effective INPUT behavior: explicit SSH allows for Matriarch and legacy sources exist; Hadrian addresses are not accepted; later drops explain SSH timeout from `.10.86`.
- Successful operator path: Matriarch identity/source acceptance is currently the observed path to Lore SSH.
- Independent recovery path: Lore physical console, operator-confirmed usable
  on 2026-07-27; re-confirm immediately before mutation.
- Evidence location and collection time: `/home/louis/helix-arpa/hv-cp/evidence/2026-07-27-local-hypervisor-firewall-baseline.md` (collection date `2026-07-27`, `EDT`).

## Dependencies

| Dependency | Owner | Required state | Evidence | Status |
| --- | --- | --- | --- | --- |
| Network/VLAN authority path | ops | Accepted Packet 001b workstation profile remains current | Packet 001b operator acceptance | Accepted |
| Address and route | ops | Hadrian `192.168.80.85/24`, route to `192.168.10.0/24` via `.80.1`, no wired default | Packet 001b operator acceptance | Accepted |
| DNS | ops | Not required; validation uses `192.168.10.20` | This packet | Not affected |
| Credential | ops | Hadrian authority credential and direct SSH trust/client config are established | Not yet collected | Blocked |
| Recovery and backup | ops | Fresh Lore firewall before-state capture, backup/export, and tested restore path | Not yet collected | Blocked |
| Management access path | ops | Independent recovery path remains available after insertion | Unknown | Blocked |

## Proposed diff

- Insert one node-level INPUT allow for `src=192.168.80.85/32`, `proto=tcp`, `dport=22` on `hv-lore`.
- Final insertion position: `pos 4`, after the four existing narrow SSH accepts and before the Web UI rules and authority-subnet drop.
- No change to defaults, comments, rule ordering outside the single allow insertion, or cluster rules.
- Local Proxmox VE 9.1.1 source proves POST accepts `pos` and `digest` but does not enforce either: create prepends. The future sequence is therefore disabled create at `pos 0`, fresh digest-guarded move to `pos 4`, then fresh digest-guarded enable. Obtain and verify a new rules digest immediately before every mutating API call; never reuse the recorded preflight digest.
- Exact commands and rollback are in the linked runbook. They remain future instructions, not authority.

## Preconditions

- [x] Packet 001b authority profile accepted for Hadrian `192.168.80.85/24`.
- [ ] Hadrian credential and direct SSH client trust are prepared and valid.
- [ ] Fresh Lore firewall state capture and backup/export are completed and verified.
- [ ] Independent recovery path is tested and approved.
- [ ] Operator approves this exact packet revision.

## Success and negative tests

- Positive: Hadrian at `192.168.80.85` reaches `hv-lore` on TCP/22 directly, using Hadrian’s identity and no `ProxyJump`, and with no Matriarch path.
- Negative: Lore TCP/22 remains denied from Hadrian Wi-Fi `192.168.10.86/32`; the new rule matches only `.80.85/32`.
- Unchanged: Matriarch accepted flows and non-target Lore baseline flows remain unchanged (for example current accepted `192.168.10.80/32`, `192.168.80.80/32`, `192.168.10.21/32`, `192.168.10.84/32`, `tcp/8006` exceptions) and existing operational behavior.
- Effective rule-counter or log evidence: unknown until post-change execution/retest.

## Stop conditions

- Identity differs from expected Hadrian authority identity
- Access-edge endpoint is ambiguous or not sole-path
- Any unknown required dependency remains unresolved
- Target/source role, address, or policy shifts before execution
- Evidence, backup, or recovery artifact unavailable at execution time

## Rollback

- With a newly fetched digest before each call, disable the exact Hadrian rule and then delete it; stop if its position or fields differ. Compare the resulting ordered rules with the exact captured before-state and use the verified private backup restore only if API rollback cannot restore that order.
- Re-run the same positive/negative/unchanged tests from this packet against the restored state.
- If restoration is not possible, stop and hand back to the last safe known management state path; this packet is not authorized until rollback has a tested path.

## Evidence and documentation handoff

- Private raw capture: unknown; to be recorded only after authorized collection.
- Firewall summary: [`../evidence/2026-07-27-hv-lore-hadrian-authority-ssh-preflight.md`](../evidence/2026-07-27-hv-lore-hadrian-authority-ssh-preflight.md).
- Canonical node record: not affected by draft status; record updates only after approved execution.
- Other affected records, or `not affected` with reason: `hv-cp` planning/state records only; no live settings changed.

## Result

Not executed.

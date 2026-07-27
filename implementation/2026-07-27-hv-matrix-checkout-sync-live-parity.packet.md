# Implementation packet: Matrix hv-cp sync and three-node live parity

Date: 2026-07-27

## Method version

This packet uses hv-cp commit
`6c5c752f91e996e26eac596e49246a6f03e337e5`, fetched and verified as
`origin/main` before the packet was written.

The permitted Matrix target is the first descendant of that commit containing
this packet. Record its exact commit and Git-bundle SHA-256 before transfer; do
not include a later commit in the bundle used for execution.

## Authority and targets

Operator authority: perform the previously identified durability gates—publish
the contract, synchronize Matrix's checkout, and freshly validate the live
Lore/Katra/Matrix contract—before the next operator chat.

- Mutable target: `/home/louis/hv-cp` on `hv-matrix.arpa`
  (`192.168.10.22`) only.
- Read-only validation targets: `hv-lore.arpa` (`192.168.10.20`),
  `hv-katra.arpa` (`192.168.10.21`), and `hv-matrix.arpa`.
- SSH path: `louis@<management-address>` with non-interactive sudo.

No live notification, canary, timer restart, service restart, package, DNS,
firewall, network, storage, guest, cluster, Ceph, credential, or GitHub-access
change is authorized.

## Established preconditions

- The active source checkout is clean at the commit containing this packet and
  synchronized with `origin/main`.
- Lore, Katra, and Matrix identities and non-interactive sudo passed read-only
  SSH preflight. Katra briefly rejected one login during shutdown but returned
  as `hv-katra.arpa`; do not mutate or restart it.
- Matrix's checkout is at
  `c974305bcec4295c59a65f55ea7485ce6f5d4080` and has no GitHub credential or
  usable forwarded SSH agent.
- Matrix has exactly three untracked implementation packets that would collide
  with newer tracked paths. Their observed SHA-256 values are:
  - DNS publication: `6fbc3069f55451f21c6e43bbac9bc5f201497de90a73ebcb23c6b5afdb73c177`
  - DNS resolver enrollment: `4d0a27c234d5559b3b8603e1d772eb49b38ded4495ab4829e58ef05e6b88c0fd`
  - Lifetap baseline: `443b01882ce56f0d28518c77ff0600f1a9ee98ebd89fea28d13dc8334e217d24`
- Those files differ from the later committed versions. They are operator work
  and must be preserved, not deleted or silently overwritten.

## Mutation

1. Create a source Git bundle containing only the committed `main` history;
   record and verify its SHA-256 on both systems.
2. On Matrix, create mode-`0700`
   `/home/louis/hv-cp-pre-sync-20260727T212316Z/`.
3. Reconfirm the three untracked paths and hashes, then move only those files
   into that preservation directory. Preserve their relative filenames and a
   checksum manifest.
4. Create Matrix branch `pre-sync-20260727-c974305` at the observed old commit.
5. Fetch the verified bundle and fast-forward `main` only. Stop if the update
   is not a fast-forward or if any other worktree path is dirty.
6. Leave the preservation directory, old branch, and bundle in place for
   rollback and provenance.

## Fresh live parity validation

Without sending a message or changing state, collect from all three hosts:

- FQDN, effective timezone, PVE version, and failed-unit count;
- enabled/active state for the daily-mail and ntfy heartbeat timers;
- disabled/inactive state for the ntfy fast-expiry timer;
- `ntfy-heartbeat-mode status` and effective five-minute cadence;
- SHA-256 and ownership/mode for the seven non-secret heartbeat artifacts;
- SHA-256 and ownership/mode for the three non-secret daily-mail artifacts;
- a normalized SHA-256 for the Discord wrapper after replacing only its public
  immutable node ID;
- active loopback-only Postfix posture and presence of the named PVE sendmail
  endpoint; and
- root-only mode/presence checks for credential-bearing files without reading
  or hashing their contents.

Do not invoke a canary, start a service, restart a timer, read an ntfy topic,
or print a credential or secret-derived value.

## Stop conditions

Stop before mutation on identity mismatch, new or changed Matrix untracked
paths, checksum mismatch, a non-fast-forward checkout, bundle mismatch, or
unavailable rollback branch. Stop the comparison on a command that would
require state change or expose a secret. Preserve partial evidence and report
the exact limitation.

## Rollback

The checkout rollback is `git switch pre-sync-20260727-c974305`; do not reset
or delete the synchronized branch. The preserved untracked originals remain
outside the checkout and are restored only by a separate explicit decision.
No live-service rollback is expected because validation is read-only.

## Canonical output paths

| Path | Action |
| --- | --- |
| `implementation/2026-07-27-hv-matrix-checkout-sync-live-parity.packet.md` | create; preserve plan and result |
| `evidence/2026-07-27-hypervisor-control-plane-live-parity.md` | create; non-secret three-node result |
| `infrastructure/nodes/hv-matrix/CURRENT_STATE.md` | update; exact synchronized checkout commit |
| `infrastructure/nodes/hv-matrix/command-log/2026-07-27-hv-cp-sync-live-parity.md` | create; Matrix mutation and cross-node result |
| private Matrix node `CURRENT_STATE.md` | update; exact synchronized checkout commit and preservation path |
| `infrastructure/nodes/hv-katra/CURRENT_STATE.md` and dated command log | update; unscheduled heartbeat and failed CT 131 unit |
| private Katra node `CURRENT_STATE.md` | update; same fresh operational exceptions |
| Lore canonical and private current-state files | not affected; fresh validation confirmed current facts |
| `LAB_IPS.md` and `standards/IP_ADDRESSING.md` | not affected; no identity, address, or role change |

## Result

Executed 2026-07-27.

### Checkout synchronization: PASS

- Source and target bundle SHA-256:
  `1027d4e77861da02f01ebec6ae9b6737421a3a4170e38a5515cfc103f7d73795`
- Matrix `main` fast-forwarded from
  `c974305bcec4295c59a65f55ea7485ce6f5d4080` to the exact permitted packet
  commit `474576b78576171049e0a8b18c98c2f82e414be5`.
- Rollback branch: `pre-sync-20260727-c974305`
- Preserved originals:
  `/home/louis/hv-cp-pre-sync-20260727T212316Z/`; its checksum manifest
  verifies, and the directory remains mode `0700`.
- Matrix's checkout is clean. It reports `main...origin/main [ahead 7]`
  because its offline `origin/main` tracking reference was not fetched or
  rewritten; this is expected and does not alter the verified target commit.

No live service, timer, notification, guest, package, network, or credential
state was changed.

### Fresh live parity: FAIL

The read-only comparison found common identity, timezone, notification relay
posture, secret-file modes, PVE endpoint, and byte-identical seven-file ntfy
heartbeat implementation. Lore's heartbeat timer also had a last trigger and
valid next elapse.

The fleet does not currently satisfy one operational contract:

- Katra and Matrix reported the heartbeat timer enabled and active with the
  five-minute cadence configured, but neither reported a last trigger or a
  next elapse after its current boot.
- Katra reported one failed systemd unit, `pve-container@131.service`.
- Lore/Katra retain the earlier daily-mail helper and timer comments; Matrix
  matches the current reviewed templates. These comment-only differences do
  not change runtime behavior.
- After immutable node IDs are treated as expected identity data, Matrix's
  Discord wrapper still differs from Lore/Katra: Matrix derives the title as
  `${host} Discord canary`, while Lore/Katra use `hv-cp Discord canary`.

The comparison did not restart the heartbeat timer, start container 131,
replace artifacts, or send a canary because those actions are outside this
packet. The full non-secret result is preserved in
`evidence/2026-07-27-hypervisor-control-plane-live-parity.md`.

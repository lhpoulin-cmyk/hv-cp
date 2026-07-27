# Implementation packet: three-hypervisor operational harmony

Date: 2026-07-27

## Method version

This packet uses published hv-cp commit
`3de427c3dface98e7d61b689727941fe7ec0e0fc`, fetched and verified as
`origin/main` before authoring.

The execution commit is the first descendant containing this packet. Record
and verify that exact commit before host mutation; do not silently substitute a
later template revision.

## Authority and outcome

Operator authority: implement operational harmony across Lore, Katra, and
Matrix, and verify durable systemd role behavior after Katra's reboot.

The intended result is:

- identical reviewed heartbeat timer and mode-helper artifacts on all three;
- an activation-relative first run after timer start or reboot, followed by
  the selected five-minute cadence;
- current daily-mail artifacts on Lore and Katra, matching Matrix;
- node-qualified Discord title behavior on Lore and Katra, matching Matrix;
- enabled/active PVE and notification-role units with valid future timers; and
- Katra CT 131 represented durably as intentionally stopped while its encrypted
  storage dependency is unavailable, rather than failing on every boot.

## Targets and boundaries

Mutable hosts:

- `hv-lore.arpa` (`192.168.10.20`)
- `hv-katra.arpa` (`192.168.10.21`)
- `hv-matrix.arpa` (`192.168.10.22`)

SSH uses `louis@<management-address>` and non-interactive sudo.

This packet may replace only the named non-secret notification artifacts,
restart only the heartbeat timer through `ntfy-heartbeat-mode slow`, disable
Katra CT 131 autostart, and clear that CT's current failed-unit marker. The
timer restart is expected to publish one normal hostname/uptime heartbeat per
host after five seconds. It does not authorize a Discord or daily-mail canary.

No credential, webhook, Postfix map, relay, PVE endpoint, package, firewall,
DNS, network, cluster, Ceph, VM, other guest, or other service change is
authorized. Do not read or hash secret-bearing files.

## Established before-state

- PVE core services, Postfix, and the daily-mail timer are enabled and active
  on all three; every daily timer has a future elapse.
- All three heartbeat timers are enabled and active with the old byte-identical
  implementation. Lore is `waiting`; Katra and Matrix are `elapsed` with no
  last trigger or future elapse after their current boots.
- Root cause is established: the old cadence drop-in's empty
  `OnUnitActiveSec=` assignment clears every monotonic trigger, including the
  base `OnBootSec`, then restores only interval-relative cadence.
- Lore/Katra use earlier comment-only daily helper/timer revisions. Matrix
  matches the current reviewed templates.
- Lore/Katra use generic Discord titles. Matrix and the current template use a
  host-derived title. Immutable node IDs remain host-specific and unchanged.
- Katra CT 131 has `onboot: 1` but is stopped and failed. Its exact bind source
  `/mnt/truenas/secure-rw/jellyfin-media` is absent.
- Read-only guest-agent evidence shows TrueNAS dataset
  `tank/secure/jellyfin-media` is unmounted, encrypted, and has key status
  `unavailable`; it retains stale mountpoint
  `/mnt/mnt/tank/secure/jellyfin-media`. Do not create a replacement directory,
  unlock, mount, rename, or change this dataset under this packet.

## Reviewed source artifacts

| Source | SHA-256 |
| --- | --- |
| `templates/ntfy-heartbeat-mode` | `2a358f6ece18eedfafa346c1eb60604e2e6d01b0591b9dd830c892a9a3ea24b5` |
| `templates/ntfy-hypervisor-canary-heartbeat.timer` | `1460b7a94f8e6e5a8291a4d631711da59acaf7aa62a4693687ef2c0ba17296df` |
| daily-mail helper | `7efb2568ba239f4627276595ea286aa14aa811d03b543e773c286b920a00ff98` |
| daily-mail timer | `4cf33fe16b8176513fa400978947e44533c82db0725c058de869a513af0250b0` |
| Discord template before node-ID rendering | `b32d88165648c8acc4764bde47dd583991e7c987d1b0df7d895ec21384f121e8` |

The Discord wrapper must be rendered separately for Lore and Katra using the
already assigned public immutable node ID. Reject an unresolved placeholder or
any other content difference.

## Preservation and mutation

1. Reconfirm FQDN, before-state hashes, timer state, and Katra CT/storage
   preconditions. Stop on drift.
2. On each host create mode-`0700`
   `/root/hv-cp-operational-harmony-20260727T181749-0400/` and copy every
   artifact that will be replaced into it with a SHA-256 manifest.
3. Install the reviewed heartbeat helper as root mode `0755` and timer as root
   mode `0644` on all three.
4. On Lore and Katra only, install the reviewed daily helper as root mode
   `0700`, daily timer as root mode `0644`, and correctly rendered Discord
   wrapper as root mode `0750`.
5. Run `systemd-analyze verify` against the affected units, reload systemd,
   then run `ntfy-heartbeat-mode slow`. This restarts only the heartbeat timer
   and leaves fast-expiry disabled.
6. On Katra, run `pct set 131 -onboot 0`, verify the configuration, then clear
   only `pve-container@131.service`'s failed marker. Do not start CT 131.

## Acceptance

On all three hosts require:

- no unresolved template placeholder;
- exact reviewed heartbeat, daily-mail, and normalized Discord content;
- expected root ownership and modes;
- PVE core services, `pve-guests`, Postfix, daily-mail timer, and heartbeat
  timer enabled/active as appropriate;
- fast-expiry disabled/inactive;
- heartbeat timer `waiting`, a successful first run after this activation, and
  a future elapse approximately five minutes later;
- daily-mail timer with a future elapse; and
- no failed systemd units.

On Katra additionally require CT 131 stopped with `onboot: 0`, exact missing
bind-source limitation preserved, all other configured on-boot guests in their
expected running state, and `pve-guests.service` successful. This verifies a
durable intentional stop; it does not claim the private-media role is restored.

## Stop conditions

Stop on identity mismatch, source or destination hash mismatch, unexpected
dirty content, unavailable preservation copy, failed unit verification,
unexpected notification transport, a new failed unit, changed Katra dataset
state, or any need to access encryption material. Preserve partial evidence
and do not improvise a storage repair.

## Rollback

Restore only the preserved non-secret artifacts to their original paths and
modes, reload systemd, and restart only the heartbeat timer. On Katra, restore
CT 131's prior boot flag with `pct set 131 -onboot 1` only if the rollback
decision explicitly accepts recurrence of the known boot failure. Do not
delete the preservation directories.

## Canonical outputs

| Path | Action |
| --- | --- |
| this packet | preserve plan and result |
| `evidence/2026-07-27-hypervisor-operational-harmony.md` | create non-secret result |
| infrastructure Lore/Katra/Matrix `CURRENT_STATE.md` and `VALIDATION.md` | update durable role result |
| infrastructure Lore/Katra/Matrix `NTFY_HEARTBEAT_MODE.md` | update current mechanism and validation |
| infrastructure dated node command logs | create per-host result |
| private Lore/Katra/Matrix `CURRENT_STATE.md` | update current role result and limitations |
| identity and IP standards | not affected |

Run the canonical heartbeat documentation validator before completion.

## Result

Pending execution.

# Hypervisor control-plane live parity

Date: 2026-07-27

## Finding

**FAIL:** Lore, Katra, and Matrix are documented against the same canonical
contract, but they are not currently operating under an idempotently identical
notification/heartbeat contract.

The comparison was read-only. It did not send a notification, read a secret,
restart a timer or service, start a guest, or change a host.

## Scope and method

The authorized targets were `hv-lore.arpa` (`192.168.10.20`),
`hv-katra.arpa` (`192.168.10.21`), and `hv-matrix.arpa`
(`192.168.10.22`). Evidence was collected over non-interactive SSH during the
2026-07-27 17:24--17:30 EDT window. Commands inspected identity, platform,
systemd state, public configuration, non-secret artifact digests and modes,
and secret-file metadata only.

## Common established state

- Each host returned its expected `.arpa` FQDN and `America/Detroit` timezone.
- `helix-arpa-daily-mail-canary.timer` and
  `ntfy-hypervisor-canary-heartbeat.timer` reported enabled and active.
- `ntfy-heartbeat-fast-expiry.timer` reported disabled and inactive.
- `ntfy-heartbeat-mode status` reported slow mode with effective
  `OnUnitActiveSec=5min`.
- Postfix was active, loopback-only, and configured for TLS-encrypted,
  authenticated relay through `[smtp.fastmail.com]:465`.
- PVE endpoint `fastmail-cluster-node-canary` was present.
- `/etc/postfix/sasl_passwd`, its database, and
  `/etc/shopgpt-sysadmin/discord-webhook-url` were present as root-owned mode
  `0600` files. Their contents were not read or hashed.

The seven non-secret heartbeat artifacts were byte-identical across all three
hosts:

| Artifact | SHA-256 | Mode |
| --- | --- | --- |
| `/usr/local/libexec/ntfy-hypervisor-canary-heartbeat` | `84b56c0ed49e155e3495bfc10d805055ee3eb88093ed3b9f08287c29e042bfb9` | `0755` |
| heartbeat service | `992298846d95468ec54aa276a5fb58cfef997f28512524ba19cf656589923dd8` | `0644` |
| heartbeat timer | `c950a9c5c945b5f6f87597cc077b4014580d68742f350f8852e20dd1a23c33af` | `0644` |
| `/usr/local/sbin/ntfy-heartbeat-mode` | `63bf48d15649570d99ee93aa2086b51fc4f9c55ce839424fd177af77514f2f19` | `0755` |
| fast-expiry service | `ad4aace9c8fb1b759bd56717239511f93410f2b22edca5444a844c69da50751b` | `0644` |
| fast-expiry timer | `ab18ee25abe0bd39a44aa25279586e4e6fb05fa035627898f89c667810e8e29` | `0644` |
| cadence drop-in | `0979d6145576ceba8092ab650985de9dc879944bedb6f2bd8cdf45d99d91ed07` | `0644` |

All were root-owned.

## Material differences

| Area | Lore | Katra | Matrix |
| --- | --- | --- | --- |
| PVE / kernel | 9.1.1 / `6.17.2-1-pve` | 9.2.2 / `7.0.14-6-pve` | 9.2.2 / `7.0.2-6-pve` |
| Failed systemd units | 0 | 1: `pve-container@131.service` | 0 |
| Current boot | not material to finding | 2026-07-27 17:19:42 EDT | 2026-07-27 17:18:47 EDT |
| Heartbeat last trigger | 17:26:16 EDT | none reported | none reported |
| Heartbeat next elapse | 17:31:16 EDT | none reported | none reported |

Katra and Matrix therefore have identical heartbeat files and configured
cadence, but no observed active schedule after the current boot. Enabled and
active unit labels alone did not establish operational equivalence.

The daily-mail service unit was identical on all hosts
(`c16448668245d8d4f2d6a18b3cbf0d898fe799d6749659985803ba4286166c41`).
Matrix matches the current reviewed helper and timer templates. Lore/Katra
differ only in comments:

- helper: Matrix adds the approved-packet installation warning;
- timer: Matrix uses the current timezone preflight wording.

The normalized Discord wrapper also differs after hostnames are normalized and
immutable node IDs are classified as expected identity data. Lore/Katra use a
generic `hv-cp Discord canary` title; Matrix derives `${host} Discord canary`.

## Conclusion and boundary

The documentation contract is now shared and mechanically validated. The live
contract is not yet shared because Katra and Matrix lack an observed heartbeat
schedule, Katra has a failed guest unit, and Discord title behavior differs.
The daily-mail differences are provenance drift without runtime effect.

Cause of the two unscheduled heartbeat timers was not determined by this
read-only collection. Remediation requires a separate operator-authorized
packet with before-state, success criteria, rollback, and a declared evidence
destination.

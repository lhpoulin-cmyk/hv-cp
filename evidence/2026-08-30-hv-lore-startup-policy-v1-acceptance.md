# hv-lore startup policy v1 acceptance

Date: 2026-08-30
Scope: repository reconciliation of operator-accepted post-migration state
Runtime mutation: none

## Accepted storage and migration state

```text
HV_LORE_MIGRATION=ACCEPTED
P3_RPOOL=ONLINE
P3_RPOOL_GUID=4137356908105663872
P3_MEMBER_1=ata-P3-256_9760522200232-part3
P3_MEMBER_2=ata-P3-256_9760511210658-part3
LAST_ACCEPTED_RPOOL_FREE_GIB=130.00
LAST_ACCEPTED_RPOOL_FREE_PERCENT=55.08
OLD_RPOOL_GUID=8921639095104950851
OLD_RPOOL_MEMBERS=TP250913B5D3323,TP250913B5D1797
OLD_RPOOL=EXPORTED
OLD_RPOOL_ROLE=HISTORICAL_CONFIGURATION_AUTHORITY_AND_READONLY_FALLBACK
```

The P3 mirror is the production boot and runtime `rpool`. The old Timetec
mirror is not production storage and may only serve as explicitly bounded,
read-only historical configuration authority or fallback.

## Accepted guest and startup policy

| Order | Guest | `onboot` | Accepted `startup` |
| ---: | --- | ---: | --- |
| 1 | CT243 `time-lore` | 1 | `order=1,up=5` |
| 1 | CT252 `lxc-lore-dns` | 1 | `order=1,up=10` |
| 2 | VM120 `truenas-lore` | 1 | `order=2,up=30,down=120` |
| 3 | CT245 `ntfy-lore` | 1 | `order=3,up=5` |
| 3 | CT246 `lxc-lore-headscale` | 1 | `order=3,up=10` |
| 3 | CT247 `lxc-lore-monitor` | 1 | `order=3,up=5` |
| 3 | VM260 `pbs-core` | 1 | `order=3,up=15,down=60` |
| 4 | VM130 `jellyfin-lore` | 1 | `order=4,up=10,down=60` |
| 4 | CT248 `lxc-lore-www` | 1 | `order=4,up=5` |
| 5 | VM100 `ansible-console` | 1 | `order=5,up=5,down=30` |
| 5 | VM140 `ws-lore-agent` | 1 | `order=5,up=10,down=60` |
| 5 | VM142 `eq-lore` | 1 | `order=5,up=5,down=30` |
| 50 | VM242 `pbs-katra` | 1 | `order=50,down=60` |

VM141 `ws-lore-apropos`, VM149 `ws-matriarch-gauntlet`, and VM150
`wow-unbound-prod` are intentionally manual with `onboot=0`. CT249 is neither
an autostart guest nor a failed restore:

```text
CT249=PARKED_INCOMPLETE
ONBOOT=0
CONTAINER_SHELL_EXISTS=YES
VAULTWARDEN_RUNTIME_DEPLOYED=NO
```

The policy encodes dependency sequencing, not an assertion that every later
guest consumes every earlier service. TrueNAS precedes VM130 and VM242, whose
accepted storage records include media mounts and NFS backing respectively.
DNS/time precede the networked core and application waves. PBS supplied
migration payloads and remains a backup role; restored guests, including
VM140 and CT252, do not acquire an ongoing runtime dependency on PBS merely
because PBS was their restore source.

Intended native reverse-order shutdown is VM242, order-5 guests,
applications, core infrastructure/PBS, TrueNAS, then DNS/time. Deliberate
shutdown allowances are VM120 120 seconds; VM130, VM140, VM242, and VM260 60
seconds; and VM100 and VM142 30 seconds.

## Fresh-boot event evidence

```text
HOST_BOOT_TIME=2026-08-29T23:07:36+00:00
PVE_GUESTS_EXEC_START=2026-08-29 19:08:21 EDT
PVE_GUESTS_ACTIVE_ENTER=2026-08-29 19:10:55 EDT
TIMING_CONFIDENCE=EVENT_ONLY
```

| Time (EDT) | Observed event |
| --- | --- |
| 19:08:22 | CT243 start |
| 19:08:27 | CT252 start |
| 19:08:38 | VM120 start |
| 19:09:09 | CT245 start |
| 19:09:14 | CT246 start |
| 19:09:24 | CT247 start |
| 19:09:29 | VM260 start |
| 19:09:45 | VM130 start |
| 19:09:55 | CT248 start |
| 19:10:01 | VM100 start |
| 19:10:06 | VM140 start |
| 19:10:16 | VM142 start |
| 19:10:23 | VM242 start |
| 19:10:26 | VM242 reported started |
| 19:10:54 | `startall` OK |
| 19:10:55 | `pve-guests.service` finished |

This measurement included VM242's former `up=30`. That final delay was later
removed because VM242 is the last startup guest and the delay had no
sequencing value. No equivalent post-change boot has been measured.

```text
MEASURED_POST_CHANGE_COMPLETION=NO
EXPECTED_NEXT_EQUIVALENT_BOOT_EFFECT=approximately_30_seconds_shorter
EXPECTED_EFFECT_IS_NOT_MEASURED=YES
```

## Accepted migration service facts

- VM120: running; QGA passed; `slowPool` healthy; Toshiba mappings passed.
- VM260: running; PBS service passed; `pbs-core-lore` available; backup
  content visible.
- CT252: real PBS restore proof passed; running DNS service active; historical
  host-side syslog bind state recreated from old-rpool authority on P3.
- VM140: accepted; raw NVMe preserved; EFI/TPM state restored from PBS to P3;
  P6000 bound to `vfio-pci`; QGA, management network, storage network, and
  8972-byte jumbo ping passed; NVIDIA driver `580.159.03`.

## Host and observer observations

The accepted boot observation is approximately 19.455 seconds to
`graphical.target`; `smartmontools.service` at approximately 15.705 seconds is
the dominant systemd critical-chain unit. It was observed, not optimized.

```text
SMARTD_TUNING=DEFERRED
OBSERVER=/usr/local/sbin/helix-pve-observe
OBSERVER_SUDO=ansible-observer ALL=(root) NOPASSWD: /usr/local/sbin/helix-pve-observe inventory, /usr/local/sbin/helix-pve-observe boot-timing
VISUDO=PASS
OBSERVER_INVENTORY=PASS
OBSERVER_BOOT_TIMING=PASS
HELIX_HYPERVISOR_BOOT_TIMING_ALL_THREE=PASS
```

## Repository claim audit

The required repository-wide terms were searched, including Lore/rpool and
device names, all listed guest IDs and service names, startup/onboot/delay
terms, and old boot-layout language. Relevant hits classify as follows:

| Classification | Paths | Reconciliation |
| --- | --- | --- |
| `CURRENT_AND_ACCURATE` | this record; `evidence/2026-08-29-hv-lore-recovery-state.md`; `implementation/2026-08-29-hv-lore-old-rpool-to-p3-realization.packet.md`; Lore rows in `plans/pve-startup-order-v1.{md,yaml}` and `generated/pve-startup-policy.json` | Current accepted facts and policy. |
| `HISTORICAL_AND_VALID` | dated Lore evidence through 2026-08-28; `evidence/pve-guest-timing/2026-08-15/`; dated Lore packets/runbooks through 2026-08-28; raw `inbox/2026-08-14-hv-lore/` captures | Observations and then-authorized actions remain unchanged and do not become current merely because they are preserved. |
| `SUPERSEDED_DECISION` | `decisions/2026-07-31-lore-boot-layout.md`; historical startup values in `evidence/2026-08-14-hv-lore-guest-autostart-restored.md` | The decision now has an explicit superseded marker; immutable dated evidence retains its original observed values. |
| `CURRENT_AND_ACCURATE` | generic control-plane docs, templates, Katra/Matrix records, `firewall-cp/`, and tooling hits | The matching terms do not make claims about current Lore migration storage or startup state; no correction required. |
| `STALE_CURRENT_CLAIM` | none after reconciliation | Pre-migration Lore rows in the active plan/generated policy were replaced. |
| `AMBIGUOUS` | none after reconciliation | Current authority and historical chronology are explicitly separated. |

Deferred work is limited to `SMARTD_TUNING=DEFERRED` and any separately
authorized future housekeeping. This record is evidence of accepted state; it
does not authorize a runtime change.

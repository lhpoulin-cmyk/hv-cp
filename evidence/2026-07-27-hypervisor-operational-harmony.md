# Three-hypervisor operational harmony

Date: 2026-07-27

## Finding

**PASS:** Lore, Katra, and Matrix now operate the shared hypervisor
control-plane contract with identical reviewed artifacts, durable systemd
activation, a successful five-minute recurrence, and no failed units.

**Explicit exception:** Katra's private Jellyfin CT 131 is intentionally
stopped and removed from autostart because its encrypted storage dependency is
unavailable. This report does not claim that private-media role is functioning.

## Root cause and repair

The old cadence helper emitted an empty `OnUnitActiveSec=` assignment. systemd
treats an empty monotonic assignment as clearing the entire monotonic timer
list, so it also removed the base unit's `OnBootSec` first trigger. After
reboot, Katra and Matrix had no service activation from which their
interval-relative cadence could be calculated.

The reviewed helper now writes `OnActiveSec=5s` after resetting the list, then
adds the selected `OnUnitActiveSec` interval. All three hosts received the same
helper and base timer and were returned to slow mode. Lore and Katra also
received the current daily-mail artifacts and node-ID-rendered Discord wrapper
already used by Matrix.

## Established runtime parity

| Artifact | Common SHA-256 |
| --- | --- |
| heartbeat publisher | `84b56c0ed49e155e3495bfc10d805055ee3eb88093ed3b9f08287c29e042bfb9` |
| heartbeat service | `99229861850652211625816da16b8ab6f8431d130b0fdafd13c8b2c66ea23dd8` |
| durable heartbeat timer | `1460b7a94f8e6e5a8291a4d631711da59acaf7aa62a4693687ef2c0ba17296df` |
| durable mode helper | `2a358f6ece18eedfafa346c1eb60604e2e6d01b0591b9dd830c892a9a3ea24b5` |
| fast-expiry service | `ad4aacbbbed9491d57c46de30a91f96e0e663c6efbb63b47ad6c9415e7eb751b` |
| fast-expiry timer | `ab18ee73de5c9829da50f4ffceb798d0f22cdf2bae3f2a337e6b8e589ad19e29` |
| durable slow-cadence drop-in | `0cc2febb16092a4328b02b29ad203ad199e996905865be13b69a7c8477ba8483` |
| daily-mail helper | `7efb2568ba239f4627276595ea286aa14aa811d03b543e773c286b920a00ff98` |
| daily-mail service | `c16448666b759b5aa9bbf3d3b3d90443ea523c97ac4ba9dc49527c68e346c41a` |
| daily-mail timer | `4cf33fe16b8176513fa400978947e44533c82db0725c058de869a513af0250b0` |
| Discord wrapper after node-ID normalization | `79e15d6f7465209651ebf9bd79175e608b303c6a228fc582bb246f7c5cb7840b` |

Expected modes are common: publisher/helper `0755`, systemd artifacts `0644`,
daily-mail helper `0700`, and Discord wrapper `0750`, all root-owned.

## Durability acceptance

| Host | First activation-relative run | Automatic recurrence | Result after recurrence |
| --- | --- | --- | --- |
| Lore | 18:20:16 EDT | 18:25:17 EDT | success; next elapse present |
| Katra | 18:20:53 EDT | 18:25:54 EDT | success; next elapse present |
| Matrix | 18:21:19 EDT | 18:26:20 EDT | success; next elapse present |

On each host, `pve-cluster`, `pvedaemon`, `pveproxy`, `pvestatd`,
`pve-guests`, Postfix, daily-mail timer, and heartbeat timer were enabled and
active as appropriate. Fast-expiry was disabled/inactive. Daily mail retained a
future calendar elapse. `systemctl --failed` returned no units.

## Katra private-media boundary

CT 131 repeatedly failed because configured host bind source
`/mnt/truenas/secure-rw/jellyfin-media` does not exist. Read-only TrueNAS guest
evidence established dataset `tank/secure/jellyfin-media` is unmounted,
encrypted, has key status `unavailable`, and retains stale mountpoint
`/mnt/mnt/tank/secure/jellyfin-media`.

The packet changed CT 131 from `onboot: 1` to `onboot: 0` and cleared its
failed marker without starting it. All other on-boot Katra guests were running
and `pve-guests.service` was successful. No key, dataset, NFS export, path, or
content was read or changed.

## Evidence and rollback boundary

Each host preserves its replaced artifacts and verified checksum manifest at
`/root/hv-cp-operational-harmony-20260727T181749-0400/`. Katra also preserves
the prior CT configuration. Staging remains under the operator's home on each
host.

No Discord or daily-mail canary was invoked. The expected first and recurring
hostname/uptime heartbeat publications were the only outbound effects. No
secret-bearing file was read or hashed.

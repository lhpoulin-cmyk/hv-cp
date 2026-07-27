# Implementation packet: hv-matrix post-contact DNS enrollment

**Target:** `hv-matrix.arpa` at verified management address
`192.168.10.22`; PVE node DNS configuration only.

**Purpose:** preserve `192.168.10.1` as the installer/bootstrap resolver, then
enroll the contacted host into the current lab resolver pair. Set DNS primary
to `192.168.10.251`, secondary to `192.168.10.252`, and retain search domain
`arpa`. The management address, gateway, bridge, physical interfaces, routes,
and DNS service hosts remain unchanged.

**Authority:** operator request on 2026-07-27 to bring Matrix through the same
post-install control-plane acceptance used for Lore and Katra, followed by the
operator decision to keep router DNS during installation and perform resolver
enrollment only after verified SSH contact.

**Established pre-change state:**

- SSH contact at `192.168.10.22` returns exactly `hv-matrix.arpa`.
- PVE reports search `arpa` and DNS1 `192.168.10.1`.
- `/etc/hosts` contains no `ws-matriarch.arpa` entry.
- The configured resolver path cannot resolve `ws-matriarch.arpa`.
- Direct queries to both `192.168.10.251` and `192.168.10.252` return
  `192.168.10.80` for `ws-matriarch.arpa`.
- Lore and Katra use the current internal resolvers and resolve the same probe.
- Core PVE services, SSH, `rpool`, `local`, and `local-zfs` are healthy; no
  failed units or guests were reported by the preceding preflight.

**Mutation:** use the PVE node DNS API to set only DNS1, DNS2, and the existing
search domain. Capture the before-state first. Do not edit `/etc/hosts` or
change the DNS servers.

**Stop conditions:** stop without further mutation if the hostname, address,
pre-change PVE DNS state, or direct resolver answers differ; if SSH drops; if
the PVE API reports an error; or if either the DNS-only probe or an external
name fails after the change.

**Validation:** confirm the PVE DNS API and `/etc/resolv.conf` show `.251` then
`.252`; confirm `ws-matriarch.arpa` remains absent from `/etc/hosts`; require
`getent ahostsv4 ws-matriarch.arpa` to return `192.168.10.80`; resolve one
external name; reconnect over SSH by the verified management address; and
confirm core PVE services remain active.

**Rollback:** use the PVE node DNS API to restore search `arpa` and DNS1
`192.168.10.1` while removing DNS2. Re-run the SSH and public-name checks.
Rollback intentionally restores the known bootstrap state; it does not claim
that state satisfies internal DNS acceptance.

**Evidence destination:** this packet's result section and the canonical
Matrix networking/validation records. No secret-bearing resolver traffic or
configuration dump belongs in evidence.

**Excluded:** no address, gateway, bridge, interface, route, firewall, DNS
service, package, storage, cluster, Ceph, guest, notification, or TruthTap
installation/pilot change.

## Result

Executed and accepted on 2026-07-27.

- The PVE DNS API was used to retain search `arpa` and set DNS1 to
  `192.168.10.251` and DNS2 to `192.168.10.252`. No address, bridge, route, or
  `/etc/hosts` change was made.
- Post-change `pvesh get /nodes/hv-matrix/dns` returned exactly the intended
  search domain and resolver order; `/etc/resolv.conf` rendered the same state.
- Matrix resolved the DNS-only probe `ws-matriarch.arpa` as `192.168.10.80`
  without a hosts-file entry and resolved an external name.
- SSH remained available at `192.168.10.22`; `hostname -f` remained
  `hv-matrix.arpa`; `pveproxy`, `pvedaemon`, `pvestatd`, `pve-cluster`, and
  `ssh` remained active with no failed systemd units reported.

Rollback was not required. A later read-only verification at
`2026-07-27T15:31:45-04:00` reconfirmed this accepted state.

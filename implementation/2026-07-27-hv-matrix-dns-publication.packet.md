# Implementation packet: hv-matrix DNS publication

**Targets:** active DNS intent in
`/home/louis/infrastructure/standards/IP_ADDRESSING.md`; `dns-lore`
(`192.168.10.252`, CT 252 on `hv-lore`) followed by `dns-katra`
(`192.168.10.251`, CT 251 on `hv-katra`).

**Purpose:** publish the installed Matrix management identity as
`hv-matrix` and `hv-matrix.arpa`, both at `192.168.10.22`, then validate the
same answer through each resolver and from Matrix's configured resolver path.

**Service impact:** update the source-of-truth host set and restart Pi-hole/FTL
once on each resolver, sequentially. Each restart may cause a brief loss of
service on that resolver only; the other resolver remains available. Existing
records must be preserved.

**Authority:** operator request on 2026-07-27 to bring Matrix to the accepted
Lore/Katra control-plane configuration and to complete its post-contact DNS
enrollment.

**Established pre-change state:**

- Matrix is installed and reachable at `192.168.10.22`; `hostname -f` returns
  `hv-matrix.arpa`.
- Matrix now uses DNS1 `.251`, DNS2 `.252`, and search `arpa` after the separate
  post-contact resolver-enrollment packet.
- Both resolvers answer the declared DNS-only probe `ws-matriarch.arpa` as
  `192.168.10.80` and resolve external names.
- Neither resolver currently answers `hv-matrix` or `hv-matrix.arpa`, and
  neither returns a PTR for `192.168.10.22`.
- `IP_ADDRESSING.md` is unmodified in the existing dirty Infrastructure
  checkout before this packet's edit; unrelated work must remain untouched.

**Mutation:**

1. Add the verified Matrix static management assignment to a table marked
   `DNS-publish: yes`, and add Matrix to the required-local-name list.
2. Run the offline source generator and staged DNS-model validation; review an
   exact two-record source delta.
3. Deploy only `hv-matrix` and `hv-matrix.arpa` with the guarded selected-record
   path. The deployer must preserve unrelated live records, create a timestamped
   `pihole.toml` backup in each container, restart Lore first and Katra second,
   and verify each FTL instance before proceeding.

**Stop conditions:** stop without deployment if the source diff contains an
unrelated record, either resolver or container is unhealthy, the intended IP
or names differ, the live selected-record diff is not an addition, the backup
cannot be created, or sequential validation fails. If Lore succeeds but Katra
fails, leave Lore's accepted record in place and stop; do not improvise a
second service mutation.

**Validation:** direct A queries for both names through `.251` and `.252` must
return only `192.168.10.22`; the PTR response must include the Matrix identity;
the existing `ws-matriarch.arpa` probe and an external name must still resolve
through both servers; Matrix's `getent ahostsv4` path must resolve the DNS-only
probe and its management name; both FTL services and Matrix's core PVE services
must remain active.

**Rollback:** remove only `hv-matrix` and `hv-matrix.arpa` through the guarded
selected-record delete path, restore the source row/list entry, and re-run
direct validation. If a resolver's generated set is damaged, restore only its
timestamped pre-change `pihole.toml` backup and restart/validate that FTL
instance before touching the other resolver.

**Evidence destination:** this packet, the canonical Matrix networking and
validation records, and a dated non-secret DNS deployment record if the live
helper emits one.

**Excluded:** no MikroTik DNS or DHCP reservation, address, gateway, firewall,
VLAN, package, storage, cluster, Ceph, guest, notification, or credential
change. The staged private DNS project remains a review mirror, not runtime
authority.

## Result

Executed and accepted on 2026-07-27.

- The Infrastructure DNS publication source was extended with only
  `hv-matrix` and `hv-matrix.arpa` at `192.168.10.22`; the private staged DNS
  model was regenerated from that source. Offline schema, conflict,
  freshness, and source/generated parity checks passed for 126 records.
- A full source-versus-live comparison exposed unrelated live drift, so the
  broad deployment path was not used. The guarded selected-record path
  deployed only the two Matrix names, backing up and restarting Lore first and
  Katra second while the other resolver remained available.
- Direct queries to both `.251` and `.252` return only `192.168.10.22` for the
  bare and `.arpa` Matrix names. Both resolvers return `hv-matrix.arpa.` for
  the `192.168.10.22` PTR.
- Matrix's configured resolver path resolves `hv-matrix.arpa`, the
  `ws-matriarch.arpa` DNS-only probe, and an external name. Its core PVE and
  SSH services remained active with no failed systemd units reported.

Unrelated live DNS drift was neither imported nor overwritten. Rollback was
not required. Read-only forward, reverse, probe, and host-path verification
was repeated successfully at `2026-07-27T15:31:45-04:00`.

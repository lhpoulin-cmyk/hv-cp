# Implementation packet: retire stale hv-alpha DNS aliases

**Targets:** `dns-lore` (`192.168.10.252`, CT 252 on `hv-lore`) followed by
`dns-katra` (`192.168.10.251`, CT 251 on `hv-katra`).

**Purpose:** remove the retired aliases `hv-alpha`, `hv-alpha.arpa`,
`hv-alpha-10g`, and `hv-alpha-10g.arpa` from both live resolver host sets.
Preserve the active `ws-alpha`, `ws-alpha.arpa`, `ws-alpha-10g`, and
`ws-alpha-10g.arpa` records.

**Service impact:** modify each live Pi-hole/FTL host set and restart FTL once
per resolver, sequentially. Each restart may briefly interrupt one resolver;
the other remains available. A timestamped `pihole.toml` backup is required on
each target before its change.

**Authority:** explicit operator request on 2026-07-27 to eliminate
`hv-alpha` references after the Matrix DNS publication preflight exposed the
stale aliases.

**Established pre-change state:** the current Infrastructure publication
source and staged private DNS model contain no `hv-alpha` record. The live
source-versus-resolver comparison shows all four retired aliases on both live
resolvers, while current doctrine identifies `ws-alpha` as the active
workstation identity and explicitly marks `hv-alpha` retired.

**Mutation:** use the guarded selected-record delete path for exactly the two
base names `hv-alpha` and `hv-alpha-10g`; its expansion includes their `.arpa`
forms. Preserve all other live records, suppress external notification, back
up and restart Lore first, then Katra.

**Stop conditions:** stop if either resolver or container is unhealthy, any
requested name differs, the backup fails, an FTL restart fails, or an active
`ws-alpha` record changes. If only Lore completes, retain its correct retired
state and stop before improvising another mutation.

**Validation:** all four retired aliases return no A answer through `.251` and
`.252`; all four current `ws-alpha` names retain their intended answers; the
Matrix names, DNS-only probe, and an external name continue to resolve through
both servers; both FTL services remain active.

**Rollback:** restore only the timestamped pre-change `pihole.toml` on the
affected resolver and restart/validate its FTL service. Reintroducing a retired
alias is not a normal desired-state rollback and requires an evidence-based
operator decision.

**Evidence destination:** this packet and the relevant DNS/Alpha retirement
records. Historical command logs and dated planning evidence that mention the
former identity remain provenance and must not be rewritten.

**Excluded:** no change to `ws-alpha`, workstation networking, SSH known-hosts,
historical evidence, router/DHCP, Matrix, packages, storage, cluster, Ceph,
credentials, or notification delivery.

## Result

Executed and accepted on 2026-07-27.

- The guarded selected-record delete path removed only the `hv-alpha` and
  `hv-alpha-10g` base names and their `.arpa` forms. It backed up and restarted
  Lore first and Katra second; notification was intentionally suppressed.
- The helper's immediate validation observed one short-lived stale
  `hv-alpha` answer from `.251` and stopped. Inspection then established that
  the retired aliases were absent from both FTL host arrays, `/etc/hosts`, and
  custom lists; both resolver services were active. No further mutation was
  performed.
- Repeated direct queries after answer/cache convergence returned no A answer
  for any of the four retired aliases through either resolver. The current
  `ws-alpha` names retained `192.168.10.84` and `ws-matriarch.arpa` retained
  `192.168.10.80`; the Matrix names and external resolution remained intact.
- A read-only repeat at `2026-07-27T15:31:45-04:00` again found no retired
  alias answer on `.251` or `.252` and reconfirmed the preserved workstation
  and Matrix answers.

The immediate stale response is recorded as bounded DNS answer/cache
convergence, not silently discarded. The desired live state was established
without rollback. Historical artifacts that contain the old planning label
remain preserved under Matrix history.

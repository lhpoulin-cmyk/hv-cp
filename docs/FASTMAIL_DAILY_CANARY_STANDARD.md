# Fastmail/Postfix and daily-mail canary standard

**Status:** implemented and receipt-confirmed on `hv-katra` and `hv-lore` on
2026-07-26 and on `hv-matrix` on 2026-07-27. This is the reusable pattern for
a future hypervisor; it is not authority to enroll one.

## Established baseline

Each enrolled hypervisor uses its existing Postfix instance as a local-only
smart relay:

```text
local root/PVE sender -> loopback-only Postfix -> smtp.fastmail.com:465 (TLS)
  -> cluster_node@poulin-arpa.com -> Fastmail routing
```

- `inet_interfaces = loopback-only`; never open inbound SMTP for this role.
- Install `libsasl2-modules`; PLAIN and LOGIN mechanisms are required for the
  verified Fastmail SMTP authentication path.
- Fastmail credentials live only in the ignored encrypted SOPS input and
  root-readable local Postfix maps. They are absent from PVE configuration,
  command lines, evidence, and Git.
- PVE's built-in `mail-to-root` endpoint is preserved. The user-created test
  endpoint is `fastmail-cluster-node-canary`, with display author
  `Helix-Arpa-Cluster`, From address `cluster_node@poulin-arpa.com`, and the
  same mailbox as its test recipient.

## Daily operator-visible canary

The daily canary is separate from PVE event routing. It is a root-only helper,
oneshot service, and persistent systemd timer from
`templates/daily-cluster-canary/`.

| Field | Value |
| --- | --- |
| Schedule | 09:15 host-local time, `RandomizedDelaySec=10m`, persistent |
| Required timezone at enrolled hosts | `America/Detroit` |
| Display sender | `Helix-Arpa-Cluster` |
| From address | `cluster_node@poulin-arpa.com` |
| Recipient | `cluster_admin@poulin-arpa.com` |
| Subject | `[Helix-ARPA daily canary] <host-fqdn>` |

The helper contains only FQDN, timestamp, and a transport label. It contains
no health summary, PVE inventory, IP address, or secret.

## Acceptance and evidence

For each node, an implementation packet must establish all of the following:

1. Preflight confirms America/Detroit, active loopback-only Postfix, TLS relay,
   root-only maps, and no unexpected user-created PVE endpoint.
2. `libsasl2-modules` is present; PLAIN and LOGIN mechanism libraries exist.
3. `systemd-analyze verify` accepts the helper service and timer.
4. One immediate service run succeeds; the Postfix queue drains and its log
   records Fastmail SMTP acceptance.
5. An operator confirms receipt at `cluster_admin@poulin-arpa.com`.

Katra and Lore passed all five conditions on 2026-07-26; Matrix passed them on
2026-07-27. Their canonical node records contain the non-secret observed
results. Every future node requires its own packet, preflight, one-message test,
receipt confirmation, and result record.

## Rollback

The daily-canary rollback removes only the named helper, service, timer, and
timer enablement. It does not delete Postfix relay state or its credential maps
unless a separate packet covers credential revocation or relay rollback.

# hv-lore Hadrian authority SSH firewall preflight — 2026-07-27

Status: secret-screened read-only summary; no firewall change

## Scope and provenance

This summary covers only future node INPUT access from Hadrian authority
`192.168.80.85/32` to `hv-lore` (`192.168.10.20`) TCP/22. It summarizes
operator-provided outputs and read-only source inspection from Matriarch on
2026-07-27 EDT. Raw firewall exports and backups are excluded from Git.

## Observed state

- Lore is `hv-lore`, Proxmox VE 9.1.1; `proxmox-firewall` was active and the
  legacy `pve-firewall` CLI was absent.
- Node firewall configuration is enabled. SSH allows occupy positions 0-3 for
  `.10.80`, `.80.80`, `.10.21`, and `.10.84`; Web UI rules begin at position 4.
- Subnet drops include `.10.0/24` at position 11, `.80.0/24` at position 12,
  and `.100.0/24` at position 13. The intended final allow position is 4.
- The observed node rules digest was
  `a249aca654b3362f329c3f7cb7d1992444a8efac`; it is historical evidence only
  and must never be used as an execution-window digest.
- Cluster firewall is enabled with input DROP/output ACCEPT, no cluster rules,
  and management IPSet members `.10.80` and `.80.80`. It is out of scope.
- Physical console is the operator-confirmed independent recovery path, subject
  to immediate reconfirmation before mutation. No firewall mutation occurred.

## Local VE 9 API-source finding

Read-only inspection covered `/usr/share/perl5/PVE/API2/Firewall/Rules.pm` and
`/usr/share/perl5/PVE/Firewall.pm`. The create schema accepts `pos` and
`digest`, but create copies the rule then prepends it and performs no digest
comparison. Update/move and delete compute the current ordered-rules digest and
call `assert_if_modified` while holding the host firewall lock. GET attaches
that digest to returned rule objects.

Consequently, the prepared future method is disabled create at position 0,
fresh digest-guarded move to position 4, fresh digest-guarded enable, with a
newly fetched and verified digest before every mutation. Rollback is fresh
digest-guarded disable/delete followed by exact ordered-state comparison.

## Limits and remaining gates

- Direct Hadrian SSH credential and host-trust readiness is not accepted.
- Execution-time fresh state, exact private backup/export path, and tested
  restore procedure are not complete.
- Physical-console availability must be reconfirmed immediately before change.
- Method revision currency and explicit operator execution approval are absent.
- No foreign device was established on Access-edge ether6; the prior local FDB
  entry must not be represented as foreign-device evidence.

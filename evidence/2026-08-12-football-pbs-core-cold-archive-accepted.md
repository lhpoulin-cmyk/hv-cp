# Football pbs-core cold archive — accepted

Football on `hv-matrix` holds the first accepted datastore-disaster recovery
point for the shared `pbs-core` datastore. Its Seagate Expansion device is
identified by serial `00000000NT1H79L3`, exFAT UUID `011D-FABB`, and stable
by-id path `usb-Seagate_Expansion_HDD_00000000NT1H79L3-0:0`.

The cold archive is
`helix-arpa-football/pbs-core-dr/archives/pbs-core-2026-08-11.zfs`: a full,
independently receivable ZFS send stream of
`slowPool/backup/pbs/pbs-core@football-2026-08-11`. It is
`536,241,455,560` bytes with SHA-256
`b0e072c8b1669d1667ec60f7c8bc6f63431354e7144ea5730a6c96109305625d`.

TrueNAS `/usr/sbin/zstream dump`, consumed through the pinned dedicated
Matrix pull path, parsed a complete stream: `4,709,073` records,
`4,191,973` `DRR_WRITE` records, a `DRR_END` record, no parser errors, and a
reported stream length exactly equal to the archive size. The archive is the
current DAILY and MONTHLY semantic point; metadata records those two roles
without duplicating bytes.

Football is mounted only for archive operations and cleanly unmounted
afterward. Existing top-level legacy content, including `truenas-katra` and
`nvme dump`, is preserved. Capacity review begins at 70% filesystem use and
archive replacement stops at 80%.

After metadata and pbs-cp acceptance were durable, the trusted VM120 TrueNAS
control path removed exactly `slowPool/backup/pbs/pbs-core@football-2026-08-11`.
No other Football snapshot was reported. Final Football filesystem use was
39%: 2,316,164,661,248 bytes used and 3,684,681,646,080 bytes free.

The initial 10.4 GB observation was made while the original producer still
held the archive open for write. It was not a failed transfer. Future archive
operations must persist transfer, hash, and parser status before promotion.

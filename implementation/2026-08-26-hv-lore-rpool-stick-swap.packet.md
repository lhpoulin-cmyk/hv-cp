# hv-lore rpool stick swap implementation packet

Date: 2026-08-26

Status: superseded by the completed 2026-08-29 P3 migration; the local seed
and pre-destruction gate below remain historical evidence

Runbook: [`../runbooks/2026-08-26-hv-lore-rpool-stick-swap.md`](../runbooks/2026-08-26-hv-lore-rpool-stick-swap.md)

## Authority

Implement `PLAY=HV-LORE-RPOOL-STICK-SWAP` as supplied by the operator. Before
any migration shutdown or P3 write, create standalone VM120 and VM260 archives
on the proven Football Seagate, validate their configuration and block-device
coverage, create a checksum manifest, and preserve the bounded host/bootstrap
configuration as ciphertext using the lab's established three-recipient `age`
policy.

Destruction is authorized only on P3 serials `9760522200232` and
`9760511210658`, and only after every pre-destruction gate passes. Old rpool
serials `TP250913B5D3323` and `TP250913B5D1797`, VM140 raw NVMe
`TP250916B5D0198`, jellyPool, and Toshiba serials `16N2A02XFWUH`,
`16N2A042FWUH`, and `16X2A00KFWUH` are mandatory-preserve.

## Control boundaries

- Use PVE `vzdump` snapshot semantics. Keep VM120 raw Toshiba mappings at
  `backup=no`; never stream those disks.
- Write only a new dated migration-seed directory on Seagate serial
  `00000000NT1H79L3`; do not overwrite historical artifacts.
- Stream secret-bearing host configuration directly into `age` encryption to
  all three established recipients. Never create plaintext secret media.
- Verify VMA compression, embedded configuration, device map, archive hashes,
  ciphertext decryption/listing, P3 identity, and old-rpool health before
  setting `DESTRUCTIVE_PHASE_AUTHORIZED=YES`.
- Physical isolation, installer selection, and independent single-stick boot
  tests require the attended operator/console path described in the runbook.
- Stop on every hard stop in the operator packet. Never repair or initialize a
  preserved disk or datastore as incidental recovery.

## Evidence

Record execution in
[`../evidence/2026-08-26-hv-lore-rpool-stick-swap.md`](../evidence/2026-08-26-hv-lore-rpool-stick-swap.md).

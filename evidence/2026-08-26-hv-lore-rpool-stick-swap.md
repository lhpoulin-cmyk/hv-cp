# hv-lore rpool stick swap — seed acceptance and physical handoff

Date: 2026-08-26 EDT

Packet: [`../implementation/2026-08-26-hv-lore-rpool-stick-swap.packet.md`](../implementation/2026-08-26-hv-lore-rpool-stick-swap.packet.md)

## Outcome at handoff

Phases 0–7 passed. The complete standalone bootstrap seed exists on proven
Seagate serial `00000000NT1H79L3`; the drive is synced and unmounted. Lore is
still running on its untouched ONLINE NVMe rpool. No P3, old-rpool, Toshiba,
jellyPool, VM140 raw-NVMe, boot, or guest configuration mutation occurred.

The play pauses before guest shutdown because physical NVMe isolation and the
attended PVE installer/UEFI console are unavailable to this execution session.
Do not shut down production until the operator is physically present with the
approved installer and ready to isolate the preserve disks.

## Accepted Seagate seed

Directory:
`helix-arpa-football/hv-lore-rpool-migration-2026-08-26/`

| Artifact | Bytes | SHA-256 | Validation |
|---|---:|---|---|
| `archives/vm120-truenas-lore-2026-08-26.vma.zst` | 7,129,837,325 | `8026592262280ae31224b203a19c01ceb9ec97f24d84f1151eb18dde2ed7d306` | `vzdump` exit 0; `zstd -t`; `vma config`; `vma list` |
| `archives/vm260-pbs-core-2026-08-26.vma.zst` | 1,184,508,814 | `40f25f2c74cb435a7ae322480b45104da2e4d8bae3ff34a04edffe830a7bcd64` | `vzdump` exit 0; `zstd -t`; `vma config`; `vma list` |
| `config/hv-lore-bootstrap-config-2026-08-26.tar.zst.age` | 21,806 | `e7ce5b582c98e43e826f7cfb751492255e5a06207b019b60e5fb91eeb67792d4` | decrypted with established age identity; filename-only tar validation |
| existing `../pbs-core-dr/archives/pbs-core-2026-08-11.zfs` | 536,241,455,560 | `b0e072c8b1669d1667ec60f7c8bc6f63431354e7144ea5730a6c96109305625d` | current size and accepted metadata match prior full structural validation |

`SHA256SUMS` contains all four entries. The three new artifacts were hashed and
verified directly. The historical stream was not reread end-to-end; its exact
current size and non-secret accepted metadata hash matched.

No `.part`, standalone `.pw`/`.enc`, or plaintext secret archive remained in
the seed. Final Seagate state was unmounted.

## VM120 proof

VM120 snapshot backup ran from 2026-08-26 17:55:31 to 17:58:45 EDT and ended
successfully. Embedded configuration matches `truenas-lore`. VMA devices are
only 540,672-byte `efidisk0` and 68,719,476,736-byte `scsi0`.

The log explicitly excluded all three raw disks as `backup=no`:

- `16N2A042FWUH`
- `16X2A00KFWUH`
- `16N2A02XFWUH`

## VM260 proof

VM260 snapshot backup ran from 2026-08-26 17:59:57 to 18:00:36 EDT and ended
successfully. Embedded configuration matches `pbs-core`. VMA devices are only
540,672-byte `efidisk0` and 68,719,476,736-byte `scsi0`.

Both standalone archives are local-file `qmrestore` inputs and do not require
PBS to restore.

## Encrypted bootstrap configuration

The bundle was streamed from Lore directly through zstd and `age` to all three
established lab recovery recipients. No plaintext archive was written. An
authorized age identity successfully decrypted and listed the bundle.

It contains the named network, hostname/resolver, storage/jobs/user/firewall,
kernel/VFIO/module/udev, boot, PCI, block/by-id, pool, VM/CT inventory, all ten
QEMU configs, all seven CT configs, and exactly these private reconnect files:

- `/etc/pve/priv/storage/pbs-core-lore.pw`
- `/etc/pve/priv/storage/pbs-core-lore.enc`

Secret values were not printed or written to evidence.

## Final pre-destruction state

- Host: `hv-lore`; PVE 9.2.6; kernel `7.0.14-8-pve`.
- Old rpool: 472G, 129G allocated, ONLINE two-member mirror, zero device
  errors, no known data errors.
- Current guests: 10 VMs and 7 CTs; production remains running. VM120 and
  VM260 are unlocked.
- `pbs-core-lore` and `pbs-katra-vm260` remain active.
- Boot: UEFI; both old ESP UUIDs configured by proxmox-boot-tool.
- P3 targets: serials `9760522200232` and `9760511210658`, unchanged.
- Old rpool: `TP250913B5D3323`, `TP250913B5D1797`, unchanged.
- VM140 raw NVMe: `TP250916B5D0198`, unchanged.
- jellyPool NVMe: `TP250913B5D1792`, unchanged.
- Toshiba serials: `16N2A02XFWUH`, `16N2A042FWUH`, `16X2A00KFWUH`, unchanged.
- Failed systemd units: none.

```text
SEAGATE_SEED=PASS
VM120_STANDALONE_RECOVERY=PASS
VM260_STANDALONE_RECOVERY=PASS
MIGRATION_ARTIFACT_CHECKSUMS=PASS
PBS_RECONNECT_SECRET_PRESERVED=YES
SECRET_ARTIFACT_ENCRYPTED=YES
SECRET_PLAINTEXT_ON_SEAGATE=NO
VM120_RESTORE_REQUIRES_PBS=NO
VM260_RESTORE_REQUIRES_PBS=NO
BOOTSTRAP_CHAIN=PASS
HOST_IDENTITY=PASS
RPOOL_HEALTH=ONLINE
P3_IDENTITY=PASS
DESTRUCTIVE_PHASE_AUTHORIZED=YES
```

## Attended handoff

The operator must be physically present with the approved PVE installer and a
working local console. Once present, resume at Phase 8: gracefully stop guests,
sync, reprove rpool, and power off. Then physically isolate both old-rpool
NVMes and preferably VM140, jellyPool, and Toshiba disks before selecting only
the two proven P3 serials in the installer.

```text
BLOCKER=attended physical isolation and installer/UEFI console are unavailable to this execution session
operation=stop production, power off Lore, remove old-rpool NVMes, isolate preserve disks, and install PVE on the P3 pair
observed=all pre-destruction gates pass, but the host is still running and no physical/graphical-console capability is exposed
expected=operator physically present with approved installer and ready to identify/disconnect exact serials before shutdown
authority=operator stick-swap packet, hv-cp console doctrine, and fail-closed physical disk-selection boundary
why_not_ordinary_debugging=software cannot safely substitute for physical isolation, attended installer selection, or independent single-stick boot manipulation
```

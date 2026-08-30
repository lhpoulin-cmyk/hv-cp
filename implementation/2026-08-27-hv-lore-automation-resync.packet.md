# Implementation packet: hv-lore automation re-enrollment

Status: superseded by the accepted 2026-08-29 migration and restored observer
baseline; the staged re-enrollment result below remains historical evidence

Date: 2026-08-27
Host: `hv-lore` (`192.168.10.20`)
Play: `HV-LORE-AUTOMATION-RESYNC`
Authority: explicit operator request dated 2026-08-27
Runbook: [hv-lore automation re-enrollment](../runbooks/2026-08-27-hv-lore-automation-resync.md)

## Objective

Re-enroll the freshly reinstalled `hv-lore` in the existing `ansible-cp` and
Semaphore CT149 realization with the minimum one-time root console bootstrap.
Reuse the governed automation identities and credentials; do not create or
rotate keys, recreate `louis`, restore stale account databases, weaken SSH host
verification, run convergence, import the old rpool, or restore guests.

## Governing state

- `auth-cp` commit `33b69fda8a879706dbb07427926b65cadd030f30` records both
  automation identities, key-only authentication, separate Foundation custody,
  observer without blanket sudo, and executor build-stage blanket sudo.
- `foundation-cp` commit `6840279` records that the two distinct ED25519
  credentials were generated in Foundation custody and only public material was
  deployed.
- `ansible-cp` commit `49a82777a875fcaf95e79678820bb7a15c3ca568`
  projects `hv-lore` as `192.168.10.20`, default remote user
  `ansible-observer`, with host-key checking enabled.
- Surviving `hv-katra` and `hv-matrix` realizations prove that numeric UID/GID
  allocation is host-selected. Both accounts have a same-named primary group,
  no supplementary groups, `/home/<identity>`, `/bin/bash`, locked password,
  home and `.ssh` mode `0700`, and `authorized_keys` mode `0600`.
- Both peers contain the exact unrestricted governed public keys and the exact
  root-owned mode-`0440` executor sudoers line recorded in the runbook.
- No current authority proves a replacement realization for human account
  `louis`; it is excluded.

## Host-key gate

From the actual CT149 execution environment, `ssh-keyscan` returned:

| Algorithm | Fresh fingerprint | Console witness |
| --- | --- | --- |
| ED25519 | `SHA256:V2j+4W03TpGYgftKVV55A8u7eL4y9X1Wauf0bMqJYsU` | match |
| ECDSA | `SHA256:rLaAaHU/n8T0rRPucgdxYUFGdfLQt3+rnxWB7dWdkqQ` | match |
| RSA | `SHA256:5FRYWZocHe3qESCjFFNDlKtwmMsfBv/XeMFE6ikk3+o` | match |

CT149 currently trusts the prior Lore ED25519, ECDSA, and RSA keys as hashed
entries in `/var/lib/semaphore/.ssh/known_hosts`, owned by `semaphore`, mode
`0600`. The replacement must preserve strict checking, hashed-host form,
ownership, and mode. It may occur only after the operator reports successful
console bootstrap.

## Authorized mutations

1. At the physical Lore console, install only Debian's `sudo` package when it
   is absent, then create or reconcile only `ansible-observer`,
   `ansible-executor`, their governed public keys, locked password state, and
   `/etc/sudoers.d/90-helix-ansible-executor` according to the linked script.
2. After successful local proof, replace only CT149's old `192.168.10.20`
   host-key entries with the already console-matched fresh scan, retaining a
   bounded backup.

No other host, SSH, network, PVE, storage, VFIO, monitoring, backup, guest,
Semaphore project, credential, template, or desired-state mutation is
authorized by this packet.

## ansible-cp execution boundary

`ansible-cp` owns the Ansible execution contract. This packet does not
authorize manual `ansible`/`ansible-playbook` invocation, invented inventory,
an ad-hoc Semaphore template, or generic convergence. After the console
identity realization and CT149 host-key transition, continue only through the
existing committed `ansible-cp` project/repository/inventory/credential/
template chain. Inspect the live non-secret Semaphore realization against
`ansible-cp/semaphore/declared-state.json` before launch.

The admitted first execution is the existing `HELIX — Observe Hypervisors`
template. Any absent or mismatched object is
`BLOCKER=ANSIBLE_CP_SEMAPHORE_REALIZATION_DRIFT`; it must not be bypassed with
manual Ansible. No current authority in this packet admits a broad Lore
convergence template.

## Acceptance and stop conditions

Acceptance requires the console script proofs, the verified CT149 trust
transition, a live non-secret match of the existing Semaphore realization to
the committed `ansible-cp` chain, a passing `HELIX — Observe Hypervisors` task,
and a categorized drift plan. A host-key mismatch stops before trust mutation.
Any canonical identity mismatch stops rather than altering the governed
credential.

`CONVERGENCE_RUN=NO` is mandatory. The new mirrored P3-256 `rpool` is
intentional. The old NVMe rpool remains absent/offline rollback material and
must not be imported or proposed as a correction. Guest restoration is a
separate play.

## Repository state

Packet creation began from hv-cp
`7d7a9d97ecc1583e575c7a3a6885d89281d1308e`; freshly fetched `origin/main`
`e615f0c8581b0ef18aa5ad9c8a9088a6c004928d` is its ancestor. Existing dirty
work is unrelated and remains preserved. No commit or push is authorized.

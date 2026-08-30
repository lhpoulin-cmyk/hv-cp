# Implementation packet: hv-lore post-reinstall realization

Status: superseded by the operationally accepted 2026-08-29 migration; the
host-baseline and bootstrap stages below remain historical chronology

Date: 2026-08-27
Host: `hv-lore` (`192.168.10.20`)
Play: `HV-LORE-POST-REINSTALL-REALIZATION`
Authority: explicit operator play dated 2026-08-27
Runbook: [post-reinstall realization](../runbooks/2026-08-27-hv-lore-post-reinstall-realization.md)

## Objective

Return the freshly reinstalled `hv-lore` from admitted OBSERVE-only access to
the smallest evidence-backed host baseline defined by `ansible-cp` and
realized through the existing Semaphore control plane. After baseline
acceptance, resume only the already-authorized storage and guest recovery
sequence.

## Fixed safety boundary

- The production `rpool` is the healthy P3-256 mirror containing
  `ata-P3-256_9760522200232-part3` and
  `ata-P3-256_9760511210658-part3`.
- Old root-pool NVMes `TP250913B5D3323` and `TP250913B5D1797` may remain
  physically visible as `PRESENT_OFFLINE_ROLLBACK`; their unused state is
  intentional.
- Missing guests are migration state, not host-baseline drift.
- No play in this campaign may import, mount, use as writable PVE storage,
  wipe, rename, or otherwise mutate the old root pool.
- Guest restoration, PBS datastore attachment, TrueNAS pool return,
  `jellyPool` import, VM140 reconstruction, and boot-degraded tests are not
  part of the host-baseline APPLY.

## Execution authority

`ansible-cp` owns playbooks, inventories, privilege behavior, variables,
limits, and the Semaphore realization contract. Semaphore project
`Helix-ARPA` is the only admitted execution plane. Direct invocation of
`ansible` or `ansible-playbook`, ad-hoc inventories, and temporary templates
are prohibited.

The OBSERVE binding is:

```text
Helix-ARPA project 2
-> ansible-cp repository 1
-> Canonical Observe Inventory 1
-> governed ansible-observer credential 4
-> HELIX - Observe Lore Post-Reinstall template 16
-> playbooks/observe-hv-lore-post-reinstall.yml
-> hv-lore / 192.168.10.20
```

## Gates

1. Preserve the complete machine-readable survey payload as evidence.
2. Compare observed APT, DNS, network, package, automation, boot, storage,
   and VFIO state to the current owning authorities. The admitted
   pre-reinstall Lore configuration is authoritative recovery state unless an
   owning authority explicitly supersedes it.
3. Author and repository-test a bounded, idempotent APPLY in `ansible-cp`.
4. Reconcile its exact existing Semaphore project/repository/inventory/
   executor-credential/template chain.
5. Use check semantics first when the admitted contract supports them, review
   the bounded plan, then launch APPLY through Semaphore.
6. Rerun the admitted observer; acceptance requires `changed=0`,
   `unreachable=0`, and `failed=0`.

The operator reported the OBSERVE task recap at 18:28:14:

```text
hv-lore ok=10 changed=0 unreachable=0 failed=0 skipped=0 rescued=0 ignored=0
```

This passed execution health. The complete machine-readable evidence was then
reviewed, the semantic rollback-media correction was admitted, and the revised
observer passed at 19:12:57:

```text
hv-lore ok=17 changed=0 unreachable=0 failed=0 skipped=0 rescued=0 ignored=0
```

The captured payload subsequently proved both old root-pool members are
physically visible. The operator superseded the earlier physical-isolation
interpretation: visible but unused rollback media is accepted as
`PRESENT_OFFLINE_ROLLBACK`. The safety boundary is semantic. The historical
pool must remain unimported, unmounted, absent from active `rpool`, absent from
writable PVE storage, and unmutated; active `rpool` must remain the healthy
two-member P3 mirror.

```text
ROLLBACK_MEDIA_1=TP250913B5D3323
ROLLBACK_MEDIA_2=TP250913B5D1797
REQUIRED_DISPOSITION=PRESENT_OFFLINE_ROLLBACK
PHYSICAL_PRESENCE_ALLOWED=YES
IMPORT_AUTHORIZED=NO
MOUNT_AUTHORIZED=NO
MUTATION_AUTHORIZED=NO
BASELINE_APPLY_AUTHORIZED=AFTER_CHECK_PASS_AND_EXACT_ACKNOWLEDGEMENT
```

Physical presence alone is not a blocker.

## Admitted bounded host baseline

`ansible-cp` commit `1fc8292` is the authoritative execution contract. It
declares two manual Semaphore templates on the existing Helix-ARPA project,
repository, apply inventory, and governed `ansible-executor` credential:

```text
HELIX - Check Lore Host Baseline
  playbooks/check-hv-lore-host-baseline.yml
  privileged read-only prechecks; no prompts; no mutation

HELIX - Apply Lore Host Baseline
  playbooks/apply-hv-lore-host-baseline.yml
  acknowledgement: APPLY HV_LORE_HOST_BASELINE hv-lore
```

The APPLY preserves `vmbr0` at `192.168.10.20/24`, restores `vmbr1` at
`192.168.100.20/24`, and realizes MTU 9000 on both `vmbr1` and the stable
physical port PCI `0000:89:00.1` / MAC `14:02:ec:71:fc:b1`, currently named
`nic3`. It creates no storage-plane gateway. Its only intended mutation is
`/etc/network/interfaces`, followed by `ifreload -a`; it preserves a rollback
copy and restores it if realization fails.

Before mutation, the APPLY repeats privileged boot, PVE, rpool, rollback-media,
storage, guest, cluster, network-identity, DNS, APT, automation, and systemd
checks. Packages, APT, DNS, automation, boot, pools, PVE storage, guests,
`jellyPool`, and VFIO are validation-only or outside this APPLY.

## Accepted realization

Semaphore task 69 ran template 19 from `ansible-cp` commit
`cb8cf1e9e1ab0dceedb56217853dabc2ac52d3f6` and passed:

```text
HV_LORE_HOST_BASELINE=PASS
NETWORK_CHANGED=True
MANAGEMENT=192.168.10.20/24@vmbr0
STORAGE=192.168.100.20/24@vmbr1
STORAGE_PHYSICAL=0000:89:00.1/14:02:ec:71:fc:b1
STORAGE_MTU=9000
STORAGE_DEFAULT_GATEWAY=NONE
APT_MUTATION=NONE
PACKAGE_MUTATION=NONE
AUTOMATION_MUTATION=NONE
OLD_RPOOL_MUTATION=NONE
GUEST_MUTATION=NONE
hv-lore ok=58 changed=2 unreachable=0 failed=0
```

The two changes were the admitted interface-file realization and network
reload. The task also passed management reachability, 8972-byte DF fabric
ping to `192.168.100.1`, exact address/MTU/route assertions, and the final
healthy-rpool assertion. The bounded host-baseline phase is closed; no further
architecture review is required before the admitted guest-restoration phase.

The closing post-baseline observer subsequently passed and is not to be run
again. `ansible-cp` commits `115b6f6`, corrective `4e860ba`, and source-mount
lifecycle commit `91be7be` admit the first
restoration boundary as
Semaphore templates `HELIX - Check Lore VM120 Bootstrap` and
`HELIX - Apply Lore VM120 Bootstrap`. VM120 is the only guest in this stage;
VM260 remains absent until TrueNAS and existing `slowPool` pass validation.
Football remains read-only on `hv-matrix`; only the authorized VMA crosses the
existing 10GbE fabric to bounded temporary staging on Lore. When Football is
not already mounted, the governed CHECK/APPLY establishes the exact stable-ID
partition at the canonical Matrix path with `ro,nosuid,nodev,noexec` and
releases only the mount it created.

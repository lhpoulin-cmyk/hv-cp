# hv-lore bounded host-baseline contract admission

Date: 2026-08-27
Packet: [post-reinstall realization](../implementation/2026-08-27-hv-lore-post-reinstall-realization.packet.md)
Runbook: [post-reinstall realization](../runbooks/2026-08-27-hv-lore-post-reinstall-realization.md)

The revised post-reinstall observer passed through Semaphore:

```text
hv-lore ok=17 changed=0 unreachable=0 failed=0 skipped=0 rescued=0 ignored=0
```

The authoritative pre-reinstall Lore configuration was classified as recovery
state rather than an architecture proposal. Current network and authentication
authorities were reviewed. The admitted first APPLY is limited to restoring
the known-good host network while preserving the already-correct P3 rpool,
management network, DNS, APT, and automation identities.

Published execution authority:

```text
ANSIBLE_CP_COMMIT=1fc8292496a5c983607bbaac6801ec45182518c4
ANSIBLE_CP_ORIGIN_MAIN=1fc8292496a5c983607bbaac6801ec45182518c4
CHECK_PLAYBOOK=playbooks/check-hv-lore-host-baseline.yml
APPLY_PLAYBOOK=playbooks/apply-hv-lore-host-baseline.yml
CHECK_INVENTORY=Canonical Apply Inventory — ansible-executor
APPLY_INVENTORY=Canonical Apply Inventory — ansible-executor
APPLY_ACKNOWLEDGEMENT=APPLY HV_LORE_HOST_BASELINE hv-lore
```

Intended APPLY mutation:

```text
/etc/network/interfaces
ifreload -a
```

Desired network restoration:

```text
vmbr0=192.168.10.20/24; gateway 192.168.10.1; preserve
vmbr1=192.168.100.20/24; no gateway; restore
storage physical identity=PCI 0000:89:00.1; MAC 14:02:ec:71:fc:b1
current physical interface name=nic3
storage MTU=9000 on nic3 and vmbr1
```

The contract performs privileged read-only boot, PVE, rpool,
rollback-media, storage, guest, cluster, physical-network, DNS, APT,
automation, and systemd prechecks before mutation. It rejects imported or
mounted rollback media, a non-P3 active rpool, unrecognized starting network
state, or drift in the preserved surfaces.

Repository validation:

```text
PYTEST_RESULT=PASS (23 tests)
SYNTAX_RESULT=PASS
INVENTORY_VALIDATION=PASS
ANSIBLE_LINT_RESULT=PASS (production profile)
YAMLLINT_RESULT=PASS
STATIC_VALIDATION=PASS
LIVE_HOST_CONTACT=NO
```

No live host or Semaphore object was mutated while authoring this contract.
The next admitted action is creation/reconciliation and execution of the
read-only CHECK template through Semaphore.

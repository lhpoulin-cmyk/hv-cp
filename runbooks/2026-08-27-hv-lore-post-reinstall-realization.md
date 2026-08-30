# Runbook: hv-lore post-reinstall realization

Status: superseded by the operationally accepted 2026-08-29 migration

Date: 2026-08-27
Packet: [post-reinstall realization packet](../implementation/2026-08-27-hv-lore-post-reinstall-realization.packet.md)

## 1. Observe

In Semaphore project `Helix-ARPA`, launch the declared template
`HELIX - Observe Lore Post-Reinstall` without prompts or overrides. Preserve
the complete `Emit machine-readable post-reinstall evidence` payload and task
recap. A passing recap is necessary but does not replace the fact payload.

## 2. Review authority

Classify each observed surface against its current owner before changing it:

- APT and host packages: current Proxmox/Debian host authority;
- management and storage networking: `network-cp` plus the current private
  Lore node record;
- automation accounts and SSH: `auth-cp` and `ansible-cp`;
- PVE/storage state and migration exclusions: this packet and `hv-cp`;
- PBS and guest state: the existing recovery runbook, not baseline APPLY;
- VFIO/GPU state: later VM140 restoration prerequisites.

Record `HOST_REQUIREMENT`, `GUEST_REQUIREMENT`, `NOT_REQUIRED`, or `UNKNOWN`
for every package candidate. Do not classify `qemu-guest-agent` as a host
requirement solely because guests use QGA.

## 3. Realize the bounded baseline

After the authority review is internally consistent, implement and validate
the smallest idempotent contract in `ansible-cp`. Reconcile its exact
Semaphore binding to the existing project, repository, apply inventory, and
governed executor credential. Do not bypass Semaphore.

The admitted contract is `ansible-cp` commit `1fc8292`. In the existing
Helix-ARPA project, realize these objects exactly:

```text
Name: HELIX - Check Lore Host Baseline
Playbook: playbooks/check-hv-lore-host-baseline.yml
Inventory: Canonical Apply Inventory — ansible-executor
Repository: ansible-cp
Branch: inherited/main
Prompts: none
Schedule: none

Name: HELIX - Apply Lore Host Baseline
Playbook: playbooks/apply-hv-lore-host-baseline.yml
Inventory: Canonical Apply Inventory — ansible-executor
Repository: ansible-cp
Branch: inherited/main
Required prompt: helix_apply_acknowledgement
Default: APPLY HV_LORE_HOST_BASELINE hv-lore
Schedule: none
```

Launch CHECK first. It must report `HV_LORE_HOST_BASELINE_CHECK=PASS` and
`NETWORK_CHANGE_REQUIRED=true`, with `changed=0`, `unreachable=0`, and
`failed=0`. Do not launch APPLY on a failed or ambiguous CHECK.

After reviewing the bounded plan, launch APPLY with the exact acknowledgement
`APPLY HV_LORE_HOST_BASELINE hv-lore`. Immediately rerun the OBSERVE template.
Do not use direct Ansible execution or add Semaphore overrides.

## 4. Acceptance

Baseline acceptance requires:

```text
BASELINE_APPLY=PASS
POST_APPLY_OBSERVER_CHANGED=0
POST_APPLY_OBSERVER_UNREACHABLE=0
POST_APPLY_OBSERVER_FAILED=0
OLD_RPOOL_RECONNECTED=NO
```

Only after acceptance may the campaign proceed to the non-root NVMe presence
gate and the existing storage/guest recovery sequence.

# hv-lore automation re-enrollment evidence

Date: 2026-08-27
Play: `HV-LORE-AUTOMATION-RESYNC`
Governing packet: [automation re-enrollment packet](../implementation/2026-08-27-hv-lore-automation-resync.packet.md)
Runbook: [automation re-enrollment runbook](../runbooks/2026-08-27-hv-lore-automation-resync.md)

## Stage 1 — physical-console bootstrap

The operator ran the governed `helix.sh` bootstrap as `root` on the freshly
installed `hv-lore`. The complete reported terminal proof showed:

- `/etc/sudoers.d/90-helix-ansible-executor: parsed OK` before and after
  realization;
- `ansible-observer` realized as UID/GID 1000 with its same-named primary
  group, `/home/ansible-observer`, and `/bin/bash`;
- `ansible-executor` realized as UID/GID 1001 with its same-named primary
  group, `/home/ansible-executor`, and `/bin/bash`;
- observer key fingerprint
  `SHA256:tRDS7wZfXIFWlIYJ4fuuk8RCiWExRLfGe1FbE6qwU/I`;
- executor key fingerprint
  `SHA256:EThzAvsy/Q2pqVsfg+qZgVtO1thPudw9boPDO/toxRs`; and
- no reported command failure.

Result: `LORE_CONSOLE_BOOTSTRAP=PASS`.

## Stage 2 — CT149 host-key replacement

The operator entered CT149 from the `hv-matrix` console and ran the bounded
host-key replacement. The scan returned exactly the three console-witnessed
fresh keys:

- ED25519 `SHA256:V2j+4W03TpGYgftKVV55A8u7eL4y9X1Wauf0bMqJYsU`;
- RSA `SHA256:5FRYWZocHe3qESCjFFNDlKtwmMsfBv/XeMFE6ikk3+o`; and
- ECDSA `SHA256:rLaAaHU/n8T0rRPucgdxYUFGdfLQt3+rnxWB7dWdkqQ`.

The previous trust file was retained as
`/var/lib/semaphore/.ssh/known_hosts.pre-hv-lore-reinstall-20260827`. The live
file contains hashed entries and both files are `semaphore:semaphore` mode
`0600`. The temporary unhashed `.old` working file was covered by the script's
temporary-directory cleanup trap.

Result: `CT149_HOST_KEY_REPLACEMENT=PASS`.

No convergence run is authorized.

## ansible-cp authority correction

The operator clarified that `ansible-cp` exclusively owns playbooks, roles,
inventory semantics, execution contracts, realization mechanics, and how
Semaphore consumes that content. Manual Ansible, invented runtime paths, and
temporary Semaphore objects are prohibited.

The current `ansible-cp` authority was fetched and inspected at matching local
and `origin/main` commit
`49a82777a875fcaf95e79678820bb7a15c3ca568`. Repository-native validation
passed: 21 tests, playbook syntax, generated inventory validation,
`ansible-lint`, and `yamllint`; validation made no live host contact.

The committed admitted first path for Lore is:

```text
Helix-ARPA project 2
-> ansible-cp repository 1, branch main
-> Canonical Observe Inventory 1
-> ansible-observer credential 4
-> HELIX — Observe Hypervisors template 2
-> playbooks/observe-hypervisors.yml
-> hypervisors group including hv-lore at 192.168.10.20
```

The playbook uses `become: false` and contains only Ansible ping plus minimal,
network, and virtualization fact collection. The committed Semaphore
declaration forbids overrides and has no schedule for this template.

`playbooks/realize-pve-observer.yml` exists in Git but is not declared as a
Semaphore template and is therefore not an admitted substitute. No generic
Lore bootstrap or convergence template is currently declared. Broad
convergence remains prohibited.

The workstation-side Matrix certificate had expired, but the operator completed
the bounded trust transition from the Matrix console. No SSH checking was
weakened. The established raw operator key subsequently authenticated strictly
to CT149's admin-plane address after its ED25519 fingerprint matched the
recorded value
`SHA256:M0CHmIfeJD/DXuNxksR3pZYVX99y20DjFO4Usouz3p0`. The governed loopback
tunnel returned HTTP 200 from Semaphore.

## Stage 3 — admitted Semaphore observation

The authenticated operator launched the existing `HELIX — Observe
Hypervisors` template without reported overrides. At 13:52:24–13:52:26 local
time the committed playbook completed both tasks against all three canonical
hypervisors:

```text
hv-katra  ok=2 changed=0 unreachable=0 failed=0
hv-lore   ok=2 changed=0 unreachable=0 failed=0
hv-matrix ok=2 changed=0 unreachable=0 failed=0
```

The tasks were exactly `Prove Ansible connectivity` and `Collect read-only
hypervisor facts`. This proves the existing Semaphore repository/inventory/
observer-credential/template path functionally authenticated to the freshly
installed Lore. The task ID was not present in the supplied transcript and
remains to be captured from Semaphore history; this does not change the live
connectivity result.

```text
LORE_ANSIBLE_OBSERVER_PATH=PASS
LORE_BECOME_USED=NO
LORE_MUTATION=NONE
CONVERGENCE_RUN=NO
```

## Drift boundary

Current `ansible-cp` contains no admitted Semaphore template for a Lore
post-reinstall package/tool survey, host bootstrap, or generic convergence.
`playbooks/realize-pve-observer.yml` exists but is not present in the committed
Semaphore declared state and uses a separate static inventory/human identity;
it is not an authorized substitute.

```text
BLOCKER=ANSIBLE_CP_SEMAPHORE_REALIZATION_DRIFT
ansible_cp_expected_state=the admitted existing path ends at read-only Observe Hypervisors
Semaphore_observed_state=the existing Observe Hypervisors path passes for hv-lore
missing_or_mismatched_object=no admitted hv-lore post-reinstall tool/package survey or bounded baseline/convergence template exists
smallest_correction_required=ansible-cp authority must define and validate the required bounded Lore post-reinstall observation/realization contract, then declare its exact Semaphore binding before realization
why_manual_ansible_execution_would_violate_authority_boundary=it would invent playbook, inventory, credential, privilege, and invocation semantics outside ansible-cp and bypass the existing Semaphore execution surface
```

Current state:

```text
LORE_CONSOLE_BOOTSTRAP=PASS
CT149_HOST_KEY_REPLACEMENT=PASS
OBSERVER_TEST=PASS
EXECUTOR_TEST=NOT_ADMITTED_BY_CURRENT_SEMAPHORE_CONTRACT
CONVERGENCE_RUN=NO
```

# hv-lore post-reinstall realization evidence

Date: 2026-08-27
Play: `HV-LORE-POST-REINSTALL-REALIZATION`
Packet: [post-reinstall realization packet](../implementation/2026-08-27-hv-lore-post-reinstall-realization.packet.md)
Runbook: [post-reinstall realization runbook](../runbooks/2026-08-27-hv-lore-post-reinstall-realization.md)

## Admitted observer realization

The live, non-secret Semaphore realization was proven as:

```text
project_id=2
project=Helix-ARPA
repository_id=1
repository=ansible-cp
repository_branch=main (inherited)
inventory_id=1
inventory=Canonical Observe Inventory
inventory_credential=governed ansible-observer
template_id=16
template=HELIX - Observe Lore Post-Reinstall
playbook=playbooks/observe-hv-lore-post-reinstall.yml
autorun=0
```

The template initially did not appear in the selected Semaphore custom view
`HELIX-ARPA MATRIX STAGE`, although its direct project object existed. This was
a presentation/view-membership issue, not loss of the template or execution
contract.

## Survey execution gate

The operator launched the admitted template through Semaphore. The reported
recap at 18:28:14 was:

```text
hv-lore : ok=10 changed=0 unreachable=0 failed=0 skipped=0 rescued=0 ignored=0
```

Result:

```text
ANSIBLE_CP_SURVEY_CONTRACT=PASS
SEMAPHORE_SURVEY_TEMPLATE=PASS
SURVEY_EXECUTION=PASS
SURVEY_CHANGED=0
SURVEY_UNREACHABLE=0
SURVEY_FAILED=0
MUTATION=NONE
```

The machine-readable survey payload remains to be captured from the completed
Semaphore task before baseline state is selected. The recap proves execution
health, not the values of APT, DNS, network, packages, storage, or automation
state.

The old root-pool NVMes remain intentionally absent:

```text
OLD_RPOOL_NVME_1=TP250913B5D3323
OLD_RPOOL_NVME_2=TP250913B5D1797
OLD_RPOOL_DISPOSITION=OFFLINE_ROLLBACK
OLD_RPOOL_RECONNECTED=NO
```

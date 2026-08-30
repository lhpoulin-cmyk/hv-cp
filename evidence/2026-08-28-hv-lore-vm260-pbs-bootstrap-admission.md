# hv-lore VM260 / PBS bootstrap admission

Date: 2026-08-28
Packet: [post-reinstall realization](../implementation/2026-08-27-hv-lore-post-reinstall-realization.packet.md)
Recovery runbook: [rpool stick swap](../runbooks/2026-08-26-hv-lore-rpool-stick-swap.md)

VM120 bootstrap is operator-accepted and is not revisited by this contract:

```text
VM120_BOOTSTRAP=ACCEPTED
VM120_RUNNING=YES
QGA=PASS
SLOWPOOL=HEALTHY
HOST_RPOOL=P3_MIRROR_ONLINE
OLD_RPOOL_IMPORTED=NO
```

Published `ansible-cp` commit
`c38190ef74ded524277e85fb15669e7df545a9cf` (`Admit Lore VM260 PBS
bootstrap`) adds the bounded VM260 recovery chain. Local `HEAD` and
`origin/main` matched that commit after publication. Complete qualification
passed 26 repository tests, Ansible syntax, inventory and freshness checks,
production-profile ansible-lint, and yamllint. No live host was contacted by
the qualification run.

The CHECK inspects only the admitted dependencies and exact VM260 source. It
proves VM120 and `slowPool`, the two-member P3 rpool, the old-pool member
identities, VM260 configuration and zvol sizes, the expected NFSv4 endpoint,
and absence of a conflicting live `192.168.10.240` identity. Its source
lifecycle is restricted to GUID `8921639095104950851`, the two exact Timetec
`-part3` devices, forced import under a temporary name, `readonly=on`,
`cachefile=none`, one read-only root-dataset mount, and cleanup/export.

The APPLY requires the CHECK-emitted VM260 configuration SHA-256 and exact
acknowledgement. A fresh run allocates only VM260's 1 MiB EFI and 64 GiB boot
zvols on `local-zfs`, copies and compares them, exports the old pool, realizes
the filtered authoritative configuration through `qm`, and starts VM260. A
stopped verified partial requires explicit prior-copy acknowledgement and
does not import, allocate, or copy. Rejected ordinary PVE options report the
option name, return code, and concise error without exposing values classified
as sensitive.

After VM260 starts, the APPLY proves QGA, `proxmox-backup-proxy`, exact backing
`192.168.100.111:/mnt/slowPool/backup/pbs/pbs-core` at `/mnt/pbs-core`, the
existing `pbs-core` datastore definition, known Lore content, and port 8007.
Only after those pass does it validate or restore the `pbs-core-lore` PVE
relationship from the existing in-memory old-pool authority. It does not
create a datastore or rotate TLS, tokens, auth keys, or encryption material.
No recovered client secret is persisted as a new resume artifact; a later
resume with an absent client therefore fails closed rather than re-importing
solely for a credential or inventing identity.

Admitted Semaphore realization:

```text
CHECK_TEMPLATE=HELIX - Check Lore VM260 PBS Bootstrap
CHECK_PLAYBOOK=playbooks/check-hv-lore-vm260-pbs-bootstrap.yml

APPLY_TEMPLATE=HELIX - Apply Lore VM260 PBS Bootstrap
APPLY_PLAYBOOK=playbooks/apply-hv-lore-vm260-pbs-bootstrap.yml
ACKNOWLEDGEMENT=APPLY HV_LORE_VM260_PBS_BOOTSTRAP hv-lore
APPLY_PROMPTS=helix_apply_acknowledgement,hv_lore_vm260_pbs_bootstrap_source_config_sha256,hv_lore_vm260_pbs_bootstrap_prior_copy_verified_authorized

ACCEPT_TEMPLATE=HELIX - Accept Lore VM260 PBS Bootstrap
ACCEPT_PLAYBOOK=playbooks/accept-hv-lore-vm260-pbs-bootstrap.yml

INVENTORY=Canonical Apply Inventory — ansible-executor
REPOSITORY=ansible-cp
VIEW=All
AUTORUN=NO
OVERRIDES=NO
```

The acceptance template is read-only and is reserved for an execution that
already reached operational success but stopped on a reporting/assertion
defect. It does not repeat the migration.

```text
ANSIBLE_CP_VM260_PBS_BOOTSTRAP_CONTRACT=PASS
LIVE_VM260_MUTATION_EXECUTED=NO
OLD_RPOOL_DATA_MUTATION=NONE
PBS_DATASTORE_MUTATION=NONE
MATRIX_AND_FOOTBALL=UNTOUCHED
NEXT=create the three existing-project Semaphore templates and run HELIX - Check Lore VM260 PBS Bootstrap
```

## First CHECK query correction

The first live CHECK at `c38190e` reached the exact old-rpool source but
stopped while reading only VM260's private pmxcfs record. Cleanup completed
and the run remained a bounded read-only import/mount/export lifecycle. The
defect was the new recursive SQLite path traversal; VM120 had already proven
the fixed `tree`-join form against this same database.

Published `ansible-cp` commit
`8e09c341c4f2d2cf7a3e81108d8504f5ffddd792` (`Fix Lore VM260 pmxcfs
queries`) uses the proven fixed joins for `260.conf` and the exact
`priv/storage/pbs-core-lore.pw` record. The private query tasks retain
`no_log`, while new failure tasks expose only stable blocker ID, SQLite return
code, and concise SQLite stderr. No configuration or secret content is
emitted. Complete qualification again passed 26 tests, syntax, inventory,
freshness, production ansible-lint, and yamllint; `HEAD` and `origin/main`
matched after publication.

```text
FAILED_CHECK_DESTINATION_MUTATION=NONE
OLD_RPOOL_DATA_MUTATION=NONE
APPLY_TEMPLATE_CHANGE=NONE
APPLY_SURVEY_CHANGE=NONE
NEXT=rerun HELIX - Check Lore VM260 PBS Bootstrap
```

## Operational VM260 / reconnect-only closure

The VM260 APPLY subsequently completed disk migration, configuration
realization, guest start, QGA, PBS service, exact backing mount, datastore, and
known-content acceptance. It stopped only before recreating the absent
`pbs-core-lore` PVE relationship because the recovered stanza used an
authoritative server hostname rather than literal `192.168.10.240`. VM260 and
PBS remain operational; migration must not be rerun.

Published `ansible-cp` commit
`1fe08e7fe62578dd4ba789d6e59f559435580edd` (`Close Lore PBS client
reconnect`) removes the literal-server requirement and adds the single manual
template `HELIX - Close Lore PBS Client Reconnect`. It re-proves operational
VM260/PBS state and the P3 rpool without changing them. If the client is
absent, it imports exact old-rpool GUID `8921639095104950851` read-only from
the two exact members, reads only `storage.cfg` and
`priv/storage/pbs-core-lore.pw`, exports immediately, preserves the recovered
server value, proves that value resolves to `192.168.10.240` and reaches TCP
8007, and recreates the PVE storage through `pvesm`. Secrets remain `no_log`
and are not persisted outside PVE authority. Existing client state is
validation-only.

Complete qualification passed 26 tests, Ansible syntax, inventory and
freshness checks, production ansible-lint, and yamllint. `HEAD` and
`origin/main` matched after publication.

```text
TEMPLATE=HELIX - Close Lore PBS Client Reconnect
PLAYBOOK=playbooks/close-hv-lore-pbs-client-reconnect.yml
ACKNOWLEDGEMENT=APPLY HV_LORE_PBS_CLIENT_RECONNECT hv-lore
VM260_MIGRATION_RERUN=NO
VM260_RUNTIME_MUTATION=NONE
PBS_DATASTORE_MUTATION=NONE
NEXT=run reconnect-only closure, then restore remaining Lore guests from PBS
```

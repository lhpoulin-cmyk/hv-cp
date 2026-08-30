# hv-lore VM120 bootstrap admission

Date: 2026-08-27
Packet: [post-reinstall realization](../implementation/2026-08-27-hv-lore-post-reinstall-realization.packet.md)
Recovery runbook: [rpool stick swap](../runbooks/2026-08-26-hv-lore-rpool-stick-swap.md)

The operator confirmed the closing post-baseline observer had already passed:

```text
POST_BASELINE_OBSERVER=PASS
HOST_BASELINE_PHASE=CLOSED
```

No additional observer or host-baseline gate was inserted. The preserved
pre-reinstall configuration supplied the authoritative VM120 mapping order:

```text
scsi1=/dev/disk/by-id/ata-TOSHIBA_HDWG51CUZSVA_16N2A042FWUH,backup=0
scsi2=/dev/disk/by-id/ata-TOSHIBA_HDWG51CUZSVA_16X2A00KFWUH,backup=0
scsi3=/dev/disk/by-id/ata-TOSHIBA_HDWG51CUZSVA_16N2A02XFWUH,backup=0
```

`ansible-cp` commit `115b6f6` initially admitted the VM120 restoration. The
operator corrected its invalid locality assumption: Football remains on
`hv-matrix` and must not be moved or mounted on Lore. Corrective commit
`4e860ba` (`Correct Lore VM120 source locality`) replaced destination-local
source access with the existing `192.168.100.22` to `192.168.100.20` 10GbE
path. The corrected contract passed 24 repository tests, Ansible syntax,
inventory validation, production-profile ansible-lint, and yamllint.

The operator subsequently authorized the playbook itself to establish source
access when Football is present but unmounted on `hv-matrix`. Published
`ansible-cp` commit `91be7be` (`Manage Football source mount in Lore
bootstrap`) identifies the exact stable partition
`usb-Seagate_Expansion_HDD_00000000NT1H79L3-0:0-part2`, proves exFAT UUID
`011D-FABB`, and mounts it only with `ro,nosuid,nodev,noexec` when the canonical
mount is absent. CHECK and APPLY unmount only mounts they created; an admitted
pre-existing read-only mount is preserved. The revised contract again passed
all 24 tests, Ansible syntax, inventory validation, production-profile
ansible-lint, and yamllint. Local `HEAD` and `origin/main` were both
`91be7be8a40b3f4ab0f86a2e35341357a3582035` after publication.

The first live CHECK then proved source-media mount safety and archive access,
but failed on an invalid source interface-name assumption: Matrix did not have
a device named `vmbr1`. Ownership-aware cleanup passed and the run unmounted
the temporary Football mount it had created. No guest, disk, pool, or source
data mutation occurred. Its reported `changed=2` was the admitted bounded
read-only source-mount lifecycle, not Lore mutation, and no persistent mount
remained. Published corrective commit `ee1b5be` (`Decouple Lore
bootstrap from Matrix bridge name`) now proves Matrix owns
`192.168.100.22`, proves its route to Lore's `192.168.100.20` selects that
source, and retains the end-to-end 8972-byte DF ping. It does not prescribe a
Matrix interface name. The correction passed all 24 repository tests and the
complete static validator; `HEAD` and `origin/main` matched
`ee1b5be930fc49b0142314c1f34a441c5faf51ad` after publication.

A subsequent live CHECK exposed a second assertion bug: the route probe used
an explicit source, then required the output to echo that source with a `src`
field. Published commit `8423ae6` (`Prove natural Matrix storage route
selection`) instead runs an unqualified kernel route lookup for
`192.168.100.20` and requires the natural result to contain destination
`192.168.100.20` and `src 192.168.100.22`. The admitted 8972-byte DF ping
remains the end-to-end jumbo-path proof. The correction passed the complete
static validator, and `HEAD` matched `origin/main` at
`8423ae684add4d95b695c2446fa429017fa12c97`.

Published `ansible-cp` commit `ccd437e` (`Standardize governed operator
handoffs`) added the shared `helix_handoff` result role and integrated both
VM120 templates. Successful APPLY handoff is limited to VM120 running state,
the exact Toshiba mapping order, TrueNAS/QGA acceptance, `slowPool` health,
unchanged host `rpool`, protected untouched surfaces, and the authoritative
recap pointer. Blocked runs perform operation-specific cleanup first, emit a
compact stable footer, and then fail again so the transcript and failed recap
remain authoritative. Local success/blocked rendering tests passed; the
blocked fixture exited nonzero with `failed=1`. Full static validation passed
25 tests, syntax, inventory, production ansible-lint, and yamllint. `HEAD` and
`origin/main` matched `ccd437efd9fb2aefe29f5eff9939611adb69059c`.

Admitted Semaphore realization:

```text
CHECK_TEMPLATE_ID=20
CHECK_TEMPLATE=HELIX - Check Lore VM120 Bootstrap
CHECK_PLAYBOOK=playbooks/check-hv-lore-vm120-bootstrap.yml

APPLY_TEMPLATE_ID=21
APPLY_TEMPLATE=HELIX - Apply Lore VM120 Bootstrap
APPLY_PLAYBOOK=playbooks/apply-hv-lore-vm120-bootstrap.yml
ACKNOWLEDGEMENT=APPLY HV_LORE_VM120_BOOTSTRAP hv-lore
INVENTORY=Canonical Apply Inventory — ansible-executor
```

The CHECK delegates source preparation and inspection to `hv-matrix`: exact
Football filesystem identity, ownership-aware temporary read-only mounting,
exact VMA size and hash, governed executor identity, Matrix storage
address, 8972-byte DF path from Lore, Lore staging capacity, healthy P3 rpool,
historical rpool not imported, host `slowPool` not imported, VM260 absent, and
every Toshiba stable identity and unmounted state.

The APPLY creates a transient source-IP-restricted, read-only rsync endpoint
on Matrix's `192.168.100.22`, exposes only the VM120 filename, stages it under
a root-only Lore path, verifies the destination hash, restores VM120 to
`local-zfs`, validates `slowPool`, and removes the staged VMA after acceptance.
The endpoint and runtime files are always removed. It does not move/mount/write
Football, create a permanent share, initialize/partition/format disks, import
or create a host pool, restore VM260, reconnect PBS, mutate old rpool, change
packages, or reboot.

```text
ANSIBLE_CP_VM120_BOOTSTRAP_CONTRACT=PASS
LIVE_GUEST_MUTATION=NONE
SOURCE=hv-matrix_Football_Seagate_READ_ONLY
TRANSPORT=validated_10GbE_bounded_transient_rsync
TARGET=hv-lore_temporary_recovery_staging
NEXT=realize templates 20/21 in existing Helix-ARPA Semaphore project and run CHECK
```

## 2026-08-28 transient endpoint correction

The admitted CHECK passed from Semaphore at `ansible-cp` commit `ccd437e`.
Its compact handoff proved the exact source hash, natural Matrix-to-Lore 10GbE
route, 8972-byte DF ping, healthy P3 rpool, free-or-matching VM120 state,
absent VM260, and exact Toshiba identities/order. Its only changes were the
bounded Matrix read-only Football mount/unmount lifecycle; source data and
Lore remained unchanged.

The first APPLY stopped before transfer or restore because Lore timed out
waiting for the transient Matrix endpoint on nonstandard port `18730/tcp`.
The admitted cleanup stopped the transient unit, removed its runtime, and
released the run-owned read-only Football mount. The run did not begin
`qmrestore`; VM120, Toshiba data, and the host rpool were not mutated.

Published `ansible-cp` commit `97873ef` (`Harden Lore VM120 transfer endpoint`)
uses the network-authority-admitted rsync service port `873/tcp`, fails closed
if Matrix already has a listener on that port, and requires both an active
transient unit and a Matrix-local endpoint proof before Lore attempts the
10GbE connection. This separates a source-service failure from fabric
reachability without changing firewall or network policy. The complete static
validator passed 25 tests, Ansible syntax, inventory validation,
production-profile ansible-lint, and yamllint. `HEAD` and `origin/main`
matched `97873ef` after publication.

```text
FAILED_APPLY_MUTATION=BOUNDED_MATRIX_READ_ONLY_MOUNT_LIFECYCLE_AND_TRANSIENT_RUNTIME_CLEANED
VM120_RESTORE_STARTED=NO
TOSHIBA_DATA_MUTATION=NONE
HOST_RPOOL_MUTATION=NONE
CORRECTION=ANSIBLE_CP_97873EF
NEXT=rerun existing HELIX - Apply Lore VM120 Bootstrap template with the admitted acknowledgement
```

Before another endpoint attempt, the operator required exact Lore-local
artifact discovery. Published `ansible-cp` commit `95d4ff7` (`Prefer verified
local Lore VM120 artifact`) updates the existing CHECK and APPLY rather than
creating another Semaphore object. CHECK now searches the active Lore root
filesystem plus already-mounted authorized recovery/staging locations for
exact filename `vm120-truenas-lore-2026-08-26.vma.zst`, hashes every candidate,
and accepts only SHA-256
`8026592262280ae31224b203a19c01ceb9ec97f24d84f1151eb18dde2ed7d306`.

The contract enumerates the attached P3-512 and Helix recovery USB without
mounting them. Historical rpool media, VM140 raw NVMe, and `jellyPool` remain
unmounted and outside the search. If an exact local match exists, APPLY uses
it directly and skips Football preparation, the Matrix rsync endpoint, and
network transfer. If no exact local match exists, the existing read-only
Football path remains authoritative. Full static validation passed 25 tests,
Ansible syntax, inventory validation, production-profile ansible-lint, and
yamllint; `HEAD` and `origin/main` matched `95d4ff7` after publication.

```text
LOCAL_DISCOVERY_MUTATION=NONE
PROTECTED_NVME_MOUNT_OR_IMPORT=NONE
NEXT=rerun existing HELIX - Check Lore VM120 Bootstrap template
```

## 2026-08-28 direct VM120 migration APPLY admission

The operator accepted the migration-source CHECK and prohibited further
source discovery. Published `ansible-cp` commit `c23323b` (`Admit direct Lore
VM120 migration`) realizes the acknowledged APPLY against the authoritative
old-rpool guest state:

```text
SOURCE=OLD_RPOOL_GUEST_STATE
SOURCE_GUID=8921639095104950851
SOURCE_MODE=EXACT_GUID_FORCE_IMPORT_READ_ONLY
VMID=120
VM120_CONFIG_SHA256=36fcfddceb0ab941561724b55708d77c8c44dfef932467b577d148c58d4bb81a
DESTINATION=P3_RPOOL:local-zfs
```

Before acknowledgement, the APPLY repeats only destination and preservation
prechecks. After exact acknowledgement it imports only the accepted GUID from
the two exact Timetec `-part3` members with `-f`, `-N`, `readonly=on`,
`cachefile=none`, an alternate root, and a temporary non-conflicting name. It
re-proves source identity, VM120 configuration hash, managed-disk sizes, and
Toshiba mappings before allocating the exact VM120 destination zvols through
PVE storage authority. It copies and compares both managed disks, exports and
proves the old pool absent, realizes the authoritative VM configuration only
through `qm`, starts VM120, proves QGA, validates existing `slowPool`, and
reconfirms the healthy two-member P3 rpool.

Matrix and Football are not contacted. VM260, every other guest, Toshiba data,
`jellyPool`, and VM140 raw NVMe remain outside this APPLY. The old rpool is
never written and returns to exported rollback state after its bounded
read-only source lifecycle. Complete qualification passed 25 tests, Ansible
syntax, inventory validation, freshness validation, production-profile
ansible-lint, and yamllint. Published `HEAD` and `origin/main` both resolve to
`c23323b603e062baaf3512f8f036c1ceb0d058b1`.

```text
APPLY_TEMPLATE_ID=22
APPLY_TEMPLATE=HELIX - Apply Lore VM120 Bootstrap
APPLY_PLAYBOOK=playbooks/apply-hv-lore-vm120-bootstrap.yml
ACKNOWLEDGEMENT=APPLY HV_LORE_VM120_BOOTSTRAP hv-lore
SEMAPHORE_TEMPLATE_CHANGE=NONE
LIVE_VM120_MIGRATION_EXECUTED=NO
NEXT=run existing Semaphore template 22 and return only its compact HELIX handoff
```

The CHECK at `ansible-cp` commit `830fa02` correctly recognized an exact stale
temporary read-only import from the interrupted inventory run, but export was
blocked because the interrupted `sqlite3 -readonly` pmxcfs inventory process
still held `/mnt/hv-lore-old-rpool-readonly` busy. Published `ansible-cp`
commit `af0c7b0` (`Release stale Lore read-only readers`) adds bounded recovery:
it identifies only the exact old-config database reader command, sends TERM
only to those matching reader processes, waits for their exit, unmounts only
the two admitted temporary datasets in nested-first order without force, then
exports the exact temporary pool. No generic process termination or forced
dataset unmount is admitted. Full static validation passed 25 tests, Ansible
syntax, inventory validation, production ansible-lint, and yamllint.

```text
FAILED_TASK=Export exact stale temporary import from an interrupted prior CHECK
OBSERVED=OLD_READONLY_DATASET_BUSY_FROM_INTERRUPTED_SQLITE_READER
CORRECTION=ANSIBLE_CP_AF0C7B0
FORCED_UNMOUNT=NO
OLD_RPOOL_DATA_MUTATION=NONE
NEXT=rerun existing HELIX - Check Lore VM120 Bootstrap template
```

The first expanded-inventory CHECK at `e369f8c` stopped before import because
the discovery contract passed the two whole-NVMe stable paths to `zpool
import -d`; the historical ZFS labels are on the corresponding `-part3`
members. ZFS reported GUID `8921639095104950851` unavailable. Football setup
was skipped, and no old pool was imported or mounted.

Published `ansible-cp` commit `b384876` (`Fix old Lore rpool member discovery`)
uses the exact stable `TP250913B5D3323-part3` and
`TP250913B5D1797-part3` identities. Before import it now proves both are block
devices and that the exact old pool GUID is discoverable from them. The import
remains non-forced, temporary-name, `readonly=on`, `cachefile=none`, and `-N`.
Full static validation passed 25 tests, Ansible syntax, inventory validation,
production ansible-lint, and yamllint.

```text
FAILED_CHECK_OLD_RPOOL_IMPORTED=NO
FAILED_CHECK_OLD_RPOOL_MOUNTED=NO
FAILED_CHECK_OLD_RPOOL_DATA_MUTATION=NONE
CORRECTION=ANSIBLE_CP_B384876
NEXT=rerun existing HELIX - Check Lore VM120 Bootstrap template
```

The next CHECK proved both stable `-part3` paths existed but stopped because
Ansible `stat` classified the unfollowed paths as symlinks rather than block
devices. Published `ansible-cp` commit `86e22b0` (`Follow old rpool member
symlinks`) sets `follow: true` and disables irrelevant checksum, MIME, and
attribute collection. It also delays the bounded-import lifecycle marker until
after partition and GUID discovery, so failures before import no longer claim
an import/mount/export mutation. Full static validation passed.

```text
FAILED_CHECK_OLD_RPOOL_IMPORTED=NO
FAILED_CHECK_MUTATION=NONE
CORRECTION=ANSIBLE_CP_86E22B0
NEXT=rerun existing HELIX - Check Lore VM120 Bootstrap template
```

The operator then superseded offline-only rollback semantics for the bounded
migration window. Published `ansible-cp` commit `bc9f201` (`Admit old Lore
rpool migration source`) classifies exact GUID `8921639095104950851` and its
two Timetec `-part3` members as an authorized read-only migration source. Only
that exact import gains `-f`; it also retains `readonly=on`, `cachefile=none`,
`-N`, the alternate root, temporary name, and cleanup proof.

CHECK no longer contacts Matrix or Football and no longer searches for
alternate archives. It privately proves VM120's old pmxcfs definition, exact
1 MiB EFI and 64 GiB system zvols, and three Toshiba `backup=0` mappings. It
reports all VM/LXC IDs evidenced by ZFS objects and config-record metadata,
then exports the old pool. Configuration content and secrets are not emitted.
Full static validation passed 25 tests, Ansible syntax, inventory validation,
production ansible-lint, and yamllint.

```text
OLD_RPOOL_ROLE=AUTHORIZED_READ_ONLY_MIGRATION_SOURCE
FORCED_IMPORT_SCOPE=EXACT_GUID_AND_EXACT_MEMBERS_ONLY
MATRIX_TRANSFER=NOT_REQUIRED
OLD_RPOOL_DATA_MUTATION=NONE
NEXT=rerun existing HELIX - Check Lore VM120 Bootstrap template and return compact handoff
```

The first migration-source CHECK stalled in the recursive SQLite inventory of
old pmxcfs records. The operator stopped the read-only run. Published
`ansible-cp` commit `830fa02` (`Bound old Lore pmxcfs inventory`) replaces both
recursive CTEs with fixed-depth joins matching
`nodes/<node>/{qemu-server,lxc}/<id>.conf` and wraps each SQLite invocation in
a 30-second timeout. It also recognizes only the exact temporary pool name,
GUID, and `readonly=on` state from an interrupted prior CHECK, exports that
stale temporary import, and then begins a fresh bounded inspection. A mismatch
still fails closed. Full static validation passed.

```text
FAILED_TASK=Inventory VM and LXC config records without reading config contents
SOURCE_QUERY_MODE=READ_ONLY
QUERY_BOUND=30_SECONDS
INTERRUPTED_IMPORT_CLEANUP=EXACT_NAME_GUID_READONLY_ONLY
CORRECTION=ANSIBLE_CP_830FA02
NEXT=rerun existing HELIX - Check Lore VM120 Bootstrap template
```

The operator then expanded the same authorized read-only inspection to locate
recovery evidence for every VM and LXC, not only VM120. Published `ansible-cp`
commit `e369f8c` (`Inventory old Lore guest recovery state`) inventories guest
IDs from all ZFS filesystem/volume objects, standalone `vzdump`/VMA archive
metadata, and VM/CT record paths and data lengths in the old pmxcfs
`config.db`. It never emits configuration contents or secrets and does not
hash or stage any non-VM120 artifact. The exact verified VM120 archive remains
the only object eligible for APPLY staging.

The existing CHECK now always performs this bounded inventory, even when a
verified artifact already exists on active Lore staging. Its compact handoff
reports discovered VM IDs, CT IDs, standalone archive count, and config-record
count. Full static validation passed 25 tests, Ansible syntax, inventory
validation, production ansible-lint, and yamllint; `HEAD` and `origin/main`
matched `e369f8c` after publication.

```text
OLD_RPOOL_GUEST_INVENTORY=AUTHORIZED_READ_ONLY
CONFIG_CONTENT_OR_SECRET_OUTPUT=NONE
NON_VM120_HASH_OR_STAGE=NONE
SEMAPHORE_TEMPLATE_CHANGE=NONE
NEXT=rerun existing HELIX - Check Lore VM120 Bootstrap template
```

The operator then explicitly authorized mounting the historical rpool to
search for the exact VM120 seed. Published `ansible-cp` commit `b628493`
(`Inspect old Lore rpool for VM120 seed`) adds this to the existing VM120
CHECK/APPLY chain. The lifecycle is bounded to old pool GUID
`8921639095104950851` and exact members `TP250913B5D3323` and
`TP250913B5D1797`. It imports under temporary name
`hv-lore-old-rpool-readonly` with `readonly=on`, `cachefile=none`, `-N`, and an
alternate root; mounts only expected root and `var-lib-vz` datasets with
`-o ro`; searches and hashes only the exact VM120 filename; then unmounts in
nested-first order, exports, and proves neither temporary name nor old GUID is
imported.

CHECK performs no copy. APPLY repeats the proof and, only for the exact hash,
copies to the already-authorized bounded Lore staging path, verifies the copy,
exports the old pool, and restores from local staging. A verified old-rpool
artifact therefore eliminates Matrix transfer. Full static validation passed
25 tests, Ansible syntax, inventory validation, production ansible-lint, and
yamllint; `HEAD` and `origin/main` matched `b628493` after publication.

```text
OLD_RPOOL_INSPECTION_AUTHORIZED=YES
OLD_RPOOL_WRITE=PROHIBITED
CHECK_COPY=NONE
APPLY_COPY=EXACT_HASH_TO_BOUNDED_NEW_RPOOL_STAGING_ONLY
NEXT=rerun existing HELIX - Check Lore VM120 Bootstrap template
```

## 2026-08-28 VM120 APPLY property-parser correction

The first direct migration APPLY at `c23323b` imported the exact old rpool
read-only, then stopped before destination allocation because its folded Jinja
GUID assertion encoded the `zpool get` tab separator as a literal
backslash-plus-`t`. Cleanup exported the source. No P3 VM120 destination or
VM120 configuration was created; Toshiba data, Matrix, and Football remained
untouched.

Published `ansible-cp` commit `9721a50` (`Fix Lore VM120 property parsing`)
uses the same tab-delimiter semantics already proven by CHECK for GUID and for
both upcoming zvol-size assertions. The import, source authority, mutation
scope, template, and acknowledgement are unchanged. Complete qualification
passed 25 tests, syntax, inventory/freshness validation, production-profile
ansible-lint, and yamllint.

```text
FAILED_TASK=Require exact read-only migration-source identity during APPLY
SOURCE_IMPORT=EXACT_GUID_READ_ONLY
SOURCE_CLEANUP=EXPORTED
P3_VM120_DESTINATION=NOT_CREATED
VM120_CONFIG=NOT_CREATED
CORRECTION=ANSIBLE_CP_9721A50
NEXT=rerun existing HELIX - Apply Lore VM120 Bootstrap template
```

## 2026-08-28 verified VM120 partial-state resume

The APPLY at `9721a50` completed both `qemu-img compare` operations, exported
the exact read-only old-rpool source, created VM120 and attached the exact
managed/Toshiba disks, then stopped in remaining PVE option replay. The old
implementation hid the rejected option through `no_log`. No guest was started.

Published `ansible-cp` commit `291ed66` (`Resume verified Lore VM120 partial
state`) makes the existing template recognize this exact stopped partial
state. It proves both existing P3 zvol names, byte sizes, writable state, raw
virtual sizes, exact VM identity and mappings, absence of a runtime lock,
complete boot-critical option names, healthy P3 rpool, and exported old source.
That branch performs no old-pool import, PVE allocation, disk conversion, or
disk comparison; the accepted prior compare transcript remains its bounded
copy-integrity authority.

For a fresh realization, generated/runtime `digest`, `lock`, and `meta` fields
are no longer blindly replayed, protection is applied last, and `qm set` runs
only for a missing or differing authoritative value. Values remain private.
A future rejection reports only `OPTION`, `PVE_RC`, and concise sanitized
`PVE_ERROR`, with sensitive option classes redacted. Complete qualification
passed 25 tests, syntax, inventory/freshness validation, production-profile
ansible-lint, and yamllint.

```text
PRIOR_MANAGED_DISK_COMPARE=PASS
OLD_RPOOL_SOURCE=EXPORTED
VM120_STATE=STOPPED_PARTIAL
RESUME_REIMPORT=NO
RESUME_REALLOCATE=NO
RESUME_RECOPY=NO
CORRECTION=ANSIBLE_CP_291ED66
NEXT=rerun existing HELIX - Apply Lore VM120 Bootstrap template
```

The first `291ed66` resume stopped in its initial assertion because YAML parsed
the unquoted expression containing `status: stopped` as a mapping rather than
an Ansible conditional string. Published syntax-only `ansible-cp` commit
`3354793` (`Fix Lore VM120 resume gate syntax`) combines the same four checks
into one explicit folded string expression. No recovery semantics changed.
Full qualification passed.

```text
FAILED_TASK=Require the operator-accepted verified-copy resume contract
RECOVERY_STATE_REMEDIATION=NONE
OLD_RPOOL_IMPORT=NO
P3_VM120_COPY=PRESERVED
VM120_STATE=STOPPED_PARTIAL
CORRECTION=ANSIBLE_CP_3354793
NEXT=rerun existing HELIX - Apply Lore VM120 Bootstrap template
```

## 2026-08-28 operational VM120 read-only acceptance closure

The resumed APPLY reached running VM120, responsive QGA, and accepted healthy
`slowPool`; it captured the final guest and host-rpool state before stopping
only because the final composite assertion contained the same YAML conditional
typing defect. The verified P3 disk copy was reused, the old rpool was not
imported during resume, and no recovery-state remediation is required.

Published `ansible-cp` commit `01ade77` (`Add read-only Lore VM120 acceptance`)
corrects the final APPLY assertions and declares a separate read-only closure
template, `HELIX - Accept Lore VM120 Bootstrap`, using
`playbooks/accept-hv-lore-vm120-bootstrap.yml`. The closure does not rerun the
APPLY. It proves running state, QGA, healthy `slowPool`, authoritative VM120
configuration, exact Toshiba mappings, the healthy two-member P3 rpool, and
absence of the historical rpool GUID. It contains no guest start/stop, PVE
configuration replay, disk allocation/copy, or pool import. Complete
qualification passed 25 tests, syntax, inventory/freshness validation,
production-profile ansible-lint, and yamllint.

```text
VM120_OPERATIONAL_RESTORE=PASS
VM120_RUNNING=YES
QGA=PASS
SLOWPOOL=HEALTHY
DISK_COPY=VERIFIED_PRIOR_COPY_REUSED
OLD_RPOOL_IMPORTED_DURING_RESUME=NO
FORMAL_ACCEPTANCE=INCOMPLETE_DUE_TO_ASSERT_SYNTAX
CORRECTION=ANSIBLE_CP_01ADE77
SEMAPHORE_TEMPLATE=HELIX - Accept Lore VM120 Bootstrap
TEMPLATE_MODE=READ_ONLY
APPLY_RERUN=NO
NEXT=run read-only acceptance template; on PASS advance to VM260_PBS_BOOTSTRAP
```

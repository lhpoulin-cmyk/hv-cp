# VM310 local media staging

Status: completed

PLAY: VM310 shared local media capacity
CHECKPOINT: runtime and persistent-mount acceptance
STATUS: AUTHORIZED by the operator's 2026-09-08 request in this session
RESULT: PASS; see ../evidence/2026-09-08-vm310-local-media.md

Authority: hv-cp owns SN810 partitioning and VM attachment; gpu-encode owns guest filesystem and media mount checks. This packet records existing operator authority, not self-authorization.

Starting hv-cp HEAD: f22f9ddd09f5791b1fe9d5f7bcc7209e4de7c3e4. Origin fetched; origin/main is 864bc35468ff42f7b28dc4de6494169eeca91f3e. Existing unrelated changes are preserved.

[Runbook](../runbooks/2026-09-08-vm310-local-media.md)

Exact scope: hv-matrix WD SN810 serial 22412Y801751, /dev/nvme1n1, GPT A6B3954C-638B-4063-B52E-0D240B607BFB. Preserve p1 start 2048, length 536870912 sectors and UUID 0B10B948-767C-4E54-A9E6-A4A12C1BA942. Add only p2 start 536872960, length 536870912 sectors (256 GiB); remaining 441.87 GiB stays unallocated. Attach stable by-id part2 as VM310 scsi1. Format only this disk inside VM310 as ext4. Persist /mnt/media and four self-bind mounts. Retain the existing 3.3 GiB media tree and verify a copy. Reserve 20% through existing appliance admission policy (mkfs reserved blocks 0%, avoiding double reservation); run one movie at a time, budgeting all shared paths together.

Canonical projection under /home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-matrix/:
- CURRENT_STATE.md: update new storage state.
- VALIDATION.md: update bounded acceptance and limitations.
- README.md: not affected, existing role/routes remain valid.
- TODO.md: not affected, no existing item superseded by this addition.
- command-log/README.md and outputs/README.md: not affected, classification unchanged.
- NOTIFICATION_IDENTITY.md and NTFY_HEARTBEAT_MODE.md: not affected.

Evidence: hv-cp/evidence/2026-09-08-vm310-local-media.md and task-specific execution output. Guest documentation: gpu-encode/CURRENT_STATE.md, CHANGELOG.md and docs/local-media-staging.md.

Preflight: GPT verify passes, one partition, 697.87 GiB contiguous unallocated tail, scsi1 absent. Guest media paths are directories on root, one 3440736144-byte work file and no open handles observed. Guest agent root is available; direct louis SSH works, passwordless guest sudo does not. Management is direct vmbr0/192.168.10.22. No service restarts, VM shutdown, networking, source deletion, or other disks authorized.

Rollback: retain GPT binary and textual backup and original VM config before adding p2. On partial failure leave p1 untouched and retain p2 for diagnosis; never restore an entire partition table over later changes. Guest rollback unmounts four binds then /mnt/media, restores saved fstab, and restores retained original media directory only after checking for new writes. Removing p2 or discarding newly written data requires separate explicit authorization. No reboot acceptance is claimed.

# CT149 runtime restoration

Authority: Louis explicitly requested restoration of CT149 on 2026-09-07.
Method: hv-cp 864bc35468ff42f7b28dc4de6494169eeca91f3e; origin fetched and
origin/main matches. Preserve unrelated dirty repository changes.
Runbook: `../runbooks/2026-09-07-ct149-runtime-restoration.md`.

Target: hv-matrix, unprivileged CT149 semaphore-matrix-stage, existing
local-zfs subvol-149-disk-0, 192.168.80.149/24 tag 80 on vmbr0.
Mutation: start the existing stopped CT through pct. No restore-from-backup,
replacement, network change, privilege change, scheduling, or fleet APPLY.

Preconditions observed: local-zfs active; rootfs mounted; SQLite quick_check
ok; 33 templates retained; no schedules; no router ARP entry at .80.149.
Lore VM100 uses .10.250 and is not altered. onboot=0 remains unchanged.

Validation: CT running, expected address, Semaphore active, HTTP response,
SQLite metadata readable, retained templates/inventories and no schedules.
Rollback: if startup produces a collision or unsafe behavior, gracefully shut
down only CT149; preserve its disk/database and inspect before further changes.

Evidence: `../evidence/2026-09-07-ct149-runtime-restoration.md` (create).
Canonical: private hv-matrix CURRENT_STATE.md dated runtime addendum (update);
ansible-cp docs/SEMAPHORE_RECOVERY.md dated service restoration note (update).
No identity, hardware, storage or network configuration changes are intended.

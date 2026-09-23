# Cider enrollment controller startup

Authority: operator instruction “GET THE MAC ENROLLLED” in the current
network-cp task; ordinary restoration of its already-selected CT149 controller.
Owner: hv-cp. Inspected HEAD: 9e6638b. No new controller or source selected.
Runbook: ../runbooks/2026-09-07-ct149-runtime-restoration.md

Target: existing hv-matrix CT149 semaphore-matrix-stage, local-zfs
subvol-149-disk-0, eth0 192.168.80.149/24, vmbr0 VLAN80, gateway .80.1.
Preflight: stopped; no lock; local-zfs active; SQLite read-only quick_check ok;
project__schedule count 0; task statuses only success/error/stopped.
36 existing templates. No secret fields inspected. PBS unavailable is observed
but not a dependency of the existing local rootfs startup.

Change: sudo -n pct start 149. Preserve disk, networking, onboot=0, isolation,
credentials and unrelated guests. No Semaphore template launch.
Verify running, expected hostname/address, route to Cider .10.83, TCP22/public
host key from that source. Compare with independently recorded Cider key.
Rollback unexpected unsafe behavior: sudo -n pct shutdown 149 --timeout 60;
no force stop or destroy. Record receipt in network-cp/evidence/
2026-09-22-ws-cider-enrollment-continuation.json and reference from hv-cp.

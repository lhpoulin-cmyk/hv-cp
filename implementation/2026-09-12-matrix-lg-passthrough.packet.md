# Matrix LG native optical passthrough — 2026-09-12

Status: completed; LG-only runtime and documentation accepted

PLAY: MATRIX_LG_PASSTHROUGH
CHECKPOINT: native LG and USB verified after clean shutdown/start
STATUS: COMPLETE
RESULT: LG-only accepted; HP remains deferred; see dated evidence

## Authority and scope

The operator resumed with “we need the lg passed through” after a live status
check. This authorizes LG-only realization and its necessary clean VM310
shutdown/start. It supersedes the prior LG deferral, not the HP hardware gate.
HP recabling and three-drive acceptance remain deferred. hv-cp owns this
bounded SSH/PVE operation; no Ansible/Semaphore template is used or admitted.

Source HEAD: `9e6638bc618df2cc3eaab9c37f4baf299a84e7a1`.
Origin fetched 2026-09-12; origin/main
`bfc3897880a87405302838408e596824de4e95ed`; HEAD is four ahead, three behind.
Incoming commits affect README/license only; the optical branch supplies this
packet's source. Unrelated dirty work, including private Matrix history, is
preserved. Procedure: [LG runbook](../runbooks/2026-09-12-matrix-lg-passthrough.md).

## Target, evidence and gates

Strict SSH: configured hv-matrix identity, HostName 192.168.10.22,
HostKeyAlias hv-matrix.arpa. Host PVE 9.2.2, VM310 b70-encode running;
guest b70-encode-matrix UUID matches VM config. Recovery uses this independent
management SSH path and PVE guest console; no host network/boot change.

Private evidence: `inbox/optical-status-20260912-63touje1/` (0700, files 0600).
`vm310.conf` is the exact before/rollback source, identical to September 11.
`vm310-pending.txt` has current entries only. `host.json`, `guest.json`,
`workload.json`, `host-boundary.txt`, and `pve-help.txt` establish preflight.
Full device identifiers stay private. Capture subsequent steps additively.

LG WH16NS60 is the sole block descendant of ASMedia 0000:03:00.0,
1b21:0612, isolated IOMMU group 36 (only that function), driver ahci,
reset methods pm/bus advertised. Its host sr1/sg4 is held only by this VM's
QEMU. HP GUD1N remains on Intel 00:17.0 with both rpool members: forbidden.
rpool ONLINE, no known data errors. PBS is already unreachable; no new backup
or restore confidence is asserted or required for this reversible config delta.
USB port 1-13 identity is retained. No guest optical mounts/handles, encoding
processes, GPU handles, logged-in users, Docker installation, at queue, user
crontabs, custom hourly jobs, or systemd jobs were observed. Timers and running
services are OS services. Refresh inventory/workload immediately before shutdown.

## Exact mutation and rollback

1. `qm shutdown 310 --timeout 60 --forceStop 0`; require stopped. Never force-stop.
2. Recheck config, all controller descendants and released LG sr/sg handles.
3. `qm set 310 --hostpci2 0000:03:00.0,pcie=1 --delete ide2 --boot order=scsi0`.
   Use a freshly read PVE config digest to reject concurrent edits.
4. Require the full config delta to contain only hostpci2 addition, ide2
   removal and boot order removal of ide2, then `qm start 310`.

Preserve hostpci0/1, USB, all disks and every other setting exactly. No manual
/etc/pve edits, driver detach, PCI reset experiments, host restart, HP changes,
network/storage edits, ARM/Docker work or disc read/eject/mount/write.
PVE owns the controller binding needed by its hostpci assignment.

If attachment/start/acceptance fails, retain diagnostics, cleanly shut down the
VM if running, remove only hostpci2 via qm, restore exact captured ide2 and
boot properties via qm, and compare all properties before starting. If PVE
leaves the controller bound to VFIO and the old attachment cannot start, inspect
installed PVE recovery behavior before any additional driver action; no host
reboot or GPU reset is authorized. Preserve unrelated concurrent drift.

## Acceptance and canonical projection

Require running guest and completed root guest-agent inventory; native LG model
and exact preflight serial with paired sr/sg, alongside the original USB serial;
no QEMU DVD substitution. Require ASMedia guest ahci, host vfio-pci, HP/controller
and rpool retained, GPU xe/audio drivers and render node retained, media mounts
retained, direct management SSH available, no pending PVE edits, and full config
comparison. One clean shutdown/start tests realization; do not claim host reboot
or repeated VFIO lifecycle validation. No rip/encode test is in scope.

Create `evidence/2026-09-12-matrix-lg-passthrough.md`; update hv-cp
`CURRENT_STATE.md`, `docs/MATRIX_OPTICAL_DESIRED_STATE.md`, and link the previous
packet/runbook to this superseding LG-only scope. Preserve immutable evidence.

Under `/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-matrix/`:
- update `CURRENT_STATE.md`: observed LG/USB, HP limitation and evidence;
- update `VALIDATION.md`: tests, recovery and persistence limits;
- update `TODO.md`: LG completion, remaining HP work;
- update `README.md`: concise current optical status and route to evidence;
- `command-log/README.md`, `outputs/README.md`: not affected; existing evidence
  classifications unchanged, raw capture remains in hv-cp inbox;
- `NOTIFICATION_IDENTITY.md`, `NTFY_HEARTBEAT_MODE.md`: not affected; no
  notification change.

Run live-mutation runbook audit before apply and canonical heartbeat-profile
validator after projection. The subsequent operator request authorizes scoped
hv-cp commit/push of qualification evidence; see the
[downstream handoff](../docs/MATRIX_LG_QUALIFICATION_HANDOFF.md).

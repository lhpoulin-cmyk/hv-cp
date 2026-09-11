# Matrix three physical optical drives

Status: blocked before mutation; not execution-ready

PLAY: MATRIX_THREE_OPTICAL
CHECKPOINT: physical topology and host-storage boundary
STATUS: operator-authorized scope; safety gate failed
RESULT: all identities found; HP controller assignment forbidden; no mutation

## Authority and method

The operator explicitly authorized discovery, repository work, validation and
minimum necessary optical-only PVE changes to this VM. The same request
requires stopping when a proposed optical controller contains unrelated
storage/devices. This packet does not override that condition.

Source hv-cp HEAD: `61cab3416294ebbd9d8eda2ccff2403fc20ab56d`.
Origin fetched on 2026-09-11; origin/main:
`bfc3897880a87405302838408e596824de4e95ed`. The starting branch is two
commits ahead and three behind; incoming changes concern documentation and
licensing. Unrelated dirty work is preserved.

Execution procedure: [separate runbook](../runbooks/2026-09-11-matrix-three-optical.md).
Desired state: [three-drive contract](../docs/MATRIX_OPTICAL_DESIRED_STATE.md).
hv-cp owns the hardware decision; ansible-cp owns any admitted realization.
The inspected ansible-cp APPLY catalog contains no Matrix optical template.
No Semaphore task or unmanaged live mutation was launched. Before changing
status to execution-ready, establish the admitted execution path and exact
operator acknowledgement required by that path. Do not invent an existing
template or use an observation credential for APPLY.

## Exact target and before state

Host `hv-matrix`, strict SSH to management `192.168.10.22`, host-key alias
`hv-matrix.arpa`; existing operator identity. Proxmox identifies VM310 as
`b70-encode`; its running guest identifies as `b70-encode-matrix`, with matching
SMBIOS UUID. PVE 9.2.2, kernel 7.0.2-6-pve. Complete config was collected
twice and matched during discovery; no pending hardware changes were observed.

Private evidence root (local workstation, mode 0700):
`inbox/optical-20260911/`. Files are ignored, mode 0600, never staged:

- `vm310-before.conf`: complete PVE before configuration and rollback source.
- `orientation.txt`: compact host orientation, config, pending state and status.
- `host-inventory.json`: stable SATA identities, USB identity/topology, IOMMU,
  reset advertisement, driver, controller descendants, mounts and handles.
- `guest-root-inventory.json`: authoritative root-visible guest inventory.
- `guest-agent-result.json`: original guest-agent response.
- `guest-inventory.json`: preliminary unprivileged guest observation.
- `private-identity-manifest.json`: exact identity correlation and private selectors.
- `boundary-and-pve-help.txt`: repeated configuration, host rpool membership,
  controller/port evidence, guest SMBIOS check and installed qm help.
- `SHA256SUMS`: integrity manifest, generated after capture.

No complete serial, media content, secret or raw capture belongs in the Git
packet. Logical identities, correlations and exact controller boundaries are
in the desired-state document.

## Preconditions and permitted delta

All three identities must match fresh private capture. No mounted optical
media, active rip/encode/job, unknown device owner, or pending PVE edit may
remain before shutdown. The host's current sr1 handle is owned by this VM's
QEMU process through ide2; release is permissible only after an approved clean
VM shutdown, followed by a fresh zero-handle check. Never kill it to release
the drive. Workload checks are time-sensitive and must include application
queue/service state immediately before any shutdown; today's process snapshot
alone is not sufficient future shutdown proof.

Current topology fails the safety gate: Intel `00:17.0` owns HP GUD1N and both
rpool disks. No change is allowed under this packet's present status.

Conditional future delta, requiring revised reviewed packet after resolution:
add only the dedicated optical controller in an unused hostpci slot; preserve
usb0 after exact USB requalification; remove only the duplicate optical ide2
mapping and its boot-order entry if native attachment replaces it. Preserve
the system boot disk and every unrelated property. No final delta for HP is
selected yet; do not apply the partial LG change as three-drive completion.

Forbidden: hostpci0/1 changes, onboard SATA/xHCI controller assignment, host
storage, bridges, networking, other guests, VFIO reset experiments, optical
mount/eject/write/rip, Docker, ARM and media configuration. No host reboot is
authorized by this packet. Physical recabling is an operator-maintenance gate.

## Shutdown, acknowledgement and rollback

No shutdown/APPLY ceremony is requested while the safety gate fails.
No new acknowledgement string is treated as admitted. Before execution, name
the actual procedure/template, authenticated operator ceremony and exact ack.
Require a reviewed clean shutdown with no forced stop and recheck handles;
after bounded apply start the VM and validate all acceptance criteria.

Rollback is optical-property reversal through PVE, never overwriting
`/etc/pve`: stop only after rechecking jobs/authority; remove only newly added
optical hostpci properties, restore captured ide2/boot/usb values from the
private before config, then compare the entire resulting `qm config 310` with
the capture before restarting. Do not remove a slot that existed before this
task. Do not change GPU fields to obtain rollback. If unrelated drift exists,
stop and reconcile ownership rather than overwrite it. A physical recabling
change requires its own rollback and host-maintenance authority. Currently
rollback is a no-op because the complete configuration is unchanged.

## Post-change validation and canonical outputs

Require simultaneous three-drive physical identity correlation, block/SCSI
pairing, guest GPU driver presence, exact unchanged non-optical configuration,
host management access and retained rpool health. Observe no media mounts or
unexpected handles. Verify persistence by reviewed restart only when safe;
distinguish PVE persistent configuration from an actual reboot result.

Current task outputs (create): `CURRENT_STATE.md`, desired-state document,
this packet, linked runbook, read-only inventory helper and dated evidence.
Update `.gitignore` only to exclude private optical captures and Python cache.

Private canonical root:
`/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-matrix/`.
For this no-mutation discovery, `CURRENT_STATE.md`, `VALIDATION.md`, `TODO.md`,
`README.md`, `command-log/README.md`, `outputs/README.md`,
`NOTIFICATION_IDENTITY.md`, and `NTFY_HEARTBEAT_MODE.md` are not affected:
no accepted node change occurred. A revised live packet must declare updates
to `CURRENT_STATE.md`, `VALIDATION.md`, and `TODO.md` before execution and
retain the remaining paths as not affected with reasons. Run the canonical
validator now for structural baseline and again after any accepted mutation.

# Lore permanent P3 boot restoration — 2026-09-12 EDT

Status: completed; P3 boot and saved permanent preference accepted

PLAY: LORE_P3_BOOTNEXT
CHECKPOINT: P3 root and healthy pools verified after reboot
STATUS: COMPLETE
RESULT: permanent P3-first order restored after HP firmware normalization

Operator asked to change the boot environment remotely and confirmed local
console availability after the proposed one-time P3 UEFI selection and reboot.
The operator then explicitly directed “set it as permanent.” This covers
BootOrder with 0021 first, necessary clean container shutdown and one host reboot.
It does not authorize disk changes, forced imports,
BIOS VMX changes, GPU rebinding or guest repairs. No additional reboot scheduled.

Source HEAD `9e6638bc618df2cc3eaab9c37f4baf299a84e7a1`; origin fetched in this
session; origin/main `704db7564b054ea3aee5e9108f734fde8c9de312` (four ahead/four
behind). Published main adds optical scope/README/license; no conflicting Lore
boot procedure. Preserve all unrelated dirty work in hv-cp and private records.
Procedure: [separate runbook](../runbooks/2026-09-12-hv-lore-p3-bootnext.md).

## Target and proof

Strict SSH to hv-lore/192.168.10.20 using existing hv-lore.arpa ED25519 key
for the currently running historical NVMe installation. Existing IP trust key
is expected after returning to P3; never weaken checking or replace keys.
Private capture: `inbox/lore-p3-boot-20260912-y89ncr_y/`.
Before boot ID, BootOrder and exact P3 identities are in preflight.json;
entry-task-details.txt correlates Boot0021 Pci(0x1f,0x2)/Sata(0,0,0) to the
P3-256 at pci-0000:00:1f.2-ata-1.0. Both P3 disk serials match the accepted
node record and partition 3 labels identify desired rpool GUID
4137356908105663872. Current active rpool is historical GUID
8921639095104950851, ONLINE. Existing BootCurrent=000C and BootNext absent.
No need to create an entry, mount an ESP, import a pool or edit boot files.

All ten VMs are stopped; seven CTs (243,245,246,247,248,249,252) running.
Recent task evidence shows automatic VM starts failed due to unavailable KVM;
backup attempt ended in failure due to unreachable PBS. No active systemd jobs
or disk transfer/encode/package-manager process observed. Require fresh active
PVE task list empty before shutdown. The first attempted task flag --running
was unsupported; do not interpret that error as an empty task list.

## Mutation and recovery

1. Recheck current boot identity, exact EFI entry/BootOrder, active task absence.
2. Cleanly shut down each running CT via pct shutdown with 60-second timeout
   and forceStop=0; require all guests stopped. Do not force a failed shutdown.
3. Set BootOrder to 0021 followed by every original entry except 0021, preserving
   their relative order, using efibootmgr --bootorder. Set --bootnext 0021.
   Verify both exact values, then systemctl reboot through normal shutdown.
4. Reconnect using strict expected P3 IP host key. Require new boot ID,
   BootCurrent=0021 (or investigate firmware representation), consumed BootNext,
   intended permanent BootOrder, root from desired P3 rpool GUID, both P3 mirror members
   healthy, management address/routes and PVE services available. Report guest,
   KVM and storage status without starting guests or forcing pool activation.

If guest shutdown fails, stop before reboot, retain evidence and recover only
cleanly stopped CTs to their before-state when safe. If BootNext is set but
reboot is cancelled, delete only the newly set BootNext and restore the exact
captured original BootOrder via efibootmgr --bootorder.
After a failed boot the operator uses the confirmed HP local console boot menu
to choose P3-256 or the original NVMe entry 000C. Do not repeatedly reboot or
force-import either identically named rpool. VMX/VT-d/GPU changes remain outside scope. No known_hosts edits.

## Evidence and canonical projection

Create `evidence/2026-09-12-hv-lore-p3-bootnext.md` with exact exits and results;
retain all private raw captures and checksums. Under
`/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-lore/`:
update CURRENT_STATE.md (boot environment), VALIDATION.md (boot/management
acceptance and limits), TODO.md (permanent boot acceptance and remaining BIOS/guest work),
README.md (concise current state). Preserve pre-existing changes in each file.
command-log/README.md and outputs/README.md not affected: classification remains
unchanged; captures stay in hv-cp inbox. NOTIFICATION_IDENTITY.md and
NTFY_HEARTBEAT_MODE.md not affected: no identity or notification configuration
change. No cross-node inventory change. Run runbook audit before mutation and
canonical heartbeat validator after the documented outcome. No commit/push.


## Execution finding

P3 BootCurrent=0021 and expected P3 rpool returned after one normal reboot.
Firmware rearranged BootOrder (including an inactive Startup Menu entry) during
boot. After proving P3 root, the authorized exact P3-first order was reapplied
and verified. No second reboot is performed solely to test firmware ordering.
VMX remains unavailable; existing destination autostart proceeds independently.

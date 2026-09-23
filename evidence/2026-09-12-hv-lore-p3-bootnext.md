# Lore permanent P3 boot restoration — 2026-09-12 EDT

Classification: immutable boot-change acceptance evidence. Result: PASS for
P3 boot restoration and saved permanent P3-first preference; not whole-host
or guest service acceptance.

Authority: operator requested remote return to P3, confirmed local-console
recovery access, then explicitly directed “set it as permanent.”
[Packet](../implementation/2026-09-12-hv-lore-p3-bootnext.packet.md),
[runbook](../runbooks/2026-09-12-hv-lore-p3-bootnext.md).
Private exact captures: `inbox/lore-p3-boot-20260912-y89ncr_y/`, mode 0700,
files 0600, ignored, SHA256SUMS. No raw serial or credential publication.

## Verified target and mutation

The active before environment was the historical Timetec rpool GUID
8921639095104950851. Existing UEFI Boot0021 P3-256 hardware path
Pci(0x1f,0x2)/Sata(0,0,0) correlated to the exact documented P3 disk through
udev pci-0000:00:1f.2-ata-1.0. Both P3 disk serials and partition labels matched
the accepted P3 mirror. No ESP mount, new boot entry or pool import was needed.

Fresh active PVE tasks returned [] using the installed --source active option;
the earlier unsupported --running query was corrected before relying on it.
All ten VMs were already stopped. Each of CT248,249,247,246,245,243,252 was
cleanly shut down with `pct shutdown ID --timeout 60 --forceStop 0` and its
stopped status verified. Every command exited 0. No forced stop occurred.

`efibootmgr --bootorder ORDER` put 0021 first and retained every other original
entry in its original relative order. `efibootmgr --bootnext 0021` selected P3
for the immediate restart. Both commands and exact readback exited 0. Then
`systemctl reboot` exited 0. One normal host reboot occurred. No guest onboot,
VMX, driver, storage or boot-file configuration was changed.

## Acceptance and firmware behavior

Strict SSH returned using the existing IP-based P3 host key; no trust changes
or verification bypass were used. New boot ID differs from before.
Host uptime reports boot at **2026-09-12 22:03:27 EDT**. BootCurrent=0021;
BootNext was consumed. Root is rpool/ROOT/pve-1 on expected P3 GUID
4137356908105663872, with both exact P3 mirror members ONLINE and zero errors.
The historical Timetec rpool is not listed as active. jellyPool is also ONLINE
with no errors under the intended installation's existing boot policy; no manual
or forced import was run.

The first after-boot exact-order assertion failed because HP firmware reordered
entries, including prepending its inactive Startup Menu. P3 remained the selected
BootCurrent and first active boot entry. To satisfy the exact requested saved
preference, after proving P3 root the complete intended P3-first BootOrder was
reapplied and verified, then independently read again at 22:05:13 EDT. All
commands exited 0. There was no second reboot. Future firmware normalization
is not ruled out; a permanent preference is saved, but repeated reboot behavior
is not claimed.

PVE manager 9.2.2 / kernel 7.0.2-6-pve matches the P3 installation. Core
pveproxy/pvedaemon/pve-cluster services are active. Management remains
vmbr0/192.168.10.20 and the existing route; storage network remains
192.168.100.20. Initial after-boot systemctl --failed listed no units.

## Remaining conditions

VMX remains unavailable (/dev/kvm absent). All ten VMs were stopped at final
capture; the existing PVE startall task was still running. Five CTs were running
(243,245,246,247,252), with 248/249 stopped at that time. These are startup-time
observations, not a completed guest fleet health result. No manual start, KVM
workaround, GPU reassignment or workload repair was performed. CPU virtualization
and changed GPU topology require separate scoped follow-up. The existing
normal autostart policy was preserved, not fabricated from the old installation.

No permanent-order rollback was needed. Exact prior BootOrder and original
NVMe entry remain in private evidence for confirmed-console recovery. Boot
restoration does not authorize retirement of historical storage or a force import.

Canonical CURRENT_STATE, VALIDATION, TODO and README were updated while
preserving unrelated edits. The heartbeat-profile canonical validator passed;
runbook audit and whitespace/link checks passed. No commit or push was requested.

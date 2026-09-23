# Lore RTX 5060 assignment to Jellyfin — 2026-09-12 EDT

Status: completed — host attachment accepted; guest driver/transcode not qualified

Authority: operator “pass the 5060 through to jellyfin,” followed by operator
VT-x/VT-d firmware work and confirmed local console. Owner: hv-cp VM attachment.
Source HEAD 9e6638bc618df2cc3eaab9c37f4baf299a84e7a1; fresh origin fetch gives
main 704db7564b054ea3aee5e9108f734fde8c9de312. Divergent local optical work is
preserved; no packet template consumed and no commit/push authorized here.
[Runbook](../runbooks/2026-09-12-hv-lore-jellyfin-5060.md).

Target: hv-lore via existing strict SSH, P3 rpool GUID 4137356908105663872
ONLINE, BootCurrent/first BootOrder 0021. VM130 jellyfin-lore, running,
SeaBIOS/machine pc, vga std. KVM present; VT-d and IRQ remapping enabled.
GPU 0000:09:00.0 10de:2d05 PNY 196e:1448 RTX 5060 and audio
0000:09:00.1 10de:22eb occupy IOMMU group 99 exclusively. No VM currently
claims them. VM140 has unrelated stale 04:00 mappings; leave it stopped.

Bounded change: clean shutdown VM130 without force, then add hostpci0 with
both 09:00 functions in conventional PCI mode, preserving firmware, machine,
virtual VGA, disks and NICs; start and inspect guest PCI, kernel and Jellyfin.
No host reboot, host driver installation, ACS override, unsafe interrupts,
manual reset, boot/storage/network change or unrelated guest mutation.
Guest NVIDIA driver and actual hardware transcode are separate acceptance
checks; never infer them from PCI enumeration. No package installation in
this attachment packet. Rollback removes only the new hostpci0 after clean
VM shutdown and starts original VM; operator console is fallback recovery.

Evidence: ignored inbox/lore-5060-assignment-* exact command/output/exit logs;
create evidence/2026-09-12-hv-lore-jellyfin-5060.md. Canonical root
/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-lore/:
update CURRENT_STATE.md, VALIDATION.md, TODO.md, README.md for returned host,
virtualization readiness, attachment and driver/transcode limitations.
command-log/README.md, outputs/README.md, NOTIFICATION_IDENTITY.md and
NTFY_HEARTBEAT_MODE.md not affected: evidence classification and notification
identity/configuration unchanged. Audit runbook link before mutation; validate
canonical heartbeat profile and inspect scoped diffs after projection.

Completion validation: pre-execution runbook audit passed; exact before/after
VM config comparison passed (only hostpci0, excluding derived digest); final
canonical heartbeat-profile validator passed for hv-lore; git diff --check
passed. [Immutable result](../evidence/2026-09-12-hv-lore-jellyfin-5060.md).
Guest driver/transcode work remains explicitly unqualified; attachment and
service recovery are accepted. No commit or push performed.

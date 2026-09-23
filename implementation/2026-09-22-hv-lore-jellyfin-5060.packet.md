# Lore Jellyfin RTX 5060 reassignment — 2026-09-22

Status: completed; assignment, driver access, service health and documentation accepted.
Authority: Louis, current session, “please re-assign it” to Jellyfin on hv-lore.
Owner: hv-cp. Runbook: [reassignment procedure](../runbooks/2026-09-22-hv-lore-jellyfin-5060.md).

Source HEAD 9e6638bc618df2cc3eaab9c37f4baf299a84e7a1; fresh fetch origin/main
704db7564b054ea3aee5e9108f734fde8c9de312, 4 ahead/4 behind. Existing dirty
work preserved. Work contract read from untracked local repo-cp
`docs/AGENT_WORK_CONTRACT.md` at repository HEAD
25be360064f87d5cef52e5304da332861a9980e9; those bytes are unpublished.
Historical assignment/removal and current September 22 recovery records read.

Target: strictly authenticated hv-lore, P3 rpool GUID 4137356908105663872,
boot ID b8080a8f-47a0-4aa2-a1fb-24f21452a89d; VM130 jellyfin-lore,
running, SeaBIOS/pc, vga std. RTX 5060 0000:09:00.0 10de:2d05 PNY
196e:1448 and audio 0000:09:00.1 10de:22eb share an otherwise empty IOMMU
group. No current VM hostpci entries. KVM, IOMMU and IRQ remapping enabled.
Guest Jellyfin active and Healthy, NVIDIA software retained, no ffmpeg found.

Change: back up original config privately; cleanly stop VM130 without force,
add only hostpci0 `0000:09:00.0;0000:09:00.1,pcie=0` with current digest,
and start. Preserve all other config, host boot/network/storage and other VMs.
No packages, guest settings, host reboot, unsafe VFIO options or manual PCI reset.
Check no conflicting active task or new GPU owner immediately before mutation.
Rollback: cleanly stop VM130 if necessary, remove only new hostpci0 with
current digest, restart original VM. Host SSH is the independent management
and rollback path; if it fails, stop for operator physical console recovery.

Acceptance: exact config delta; running VM; guest sees RTX 5060 and NVIDIA
driver; Jellyfin /health Healthy; fresh management SSH and healthy P3 pool;
unchanged host boot ID, unrelated VM states/PIDs and configuration. Report
hardware decode separately if tested; assignment alone is not playback proof.
Private receipts: inbox/lore-5060-reassign-20260922/. Immutable evidence:
evidence/2026-09-22-hv-lore-jellyfin-5060.md.

Canonical output root:
/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-lore/
- README.md: update current GPU/service status.
- CURRENT_STATE.md: update current assignment and evidence boundary.
- VALIDATION.md: update verified checks and limitations.
- TODO.md: update completed reassignment and remaining tests.
- command-log/README.md: not affected; classification unchanged.
- outputs/README.md: not affected; classification unchanged.
- NOTIFICATION_IDENTITY.md: not affected; identity unchanged.
- NTFY_HEARTBEAT_MODE.md: not affected; heartbeat unchanged.
Update hv-cp CURRENT_STATE.md; no role/address/publication changes requiring
cross-node inventory updates. Run audit-live-mutation-runbooks.sh before
execution, heartbeat node validator and scoped whitespace/diff review after.
No commit or push.

Completion: [immutable evidence](../evidence/2026-09-22-hv-lore-jellyfin-5060.md).
Runbook audit before execution, exact config/unrelated VM continuity checks,
NVIDIA access and Jellyfin health passed. Canonical heartbeat validator and
whitespace review passed. Playback/transcode not tested. No commit or push.

# Jellyfin RTX 5060 driver and Arc cleanup — 2026-09-12 EDT

Status: completed — NVIDIA driver, Arc cleanup and bounded GPU decode PASS

Authority: operator “get the driver situation sorted out. remove the old arc
drivers too,” with explicit acceptance correction “decode.” Target only guest
VM130 jellyfin-lore on hv-lore, through strict host SSH and qm guest exec.
Source HEAD 9e6638bc618df2cc3eaab9c37f4baf299a84e7a1; fresh fetch main
704db7564b054ea3aee5e9108f734fde8c9de312. Preserve unrelated dirty state.
[Runbook](../runbooks/2026-09-12-hv-lore-jellyfin-nvidia-driver.md).

Install Ubuntu repository NVIDIA open kernel driver selected from current
supported hardware/package metadata, including required decode user libraries.
Review apt simulation before changes. Remove explicit Arc userspace GPU tools,
VA driver and OpenCL packages; preserve CPU microcode, shared libraries and
kernel-owned Intel modules required by distribution packages. Do not remove
Jellyfin or kernel metapackages. No blanket autoremove or third-party installer.
Refresh package indexes if necessary. Configure Jellyfin's acceleration backend
for NVIDIA with backup and stopped-service edit, preserving unrelated options.
Clean guest restart authorized as needed; no host restart or other VM change.

Acceptance: nvidia driver bound to 10de:2d05, nvidia-smi healthy; bounded real
NVDEC operation as jellyfin user with generated non-library fixture, decoded
frames verified and no software fallback. Final Jellyfin /health succeeds.
Record codec limitations honestly. Fixture generation may use software encoding
solely to supply the explicitly requested hardware decode check. Preserve
exact commands and exits privately; inspect guest/host errors during tests.
Rollback: restore encoding.xml backup, revert exact changed packages from
recorded versions if necessary, preserve working service and existing passthrough;
use clean VM restart and host SSH recovery, never force-stop or modify storage.

Create evidence/2026-09-12-hv-lore-jellyfin-nvidia-driver.md. Update canonical
/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-lore/
CURRENT_STATE.md, VALIDATION.md, TODO.md, README.md. command-log/README.md,
outputs/README.md, NOTIFICATION_IDENTITY.md, NTFY_HEARTBEAT_MODE.md not affected:
no evidence classification or notification changes. Run linked-runbook audit,
canonical heartbeat validator, scoped whitespace/link checks. No commit/push.

Observed maintenance detail: initial systemctl stop refused (guest exit 4),
without changing encoding.xml. Existing infrastructure node operating note
nodes/hv-lore/command-log/2026-05-30-jellyfin-manual-stop-guard.md explicitly
prescribes temporarily overriding RefuseManualStop for intentional maintenance,
then restoring it. Use unique /run systemd drop-in with cleanup trap, preserving
the permanent guard byte-for-byte; verify RefuseManualStop=yes afterward.
This is the documented maintenance path within the authorized driver work.

Completion: [immutable evidence](../evidence/2026-09-12-hv-lore-jellyfin-nvidia-driver.md).
Driver install and Arc purge both guest exit 0; three bounded CUDA decode tests
60/30/60 frames with zero decode errors passed as jellyfin. Configuration delta
and final health/guard/package checks passed. Canonical heartbeat validator,
scoped private/hv-cp diff checks, helper shell syntax and local link checks
passed. Pre-execution live-runbook audit passed. Unrelated work preserved;
no commit/push. Client playback and hardware encode not asserted.

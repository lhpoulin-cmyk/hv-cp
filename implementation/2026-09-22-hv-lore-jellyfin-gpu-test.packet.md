# Jellyfin GPU transcode qualification — 2026-09-22

Status: completed; bounded GPU decode/encode and continuity accepted.
Authority: operator requested “please test” after reassignment.
Owner: hv-cp, bounded VM130 jellyfin-lore test on hv-lore via existing strict SSH/QGA.
[Runbook](../runbooks/2026-09-22-hv-lore-jellyfin-gpu-test.md).
HEAD 9e6638bc618df2cc3eaab9c37f4baf299a84e7a1; refreshed origin/main
704db7564b054ea3aee5e9108f734fde8c9de312. Existing dirty work preserved.

Confirm running VM130, assigned 09:00.0/1, NVIDIA RTX 5060 and healthy Jellyfin.
Run installed Jellyfin FFmpeg as jellyfin with short generated 720p fixtures:
H.264 and HEVC Main10 GPU decode, and H.264/HEVC NVENC transcodes.
Require CUDA hardware frames and explicit NVENC encoders; verify encoded outputs
by independent software decode/frame counts. No media-library input, service
restart, driver/package/config change, host or unrelated VM mutation.
Temporary test files only in a new guest /tmp directory, removed in finally.
Timeout each subprocess; rollback is cleanup of only that created directory.
Inspect selected acceleration XML fields only, never credentials.

Positive: hardware decode/encode exit zero and expected frame counts, service
Healthy afterwards, no new GPU errors. Negative boundary: no software fallback
accepted; no user media used; unchanged host boot and VM config, service PID.
This does not prove a client playback session, HDR handling or sustained capacity.
Evidence: evidence/2026-09-22-hv-lore-jellyfin-gpu-test.md;
raw logs: ignored inbox/lore-gpu-test-20260922/.
Canonical root /home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-lore/:
- README.md: update bounded test status.
- CURRENT_STATE.md: update GPU qualification.
- VALIDATION.md: update test results and limitations.
- TODO.md: update completed test and remaining client/sustained checks.
- command-log/README.md and outputs/README.md: not affected; classifications unchanged.
- NOTIFICATION_IDENTITY.md and NTFY_HEARTBEAT_MODE.md: not affected; no identity/heartbeat change.
Reconcile hv-cp CURRENT_STATE.md. Run runbook audit before execution; heartbeat
node validator and scoped whitespace/diff review after. No commit/push.

Completion: [evidence](../evidence/2026-09-22-hv-lore-jellyfin-gpu-test.md).
All five GPU paths and independent output checks passed; service Healthy.
Canonical validation passed; client playback and sustained capacity untested.

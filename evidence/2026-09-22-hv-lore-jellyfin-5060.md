# Lore RTX 5060 reassigned to Jellyfin — 2026-09-22

Result: PASS for VM assignment, NVIDIA service-user access and Jellyfin health.
Operator request: “please re-assign it,” referring to RTX 5060 on hv-lore.
[Packet](../implementation/2026-09-22-hv-lore-jellyfin-5060.packet.md) and
[runbook](../runbooks/2026-09-22-hv-lore-jellyfin-5060.md) governed the change.
Source hv-cp HEAD 9e6638bc618df2cc3eaab9c37f4baf299a84e7a1; freshly fetched
origin/main 704db7564b054ea3aee5e9108f734fde8c9de312, four ahead/four behind.
Canonical private repository HEAD c8ec8aa5e1de9a513ea60a6caaecba8740d0c1a9;
preexisting dirty documents preserved and extended. Outputs are local/uncommitted.

## Before and change

Strict SSH verified hv-lore, P3 rpool GUID 4137356908105663872 ONLINE,
boot ID b8080a8f-47a0-4aa2-a1fb-24f21452a89d. PVE 9.2.2, kernel 7.0.2-6-pve.
GPU 09:00.0 10de:2d05 PNY 196e:1448 and audio 09:00.1 10de:22eb were
unassigned and alone together in their IOMMU group. KVM, IOMMU and IRQ
remapping enabled. Eleven VM raw configurations had no hostpci or snapshot
sections. VM130 had no pending config; Jellyfin active/Healthy, no ffmpeg.
Installed task API uses `--source active`; initial unsupported `--running`
query failed read-only and was corrected after installed interface inspection.
Fresh active task list was empty immediately before mutation.

Root-only backup directory /root/lore-5060-reassign-20260922T202005Z contains
130.conf and before.json (all VM configs and runtime states/PIDs). At 20:20 UTC,
`qm shutdown 130 --timeout 120 --forceStop 0` succeeded and stopped state was
verified. Config digest remained 994c368057f5ed4d678ad3fba380538db3227b19.
`qm set 130 --hostpci0 '0000:09:00.0;0000:09:00.1,pcie=0' --digest ...`
succeeded. `qm start 130` succeeded. No host reboot or forced stop.

## Verification

Fresh SSH assertions and captured guest results establish:

- VM130 running; exact API config delta is only hostpci0 (excluding derived
  digest). Raw 130.conf differs only by the new hostpci0 line.
- All ten unrelated VM configs byte-identical, states/PIDs unchanged, including
  running TrueNAS VM120. VM140 remains running without passthrough.
- Host boot ID unchanged. P3 rpool ONLINE, both members zero error counters,
  no known data errors. Independent management SSH passed.
- Guest graphics at 00:10.0 binds nvidia, audio at 00:10.1 binds snd_hda_intel.
  `nvidia-smi` as jellyfin succeeds: RTX 5060, 595.91.07, 8151 MiB.
- Jellyfin active, /health Healthy, RefuseManualStop=yes. Initial curl exit 7
  occurred before HTTP listener readiness; startup finished normally at
  20:21:17 UTC, with NRestarts=0 and later guest verification exit 0.
- Captured current-boot guest kernel shows successful NVIDIA initialization
  with expected out-of-tree/signature taint notices, no Xid/GSP initialization
  failure. Host mutation window shows VFIO resets completed, no captured
  IOMMU/BAR/reset failure.

No package or guest application configuration changes, disk/network changes,
manual PCI resets or unrelated guest mutations. No client playback, GPU decode
or encode workload was tested; September 12 decode tests remain historical.
Service startup log includes a WebRootPath warning; /health passes, web UI
rendering was not tested. This attachment task does not accept UI behavior.

## Custody and documentation

Private ignored receipts: inbox/lore-5060-reassign-20260922/preflight.json,
assignment.log, verification.log (initial early health failure),
service-startup.log, verification-final.log. Final SSH exit 0; nested guest
health/driver exit 0, untruncated. Local scripts retained alongside receipts.
Runbook audit passed for this execution-ready packet before mutation.
Canonical README, CURRENT_STATE, VALIDATION and TODO updated, superseded
removal statements reconciled. Heartbeat documentation validator for hv-lore
and whitespace checks passed. No commit or push; live assignment is verified.

# Lore VM130/140 PCI removal — 2026-09-14

Status: completed; explicitly authorized by operator to back up both VM
configurations, gracefully stop either running VM, remove all their hostpci
entries, verify all Lore VM configs including pending changes, preserve NAS
and unrelated settings, and never reboot the host.

Source HEAD 9e6638bc618df2cc3eaab9c37f4baf299a84e7a1; freshly fetched origin/main
704db7564b054ea3aee5e9108f734fde8c9de312. Existing branch and dirty work preserved.
[Runbook](../runbooks/2026-09-14-hv-lore-remove-pci.md).

Preflight: strict SSH hv-lore, accepted P3 rpool GUID 4137356908105663872 ONLINE.
VM130 running with hostpci0 09:00.0/1; VM140 stopped with hostpci0/1 04:00.0/1.
NAS VM120 running. Owner hv-cp. Backup root /root/hv-lore-pci-removal-20260914.
Backups precede shutdown; only qm interfaces mutate VM settings. Graceful
shutdown timeout does not authorize forced stop. Leave both target VMs stopped.
Do not change onboot, startup, disks, networking, host drivers, or NAS services.

Positive test: full configuration comparison proves only hostpci deletions;
all config sections and pending APIs contain no hostpci entries. Negative test:
other VM configuration bytes and runtime PIDs/states unchanged. Independent
management: fresh strict SSH and unchanged host boot ID. Rollback materials are
root-only original configs; any restoration must use qm and revalidate device
identities, never blindly restore stale PCI assignments or rewrite /etc/pve.

Create evidence/2026-09-14-hv-lore-remove-pci.md; update CURRENT_STATE.md.
Canonical root /home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-lore/:
update README.md, CURRENT_STATE.md, VALIDATION.md, TODO.md with removal,
stopped target VMs and supersession of prior GPU attachment status.
command-log/README.md, outputs/README.md, NOTIFICATION_IDENTITY.md and
NTFY_HEARTBEAT_MODE.md not affected: identity and evidence policy unchanged.
Run live-mutation runbook audit before execution and canonical heartbeat
validator after documentation projection. No commit/push requested.

Completion: all runtime assertions passed; NAS middleware/NFS/SMB active;
canonical heartbeat validator and scoped whitespace checks passed.

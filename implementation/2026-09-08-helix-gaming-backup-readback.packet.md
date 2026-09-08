# Helix-gaming encrypted backup readback transport

Status: complete; temporary readback mount removed

Operator authority: complete helix-gaming Bazzite filesystem backup to Lore,
including ordinary capture and restore verification; preserve Windows jobs.
ws-cp owns recovery semantics and truenas-cp owns the existing export. hv-cp
owns this bounded temporary client mount, needed because Hadrian direct NFS
readback measures only 1.3 MB/s while capture writes continue normally.

Follow [the runbook](../runbooks/2026-09-08-helix-gaming-backup-readback.md).
Observed HEAD 864bc35468ff42f7b28dc4de6494169eeca91f3e; preserve unrelated
dirty work. No VM, service, firewall, persistent storage, or key change.

Create only /mnt/helix-gaming-readback-20260908T045622Z on hv-lore and mount
the already exported steam.incoming read-only with nosuid,nodev,noexec.
Read only .helix-gaming-fs-20260908T045622Z payloads through existing pinned
Hadrian SSH. Test a bounded encrypted boot read first. If export admission
fails, do not alter it. Unmount and remove the exact empty mountpoint afterward.

# Lore P3 boot repair — 2026-09-21 EDT

Status: P3 service restored; persistent configuration verified; unattended reboot test pending

PLAY: LORE_P3_BOOT_REPAIR
CHECKPOINT: P3 service restored and persistent boot configuration verified
STATUS: BOOT_ACCEPTANCE_PENDING
RESULT: recovery succeeded; unattended reboot acceptance remains pending

Operator authorized clean guest shutdown and reboot with console available,
then explicitly directed “option 1, make it permanent”. This authorizes P3-first
persistent BootOrder, a one-time matching BootNext, and a normal reboot.
No disk deletion, pool import, trust change, credential issuance or guest repair.
Source HEAD 9e6638bc618df2cc3eaab9c37f4baf299a84e7a1; fetched origin/main
704db7564b054ea3aee5e9108f734fde8c9de312, four ahead/four behind.
Remote changes concern optical documentation/license; no boot-procedure conflict.
Unrelated dirty state is preserved.

Use [the runbook](../runbooks/2026-09-21-hv-lore-p3-boot-repair.md).
Capture location: ignored inbox/lore-p3-20260921, owner-only JSON receipts.
Current root GUID 8921639095104950851 and BootCurrent 000C identify Timetec.
Existing strict historical hv-lore.arpa key authenticates diagnosis only.
Both exact P3 members match pool GUID 4137356908105663872 in on-disk labels.
Current Boot001B maps Pci(0x1f,0x2)/Sata(0,0,0) to P3 serial
9760511210658 through pci-0000:00:1f.2-ata-1.0. The other member is
9760522200232. Historical Boot0021 is now network boot; never reuse it.
Wait for active PVE tasks to complete before clean shutdown.

Canonical paths under helix-arpa-private/nodes/local-compute/hv/hv-lore/:
- README.md: update concise accepted status.
- CURRENT_STATE.md: update current boot, saved preference and limits.
- VALIDATION.md: update dated acceptance.
- TODO.md: update completed restoration and firmware recurrence limit.
- command-log/README.md and outputs/README.md: not affected; classification unchanged.
- NOTIFICATION_IDENTITY.md and NTFY_HEARTBEAT_MODE.md: not affected; no identity change.
Update hv-cp/CURRENT_STATE.md and create dated evidence. Cross-node inventory
not affected: no identity/address/role change. No commit or publication requested.

Execution refinement: leave BootNext absent so the authorized reboot tests
the permanent BootOrder itself. No one-time override masks its behavior.

## USB console recovery continuation — 2026-09-22

Operator explicitly directed proceeding with the proposed backed-up P3 boot-menu
repair after pointing out that inspection had not fixed either boot or menu.
Authorized bounded next mutation: on verified P3 serial 9760511210658 ESP,
UUID D24B-C1DB (USB session /dev/sdc2, mounted /mnt/p3-efi), preserve and
compare a backup of grub/grub.cfg, change zero-second GRUB timeout assignments
to 15 seconds, verify the diff and remount read-only before boot testing.
This is a temporary recovery edit to a generated ESP file; after successful
P3 recovery, reconcile the owning configuration and proxmox-boot-tool outputs.
No force import, reinstall, trust change, or data-pool mutation is authorized.
Execution and menu acceptance are pending operator console results.
Follow the USB menu recovery section of the linked runbook.

### Successful diagnostic boot and persistent reconciliation

Operator confirmed the 15-second menu appeared, removed quiet,
video=vesafb:off, video=efifb:off and initcall_blacklist=sysfb_init for one
boot, and reported Lore and PVE web UI online. Strict existing-key SSH
confirmed P3 GUID 4137356908105663872, both mirror members ONLINE without
reported errors, BootCurrent 001B and P3-first BootOrder. This supports
persisting that exact successful parameter combination, not attributing the
failure to any one removed parameter. Existing authorization to repair boot
and make it permanent covers /etc/default/grub backup, timeout 15 and removal
of those four tokens, followed by installed proxmox-boot-tool refresh and
read-only verification of both registered P3 ESPs. Preserve IOMMU and root
arguments. Do not reboot automatically while documenting restored service.
An unattended boot using the persisted configuration remains a separate
acceptance check to schedule with the operator after service restoration.

## Historical P3 boot repair checkpoint — 2026-09-22 EDT

This checkpoint precedes the recovery result below and is retained as history.

Operator authorized clean shutdown, confirmed console availability and requested
permanent P3 boot. Timetec root GUID 8921639095104950851 was active again;
current EFI P3 entry is 001B, independently matched to exact P3 disk hardware
and pool GUID 4137356908105663872 on both member labels. Historical entry 0021
now means IPv6 network boot and must not be replayed.

The old installation's scheduled backup was already running when inspected;
the agent did not launch a backup, cancel it, or change backup configuration.
It completed before shutdown (job contained failures from stale guest/storage
configuration; backup health is not accepted). Seven containers and five VMs
were shut down cleanly, with no forced stops. Permanent BootOrder was written
and read back with 001B first, preserving every other entry and relative order.
BootNext remained absent to test the permanent preference directly. One normal
reboot command succeeded. Operator reports console at “loading initram”.

Acceptance is PENDING: management ARP/ping/SSH have not returned. P3 root,
post-reboot BootCurrent, firmware persistence and guest health are not yet
verified. Do not treat earlier dated P3 acceptance as this boot's live state.
Host trust, credentials, disks, pools and guest configuration were unchanged
by this repair. No issuance, adoption, secret extraction or custody recovery.
Source: hv-cp/implementation/2026-09-21-hv-lore-p3-boot-repair.packet.md;
private receipts: hv-cp/inbox/lore-p3-20260921/.

## Recovery result — 2026-09-22

## Lore recovered on P3; persistent boot settings saved — 2026-09-22 EDT

Lore is online on rpool/ROOT/pve-1, pool GUID 4137356908105663872.
Both P3 mirror members are ONLINE with zero reported read/write/checksum
errors and no known data errors. BootCurrent is 001B and saved BootOrder
still starts with 001B. Boot ID: b8080a8f-47a0-4aa2-a1fb-24f21452a89d.
Operator observed the repaired menu and successful PVE web UI access.
Ordinary strict SSH and nonissuing `reauth --check hv-lore` passed.
pveproxy, pvedaemon and pve-cluster are active; no failed systemd units listed.

Successful boot omitted quiet, video=vesafb:off, video=efifb:off and
initcall_blacklist=sysfb_init. The individual causal parameter remains
unisolated. The same combination is now persisted in /etc/default/grub with
GRUB_TIMEOUT=15, preserving IOMMU and root arguments. The installed
proxmox-boot-tool refresh succeeded for both registered P3 ESPs D24B-0CBC
and D24B-C1DB. Read-only checks passed GRUB syntax, menu timeout (15 seconds
normally, 30 on its existing failure branch), root selection and kernel
parameters on both ESPs. The firmware's separate zero-second timeout is
unchanged. Backup: /root/lore-boot-recovery-20260922T054515Z/grub.before.

Remaining acceptance: an unattended reboot using the persisted configuration
has not yet been performed. Lore remains running; the successful boot used
an equivalent one-time editor change. Do not represent this as an unattended
reboot test or proof against firmware resets. USB inspection did not force
import any pool, rewrite an initramfs or reinstall. No trust/credential change.

Guest snapshot: VMs 120, 130 and 260 running; CTs 243, 245, 246, 247, 248 and
252 running; CT249 and other listed VMs stopped. Guest application health
was not independently accepted by this recovery. Earlier stopped-state
statements below are dated historical observations.
Evidence: hv-cp/evidence/2026-09-22-hv-lore-p3-recovery-online.md.

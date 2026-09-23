# Lore P3 recovery and persistent boot configuration — 2026-09-22

Classification: immutable recovery observation.

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

Source HEAD 9e6638bc618df2cc3eaab9c37f4baf299a84e7a1; refreshed origin/main 704db7564b054ea3aee5e9108f734fde8c9de312 (4 ahead/4 behind). Existing dirty work preserved. Remote persistence receipt: inbox/lore-p3-20260921/persist-boot-result.json. USB-console findings came from operator photographs; final state and generated-file checks came from strictly authenticated SSH.

The USB lacked zstd: lsinitramfs succeeded after media package extraction into RAM, so its initial decompression error was not proof of damaged initramfs. The embedded pool cache identified both correct P3 members. The main scripts/zfs stub was present; no script repair was justified by the partial local-top inspection.

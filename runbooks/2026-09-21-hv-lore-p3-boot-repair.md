# Lore P3 boot repair

Requires [operator-authorized packet](../implementation/2026-09-21-hv-lore-p3-boot-repair.packet.md).

1. Preserve exact BootOrder, boot ID and public identity evidence in private
   receipts. Match current EFI hardware path to exact P3 disk and both on-disk
   pool labels. Do not mount/import the inactive pool.
2. Require no active PVE backup or guest-management tasks; an open vncshell
   console session is not guest-management work and is preserved. Cleanly stop containers with pct shutdown, then VMs with qm shutdown
   (NAS and backup-server VMs last), timeout 60, forceStop 0; verify each stopped.
   Recheck every guest and active task before boot mutation. Shutdown failure
   requires diagnosis, not forced termination.
3. Recheck root, BootOrder and Boot001B hardware identity. Preserve all entries
   and their relative order, moving only 001B first. Write permanent BootOrder,
   leave BootNext absent, read back, then normal systemctl reboot.
   Absence of BootNext tests the persistent order directly during this reboot.
4. Bounded strict SSH using ordinary existing IP pin must return. Verify new
   boot ID, P3 root GUID, both mirror members ONLINE, BootCurrent mapped to P3,
   consumed BootNext, P3-first saved order, services and guest startup status.
   If firmware normalizes order, reconcile the same verified P3-first preference
   and independently read back; no blind historical-entry replay.
5. Use reauth --check hv-lore without issuance. Preserve all host pins.
   Record limits and canonical projection; run runbook audit and node validator.

Rollback before reboot: remove only newly set BootNext and restore captured
BootOrder. After boot failure use confirmed operator console and verified P3
hardware entry or captured original NVMe entry. No forced import or disk changes.
Do not claim immunity to BIOS reset/hardware enumeration changes from readback.

## USB menu recovery — 2026-09-22

Console evidence verified P3 serial 9760511210658 as /dev/sdc, its FAT ESP
UUID D24B-C1DB mounted read-only at /mnt/p3-efi, and both EFI stubs pointing
to that ESP's /grub/grub.cfg. Pool discovery identified intended GUID
4137356908105663872 and both members ONLINE; no pool was imported.
The kernel and initramfs exist. Initramfs listing succeeded after extracting
the USB media's missing zstd tool into RAM; its cache names the intended P3
members. This does not prove the installed OS boots successfully.

Within the packet's new explicit menu-repair authorization:
1. Confirm the existing mount source and UUID still match; do not continue
   after any mismatch or command error.
2. Remount only this ESP read-write. Preserve grub.cfg.lore-before-menu using
   cp -n; compare it to grub.cfg before any edit. If different, inspect rather
   than overwrite that backup or apply another edit blindly.
3. Change only exact `set timeout=0` line endings to `set timeout=15`.
   Review diff against backup; only timeout assignments may change.
4. Sync and remount read-only. Read back timeout assignments. Do not report
   menu recovery accepted until the P3 boot actually displays a timed menu.
5. Rollback: from the same verified USB mount, remount read-write, restore
   the preserved backup, sync and remount read-only.

Underlying boot failure remains unresolved. At the restored menu, prepare a
one-boot diagnostic edit before booting; preserve IOMMU configuration and do
not enable forced ZFS import. After OS recovery, use the owning Proxmox boot
configuration workflow to make the accepted menu settings durable on both
intended ESPs and complete the packet's original acceptance and canonical
documentation requirements.

### Persist the successful diagnostic parameters

On the strictly authenticated running P3 system, assert the expected root
GUID, registered ESP UUIDs D24B-0CBC and D24B-C1DB, and observed running
command line. Back up /etc/default/grub to a dated root-only recovery
directory. Set GRUB_TIMEOUT=15 and remove only quiet, video=vesafb:off,
video=efifb:off and initcall_blacklist=sysfb_init from its default command
line. Preserve intel_iommu=on, iommu=pt and the existing root configuration.
Use proxmox-boot-tool refresh: installed 000_proxmox_boot_header explicitly
states /boot/grub/grub.cfg alone is not the active ESP configuration.
Validate both registered ESPs read-only: grub-script-check succeeds, timeout
assignments are positive, and linux entries retain intended root and IOMMU
arguments without the removed tokens. Verify host services and strict SSH.
Rollback uses the saved /etc/default/grub followed by the same refresh;
retain the USB and ESP menu backup for console recovery. No automated reboot
in this persistence step; report the remaining unattended-reboot test.

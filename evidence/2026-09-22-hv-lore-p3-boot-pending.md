# Lore P3 boot attempt — acceptance pending

Classification: immutable observation of the first authorized boot attempt.
Source hv-cp HEAD: 9e6638bc618df2cc3eaab9c37f4baf299a84e7a1.

## P3 boot repair in progress — 2026-09-22 EDT

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

Operator subsequently confirmed the console did not advance past initial-ramdisk loading. Remote boot acceptance remains blocked pending console diagnostic evidence; no additional reboot or forced action was attempted.

Documentation validation: heartbeat node contract, runbook audit and hv-cp whitespace check passed. No commit or push.

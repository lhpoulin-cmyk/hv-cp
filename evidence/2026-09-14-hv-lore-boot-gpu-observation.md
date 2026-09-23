# hv-lore boot and GPU observation — 2026-09-14

Read-only follow-up after the operator reported Lore booting. Supersedes the
reachability limitation of the earlier A380 search for this observation window.
Source hv-cp HEAD: `9e6638bc618df2cc3eaab9c37f4baf299a84e7a1`.
No template, mutation packet, or host changes; unrelated dirty work preserved.

Strict existing SSH to hv-lore succeeded at 16:43:24 EDT, reporting hostname
hv-lore and uptime one minute. Repeated checks through 16:45:04 EDT remained
reachable. Systemd transitioned from starting (pve-guests startup in progress)
to running, with no pending jobs and zero failed units at the final check.
This is boot observation, not full application or storage acceptance.

Repeated PCI GPU queries show only NVIDIA RTX 5060, 0000:09:00.0,
10de:2d05, PNY subsystem 196e:1448. Its driver was vfio-pci at 16:44:21.
No Arc A380 or other Intel display controller was enumerated. Absence from
PCI enumeration does not prove physical absence or identify a hardware cause.
No PCI rescan, driver load, firmware change, or guest action was attempted.

The bounded current-boot kernel filter returned ROM allocation failures for
01:00.0 (SAS2308 HBA) and 02:00.1 (82599ES NIC); these do not identify an Arc
device. No Arc/DG2 initialization message appeared in the filter output.

At 16:44:21, qm list showed VMs 100, 120, 130 and 260 running. Other listed
VMs were stopped at that moment; guest startup was still in progress.
All SSH invocations exited zero. No accepted configuration change occurred,
so canonical accepted-state documentation was not altered.

# hv-lore Arc A380 search — 2026-09-14

Read-only request: look for the Arc A380 on hv-lore. No live hardware
observation was obtained and no host changes were made.
Source HEAD: `9e6638bc618df2cc3eaab9c37f4baf299a84e7a1`.
Pre-existing dirty work was preserved. No template or mutation packet used.

Strict SSH with the existing user configuration, BatchMode and a ten-second
connection timeout targeted 192.168.10.20:22. The first network-enabled attempt
timed out; the retry returned `No route to host`, both exit 255, before remote
commands ran. Local route lookup selected wlp2s0, source 192.168.10.86.
The workstation has no directly connected Lore storage-network address.

The September 12 full inventory recorded only an RTX 5060. This is historical
evidence and cannot establish whether an A380 is installed now.

BLOCKER=hv-lore management SSH unreachable
operation=read-only PCI enumeration over SSH to 192.168.10.20:22
observed=connection timeout followed by No route to host
expected=authenticated SSH returning current PCI GPU identity and driver
authority=inspection request does not authorize host or network recovery changes
why_not_ordinary_debugging=no remote command executed; live inspection requires restored reachability

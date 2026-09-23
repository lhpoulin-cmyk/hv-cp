# CT149 restored for Cider enrollment

## Verified Cider address and SSH identity — 2026-09-22

Operator reported .83 after renewal; Netbrain independently confirms bound
active-address 192.168.10.83 for MAC 50:ED:3C:47:50:23 and client ID
1:50:ed:3c:47:50:23. Private Wi-Fi Address is operator-reported Off.
Prior missing native MAC and address-reacquisition blockers are superseded.
Do not repeat account, Python, MAC, privacy-setting or address collection.

The selected CT149 controller was stopped. Its existing local rootfs and
read-only database passed preflight: no schedules, no pending tasks. Restored
CT149 under the enrollment instruction; it is running, Semaphore active,
source 192.168.80.149/24 via .80.1. No template was launched. Startup emitted
the existing systemd/nesting advisory; no isolation setting was changed.

CT149 reached Cider .10.83 TCP22 and received the exact previously approved
ED25519 key, fingerprint
`SHA256:FwhrQf0X7u5YpTbnzrERt2ItvB/jTk127W8g8OXw5y0`. This proves selected-path
reachability and live host identity, not authentication or Ansible readiness.

Receipt: `network-cp/evidence/2026-09-22-ws-cider-enrollment-continuation.json`.
Current admission: IDENTIFIED, NOT_AUTHENTICATED, NOT_OBSERVE_READY.
Network IPAM lifecycle is ACTIVE_STATIC; no DNS or firewall change required.

Remaining auth-owned step: provision and accept the dedicated Cider observation
credential for CT149 -> louis/UID501, keeping the selected dedicated-key policy.
No registered Cider credential/provider/grant was found; no arbitrary credential
path or other target's key was tried. Accepted protected custody/delivery and
local Mac installation are needed before authenticated verification of
/Users/louis/.ansible/tmp and the bounded OBSERVE play. A bootstrap cannot be
performed remotely through a credential that has not been installed.
No secret access, issuance, key installation, authentication, commit or push.

Packet: [bounded startup](../implementation/2026-09-22-cider-ct149-start.packet.md).
Rollback is graceful pct shutdown 149 --timeout 60 if unsafe behavior appears.
Unrelated guests, onboot=0, storage and networking were preserved.

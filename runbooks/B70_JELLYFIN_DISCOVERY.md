# B70 Jellyfin discovery bounded operator realization

Authority: Louis:2026-09-16:b70-jellyfin-discovery-v1-approved and
Louis:2026-09-16:b70-jellyfin-fresh-enrollment-custody-approved.
The user explicitly directs installation through the existing Hadrian operator
path after custody acceptance. This single operator-directed transaction does
not add a Semaphore APPLY lane or delegate a generic privileged primitive.
Auth-cp contract: ../../auth-cp/contracts/b70-jellyfin-discovery-v1.md;
custody: ../../auth-cp/docs/B70_JELLYFIN_CUSTODY_TRACE.md.

Targets: hv-lore QGA VM130 jellyfin-lore and hv-matrix QGA VM310
b70-encode-matrix, through Hadrian strict pinned SSH, no forwarding.
No hypervisor desired-state mutation. No B70 hypervisor identity or QGA grant.
Initial public preflight: both QGA roots verified; task resources absent;
VM130 service mount namespace equals collector namespace. B70 source .91.

Sequence: isolated native SSH rehearsal; public checksum-pinned SOPS staging;
root-protected B70 runtime directory and task-only noswap tmpfs; dedicated local
ED25519 creation and SOPS-age encryption; transfer only ciphertext/public data;
exclusive encrypted custody write on verified Foundation medium; guest locked
account, fixed helper, exact named execute-only ACL on /var/lib/jellyfin,
root-owned host policy and expiring public key; sshd syntax/effective policy
qualification before reload; client and verified host pin installation; exact
one-hour gate activation; actual Louis-on-B70 positive and negative tests.
No private key crosses B70. No age identity, CA or allocator operation.
No ARM path, existing credential, guest media/configuration or service mutation.

Interruption: leave gate disabled; preserve same key and public receipt, never
silently reissue. Unknown existing resources fail closed. Exact payload hashes
and public results recorded in auth-cp/docs/B70_JELLYFIN_LIVE_EVIDENCE.md.
Rollback: disable gate/remove dedicated authorized-key entry first; remove
only dedicated runtime key; retain ciphertext/public history. Remove only named
account ACL if it matches this transaction; preserve other ACLs and operator
path. No data/account deletion or broad cleanup. Expiry enforced by SSH key
expiry and helper wall clock, plus a fixed B70 transient systemd lease timer.
Independent Hadrian management path checked after realization.

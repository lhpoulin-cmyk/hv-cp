# B70 Jellyfin 72-hour renewal — 2026-09-22

PLAY: B70_JELLYFIN_DISCOVERY_RENEWAL
CHECKPOINT: preflight and isolated issuance/SSH/renewal rehearsals passed
Status: completed
STATUS: AUTHORIZED
RESULT: exact October 1 transaction installed and live verified

Operator requested remedy of arm-cp 3f05404 and then at least three days.
September 22 retry resumes that same authority. Auth-cp contract and custody
exception: ../../auth-cp/contracts/b70-jellyfin-discovery-v1.md and
../../auth-cp/docs/B70_JELLYFIN_CUSTODY_TRACE.md.
Runbook: [renewal](../runbooks/2026-09-22-b70-jellyfin-renewal.md).

Source hv-cp HEAD 9e6638bc618df2cc3eaab9c37f4baf299a84e7a1; fetched origin/main
704db7564b054ea3aee5e9108f734fde8c9de312, four ahead/four behind; unrelated
optical commits and dirty state preserved. Auth-cp HEAD 3bdcde14bb7c0d77775cfeb2d1bd5571488d6f2a.
Strict ordinary Lore SSH now passes. Accepted P3 GUID 4137356908105663872;
VM130 and VM120 running. VM310 on Matrix running. VM130 public host pin,
old account UID995/GID982, installed helper/client/sshd hashes and source .91
match September 16 evidence. Old lease key/public companion absent; timer
inactive; task tmpfs retains noswap,nosuid,nodev,noexec. Foundation medium
serial 25072613770027, LUKS f28aa6f4-6234-4f06-a762-f62ee3b001bc, ext4
b638e169-cb30-4e23-a79f-43a5c18772eb and root0700 namespace requalified.

Scope: new dedicated B70-local key, 72-hour expiry, sealed fresh-enrollment
custody in distinct renewal namespace, same forced command/source/account/pin,
updated 72-hour collector, fixed expiry timer, positive/negative acceptance.
No restore, import, CA/allocator action, guest start/stop, host desired-state,
media/library/permission expansion, scan or publication. No ansible-cp edit.
Rollback disables exact new gate and removes new authorized-key entry before
revoking only new runtime key; preserve all old receipts/ciphertext and account.
Evidence returns to auth-cp renewal and operational handoff; no publication.

## Exact operator validity amendment

After issuance/custody and disabled guest staging, Louis directed “make that
oct 1”. Final deadline: 2026-10-01T05:57:22Z for the same newly issued key
SHA256:kHB5cH8l4oXQs/x6wfKi7Ow3X+MoDpWS/7frRTa43xI. Do not reissue or restore.
Use auth-cp amend_guest_20261001.py and amend_lease_20261001.py, preserve the
original disabled transaction and sealed snapshot, and write a public validity
amendment next to ciphertext. Qualify new timer before stopping the September
25 timer. Activate only after matching guest, key and runtime expiry checks.
The October 1 exception is restricted to this exact key/start/source tuple.

## Accepted result

Same fresh B70 key is active through 2026-10-01T05:57:22Z. Public ciphertext
custody and validity-amendment readback passed. Final helper/key/gate and
B70 runtime timer agree. Actual Louis UID1000 fixed discovery, 16 negative
checks and separate disabled/expired gate checks passed; exact deadline restored.
Guest account/ACL, host pins, client and SSH Match policy are unchanged.
No hypervisor desired-state or guest lifecycle mutation occurred. No media
write, scan, playback, import/recovery or publication. Native synthetic issuance,
renewal and amendment rehearsals passed. Auth-cp tools/validate passed 167 tests
plus 10 Hadrian tests, schemas/syntax/links/material/diff checks. Raw runtime
receipts remain outside Git; canonical public identity/current deadline are
recorded in auth-cp registry and B70_JELLYFIN_AGENT_HANDOFF.md.

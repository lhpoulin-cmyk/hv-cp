# B70 Jellyfin renewal operator procedure

Requires [exact packet](../implementation/2026-09-22-b70-jellyfin-renewal.packet.md).
Use existing strict Hadrian owner SSH and QGA only: Matrix VM310, Lore VM130.

1. Check original public receipts and installed digests, account and host pin;
   old key absent, old timer inactive, protected runtime and ciphertext namespace.
2. Rehearse auth-cp renew_issue_b70.py and renew_guest.py in isolated synthetic
   containers. Keep secret-aware environment empty except fixed safe variables.
3. Stage only checksum-pinned public SOPS binary on B70 via QGA stdin chunks;
   verify full digest before executable use. Preserve existing transaction state.
4. Issue once under distinct 20260922 state; timer scheduled before generation,
   private bytes stay on B70 and root-only until verified encrypted custody.
   New grant and lease last exactly 72 hours; retain immutable public receipt.
5. Transfer only SOPS ciphertext through memory to exclusive root0600 file in
   the verified Foundation namespace's renewal-20260922 directory; fsync/readback.
6. Compare original guest public files; save exact before-state in root0700
   transaction receipt; stage disabled gate, updated helper and new restricted
   key. Verify sshd syntax/effective policy. Preserve account, ACL and client.
7. Qualify custody hash, enable new gate and deliver runtime to Louis UID1000.
   Test actual B70 command, restrictions, disabled/expired gate and restore only
   the same new grant. Verify timer, deadline and independent operator path.
8. Update auth-cp registry and operational handoff with actual acceptance only.
   If interrupted, reconcile existing transaction; never silently regenerate.

Rollback: disable gate and remove only this transaction's public key; then
remove its runtime key and public companion. No old-key restoration or custody
decryption. Preserve all public/ciphertext history and unrelated state.

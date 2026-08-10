# Matrix SSH host-identity enrollment

Use this runbook only to establish a previously absent Matrix SSH host-key
trust record. It does not authorize a Matrix service, network, guest, storage,
or notification change.

1. Obtain the public host-key fingerprints from a physical/local Matrix
   console or another independently trusted console path. Never read or copy a
   private host key.
2. Obtain keys presented by `hv-matrix.arpa` without writing known-host state.
3. Compare each key type's SHA-256 fingerprint exactly. Stop on a mismatch.
4. Preserve any existing Matrix entries before replacing only those entries, or
   add only the matched public key lines when none exist.
5. Configure the `hv-matrix` profile to use `hv-matrix.arpa`; do not require a
   literal-address authentication path.
6. Require `StrictHostKeyChecking=yes` and verify `ssh hv-matrix 'hostname; id'`.

Do not use TOFU, `accept-new`, `StrictHostKeyChecking=no`, or blind
known-host replacement.

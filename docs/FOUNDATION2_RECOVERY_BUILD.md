# Foundation 2 hypervisor recovery-build process

Status: implemented as the Matrix recovery-build method on 2026-07-26. This
document describes a local installer-artifact build; it is not installation or
host-change authority.

## Why this exists

An automated hypervisor installer is useful only if it can be recreated after
the active workstation, its working SOPS copies, or a generated ISO disappear.
The recovery build separates durable inputs by role:

| Source | Supplies | Why it is used |
| --- | --- | --- |
| Foundation 2 encrypted recovery storage | live account and notification SOPS components, age identity, and verified SSH public key | Recovers credential-bearing inputs without depending on active working copies. |
| Git | reviewed installer code, disk/network contract, and non-secret node manifest | Makes the build logic reviewable and reconstructible. |
| Local verified vendor ISO | PVE installer payload | Keeps the vendor binary separate from credentials and Git. |

The result is a newly generated **sensitive** ISO in a dedicated local cache.
It does not write a target host.  Removable-media staging is deliberately a
separate, explicitly authorized step.

## Exact method

1. Require the already-unlocked Foundation 2 recovery storage to be mounted
   read-only. A recovery build must never mutate its source vault.
2. Verify the account SOPS input, Fastmail component, Discord component, ntfy
   component, age identity, and public SSH key are present.
3. Decrypt only the required component records into a mode-0700 temporary
   workspace using Foundation 2's own age identity.
4. Combine those component records with the Git-tracked immutable node ID into
   the installer’s transient notification JSON shape.
5. Validate that JSON locally. Reject missing fields, placeholders, malformed
   node IDs, unsafe route fields, and invalid enablement states before ISO work.
6. Invoke the ordinary Matrix builder with explicit recovery-source overrides:
   the Foundation 2 account source, temporary notification JSON, recovered
   public key, and a recovery-specific output directory/name.
7. Validate the generated PVE answer and ISO boot metadata, record only the
   Git revision and base/generated ISO checksums, then remove the temporary
   plaintext workspace.

Run the recovery wrapper from the installer project with:

```bash
bash installer/build-hv-matrix-from-foundation2.sh
```

At no stage should the wrapper read an active node SOPS file, print a secret,
write Foundation 2, send a notification, or install a host.

## Controlled removable-media staging

The wrapper intentionally does **not** stage media itself.  When the operator
explicitly authorizes staging, create a second implementation packet that
names the resolved removable-media mount, distinct output filename, expected
sidecars, rollback targets, and evidence destination.  Then:

1. Confirm the recovery-source vault remains read-only and the removable
   target has enough space.
2. Confirm that the exact output names do not already exist; never replace a
   prior installer by accident.
3. Copy only the ISO, SHA-256 sidecar, and non-secret recovery metadata.
4. Compare source and target checksums and inspect the staged ISO's BIOS/UEFI
   boot metadata.
5. Record the result.  Booting or installing remains a separate authorization.

This separation makes the custody build reusable while keeping removable-media
mutation visible and reversible.

## Public-key rationale

The installer needs only the public half of the lab key. Its verified recovery
copy belongs with Foundation 2's SSH public-key custody material so a recovery
build does not need access to the active workstation identity or any private
SSH key. A byte comparison against the Git-designated public source is a
pre-build stop condition.

## Notification rationale

Foundation 2 holds notification credentials as separate least-purpose SOPS
components. The build assembles them transiently because the installer expects
one node-shaped object. The immutable node ID remains Git-tracked and
non-secret; it must not be reconstructed from a hostname or copied from another
hypervisor.

This assembly is a build concern, not transport authorization. Fastmail,
Discord, and ntfy still require their own node-specific post-install acceptance
and operator-visible receipts.

## Recovery limits and follow-up

A successful recovery build proves that its declared inputs can reproduce an
installer artifact. It does not prove hardware identity, management reachability,
notification delivery, or correct physical disk selection. Those remain
separate preflight and installation gates.

Record the generated ISO checksum, Git revision, non-secret manifest revision,
and result in the private node record. If custody sources change, re-run this
recovery build as a drill rather than assuming the old result remains valid.

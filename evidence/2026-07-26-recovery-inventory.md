# Read-only recovery inventory

**Captured:** 2026-07-26  
**Method:** read-only SSH inventory and SHA-256 calculation on `hv-katra`  
**Source:** recovered local autoinstall workspace described in
[`docs/SOURCE_RECOVERY.md`](../docs/SOURCE_RECOVERY.md)

## Result

- The workspace is not a Git repository.
- It was found as untracked content within a dirty `infrastructure` checkout
  that was both ahead of and behind its remote.
- It contains installer configuration, generated first-boot material,
  firmware-analysis reports, raw firmware utilities, an archive, and a USB
  marker blob.
- No source script was run and no source file was copied into this repository
  during the inventory.

This evidence is intentionally a concise capture. The detailed provenance and
hashes are in `docs/SOURCE_RECOVERY.md`; the host baseline is in the private
Katra node record.

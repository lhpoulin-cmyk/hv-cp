# Matrix optical preparation validation — 2026-09-11

Additive validation record for the
[inspection](2026-09-11-matrix-three-optical.md). This is repository and
read-only observation acceptance, not passthrough acceptance.

- PASS: inventory helper Python compilation; actual host and guest-agent
  root execution; mount, block, PCI, process and optical udev commands returned
  successfully. Optical fuser results distinguished present from absent
  handles. Preliminary non-root output was not used as complete proof.
- PASS: all local links in the new documents resolve.
- PASS: `tools/audit-live-mutation-runbooks.sh`. The new packet is deliberately
  blocked and is not counted as execution-ready by this audit.
- PASS: `tools/validate-node-documentation-contract.sh --profile heartbeat
  /home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv hv-matrix`.
  This is structural baseline validation, not a claim of new canonical runtime
  acceptance. No accepted node mutation requires projection in this task.
- PASS: staged `git diff --check`; reviewed only the seven task-specific files
  plus this validation record. Unrelated dirty work remains unstaged.
- PASS: private physical serial/by-id exclusion from new publishable artifacts.
  Linux USB root-hub serial fields that merely repeat public PCI addresses were
  distinguished from physical device serials during review.
- PASS: `SHA256SUMS` verifies the original eight private capture files. A final
  additional `vm310-final.conf` matches `vm310-before.conf` byte-for-byte;
  original captures and their checksum manifest were not overwritten.

No image/device deployment, VM shutdown, reboot, disc operation, media access,
Docker work or GPU workload test was run. Desired state remains blocked by the
HP drive sharing the host rpool controller. Before/after hardware is identical;
rollback for this task is therefore a no-op.

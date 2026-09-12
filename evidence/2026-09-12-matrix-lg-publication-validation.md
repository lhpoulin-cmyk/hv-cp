# Matrix LG scoped publication validation — 2026-09-12

Classification: sanitized immutable documentation/policy validation summary.
Operator authorized finalize, validate, commit and push only scoped hv-cp LG
qualification evidence. No live operation was performed for publication.

Publication checkout: isolated `/tmp/hv-cp-lg-publish`, branch
`publish/matrix-lg-qualification`, tracking `origin/main`. Canonical remote:
`git@github.com:lhpoulin-cmyk/hv-cp.git`. Base was fetched and directly verified
as `bfc3897880a87405302838408e596824de4e95ed`. The original working branch also
contains unrelated backup/storage commits, so it is not merged into main.
The optical dependency closure is copied without those unrelated commits.

## Results

- PASS: passthrough and bounded disc-I/O evidence remain separate immutable
  records; current handoff links both PASS results, the failed initial dd
  method, successful aligned read and no observed test-time kernel failure.
- PASS: USB remains available in accepted passthrough evidence and was not
  probed by LG disc testing; HP remains explicitly deferred.
- PASS: `tools/audit-live-mutation-runbooks.sh`. There are no execution-ready
  packets in the publication checkout; completed/deferred packets are excluded
  by the audit. The completed LG packet's separate runbook link was additionally
  checked explicitly. No fresh live-mutation authority is inferred.
- PASS: `tools/validate-node-documentation-contract.sh --profile heartbeat
  /home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv hv-matrix`.
- PASS: `bash tools/tests/test-node-documentation-contract.sh` (passing and
  negative contract fixtures). No validator implementation was changed.
- PASS: Python AST parsing of all four optical helpers; no helper is executed
  against devices during publication validation.
- PASS: all scoped Markdown relative links resolve; Git whitespace check;
  allowlisted scoped file review; no raw capture, physical serial, credentials,
  archive or binary is staged. Optical private-capture ignore rule retained.
- PASS: existing immutable evidence copies match the source workspace exactly.
- PASS: source-workspace tracked/untracked nonignored file hashes match the
  pre-publication snapshot; unrelated edits and files remain byte-for-byte.

Private canonical Matrix documentation is validated locally, not committed or
pushed by this hv-cp publication. The original checkout remains on its original
branch to preserve all work. Local HEAD/upstream/direct remote main parity is
verified in the isolated publication checkout after a normal fast-forward push;
the resulting immutable SHA is returned to the operator for downstream use.
The enclosing commit identifies this artifact; no self-referential SHA is
embedded in the content.

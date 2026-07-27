# hv-matrix standalone hv-cp checkout

Date: 2026-07-27

## Result

PASS. The private standalone `hv-cp` repository was transported to Matrix as
a Git bundle and cloned at `/home/louis/hv-cp` without placing a GitHub private
key or token on the host.

- Source and Matrix bundle SHA-256:
  `d0f03e3c897db896801b6b79c4a8cdb4ec6e12bea349ad9dca821d2cd8099030`.
- Checked-out commit:
  `80b2ce5dc014903daae781eb89344e489bc68fd7`.
- Branch status: `main...origin/main`.
- Origin: `git@github.com:lhpoulin-cmyk/hv-cp.git`.
- Temporary bundle removed from Matrix after validation.

SSH-agent forwarding was unavailable on Matrix. The host SSH policy was left
unchanged, and future remote fetch access remains a separate decision.

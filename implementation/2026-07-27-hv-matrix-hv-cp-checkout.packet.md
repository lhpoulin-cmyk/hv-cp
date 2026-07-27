# Implementation packet: hv-matrix hv-cp checkout

Purpose: clone standalone hv-cp to /home/louis/hv-cp on Matrix.
Authority: operator, 2026-07-27.
Excluded: services, credentials, notifications, network, storage, cluster, Ceph, guests.
Validation: clean main checkout. Rollback: remove only that checkout.

## Result

Completed 2026-07-27. Matrix's SSH server did not expose the forwarded local
authentication agent, so no private key or token was copied and the host SSH
policy was not weakened. The operator instead transferred a Git bundle whose
local and Matrix SHA-256 values matched, cloned it at `/home/louis/hv-cp`,
attached `main` to commit `80b2ce5dc014903daae781eb89344e489bc68fd7`, and
set `origin` to `git@github.com:lhpoulin-cmyk/hv-cp.git`.

The checkout was clean at `main...origin/main`. Future network fetches remain
blocked pending a separate Matrix GitHub-access decision.

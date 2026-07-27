# hv-lore canonical control-plane enrollment

**Date:** 2026-07-26  
**Target:** `hv-lore.arpa` (`192.168.10.20`)

## Result

- Dedicated non-login account `lore-sync` created.
- Unique deploy key added only to the canonical `infrastructure` repository.
- Clean clone installed at `/var/lib/lore-sync/infrastructure`.
- Authenticated `git ls-remote origin HEAD` returned
  `df40c01f9dec29650916eeddd9269f6a755b0d1b`.
- Clone status was clean on `master...origin/master`.
- Non-secret host enrollment receipt installed at
  `/var/lib/lore-sync/control-plane/2026-07-26-enrollment.md`.

The user-owned `/home/louis/infrastructure` checkout was deliberately left
untouched despite its local work and remote divergence. No automatic Git
synchronization, Lifetap collection, TruthTap configuration, service, timer,
network, cluster, Ceph, or storage change occurred.

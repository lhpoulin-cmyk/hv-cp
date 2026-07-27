# Implementation packet: hv-lore canonical control-plane enrollment

Target: `hv-lore.arpa` (`192.168.10.20`)

Intended mutation: create a dedicated non-login `lore-sync` account with a
unique SSH deploy key scoped only to the canonical `infrastructure` repository,
then create a clean clone at `/var/lib/lore-sync/infrastructure`. The existing
user-owned `/home/louis/infrastructure` checkout is explicitly out of scope.

Authority: operator approval on 2026-07-26 to inspect Lore's repository and
install its control plane before collecting a Lifetap baseline.

Preconditions: Lore SSH host identity was console-confirmed; Louis has
passwordless sudo; the existing checkout is recognized as dirty and ahead of
its remote; GitHub access is limited to the `infrastructure` deploy key.

Rollback: remove the dedicated clone, key, and `lore-sync` account; revoke the
corresponding repository deploy key. Do not alter or reset
`/home/louis/infrastructure`.

Evidence destination: `/var/lib/lore-sync/control-plane/2026-07-26-enrollment.md`
on Lore and a non-secret canonical node record after validation.

Exclusions: no Lifetap collection, TruthTap manifest, service, timer, storage,
network, DNS, cluster, Ceph, or Git push is part of this enrollment.

## Result

**Executed:** 2026-07-26

`lore-sync` was created as a dedicated non-login account. Its unique deploy key
is scoped only to `lhpoulin-cmyk/infrastructure`; its public-key fingerprint is
`SHA256:A+SuqUwxDldZd4CzOYt6SQeV9pCKn7rOgkdvUjCFXDU`.

The clean canonical clone at `/var/lib/lore-sync/infrastructure` authenticated
to origin and was clean at `df40c01f9dec29650916eeddd9269f6a755b0d1b`.
No automatic synchronization was configured. The pre-existing
`/home/louis/infrastructure` checkout was not changed.

TruthTap remains deferred: Lore has no Lifetap baseline yet, and baseline
collection was intentionally excluded from this packet.

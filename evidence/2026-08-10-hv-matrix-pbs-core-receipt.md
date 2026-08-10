# Matrix pbs-core validation receipt

One authorized execution of `pbs-core-matrix-vm310` completed successfully:
`UPID:hv-matrix:00035C90:03F3E605:6A7A15E9:vzdump:310:root@pam:`.

VM310 `b70-encode` was the only selected guest. It created PBS archive
`vm/310/2026-08-10T18:18:17Z`, completed in 7m40s, and PVE returned `OK` at
2026-08-10 14:25:57 EDT. The approved `hv-lore` -> guest-agent -> VM260
inspection path found the matching server-side index:
`ns/matrix/vm/310/2026-08-10T18:18:17Z/index.json.blob`.

The job has no client-side `prune-backups`. Receipt is proven; integrity and
restore recovery remain unproven.

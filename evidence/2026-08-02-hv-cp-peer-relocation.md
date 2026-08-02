# hv-cp peer-repository relocation

Date: 2026-08-02 America/Detroit
Disposition: relocated and validated; no live infrastructure mutation

## Authority and scope

The operator authorized relocation of the existing authoritative `hv-cp` Git
repository from `/home/louis/active/hv-cp` to the Helix-ARPA peer-control-plane
path `/home/louis/helix-arpa/hv-cp`. This record covers repository discovery,
pre-v2 checkpointing, publication, history-preserving relocation, and static
validation only. It grants no host, firewall, network, Ceph, VM, or service
execution authority and does not begin the hv-cp v2 redesign.

## Source selection

The authoritative source was `/home/louis/active/hv-cp`, branch `main`, starting
at `5c6b93841e3b85c0bd119d8979fe4202e4ac33fc`. It contained the current
hypervisor storage assessment, delegated `firewall-cp`, and intentional dirty
Matrix/firewall documentation work.

`/home/louis/src/hv-cp` was absent. `/tmp/hv-cp-misplaced-20260801` was an
archival checkout diverging from the shared `30a62b2` base only through the
misplaced Ceph v1 architecture/reference export. That Ceph material is governed
by independent `ceph-cp` and `ceph-reference-cache` repositories and was not
merged or embedded here.

## Checkpoint and publication

The intentional pre-v2 changes were committed as
`be2d114969502c81cadacf3ad5418394736b2526`. The checkpoint also corrected only
paths invalidated by relocation and copied the existing static live-mutation
packet audit into `tools/` so the independent repository no longer relies on
the enclosing `/home/louis/active` checkout. The verified zero-byte
`firewall-cp/implementation/.write_test` probe was discarded.

After a fetch, local `main` was three commits ahead and zero behind
`origin/main`. A normal fast-forward push updated
`git@github.com:lhpoulin-cmyk/hv-cp.git`; no force push or history rewrite was
used.

## Relocation and preservation

Source and destination were on the same filesystem, the destination was an
empty directory, and the source had one worktree. An exact metadata-preserving
copy populated `/home/louis/helix-arpa/hv-cp`. Before cutover, recursive file
comparison, Git refs, tags, remotes, HEAD, upstream, tests, and validators all
matched.

The original checkout is preserved at:

```text
/home/louis/active/hv-cp.pre-relocation-20260802
```

The former source path is now a symlink to the authoritative destination:

```text
/home/louis/active/hv-cp -> /home/louis/helix-arpa/hv-cp
```

The enclosing `/home/louis/helix-arpa` repository was not modified, staged,
committed, cleaned, or reset. Its existing unrelated changes and peer nested
repositories remain outside this relocation.

## Validation

- destination Git root resolved exactly to `/home/louis/helix-arpa/hv-cp`;
- canonical-node documentation fixture test passed;
- live-mutation packet/runbook audit passed;
- `git diff --check` passed;
- local and remote `main` matched after publication;
- destination worktree was clean before this factual record;
- no Ceph v1 control-plane repository or manifest was embedded;
- no live infrastructure or sibling repository was mutated.

This relocation record is the final pre-v2 checkpoint addition. Passing these
checks is not authority to install hv-cp v2 doctrine or perform live work.

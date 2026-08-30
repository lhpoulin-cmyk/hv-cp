# hv-lore rollback-media boundary correction

Date: 2026-08-27
Supersedes: physical-presence blocker recorded earlier on 2026-08-27
Authority: explicit operator correction

The operator withdrew
`OLD_RPOOL_ROLLBACK_MEDIA_UNEXPECTEDLY_CONNECTED`. Historical root-pool media
may remain physically connected. Its accepted classification is:

```text
OLD_RPOOL_MEDIA_PRESENT=YES
OLD_RPOOL_ROLE=PRESENT_OFFLINE_ROLLBACK
OLD_RPOOL_IMPORTED=NO
OLD_RPOOL_MOUNTED=NO
OLD_RPOOL_USED_BY_PVE_STORAGE=NO
OLD_RPOOL_MUTATION=NONE
```

Physical visibility is intentional migration state and is not drift. The
safety contract fails closed only if the historical pool is imported, a
historical member is mounted or enters active `rpool`, a rollback device is
configured as writable PVE storage or selected for destructive mutation, or
the active `rpool` ceases to be the healthy two-member P3 pool.

`ansible-cp` commit `137a3a7` implements this corrected contract. The observer
now:

- requires active `rpool` GUID `4137356908105663872` to be `ONLINE`;
- requires both authorized P3 partition identities and exactly two physical
  leaf paths in active `rpool`;
- rejects either historical serial in active `rpool`;
- rejects imported historical pool GUID `8921639095104950851`;
- rejects mounted partitions on either historical member;
- captures `/etc/pve/storage.cfg` and rejects direct rollback-serial
  references when the file is readable; and
- reports visible media as `PRESENT_OFFLINE_ROLLBACK`.

Repository validation before push:

```text
PYTEST_RESULT=PASS (22 tests)
SYNTAX_RESULT=PASS
INVENTORY_VALIDATION=PASS
ANSIBLE_LINT_RESULT=PASS
YAMLLINT_RESULT=PASS
STATIC_VALIDATION=PASS
LIVE_HOST_CONTACT=NO
```

No host, disk, pool, storage, guest, boot, network, or Semaphore object was
mutated. No shutdown or physical removal is required by this correction.

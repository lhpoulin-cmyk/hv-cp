# hv-lore survey isolation-gate correction

Date: 2026-08-27
Authority repository: `ansible-cp`
Commit: `e3cb67c` (`Fail closed on connected Lore rollback media`)

The first admitted post-reinstall survey correctly collected the physical disk
inventory but only reported the declared rollback disposition. It did not
assert that serials `TP250913B5D3323` and `TP250913B5D1797` were absent, so a
task could return a green recap while those prohibited devices were visible.

The committed correction adds a read-only assertion after evidence
normalization. Future runs fail if either historical root-pool serial occurs in
the physical disk inventory. Documentation and a repository test were updated
with the same contract.

Validation before push:

```text
PYTEST_RESULT=PASS (22 tests)
SYNTAX_RESULT=PASS
INVENTORY_VALIDATION=PASS
ANSIBLE_LINT_RESULT=PASS
YAMLLINT_RESULT=PASS
STATIC_VALIDATION=PASS
LIVE_HOST_CONTACT=NO
```

The commit was pushed to `origin/main`. No host, disk, pool, guest, boot,
network, or Semaphore object was mutated by this repository correction.

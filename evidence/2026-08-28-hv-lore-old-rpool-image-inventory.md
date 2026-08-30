# hv-lore old-rpool disk-image inventory

Date: 2026-08-28
Packet: [old-rpool disk-image inventory packet](../implementation/2026-08-28-hv-lore-old-rpool-image-inventory.packet.md)
Runbook: [old-rpool disk-image inventory runbook](../runbooks/2026-08-28-hv-lore-old-rpool-image-inventory.md)

## Authority and repository state

The operator explicitly authorized non-destructive mounting and complete disk-
image discovery on the historical Lore rpool. Fresh fetch proved hv-cp
`origin/main` `e615f0c8581b0ef18aa5ad9c8a9088a6c004928d` is an ancestor of
execution commit `7d7a9d97ecc1583e575c7a3a6885d89281d1308e`. Existing unrelated
and in-scope uncommitted work was preserved.

## Access proof and current stop

- Live ED25519 scan of `192.168.10.20` matched the already console-witnessed
  reinstall fingerprint
  `SHA256:V2j+4W03TpGYgftKVV55A8u7eL4y9X1Wauf0bMqJYsU`.
- Direct root public-key authentication was rejected.
- The documented human operator certificate was rejected and is locally
  proven expired since 2026-08-19 17:37:48.
- Semaphore CT149 is reachable at its documented admin-plane address
  `192.168.80.149`; its live ED25519 fingerprint matched
  `SHA256:M0CHmIfeJD/DXuNxksR3pZYVX99y20DjFO4Usouz3p0`, hostname was
  `semaphore-matrix-stage`, and the Semaphore service was active on loopback
  TCP/3000.
- The current session has neither a Semaphore operator session/API credential
  nor the sealed `ansible-executor` private credential. No credential was
  extracted, copied, guessed, or weakened.

```text
BLOCKER=HV_LORE_PRIVILEGED_EXECUTION_CREDENTIAL_UNAVAILABLE
operation=exact-GUID readonly old-rpool import, bounded dataset mounts, and complete disk-image inventory
observed=verified host reachable but root and expired human certificate rejected; governed executor remains sealed inside reachable Semaphore and no operator session/API credential is available to this session
expected=an admitted privileged SSH identity or authenticated Semaphore launch path for the execution-ready packet
authority=operator-authorized HV-LORE-OLD-RPOOL-IMAGE-INVENTORY plus ansible-cp ownership of governed executor credentials
why_not_ordinary_debugging=continuing would require issuing, extracting, copying, guessing, or bypassing a privileged credential, which is a new security authority decision
```

## Live result

```text
OLD_RPOOL_IMPORTED=NO
OLD_RPOOL_MOUNTED=NO
OLD_RPOOL_MUTATION=NONE
DISK_IMAGE_INVENTORY=NOT_COLLECTED
```

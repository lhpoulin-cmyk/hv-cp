# hv-lore host baseline accepted

Date: 2026-08-27
Packet: [post-reinstall realization](../implementation/2026-08-27-hv-lore-post-reinstall-realization.packet.md)
Runbook: [post-reinstall realization](../runbooks/2026-08-27-hv-lore-post-reinstall-realization.md)

The privileged read-only CHECK passed before mutation:

```text
hv-lore ok=44 changed=0 unreachable=0 failed=0 skipped=0 rescued=0 ignored=0
```

The operator then supplied the exact required acknowledgement and launched the
admitted APPLY through Semaphore.

```text
SEMAPHORE_TASK=69
SEMAPHORE_TEMPLATE=19
ANSIBLE_CP_COMMIT=cb8cf1e9e1ab0dceedb56217853dabc2ac52d3f6
TASK_STATUS=success
START_UTC=2026-08-28T01:52:33Z
END_UTC=2026-08-28T01:53:13Z
```

Machine-readable result:

```text
HV_LORE_HOST_BASELINE=PASS
NETWORK_CHANGED=True
MANAGEMENT=192.168.10.20/24@vmbr0
STORAGE=192.168.100.20/24@vmbr1
STORAGE_PHYSICAL=0000:89:00.1/14:02:ec:71:fc:b1
STORAGE_MTU=9000
STORAGE_DEFAULT_GATEWAY=NONE
APT_MUTATION=NONE
PACKAGE_MUTATION=NONE
AUTOMATION_MUTATION=NONE
OLD_RPOOL_MUTATION=NONE
GUEST_MUTATION=NONE
```

The APPLY passed its management-gateway ping, 8972-byte DF ping to
`192.168.100.1`, exact vmbr0/vmbr1 address and MTU assertions, storage-plane
no-default-route assertion, and final `rpool` health assertion.

```text
hv-lore ok=58 changed=2 unreachable=0 failed=0 skipped=0 rescued=0 ignored=0
```

Only `/etc/network/interfaces` and live network realization were in scope.
No APT, package, DNS, automation, boot, pool, rollback-media, PVE storage,
disk, VFIO, or guest mutation occurred.

```text
BASELINE_APPLY=PASS
MANAGEMENT_REACHABILITY=PASS
JUMBO_FABRIC_PATH=PASS
RPOOL_POSTCHECK=PASS
OLD_RPOOL_MUTATION=NONE
GUEST_MUTATION=NONE
HOST_BASELINE_PHASE=CLOSED
NEXT_PHASE=ADMITTED_GUEST_RESTORATION
```

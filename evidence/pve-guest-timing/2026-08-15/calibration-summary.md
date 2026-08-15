# PVE Guest Timing V2 calibration summary

Date: 2026-08-15 12:32–12:34 and 12:55 EDT
V1 branch/PR: `agent/pve-guest-timing-v1`, [PR #1](https://github.com/lhpoulin-cmyk/hv-cp/pull/1)

| guest | cycles | shutdown min/median/max | running min/median/max | init/QGA min/median/max | service min/median/max | proposed up | proposed down | confidence |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| hv-katra VM320 `cuda-compute-katra` | 3 | 0.553 / unavailable / 0.557 s | 0.567 / unavailable / 0.580 s | QGA 22.975 / unavailable / 23.535 s | Ollama 19.066 / unavailable / 19.743 s | 30 s | 10 s | MEDIUM |
| hv-katra CT122 `lxc-katra-print` | 3 | 0.538 / 0.542 / 0.542 s | 0.566 / 0.566 / 0.570 s | init 1.656 / 1.665 / 1.675 s | unavailable | 5 s | 5 s | MEDIUM |

VM320 started and stopped gracefully three times and returned to its original
running state. QGA, network, and the existing `ollama` service were separately
observed. QGA response was slower than the service probe in these samples;
QGA response is not treated as application readiness. The retry report supplied
min/max ranges but not the three individual samples, so medians are deliberately
left unavailable rather than manufactured. The proposed `up=30` provides a
modest margin above the observed QGA maximum; `down=10` provides a modest
allowance above the observed graceful shutdown maximum.

CT131 was selected because it was stopped and noncritical, but its setup start
failed immediately. Its configuration references
`/mnt/truenas/secure-rw/jellyfin-media` as `mp0`; the failure was recorded from
the PVE task/journal and was not repaired or retried. It remained stopped, its
original state. No LXC timing value is inferred from the failed attempt. CT131
was subsequently retired and destroyed with `pct destroy 131 --purge` after
its local rootfs ownership and PVE references were checked. Its failed
calibration remains historical evidence; it is not an active policy target.

CT122 was selected as the replacement because it is an unprivileged,
best-effort print container with no `mpX` mount or storage/DNS/Foundation role.
It completed three graceful cycles and returned to its original running state.
The init and network probes succeeded; no application service probe was used.
The measured `up=5`, `down=5` values add a modest margin to the observed
milestones.

Lore collection was completed through the authorized key-only SSH path for all
17 guests. Inventory, recent-boot, readiness, and plan completed. The expired
workstation certificate was not renewed because it was not needed for this
collection path. Lore boot task ordering and per-guest timing remain
`UNAVAILABLE` because the current journal/task evidence did not expose those
events; readiness probes were collected without changing guest state.

No startup configuration, host reboot, storage, network, or Ceph change was
made. The active fleet proposal now contains 28 guests; CT131 is retained only
in retirement and historical calibration evidence.

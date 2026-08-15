# PVE Guest Timing V2 calibration summary

Date: 2026-08-15 12:32–12:34 EDT
V1 branch/PR: `agent/pve-guest-timing-v1`, [PR #1](https://github.com/lhpoulin-cmyk/hv-cp/pull/1)

| guest | cycles | shutdown min/median/max | running min/median/max | init/QGA min/median/max | service min/median/max | proposed up | proposed down | confidence |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| hv-katra VM320 `cuda-compute-katra` | 3 | 0.553 / unavailable / 0.557 s | 0.567 / unavailable / 0.580 s | QGA 22.975 / unavailable / 23.535 s | Ollama 19.066 / unavailable / 19.743 s | 30 s | 10 s | MEDIUM |
| hv-katra CT131 `lxc-katra-jellyfin` | 0 completed | unavailable | unavailable | unavailable | unavailable | retain 20 s, unmeasured | retain 30 s, unmeasured | UNAVAILABLE |

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
original state. No LXC timing value is inferred from the failed attempt.

Lore collection was completed through the authorized key-only SSH path for all
17 guests. Inventory, recent-boot, readiness, and plan completed. The expired
workstation certificate was not renewed because it was not needed for this
collection path. Lore boot task ordering and per-guest timing remain
`UNAVAILABLE` because the current journal/task evidence did not expose those
events; readiness probes were collected without changing guest state.

No startup configuration, host reboot, storage, network, or Ceph change was
made.

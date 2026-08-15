# PVE Guest Timing V2 calibration summary

Date: 2026-08-15 12:32–12:34 EDT
V1 branch/PR: `agent/pve-guest-timing-v1`, [PR #1](https://github.com/lhpoulin-cmyk/hv-cp/pull/1)

| guest | cycles | shutdown min/median/max | running min/median/max | init/QGA min/median/max | service min/median/max | proposed up | proposed down | confidence |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| hv-katra VM320 `cuda-compute-katra` | 3 | 0.550 / 0.559 / 0.563 s | 0.565 / 0.565 / 0.568 s | QGA 22.975 / 23.088 / 23.321 s | Ollama 19.066 / 19.181 / 19.413 s | 30 s | 10 s | MEDIUM |
| hv-katra CT131 `lxc-katra-jellyfin` | 0 completed | unavailable | unavailable | unavailable | unavailable | retain 20 s, unmeasured | retain 30 s, unmeasured | UNAVAILABLE |

VM320 started and stopped gracefully three times and returned to its original
running state. QGA, network, and the existing `ollama` service were separately
observed. QGA response was slower than the service probe in these samples;
QGA response is not treated as application readiness. The proposed `up=30`
provides a modest margin above the observed QGA median. The proposed `down=10`
provides a modest allowance above the observed graceful shutdown median.

CT131 was selected because it was stopped and noncritical, but its setup start
failed immediately. Its configuration references
`/mnt/truenas/secure-rw/jellyfin-media` as `mp0`; the failure was recorded from
the PVE task/journal and was not repaired or retried. It remained stopped, its
original state. No LXC timing value is inferred from the failed attempt.

`HV_LORE_TIMING_COLLECTION=DEFERRED_AUTH`: the normal workstation certificate
was expired; auth-cp requires a fresh one-time authorization and Foundation’s
checked-in signer profile is disabled. No credential or Lore guest state was
changed. No substitute LXC met the safety boundary without guessing.

No startup configuration, host reboot, storage, network, or Ceph change was
made.

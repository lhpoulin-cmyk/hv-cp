# Proposed PVE startup order V1

Proposal only. No `qm set` or `pct set` command was run.

Coarse waves: 10 FOUNDATION, 20 STORAGE, 30 IDENTITY_DNS, 40 NETWORK_SERVICE,
50 APPLICATION, 90 BEST_EFFORT. `ORDER_UNSET` remains unset where dependency
authority is missing. Native shutdown reverses these waves, yielding
applications → network/identity → storage → foundation.

The only measured policy is VM320: `up=30`, `down=10`, from three cycles. All
other delays retain observed values or remain unset. Lore inventory and
readiness were refreshed over key-only SSH; its boot task ordering and timing
remain unavailable in current evidence.

| host | ID | guest | class | onboot | order | up | down | readiness basis | confidence |
| --- | ---: | --- | --- | ---: | ---: | ---: | ---: | --- | --- |
| hv-katra | 244 | time-katra | FOUNDATION | 1 | 10 | 10 | - | init existing | LOW |
| hv-katra | 110 | truenas-katra | STORAGE | 1 | 20 | 120 | 120 | QGA existing | LOW |
| hv-katra | 241 | pbs-lore | STORAGE | 1 | 20 | 30 | 60 | QGA existing | LOW |
| hv-katra | 251 | lxc-katra-dns | IDENTITY_DNS | 1 | 30 | 20 | 30 | init existing | LOW |
| hv-katra | 120 | lxc-katra-os | UNRESOLVED | 1 | unset | - | - | init observed | LOW |
| hv-katra | 249 | vaultwarden-lore | UNRESOLVED | 1 | unset | 20 | 30 | init existing | LOW |
| hv-katra | 122 | lxc-katra-print | BEST_EFFORT | 1 | 90 | - | - | init observed | LOW |
| hv-katra | 131 | lxc-katra-jellyfin | APPLICATION | 0 | 50 | 20 | 30 | start failed at mount | LOW |
| hv-katra | 320 | cuda-compute-katra | BEST_EFFORT | 1 | 90 | 30 | 10 | QGA/network/Ollama, 3 cycles | MEDIUM |
| hv-katra | 9320 | tpl-compute-ubuntu2604-20260808 | BEST_EFFORT | 0 | 90 | - | - | stopped | LOW |
| hv-matrix | 149 | semaphore-matrix-stage | UNRESOLVED | 0 | unset | - | - | init observed | LOW |
| hv-matrix | 310 | b70-encode | APPLICATION | 0 | 50 | - | - | QGA/network observed | LOW |
| hv-lore | 100,120,130,140,142,242,260,243,245,246,247,248,252 | current guests | existing classes | existing | coarse waves | existing | existing | inventory/readiness current; timing unavailable | LOW/UNAVAILABLE |
| hv-lore | 141,149,150 | current offboot guests | BEST_EFFORT | 0 | 90 | - | - | inventory current; timing unavailable | UNAVAILABLE |

Unresolved dependencies are Katra 120/249, Matrix 149/310, and Lore 249. The
Lore VM130 `up=180` is the largest proposal delay but is
not accepted as measured policy. Ansible-cp may consume the machine-readable
proposal later; hv-cp remains policy authority.

# PVE startup order V1

Katra and Matrix entries remain the 2026-08-15 proposal. The Lore entries are
the accepted policy observed after the completed 2026-08-29 migration and
reconciled on 2026-08-30. This document does not authorize runtime changes.

The Katra/Matrix proposal uses coarse waves: 10 FOUNDATION, 20 STORAGE, 30
IDENTITY_DNS, 40 NETWORK_SERVICE, 50 APPLICATION, 90 BEST_EFFORT.
`ORDER_UNSET` remains unset where dependency authority is missing. Lore uses
its accepted 1/2/3/4/5/50 policy and reverse-order shutdown described below.

Measured Katra policies are CT122 `up=5`, `down=5`, and VM320 `up=30`,
`down=10`, each from three cycles. Lore has a fresh-boot event timeline; it is
event-only evidence, not per-guest readiness measurement.

| host | ID | guest | class | onboot | order | up | down | readiness basis | confidence |
| --- | ---: | --- | --- | ---: | ---: | ---: | ---: | --- | --- |
| hv-katra | 244 | time-katra | FOUNDATION | 1 | 10 | 10 | - | init existing | LOW |
| hv-katra | 110 | truenas-katra | STORAGE | 1 | 20 | 120 | 120 | QGA existing | LOW |
| hv-katra | 241 | pbs-lore | STORAGE | 1 | 20 | 30 | 60 | QGA existing | LOW |
| hv-katra | 251 | lxc-katra-dns | IDENTITY_DNS | 1 | 30 | 20 | 30 | init existing | LOW |
| hv-katra | 120 | lxc-katra-os | UNRESOLVED | 1 | unset | - | - | init observed | LOW |
| hv-katra | 249 | vaultwarden-lore | UNRESOLVED | 1 | unset | 20 | 30 | init existing | LOW |
| hv-katra | 122 | lxc-katra-print | BEST_EFFORT | 1 | 90 | 5 | 5 | init/network, 3 cycles | MEDIUM |
| hv-katra | 320 | cuda-compute-katra | BEST_EFFORT | 1 | 90 | 30 | 10 | QGA/network/Ollama, 3 cycles | MEDIUM |
| hv-katra | 9320 | tpl-compute-ubuntu2604-20260808 | BEST_EFFORT | 0 | 90 | - | - | stopped | LOW |
| hv-matrix | 149 | semaphore-matrix-stage | UNRESOLVED | 0 | unset | - | - | init observed | LOW |
| hv-matrix | 310 | b70-encode | APPLICATION | 0 | 50 | - | - | QGA/network observed | LOW |
| hv-lore | 243 | time-lore | FOUNDATION | 1 | 1 | 5 | - | accepted policy; fresh-boot event | HIGH |
| hv-lore | 252 | lxc-lore-dns | IDENTITY_DNS | 1 | 1 | 10 | - | accepted policy; fresh-boot event | HIGH |
| hv-lore | 120 | truenas-lore | STORAGE | 1 | 2 | 30 | 120 | QGA and slowPool accepted; fresh-boot event | HIGH |
| hv-lore | 245 | ntfy-lore | CORE_INFRASTRUCTURE | 1 | 3 | 5 | - | accepted policy; fresh-boot event | HIGH |
| hv-lore | 246 | lxc-lore-headscale | CORE_INFRASTRUCTURE | 1 | 3 | 10 | - | accepted policy; fresh-boot event | HIGH |
| hv-lore | 247 | lxc-lore-monitor | CORE_INFRASTRUCTURE | 1 | 3 | 5 | - | accepted policy; fresh-boot event | HIGH |
| hv-lore | 260 | pbs-core | CORE_INFRASTRUCTURE | 1 | 3 | 15 | 60 | PBS accepted; fresh-boot event | HIGH |
| hv-lore | 130 | jellyfin-lore | APPLICATION | 1 | 4 | 10 | 60 | accepted policy; fresh-boot event | HIGH |
| hv-lore | 248 | lxc-lore-www | APPLICATION | 1 | 4 | 5 | - | accepted policy; fresh-boot event | HIGH |
| hv-lore | 100 | ansible-console | LATE_HEAVY | 1 | 5 | 5 | 30 | accepted policy; fresh-boot event | HIGH |
| hv-lore | 140 | ws-lore-agent | LATE_HEAVY | 1 | 5 | 10 | 60 | accepted policy; fresh-boot event | HIGH |
| hv-lore | 142 | eq-lore | LATE_HEAVY | 1 | 5 | 5 | 30 | accepted policy; fresh-boot event | HIGH |
| hv-lore | 242 | pbs-katra | FINAL_BACKUP | 1 | 50 | - | 60 | accepted policy; final `up=30` removed after measurement | HIGH |
| hv-lore | 141 | ws-lore-apropos | MANUAL | 0 | - | - | - | accepted manual classification | HIGH |
| hv-lore | 149 | ws-matriarch-gauntlet | MANUAL | 0 | - | - | - | accepted manual classification | HIGH |
| hv-lore | 150 | wow-unbound-prod | MANUAL | 0 | - | - | - | accepted manual classification | HIGH |
| hv-lore | 249 | vaultwarden-lore | PARKED_INCOMPLETE | 0 | - | - | - | shell exists; no deployed Vaultwarden runtime | HIGH |

Unresolved dependencies are Katra 120/249 and Matrix 149/310. Lore has no
unresolved classification: CT249 is parked/incomplete. Lore's former VM130
`up=180` is historical and superseded. VM242's fresh-boot measurement still
included its former final `up=30`; removing it is expected to shorten an
equivalent boot by about 30 seconds, but that effect has not been measured.
Ansible-cp may consume the machine-readable policy; hv-cp remains policy
authority.

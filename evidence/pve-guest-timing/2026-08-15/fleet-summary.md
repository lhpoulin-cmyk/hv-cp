# PVE Guest Timing V1 fleet summary

Captured 2026-08-15 from hv-cp `16bdaeb4f9c0bff379b303f8f65b1ec986f6922d`.
All collection was read-only. `measure-cycle` was not executed.

## Fleet planning matrix

`ORDER_UNSET` is preserved as unset. Roles and dependency classes are
`UNRESOLVED` unless an existing record explicitly supplied them; no role was
guessed. Suggested values are recommendations only and currently retain the
observed configuration because no controlled timing cycle has been accepted.

| host | ID | guest | type | role | current onboot | current order | current up | current down | running | QGA/init readiness | recent-boot evidence | suggested order | suggested up | suggested down | confidence | dependency notes |
| --- | ---: | --- | --- | --- | ---: | --- | ---: | ---: | --- | --- | --- | ---: | ---: | ---: | --- | --- |
| hv-katra | 244 | time-katra | CT | UNRESOLVED | 1 | 1 | 10 | - | running | INIT_RESPONDING | EVENT_ONLY | 1 | 10 | - | LOW | class/edges not supplied |
| hv-katra | 110 | truenas-katra | VM | UNRESOLVED | 1 | 10 | 120 | 120 | running | QGA_RESPONDING; network probe OK | EVENT_ONLY | 10 | 120 | 120 | LOW | storage-like name is not a classification |
| hv-katra | 249 | vaultwarden-lore | CT | UNRESOLVED | 1 | 20 | 20 | 30 | running | INIT_RESPONDING | EVENT_ONLY | 20 | 20 | 30 | LOW | class/edges not supplied |
| hv-katra | 251 | lxc-katra-dns | CT | UNRESOLVED | 1 | 20 | 20 | 30 | running | INIT_RESPONDING | EVENT_ONLY | 20 | 20 | 30 | LOW | DNS-like name is not a classification |
| hv-katra | 120 | lxc-katra-os | CT | UNRESOLVED | 1 | 30 | 20 | 30 | running | INIT_RESPONDING | EVENT_ONLY | 30 | 20 | 30 | LOW | class/edges not supplied |
| hv-katra | 131 | lxc-katra-jellyfin | CT | UNRESOLVED | 0 | 40 | 20 | 30 | stopped | - | EVENT_ONLY | 40 | 20 | 30 | LOW | app-like name is not a classification |
| hv-katra | 241 | pbs-lore | VM | UNRESOLVED | 1 | 50 | 30 | 60 | running | QGA_RESPONDING; network probe OK | EVENT_ONLY | 50 | 30 | 60 | LOW | backup-like name is not a classification |
| hv-katra | 122 | lxc-katra-print | CT | UNRESOLVED | 1 | ORDER_UNSET | - | - | running | INIT_RESPONDING | EVENT_ONLY | ORDER_UNSET | - | - | LOW | no explicit order or class evidence |
| hv-katra | 320 | cuda-compute-katra | VM | UNRESOLVED | 1 | ORDER_UNSET | - | - | running | QGA_RESPONDING; network probe OK | EVENT_ONLY | ORDER_UNSET | - | - | LOW | no explicit order or class evidence |
| hv-katra | 9320 | tpl-compute-ubuntu2604-20260808 | VM | UNRESOLVED | 0 | ORDER_UNSET | - | - | stopped | - | EVENT_ONLY | ORDER_UNSET | - | - | LOW | template-like name is not a classification |
| hv-matrix | 149 | semaphore-matrix-stage | CT | UNRESOLVED | 0 | ORDER_UNSET | - | - | running | INIT_RESPONDING | UNAVAILABLE (boot 2026-08-02) | ORDER_UNSET | - | - | LOW | no explicit order or class evidence |
| hv-matrix | 310 | b70-encode | VM | UNRESOLVED | 0 | ORDER_UNSET | - | - | running | QGA_RESPONDING; network probe OK | UNAVAILABLE (boot 2026-08-02) | ORDER_UNSET | - | - | LOW | no explicit order or class evidence |
| hv-lore | - | live collection unavailable | - | UNRESOLVED | - | - | - | - | UNKNOWN | UNKNOWN | AUTH_LIMITATION | - | - | - | UNAVAILABLE | expired `lab-operator-view` certificate; last durable startup record is 2026-08-14 and is not substituted for current state |

## Host observations

### hv-lore

The documented SSH path reached `192.168.10.20` but authentication was
rejected because the installed `lab-operator-view` certificate expired at
`2026-08-15T03:30:10`. No inventory, journal, QGA, guest start, or mutation
command ran on Lore. The prior 2026-08-14 record shows 17 guests and preserved
startup settings, but it is explicitly historical for this play. This is an
`AUTHENTICATION_LIMITATION`, not a maintenance claim.

### hv-katra

Ten guests were inventoried. Nine have explicit order values; CT 122 and VMs
320/9320 are `ORDER_UNSET`. The current host boot and `pve-guests` sequence are
recoverable from journal evidence. Guest completion precision is not claimed
for all guests, so confidence is `EVENT_ONLY`. Five running CT init probes and
three running VM QGA probes succeeded.

### hv-matrix

Two guests were inventoried; both are `ORDER_UNSET` and both have `onboot=0`.
The host boot is 2026-08-02, not a recent boot for this play. VM 310 QGA and CT
149 init probes succeeded. No startup settings were changed.

## Planner and cross-host boundary

The planner retained current explicit order/up/down values and left unset
values unset. It did not infer dependency classes or create edges. Measured
readiness baselines and modest safety margins become actionable only after a
future controlled `measure-cycle` acceptance. Proxmox startup order is
host-local: host-local sequencing maps to native PVE startup settings;
cross-host sequencing belongs to future ansible-cp/Semaphore orchestration.
After Ceph clustering, cold-start planning must include cluster quorum before
`pve-guests` starts onboot guests.

## Checkpoint

```text
public references:
  Proxmox docs: references/pve-guest-timing/README.md (official 9.x guide)
  Boot Order Checker: gist, REFERENCE_ONLY; not vendored
  Community Scripts: MIT; commit 91fd6e57a66c10f3c0d76037ee7116af708bcf87
tool:
  inventory: implemented and run on Katra/Matrix
  recent-boot: implemented and run on Katra/Matrix
  readiness: implemented and run on Katra/Matrix
  plan: implemented and run on Katra/Matrix
  measure-cycle prepared: yes; not executed
hv-lore: live collection limited by expired SSH certificate; historical record not substituted
hv-katra: 10 guests; boot 2026-08-15 11:18:40 EDT; 9 explicit orders; QGA/init coverage successful for running probes
hv-matrix: 2 guests; boot 2026-08-02 22:05:39 EDT; no explicit orders; QGA/init coverage successful for running probes
fleet:
  current-order problems: unset order on Katra 122/320/9320 and Matrix 149/310; no order invented
  missing onboot: Matrix 149/310 are onboot=0; Katra 131/9320 are onboot=0
  missing QGA: none among running configured/probed Katra/Matrix VMs; stopped VMs not probed
  unresolved dependencies: all live rows
  obvious timing waste: not asserted without measured cycles
  likely critical path: not asserted without dependency authority
live effects:
  guests started: none
  guests stopped: none
  hosts rebooted: none
  startup settings changed: none
  Ceph changed: none

PVE_GUEST_TIMING_V1: PARTIAL — hv-lore current read-only collection could not authenticate with the expired configured SSH certificate; no safe credential renewal was authorized in this play.
```

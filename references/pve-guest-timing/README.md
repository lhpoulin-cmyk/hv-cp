# PVE guest timing references

Recorded 2026-08-15 against hv-cp `16bdaeb4f9c0bff379b303f8f65b1ec986f6922d`.
The checkout was online but its cached `origin/main` was behind/ahead-diverged;
remote currency was not used as a claim for this play.

## Proxmox official documentation

- Source: [Proxmox VE Administration Guide 9.x](https://pve.proxmox.com/pve-docs/pve-admin-guide.pdf)
- Retrieved: 2026-08-15
- Relevant section: `qm_startup_and_shutdown`; the `startup` property carries
  `order`, `up`, and `down`, with reverse order for shutdown. The guide also
  describes the host-local nature of startup/shutdown ordering.
- Version: the current official 9.x guide available at retrieval; the live
  hosts are expected to report their installed PVE version during collection.

## Proxmox Boot Order Checker

- Upstream: [ErilovNikita/Proxmox Boot Order Checker gist](https://gist.github.com/ErilovNikita/826cad44182a75b143b1e9d7a56557d4)
- Retrieved: 2026-08-15; latest visible revision at retrieval: 7 revisions,
  last active 2026-08-15.
- Disposition: `REFERENCE_ONLY`.
- Reason: useful table, sorting, and field-selection ideas; no explicit license
  was accepted for vendoring. Its implementation was not copied.

## Community Scripts ProxmoxVE

- Upstream: [community-scripts/ProxmoxVE](https://github.com/community-scripts/ProxmoxVE)
- License: MIT (repository license page, retrieved 2026-08-15).
- Exact upstream commit inspected: `91fd6e57a66c10f3c0d76037ee7116af708bcf87`
  (2026-08-15 commit listing; [commit page](https://github.com/community-scripts/ProxmoxVE/commit/91fd6e57a66c10f3c0d76037ee7116af708bcf87)).
- Consulted source files/functions at that commit:
  - `vm/docker-vm.sh`: VM creation/start block (`qm create`, `qm start`),
    status/existence checks, QEMU agent enablement, and the post-start
    `qm guest cmd ... network-get-interfaces` polling loop.
  - `misc/install.func`: `setting_up_container`, the bounded container
    network/readiness retry loop.
  - The repository revision did not contain a reusable graceful-shutdown
    wait function; this is recorded as a documentation gap rather than
    attributed to Community Scripts. No Community Scripts code is copied or
    adapted in this play.
- Scope statement: hv-cp uses only the concepts, not source code. There is no
  copied notice to retain because no code was copied.

## Design boundary

`tools/pve-guest-timing` is standard-library Python. Its inventory, boot, plan,
and readiness surfaces are read-only; its explicitly invoked `measure-cycle`
is the bounded guest lifecycle actuator described in the V2 calibration packet.
It uses
supported `qm`, `pct`, `pvesh`-compatible guest query surfaces, `qm guest cmd`
for an already configured QGA probe, `pct exec true` for an already-running
container init probe, and journal/systemd evidence. It never invokes `qm set`,
`pct set`, reboot, or force-stop. `measure-cycle` invokes only explicit graceful
start/shutdown requests, captures milestones, and restores the original state;
it refuses to run without an explicit guest type and ID.

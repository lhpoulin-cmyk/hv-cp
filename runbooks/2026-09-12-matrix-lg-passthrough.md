# Matrix LG-only passthrough

Governed by the [LG packet](../implementation/2026-09-12-matrix-lg-passthrough.packet.md).
This supersedes the earlier LG deferral only. HP remains on host SATA.

Use strict management SSH to hv-matrix/192.168.10.22 with hv-matrix.arpa key
alias and existing operator credentials. Use sudo and installed PVE qm commands.
Save exact config/pending plus the read-only
[optical inventory](helpers/optical-inventory.py) on host and guest, and the
[workload collector](helpers/optical-workload-readiness.py) in the guest through
qm guest exec. The latter collects service/timer/job metadata, login/container/
cron presence, GPU handles, boot/identity and mount metadata; it changes nothing
and reads neither media nor credential contents. Retain private output under the
packet's inbox directory; require completed guest-agent execution and inspect
individual return codes. fuser rc 1 with empty output means no handles.

Verify exact physical serials, isolated ASMedia 03:00.0 with only LG attached,
no optical mounts/workloads/queues, existing GPU/USB values, no pending edits,
management route and rpool. No external documentation retrieval is needed:
installed `qm help set`, `qm help shutdown`, `qm help start` are captured.

Apply the packet's exact shutdown, stopped-state recheck, qm set and start
sequence. Read the config digest using
`pvesh get /nodes/hv-matrix/qemu/310/config --output-format json` and pass it
as `qm set --digest` to prevent a concurrent overwrite. Compare full config
before/after allowing only the three named properties. Do not force a stop,
ignore locks, or manually rewrite PVE state.

On running guest acceptance, correlate LG serial from host-before to guest-after
and USB identity across inventories. Verify sr/sg pairs, guest ahci, GPU xe and
audio driver, render access and all five media mountpoints. Verify host management,
rpool, retained HP controller, no pending edits. Preserve before/after config,
collector output and SHA256SUMS, then write reviewed evidence and canonical
projection. A start under the new config proves initial realization, not a host
reboot or repeated VFIO reset cycle. Do not read discs or run an encode.

For failure, follow the packet's optical-only rollback using the exact before
config. Never restore the whole file over unrelated changes. Inspect PVE-managed
controller recovery if required; a new manual driver recovery choice requires
separate qualification. Keep the independent host management path available.

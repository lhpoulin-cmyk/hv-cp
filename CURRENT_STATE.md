# hv-cp current work

## Matrix three-drive optical assignment — 2026-09-11

Status: deferred by operator; shared host-storage controller is a known limitation.
The [desired state](docs/MATRIX_OPTICAL_DESIRED_STATE.md) requires all three
physical optical drives in VM310. Discovery identified all three, correlated
the existing USB assignment, and confirmed both B70 mappings unchanged.
The HP DVD drive shares Intel SATA controller `00:17.0` with both rpool disks;
that controller must remain on the host. The LG Blu-ray drive is alone on
ASMedia controller `03:00.0`, with an isolated IOMMU group and advertised reset
methods. No passthrough change or shutdown was performed.

Operator disposition — 2026-09-11: retain this as a known limitation; no
recabling or live realization today. Moving the HP GUD1N to an available port
on the isolated ASMedia controller is the agreed future direction, subject to
physical connector verification and a separate powered-off maintenance plan.
No maintenance window is scheduled and no operator action is currently due.

On explicit resumption: resolve the HP drive's safe attachment method, then refresh the
packet, qualify the executor and any required shutdown/APPLY acknowledgement,
and rerun all live preconditions. A physical move needs separately planned
powered-off maintenance. Do not count the existing QEMU DVD-ROM as a physical
drive or claim simultaneous three-drive acceptance.

This entry tracks the bounded current task; it does not replace the private
node records or earlier immutable portfolio evidence.

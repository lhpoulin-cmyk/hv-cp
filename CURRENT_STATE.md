# hv-cp current work

## Matrix LG optical passthrough — 2026-09-12

Status: LG-only realization accepted. VM310 `b70-encode` is running with the
physical LG WH16NS60 through isolated ASMedia `03:00.0` in `hostpci2`.
Guest LG is `/dev/sr1` + `/dev/sg3`; the retained USB BP50NB40 is
`/dev/sr0` + `/dev/sg2`. Both physical identities match private preflight.
The former virtual DVD `ide2` and its boot entry were removed. GPU mappings,
USB configuration, disks and all other properties are unchanged.

The operator resumed LG-only work on September 12. One clean guest shutdown
and start passed. Host management/rpool, guest GPU drivers/render access and
media mounts passed. PVE emitted a BAR 5 dma-buf mapping warning; controller
initialization and drive enumeration passed. Subsequent
[read-only disc qualification](evidence/2026-09-12-matrix-lg-disc-io.md) read
16 MiB successfully with aligned O_DIRECT and passed SCSI inquiry without new
host/guest kernel errors. Initial uutils dd direct mode failed with Invalid input;
the aligned retry passed. Full-disc I/O and repeated VFIO cycles remain untested. No host restart or application change.

The three-drive [desired state](docs/MATRIX_OPTICAL_DESIRED_STATE.md) remains
incomplete: HP GUD1N shares Intel `00:17.0` with both rpool disks and is still
absent from the guest. Its recabling remains deferred with no maintenance
window. A future physical move requires a separately approved powered-off plan.

See [LG packet](implementation/2026-09-12-matrix-lg-passthrough.packet.md),
[runbook](runbooks/2026-09-12-matrix-lg-passthrough.md), and
[accepted evidence](evidence/2026-09-12-matrix-lg-passthrough.md).

Downstream consumption: [LG qualification handoff](docs/MATRIX_LG_QUALIFICATION_HANDOFF.md)
records separate enumeration/disc-I/O PASS results and the retained limitations.

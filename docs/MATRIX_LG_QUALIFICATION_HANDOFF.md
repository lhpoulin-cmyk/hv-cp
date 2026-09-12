# Matrix LG WH16NS60 qualification handoff

Owner: hv-cp. Consumers: ansible-cp and arm-cp. Target: hv-matrix, VM310
`b70-encode`, guest `b70-encode-matrix`. This is accepted observation evidence,
not authorization to deploy ARM, launch automation, rip, encode, or mutate a host.
Consume this document and its evidence at the immutable published Git commit,
not a moving branch. No credential or raw identity manifest is published.

## Accepted state — 2026-09-12

| Qualification | Result | Evidence |
| --- | --- | --- |
| Native LG passthrough enumeration | PASS | [Passthrough acceptance](../evidence/2026-09-12-matrix-lg-passthrough.md) |
| Actual Blu-ray disc I/O | PASS | [Read qualification](../evidence/2026-09-12-matrix-lg-disc-io.md) |
| Read-only generic-SCSI inquiry | PASS | Same read qualification; standard INQUIRY exits 0 |
| Other optical devices | USB retained and available at passthrough acceptance; HP explicitly deferred | [Current optical state](MATRIX_OPTICAL_DESIRED_STATE.md) |

LG WH16NS60 is assigned through isolated ASMedia SATA controller 03:00.0 in
hostpci2. Native guest /dev/sr1 and /dev/sg3 correlate to the same exact physical
LG identity. The virtual ide2 attachment and its boot-order entry were removed;
GPU, USB, disks and unrelated VM properties were preserved. Device enumeration
paths are dated observations; consumers must requalify identity before use.

The mounted-state check found the LG unmounted. Detected Blu-ray capacity is
86,710,419,456 bytes; filesystem UDF 2.50; label BACK_TO_THE_FUTURE_PART_II.
The successful aligned O_RDONLY|O_DIRECT test read exactly 16,777,216 bytes
from offset zero in 2.491 seconds, exit 0. SCSI inquiry also exited 0.

## Preserve both read outcomes

1. Initial uutils dd 0.8.0 direct mode: exit 1, `IO error: Invalid input`, no
   byte count emitted. It is not a passed read; transferred bytes are UNKNOWN.
2. Subsequent aligned read: exit 0, 16,777,216 bytes. Anonymous page-aligned
   buffers and positioned O_RDONLY|O_DIRECT reads succeeded. No package,
   device setting or permission was changed to obtain that result.

The precise cause of the dd failure was not established. It remains separate
from the accepted aligned read, with both exact commands and results retained.

The earlier QEMU startup BAR-mapping warning is preserved. No controller reset,
I/O error, optical error or BAR failure was observed in host or guest kernel
logs during the qualified read; both after-cursor collections exited 0 with
no new entries. This is bounded non-recurrence evidence, not a claim that the
startup warning was repaired or that all possible workloads are qualified.

## Remaining boundary

USB BP50NB40 remains assigned by existing usb0 and was native/available after
the guest start. It was not probed during the LG-only disc test. HP GUD1N is
absent from the guest and explicitly deferred: its Intel controller also owns
host rpool disks and must not be assigned. No HP recabling is scheduled.

No full-disc scan, integrity/decryption qualification, rip, encode, package
installation, service/account/mount change, host reboot or repeated VFIO
lifecycle test is claimed. Three-drive acceptance remains incomplete.

## Publication validation

See [scoped publication checks](../evidence/2026-09-12-matrix-lg-publication-validation.md).
Only hv-cp optical scope is published. Private canonical Matrix records were
updated and validated locally; no peer repository is committed or pushed.

# Matrix optical desired state

Owner: hv-cp. Target: hv-matrix, PVE VM310 `b70-encode`, guest hostname
`b70-encode-matrix`. These names were correlated through the running guest
agent and matching SMBIOS UUID on 2026-09-11; they are not separate VMs.

## Desired state

The operator explicitly requires all three physical optical drives to be
simultaneously available to this guest for Helix ARM. Each must retain a
provable physical identity and expose a paired optical block and generic-SCSI
interface. This authorizes no ARM/Docker work, disc access, media changes,
other guest changes, or GPU changes.

| Stable logical identity | Physical model / transport | Selected or conditional method |
| --- | --- | --- |
| matrix-sata-bluray | LG WH16NS60, SATA | Whole ASMedia controller `0000:03:00.0` assigned as hostpci2 on 2026-09-12; LG-only acceptance passed. |
| matrix-sata-dvd | HP GUD1N, SATA | Unresolved: present controller also owns host rpool disks and is forbidden. Prefer physically relocating this drive onto the isolated optical controller, subject to a separately planned hardware-maintenance step. No raw-device workaround selected. |
| matrix-usb-bluray | HL-DT-ST BP50NB40, USB | Preserve existing `usb0: host=1-13,usb3=1`; host/guest serial equality proves current physical identity. Port binding requires requalification if cables move. |

Full serials, by-id/by-path identities, topology, and the complete before
configuration are in the private manifest and captures named in the
[packet](../implementation/2026-09-11-matrix-three-optical.packet.md).
Do not copy raw identifiers into shared documentation. Enumeration names below
are dated evidence only, never future selectors.

## Current observation — 2026-09-12

LG-only work resumed explicitly and passed under the
[LG packet](../implementation/2026-09-12-matrix-lg-passthrough.packet.md).
The guest now sees native WH16NS60 `/dev/sr1` + `/dev/sg3`, exact serial
matching host preflight, through ASMedia ahci. USB BP50NB40 remains native,
now `/dev/sr0` + `/dev/sg2`, with matching USB serial. Host ASMedia uses
vfio-pci; HP and both rpool disks remain on host Intel ahci.

Only hostpci2, ide2 removal and boot order changed. Guest clean shutdown/start,
GPU xe/audio drivers, louis render access, all five media mountpoints,
management and healthy rpool passed. PVE emitted a BAR 5 dma-buf warning;
initialization/enumeration passed. Subsequent
[disc qualification](../evidence/2026-09-12-matrix-lg-disc-io.md) passed a 16 MiB
aligned direct read and SCSI inquiry with no new kernel errors. Initial uutils
dd direct mode returned Invalid input; aligned retry passed. Full-disc I/O
and repeated VFIO cycles remain untested.
No host reboot, media operation or ARM/Docker change. See
[acceptance evidence](../evidence/2026-09-12-matrix-lg-passthrough.md).

## Historical observation — 2026-09-11

| Drive | Host block / generic SCSI | Guest block / generic SCSI | Finding |
| --- | --- | --- | --- |
| HP GUD1N | `/dev/sr0` / `/dev/sg2` | Absent | On Intel `0000:00:17.0`, IOMMU group 30, driver ahci; same controller owns both host rpool member disks. No per-function reset file. Forbidden controller assignment. |
| LG WH16NS60 | `/dev/sr1` / `/dev/sg4` | Represented by QEMU DVD-ROM `/dev/sr0` / `/dev/sg2` | Existing stable-by-id `ide2` media attachment does not establish native physical-command passthrough. |
| USB BP50NB40 | USB port `1-13`, VID:PID `152e:2571`; no host sr node while claimed | `/dev/sr1` / `/dev/sg3` | Exactly one matching USB serial on host and guest. Persistent PVE port assignment already exists. |

The ASMedia ASM1061/ASM1062 SATA controller `0000:03:00.0` (`1b21:0612`)
is the dedicated controller matching the operator-reported relocation. Current
topology proves only the WH16NS60 is attached; installation date is not proven.
IOMMU group 36 contains only that function, ahci owns it, and sysfs advertises
`pm bus` reset methods. Ports ata9 and ata10 exist. This does not prove spare
physical connector availability or successful VFIO reset/restart. Upstream
bridge `0000:00:1d.0` is not an assignment target.

`hostpci0: 0000:23:00.0,pcie=1` and
`hostpci1: 0000:24:00.0,pcie=1` must remain byte-for-byte unchanged.
Guest PCI enumeration confirms Intel Battlemage graphics uses xe and its
audio function uses snd_hda_intel. No encoding or GPU reset test was run.

## Historical disposition — 2026-09-11

Operator disposition — 2026-09-11: known limitation accepted for now; recabling
and realization are deferred, with no work scheduled today. The agreed future
direction is moving HP GUD1N onto an available port on the isolated ASMedia
controller, after physical verification and a separate powered-off maintenance
plan. LG-only work subsequently resumed on September 12; HP remains deferred. This deferral does not accept
the current configuration as satisfying the three-drive desired state.

At that inspection, not realized. Only one native physical optical drive was visible in
the guest. No mutation was made because the shared host-storage controller
triggered the operator's stop condition. No controller, guest, or host restart
occurred; new reboot persistence is untested. The existing USB mapping is
persistent configuration, not a new reboot test.

See the [runbook](../runbooks/2026-09-11-matrix-three-optical.md) and
[immutable inspection summary](../evidence/2026-09-11-matrix-three-optical.md).

## Current acceptance

LG-only passthrough is accepted; two native drives are proven. Three-drive
acceptance remains incomplete because HP is absent. Its shared host-storage
controller remains forbidden and physical recabling is not scheduled.

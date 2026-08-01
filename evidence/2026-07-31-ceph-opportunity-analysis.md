# Ceph opportunity analysis

Date: 2026-07-31

## Result

No safe initial three-node OSD layout is currently proposed. The required
one-whole-device-per-host condition cannot be met from proven eligible media.
This is a stop decision, not permission to reuse an apparently idle disk.

| Host | Potential media reviewed | Result | Blocking evidence |
| --- | --- | --- | --- |
| hv-lore | all visible local disks | none eligible | boot mirror, active PVE pools, raw guest disk, and active TrueNAS members consume all observed media |
| hv-katra | Samsung 970 EVO Plus 1 TB | unknown — blocked | unreferenced is not ownership proof; 23,067 NVMe error-log entries need diagnosis before reuse |
| hv-matrix | WD Blue 1 TB; WD SN810 1 TB | none eligible | WD Blue has an NTFS payload with unproven owner; SN810 p1 is directly assigned to VM 310 |

## Initial OSD candidate table

| Host | Proposed OSD device | Size | Media | Health | Current state | Preparation needed |
| --- | --- | ---: | --- | --- | --- | --- |
| hv-lore | none | — | — | — | no eligible disk | obtain and assess a separate device after Lore boot evidence is resolved |
| hv-katra | none | — | — | SMART not critical but error-log count unresolved | ownership and health incomplete | preserve data; investigate in a separate approved assessment |
| hv-matrix | none | — | — | — | all visible media is boot, guest, or unknown | establish WD Blue ownership or add new media |

No DB/WAL layout, partitioning, package installation, cluster formation, or
Ceph initialization was performed or proposed.

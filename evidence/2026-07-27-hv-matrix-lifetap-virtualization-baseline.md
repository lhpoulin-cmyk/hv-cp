# hv-matrix Lifetap virtualization baseline

**Capture:** 2026-07-27T14:31:21Z–2026-07-27T14:31:25Z
**Profile:** local read-only `virtualization-baseline`
**Archive SHA-256:** `02a0c218dd41076811ded918cacab3871e4dad8fef6e87fa3581e03590af422e`

The Lifetap bundle and archive checksum both verified. The capture established
the expected `hv-matrix` identity, PVE 9.2.2, kernel `7.0.2-6-pve`, active core
PVE services, the management bridge, a healthy mirrored `rpool`, active
`local` and `local-zfs` storage, no guests, and no captured failed units.

The verified archive remains in the private Matrix node record. Optional
`nmcli` and `iw` collectors were unavailable; neither was installed or treated
as a collection failure.

# Implementation packet: hv-matrix Lifetap virtualization baseline

Date: 2026-07-27

## Purpose and target

Collect one fresh read-only Proxmox virtualization baseline from
`hv-matrix.arpa` (`192.168.10.22`) for the canonical infrastructure and
private node records.

## Authority and boundaries

Operator authorization: finish validating `hv-matrix` and record it in
`/home/louis/infrastructure` and the private local-compute hypervisor tree.

This packet authorizes installing the verified portable Lifetap collector at
`/opt/lifetap/lifetap.pyz`, writing one new evidence bundle and archive under
`/var/lib/lifetap`, and copying the verified archive into the private record.
It does not authorize package installation, remediation, services, timers,
network changes, storage changes, guest actions, cluster/Ceph changes, or
outbound notifications.

## Preconditions

- SSH path: `louis@192.168.10.22`, with local console as break-glass access.
- Collector source:
  `/home/louis/src/lifetap/dist/lifetap.pyz`.
- Collector SHA-256:
  `67ef821681b8e40ec4e222660e666c47dcd46e2dab773e9bc12d1ac22669204b`.
- Destination names must not already exist.

## Action and evidence destination

Install the collector root-owned and non-writable, run the
`virtualization-baseline` profile as root, verify the generated bundle, create
a tar archive and SHA-256 sidecar, and copy those verified artifacts to:

`nodes/local-compute/hv/hv-matrix/lifetap/2026-07-27/`

Record only concise non-secret observed facts in canonical Markdown records.

## Validation and stop conditions

Success requires a valid bundle checksum manifest, a verified archive hash,
the expected `hv-matrix` identity, active core PVE services, healthy ZFS boot
pool, expected management address, and no unexpected guests or storage
backends. Missing optional commands remain limitations; do not install them.

Stop on an existing destination, checksum mismatch, identity mismatch,
unexpected disk/pool membership, failed core PVE service, or evidence that
would expose secrets or content-bearing paths.

## Rollback

Remove `/opt/lifetap/lifetap.pyz` only if separately requested. Preserve a
completed verified evidence bundle and archive. If collection fails, retain
the failed bundle for review and do not promote it into canonical records.

## Result

Completed successfully on 2026-07-27.

- Capture window: `2026-07-27T14:31:21Z`–`2026-07-27T14:31:25Z`
- Bundle:
  `/var/lib/lifetap/hv-matrix-2026-07-27-lifetap-virtualization-baseline/`
- Archive:
  `/var/lib/lifetap/archive/hv-matrix-2026-07-27-lifetap-virtualization-baseline.tar`
- Archive SHA-256:
  `02a0c218dd41076811ded918cacab3871e4dad8fef6e87fa3581e03590af422e`

Bundle and archive checksums verified. The capture established the expected
hostname, PVE 9.2.2, kernel `7.0.2-6-pve`, active core PVE services, management
bridge, healthy mirrored `rpool`, active `local` and `local-zfs` storage, no
guests, and no captured failed units.

Optional `nmcli` and `iw` collectors were unavailable. The verified zipapp
lacked an executable launcher header and was invoked with `python3`; no
remediation or package installation occurred.

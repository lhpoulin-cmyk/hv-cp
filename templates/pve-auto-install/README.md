# PVE auto-install template

This directory is the reusable, non-secret installer contract for a
human-supervised Proxmox VE host with a two-disk ZFS boot mirror. It is a
starting point, not a deployed-node record and not installation authority.

## Evidence basis

This revision is derived from the checksum-verified Matrix post-install
baseline captured from `2026-07-27T14:31:21Z` through `14:31:25Z` and the
preserved launch evidence for its PVE 9.2 installation. The private baseline
archive SHA-256 is
`02a0c218dd41076811ded918cacab3871e4dad8fef6e87fa3581e03590af422e`.
Its material collection limitations were the absence of optional `nmcli` and
`iw` collectors; those limitations do not affect the observed PVE identity,
management bridge, explicit ZFS members, or guest inventory used here.

The exact source records remain outside this repository in the private Matrix
node record and retired launch archive. This template is a derived operational
pattern, not a replacement for those originals.

## Why this template is narrow

The Matrix first article established that the core PVE answer can produce a
working EFI installation, management bridge, SSH path, and healthy ZFS mirror.
Its completion through DNS, notification-profile normalization, and a
TruthTap record-only pilot exposed several reusable risks:

- PVE's disk filter syntax cannot express an exact OR across two unrelated
  serials. An explicit installer device list is therefore used, but each name
  must be mapped back to the approved model, serial, and `/dev/disk/by-id`
  identity at the physical console immediately before any write.
- Optional first-boot notification enrollment failed on an undeclared `jq`
  dependency and later on cleanup state escaping function scope. Base install
  media should not couple host recoverability to optional integrations.
- The router resolver was correct for bootstrap, but it could not satisfy the
  internal DNS-only acceptance probe. Installer DNS and accepted operational
  DNS are therefore distinct states: retain the reachable bootstrap resolver
  until SSH contact by static IP, then enroll the internal pair explicitly.
- The installed node identity was initially absent from both internal
  resolvers. Resolver enrollment and node publication are separate changes;
  publication must use an exact selected-record diff and validate forward and
  reverse answers through both resolvers.
- A restrictive `umask 077` correctly protected secrets but also rendered
  systemd unit files as `0600`. Every non-secret installed artifact needs an
  explicit mode, followed by `systemd-analyze verify`.
- Local Postfix configuration and an active timer do not prove an outbound
  path. Configure the named PVE endpoint without invoking it, and record
  provider acceptance and operator receipt only after a separately approved
  one-message canary.

For that reason, `answer.toml.template` contains only the PVE installation,
management, boot-pool, and root-access contract. It deliberately omits
first-boot automation. A hook may be added only when it follows
`../POSTINSTALL_CONTRACT.md`, declares all package and repository prerequisites,
uses bounded retries, preserves recoverable state on failure, cleans temporary
secret material, passes offline tests, and has its own approval boundary.

## Files

- `answer.toml.template` — rendered into the PVE answer file.
- `node-manifest.toml.template` — binds node inputs to observed evidence,
  explicit exclusions, validation, rollback, and separate authority gates.
- `tests/test-template.sh` — renders a non-secret fixture and validates it with
  the locally installed Proxmox auto-install assistant when available.

Run the offline test from the repository root:

```bash
bash templates/pve-auto-install/tests/test-template.sh
```

## Required workflow

1. Verify and review a current private baseline. Record its source, capture
   window, limitations, and SHA-256 in the node manifest.
2. Record the exact PVE ISO release, vendor source, vendor-published checksum,
   calculated checksum, and version-matched auto-install assistant.
3. Record exactly two approved boot disks and every material excluded disk.
   Use stable serial/by-id identities in the manifest; use installer device
   names in the answer only after correlating them to those identities.
4. Record the management interface from observed hardware identity. Do not
   borrow another node's name, address, NIC, or disk selector.
5. Record two DNS phases: one reachable bootstrap resolver in the answer and
   the intended post-contact resolver pair, DNS-only probe, expected probe
   answer, node publication names, and reverse address in the manifest.
6. Render the answer under `umask 077` from approved encrypted inputs. Reject
   every unresolved `REQUIRED_*` token and never commit the rendered file.
7. Run the template test and `proxmox-auto-install-assistant validate-answer`.
   Inspect the generated ISO and record its SHA-256.
8. Rehearse in disposable, loopback-only QEMU. A virtual rehearsal validates
   the automation path, not the physical disk or LAN identities.
9. Keep answer rendering, ISO generation, removable-media write, physical-host
   disk write, and optional post-install work as separate approval gates.
10. At the physical console, stop unless the platform, NIC, two approved disks,
   and all excluded disks match the reviewed manifest exactly.
11. Make first SSH contact by the reviewed static management address. Confirm
    the exact hostname, PVE services, storage, routes, and bootstrap DNS before
    any post-contact mutation.
12. Query both intended internal resolvers directly for the declared DNS-only
    probe. If they pass, enroll them through the PVE DNS API, recheck the probe
    and an external name, then publish only the node's declared forward names
    and reverse address through a separate guarded packet.
13. Install optional notification configuration only after dependency and
    secret-cleanup tests. Set explicit modes, verify units, create but do not
    test the PVE endpoint, and label the state **configured, unproven** until a
    bounded provider-accepted and operator-received canary exists.
14. After install, capture a new checksum-verified baseline and promote only
    reviewed facts to the private and canonical node records.

## Recovery boundary

Before a target disk is written, withdrawal means removing only the named ISO
and checksum sidecar from approved media. After a disk write, recovery is the
node-specific rebuild or restore path recorded in the manifest; a healthy ZFS
mirror is not a backup.

Generating or validating media does not authorize media placement, a host disk
write, live network changes, storage changes, cluster membership, Ceph, GPU
assignment, guest creation, or outbound notification.

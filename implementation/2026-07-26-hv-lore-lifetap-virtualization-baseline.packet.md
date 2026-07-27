# Implementation packet: hv-lore Lifetap virtualization baseline

Target: `hv-lore.arpa` (`192.168.10.20`)

Intended mutation: install the verified Lifetap collector and verifier under
`/opt/lifetap`, then collect one read-only virtualization baseline and archive
it under `/var/lib/lifetap`. No service, timer, transport, package install,
configuration management, network scan, or host remediation is enabled.

Authority: operator approval on 2026-07-26 to begin Lore's Lifetap baseline
collection after canonical control-plane enrollment.

Preconditions: Lore SSH host identity is console-confirmed; Louis has
passwordless sudo; the local Lifetap artifact and checksum verify before
transfer; the destination name is new and no existing evidence is overwritten.

Rollback: remove `/opt/lifetap` only if requested. Preserve the completed
baseline archive and checksum as evidence; do not delete it as rollback.

Evidence destination: `/var/lib/lifetap/hv-lore-2026-07-26-lifetap-virtualization-baseline/`
and its archive/checksum under `/var/lib/lifetap/archive/`, then the private
Lore node record after checksum verification.

Exclusions: no TruthTap configuration, Git push, service/timer, package,
storage, cluster, Ceph, DNS, firewall, or network mutation is part of this
collection.

## Result

**Collected:** 2026-07-26T17:43:17Z–17:43:29Z  
**Collector manifest:** Lifetap 0.1.0, schema 1.1  
**Archive SHA-256:** `8d78d28537f146a79163d0467758800e5c4e1e8158c25504c1be962dcf4f56b7`

The virtualization-baseline bundle and archive checksum both verified. The
archive is 225280 bytes and remains on Lore under the stated evidence paths.
The only reported limitations were unavailable `nmcli` and `iw`; neither was
installed or remediated as part of evidence collection.

# HAD-HV-02A: Matrix SSH host-identity enrollment

Status: complete

## Scope and authority

`hv-cp` owns Matrix access/trust documentation. The operator authorized only
the enrollment of a public SSH host-key trust record and read-only Matrix
discovery. Follow
[the Matrix host-identity runbook](../runbooks/2026-08-09-hv-matrix-ssh-host-identity.md).

The execution profile is `ssh hv-matrix`, resolving to the hv-cp governed
management identity `hv-matrix.arpa` (`192.168.10.22`) through the approved
workstation jump path. No literal-address authentication is required.

## Preconditions and stop conditions

The independent Matrix local console reported hostname and static hostname
`hv-matrix`, plus these public host-key fingerprints:

| Type | SHA-256 fingerprint |
| --- | --- |
| ED25519 | `SHA256:Ni3EH6EkpQ/pT1wQCgjdKwPV/SRg+BM76WA63v8wXog` |
| ECDSA | `SHA256:VbnYXycTCQWaaOj6blPCUT9xtiYRwYd5onjQQCXads4` |
| RSA | `SHA256:fteSpTgGlHw7ktp5dmHmvvVVOw+U+G4erMRV57FjZCI` |

Stop rather than enrolling if any presented public key fingerprint differs.
Do not use TOFU, `accept-new`, `StrictHostKeyChecking=no`, private-key
material, or broad known-host deletion.

## Canonical output paths

- `implementation/2026-08-09-hv-matrix-ssh-host-identity.packet.md`: create;
  records authorization, comparison, and acceptance.
- `evidence/2026-08-09-hv-matrix-ssh-host-identity.md`: create; immutable
  non-secret comparison and discovery evidence.
- `/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-matrix/CURRENT_STATE.md`:
  update; records the verified access identity and current heartbeat endpoint.
- `/home/louis/helix-arpa/helix-arpa-private/nodes/local-compute/hv/hv-matrix/VALIDATION.md`:
  update; records the strict SSH acceptance limitation and result.

## Result

The live server presented all three public key types with an exact match to
the independent console fingerprints. No pre-existing Matrix known-host entry
existed. Only the matched public keys were enrolled under `hv-matrix.arpa` and
the `hv-matrix` profile was configured to use that name with strict host-key
checking.

`ssh hv-matrix 'hostname; hostnamectl --static; id'` returned `hv-matrix` for
both host-name checks and authenticated `louis` (`uid=1000`, group `sudo`).
No host configuration was changed.

Read-only discovery found
`ntfy-hypervisor-canary-heartbeat.timer` enabled, active, and waiting. Its
static service is inactive with its last result `success`; the root-owned,
mode-0755 helper is `/usr/local/libexec/ntfy-hypervisor-canary-heartbeat` and
still uses `http://ntfy-lore.arpa/ntfy-canary`. That later endpoint-only
consumer migration remains a separate authorized checkpoint.

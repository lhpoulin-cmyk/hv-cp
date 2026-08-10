# hv-matrix SSH host-identity enrollment evidence

Date: 2026-08-09 EDT

An independent Matrix local-console session reported `hostname` and
`hostnamectl --static` as `hv-matrix`. It reported these public SSH host-key
fingerprints:

| Type | Console fingerprint | Presented fingerprint | Result |
| --- | --- | --- | --- |
| ED25519 | `SHA256:Ni3EH6EkpQ/pT1wQCgjdKwPV/SRg+BM76WA63v8wXog` | `SHA256:Ni3EH6EkpQ/pT1wQCgjdKwPV/SRg+BM76WA63v8wXog` | exact match |
| ECDSA | `SHA256:VbnYXycTCQWaaOj6blPCUT9xtiYRwYd5onjQQCXads4` | `SHA256:VbnYXycTCQWaaOj6blPCUT9xtiYRwYd5onjQQCXads4` | exact match |
| RSA | `SHA256:fteSpTgGlHw7ktp5dmHmvvVVOw+U+G4erMRV57FjZCI` | `SHA256:fteSpTgGlHw7ktp5dmHmvvVVOw+U+G4erMRV57FjZCI` | exact match |

The approved `hv-matrix` SSH profile targets `hv-matrix.arpa`, the
hv-cp-governed management identity at `192.168.10.22`. No Matrix entries were
present in the operator known-host files before enrollment. The matched public
keys alone were enrolled for `hv-matrix.arpa`; no private key material was
read, copied, or recorded.

With strict host-key checking, `ssh hv-matrix` authenticated the operator
account and returned `hv-matrix` as both runtime and static host name. The
access check then found the legacy Ntfy heartbeat consumer still configured;
no Matrix state was changed.

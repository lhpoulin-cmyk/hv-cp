# Firewall change packet: Lore accepts direct Hadrian peer SSH

Status: approved for execution; executed successfully
Owner: operator
Prepared: 2026-08-12, America/Detroit
Method commit: `810cb74`
Execution runbook: [`../runbooks/002-hv-lore-hadrian-peer-ssh.md`](../runbooks/002-hv-lore-hadrian-peer-ssh.md)

## Outcome

Add exactly two node-level INPUT accepts on `hv-lore`: TCP/22 from Hadrian's
active Wi-Fi management address `192.168.10.86/32` and wired-resilience
address `192.168.10.85/32`.  This establishes the durable, direct peer
management path for co-equal workstations `ws-hadrian` and `ws-matriarch`.

## Exact scope

- Node: `hv-lore` (`192.168.10.20`)
- Sources: `192.168.10.86/32`, `192.168.10.85/32`
- Destination: node INPUT TCP/22 only
- Mechanism: Proxmox node-firewall API only
- Exclusions: no default-policy, cluster, guest, VLAN, DNS, credential,
  RouterOS, SSH-client, service, or other host-rule change.

## Fresh before state

Collected immediately before execution on 2026-08-12:

- `proxmox-firewall` is active; node firewall is enabled.
- The node rule digest is `3c32a924c58901eb8081164750130c4eb1e13db0`.
- Existing TCP/22 accepts occupy positions 0--4 for `.10.80`, `.80.80`,
  `.10.21`, `.10.84`, and `.10.90`; Web UI rules begin at position 5.
- The later `.10.0/24` INPUT drop remains the guardrail, so both new accepts
  must appear before it and must be `/32` rules.
- Hadrian reaches Lore TCP/8006 but direct TCP/22 times out from `.10.86`.
- `hv-katra` can directly SSH to Lore as `louis` with non-interactive sudo.
  It is the verified independent recovery/execution path and is not a
  workstation proxy or a new topology.

## Ordered desired state

Keep positions 0--4 unchanged.  Insert `.10.86/32` at position 5 and
`.10.85/32` at position 6, before the former Web UI rule.  All remaining rules
retain their relative order.

## Preconditions and stop conditions

- Take and verify a root-owned private copy of the exact host firewall file.
- Re-fetch rules and a fresh digest before every PVE API mutation.
- Stop before enabling a rule if its source, protocol, port, enable state, or
  position differs from this packet.
- Stop if Katra-to-Lore recovery is unavailable or any existing rule changed.

## Validation

- Positive: direct Hadrian (`.10.86`) SSH to Lore, without `ProxyJump`,
  authenticates as `louis`.
- Rule boundary: PVE API and effective chain show only the two new `/32`
  TCP/22 accepts; the `.10.0/24` guardrail remains.
- Unchanged: Katra-to-Lore SSH recovery and Hadrian-to-Lore TCP/8006 still
  work.
- Wired `.10.85` live ingress is deferred only because its Ethernet link is
  physically disconnected; validate the exact rule now and perform the live
  path test when that link is connected.

## Rollback

Using a freshly fetched digest before each call, disable and delete exactly the
two new rules in reverse order.  Re-fetch and compare the complete ordered
rules to the private backup.  Use the verified backup only if API rollback
cannot restore the captured order.

## Result

Executed successfully on 2026-08-12.  See
[`../evidence/2026-08-12-hv-lore-hadrian-peer-ssh.md`](../evidence/2026-08-12-hv-lore-hadrian-peer-ssh.md).

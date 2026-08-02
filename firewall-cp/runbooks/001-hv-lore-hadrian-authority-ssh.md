# Runbook: Packet 001 — Lore allows Hadrian authority SSH

Status: prepared but blocked; no standing authority
Governing packet: [`../implementation/001-hv-lore-hadrian-authority-ssh.packet.md`](../implementation/001-hv-lore-hadrian-authority-ssh.packet.md)

## Purpose and boundary

Prepare one reversible Proxmox node-firewall change on `hv-lore`: allow only
Hadrian authority source `192.168.80.85/32` to reach Lore's INPUT TCP/22 path.
Use Matriarch as the operator console.  This guide does not authorize a live
change, and it does not change Hadrian networking, credentials, client trust,
RouterOS, DNS, Katra, Matrix, guests, cluster policy, or defaults.

The intended final position is `pos 4`. Local VE 9.1.1 source establishes that
POST accepts `pos` and `digest`, but create does not compare the digest or honor
the requested position: it prepends. PUT move/update and DELETE compare their
supplied digest while holding the host firewall lock. Therefore use only the
staged procedure below, after every remaining gate is satisfied.

## Preconditions

- Packet 001b's accepted Hadrian host profile evidence is recorded and remains
  current; direct credential/trust acceptance is still a separate dependency.
- Matriarch retains its currently accepted Lore SSH path and can reach Lore
  management `192.168.10.20`.
- Lore's physical console is the designated, operator-confirmed recovery route
  on 2026-07-27.  Reconfirm it is physically available and reaches a usable
  Lore console or login prompt immediately before mutation; record the
  operator and result.  A second SSH allow through the same firewall is not
  independent recovery.
- The exact approved `hv-cp` commit is recorded before any execution.
- Fresh, secret-screened before-state and backup/export destinations are named.

## Read-only preflight from Matriarch

From the firewall-control-plane directory, record the method revision:

```bash
cd /home/louis/helix-arpa/hv-cp/firewall-cp
git rev-parse HEAD
git status --short
```

Confirm the existing Matriarch recovery contact, Lore identity, and the
Proxmox VE 9 firewall service.  `pve-firewall` is not a valid Lore CLI in this
release; use systemd's `proxmox-firewall` unit:

```bash
ssh -o BatchMode=yes louis@192.168.10.20 \
  'hostname -s'

ssh -o BatchMode=yes louis@192.168.10.20 \
  'systemctl is-active proxmox-firewall'

ssh -o BatchMode=yes louis@192.168.10.20 \
  'systemctl status --no-pager --lines=0 proxmox-firewall'
```

Collect the exact effective configuration and order through Louis's interactive
`sudo` access; root SSH is neither required nor expected.  `-tt` preserves a
terminal for a possible `sudo` prompt.  Save raw output only in the approved
private evidence location; do not commit unredacted exports:

```bash
ssh -tt louis@192.168.10.20 \
  'sudo cat /etc/pve/nodes/$(hostname -s)/host.fw'

ssh -tt louis@192.168.10.20 \
  'sudo cat /etc/pve/firewall/cluster.fw'

ssh -tt louis@192.168.10.20 \
  'sudo pvesh get /nodes/$(hostname -s)/firewall/options --output-format json-pretty'

ssh -tt louis@192.168.10.20 \
  'sudo pvesh get /nodes/$(hostname -s)/firewall/rules --output-format json-pretty'

ssh -tt louis@192.168.10.20 \
  'sudo pvesh get /cluster/firewall/options --output-format json-pretty'

ssh -tt louis@192.168.10.20 \
  'sudo pvesh get /cluster/firewall/rules --output-format json-pretty'
```

Stop if the hostname, management endpoint, runtime status, node/cluster scope,
default policy, accepted Matriarch path, ordered rule set, or recovery path
differs from the packet baseline.  Do not infer a rule position from an older
summary.

## Gate before an apply revision

The next packet revision must name all of the following before it contains an
apply command:

1. a fresh ordered rule capture showing the expected four SSH allows at
   positions 0-3 and the Web UI rules beginning at position 4;
2. exact private backup/export path and restore command, verified against the
   collected configuration;
3. physical-console recovery operator and execution-time confirmation that it
   reaches a usable Lore console/login prompt;
4. execution-time source proof that Hadrian is `.80.85`, not Wi-Fi `.10.86`;
5. direct Hadrian SSH credential/trust test plan, with no `ProxyJump`; and
6. positive, negative, unchanged-flow, and post-rollback tests.

Run the workspace runbook audit once the packet is marked execution-ready:

```bash
cd /home/louis/helix-arpa/hv-cp/firewall-cp
../tools/audit-live-mutation-runbooks.sh
```

## Future guarded mutation

Do not run this section while the packet is blocked. From Matriarch, open an
interactive Lore session with `ssh -tt louis@192.168.10.20`. Before each API
mutation, fetch `/nodes/hv-lore/firewall/rules`, confirm the exact expected
object/order, and take the `digest` returned on its rule objects. Stop if the
digest is absent, unchanged state cannot be proved, or another rule changed.

```bash
# 1. Fresh before-state digest required. POST ignores its supplied digest, so
# create disabled and require the new rule to appear at pos 0 before continuing.
sudo pvesh create /nodes/hv-lore/firewall/rules \
  --type in --action ACCEPT --source 192.168.80.85/32 \
  --proto tcp --dport 22 --enable 0 --digest "$FRESH_DIGEST"

# 2. Re-fetch rules; verify the exact disabled rule at pos 0 and set a NEW digest.
sudo pvesh set /nodes/hv-lore/firewall/rules/0 \
  --moveto 4 --digest "$POST_CREATE_DIGEST"

# 3. Re-fetch rules; verify the exact disabled rule at pos 4 and set a NEW digest.
sudo pvesh set /nodes/hv-lore/firewall/rules/4 \
  --enable 1 --digest "$POST_MOVE_DIGEST"
```

Never substitute the dated preflight digest for any variable above. Re-fetch
and verify after enable: `pos 4` must be exactly `IN ACCEPT`, source
`192.168.80.85/32`, protocol `tcp`, destination port `22`, enabled; the four
prior SSH allows and all following rules must retain their relative order.

From Hadrian, the positive test is direct SSH to `192.168.10.20` with no
`ProxyJump`; do not execute until the exact approved identity and host-trust
inputs are recorded. From Hadrian Wi-Fi `.10.86`, confirm TCP/22 remains denied.
From Matriarch, confirm the existing direct SSH path still returns `hv-lore`.

## Exact rollback sequence

At `pos 4`, first verify every target field. Obtain a fresh digest immediately
before each command. Stop rather than touching a rule that differs.

```bash
sudo pvesh set /nodes/hv-lore/firewall/rules/4 \
  --enable 0 --digest "$ROLLBACK_ENABLE_DIGEST"

# Re-fetch, verify the same rule is disabled at pos 4, and obtain a NEW digest.
sudo pvesh delete /nodes/hv-lore/firewall/rules/4 \
  --digest "$ROLLBACK_DELETE_DIGEST"
```

Re-fetch and compare the complete order to the private exact before-state. If
it differs, use only the execution-window verified backup restore procedure
from the physical console; the backup path and restore test remain blockers.

## Validation and rollback boundary

The accepted future change must prove: `.80.85` reaches only Lore TCP/22;
`.10.86` remains denied; current Matriarch SSH and the recorded non-target
flows remain unchanged; and the added rule's position/counter is confirmed.

Rollback must restore the exact captured Lore firewall before-state using the
freshly verified restore procedure, then repeat the Matriarch recovery,
Hadrian negative, and unchanged-flow tests.  If the restore method or recovery
path is not verified, stop rather than applying the allow.

## Evidence handoff

Keep raw captures and backups in the approved private node record.  Save only
a reviewed, secret-screened dated summary in `firewall-cp/evidence/`, including
collection time, commands, exact rule order, recovery proof, limitations, and
whether live state changed.

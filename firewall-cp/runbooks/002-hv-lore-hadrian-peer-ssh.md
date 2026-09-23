# Runbook: Packet 002 — Lore direct Hadrian peer SSH

Governing packet: [`../implementation/002-hv-lore-hadrian-peer-ssh.packet.md`](../implementation/002-hv-lore-hadrian-peer-ssh.packet.md)

Execute only under the operator authorization recorded by Packet 002.  Use the
existing Katra-to-Lore direct SSH path solely as the independent recovery and
execution channel; it does not alter the direct Hadrian-to-Lore topology.

## Guarded sequence

1. Capture `/etc/pve/nodes/hv-lore/host.fw` to a root-owned `0600` backup on
   Lore, and compare its digest with the source.
2. Fetch `/nodes/hv-lore/firewall/rules`; verify the five existing SSH allows
   and record its current digest.
3. Create the `.10.86/32` TCP/22 accept disabled.  Fetch again; verify it is
   the exact disabled rule at position 0.  With the newly fetched digest, move
   it with `--moveto 6`; the API's move index is evaluated before removal, so
   a prepend at position 0 lands at final position 5.  Fetch again; verify it
   remains disabled at position 5.
   With a further fresh digest, enable it.
4. Repeat the disabled-create, fresh-fetch, move, fresh-fetch, enable sequence
   for `.10.85/32`, moving it with `--moveto 7` to final position 6.  Confirm
   `.10.86/32` remains at position 5 before enabling the second rule.
5. Fetch the complete ordered rule list and effective firewall chain.  Confirm
   no other rule moved or changed and the two `/32` accepts precede the subnet
   drop.

Use the supported node API; never edit `/etc/pve` directly:

```bash
sudo pvesh create /nodes/hv-lore/firewall/rules \
  --type in --action ACCEPT --source SOURCE/32 --proto tcp --dport 22 \
  --enable 0 --digest FRESH_DIGEST
sudo pvesh set /nodes/hv-lore/firewall/rules/0 \
  --moveto PRE_REMOVAL_TARGET --digest FRESH_DIGEST
sudo pvesh set /nodes/hv-lore/firewall/rules/FINAL_POSITION \
  --enable 1 --digest FRESH_DIGEST
```

`FRESH_DIGEST` means the digest returned from the immediately preceding rules
fetch.  Creation prepends the rule, so do not rely on a requested create
position.  Stop on any mismatch rather than correcting it interactively.

## Tests and rollback

From Hadrian, run direct batch SSH to `hv-lore` and `hostname; id -un` without
`ProxyJump`.  Confirm Katra-to-Lore SSH recovery and Hadrian-to-Lore TCP/8006
remain available.  The wired `.10.85` live test waits for physical link.

For rollback, re-fetch, identify the exact new `.10.85/32` rule, disable then
delete it with a fresh digest; repeat for `.10.86/32`.  Compare the resulting
ordered set with the saved backup.  Do not restore by direct file editing.

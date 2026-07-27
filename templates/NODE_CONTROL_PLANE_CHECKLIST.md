# Node control-plane checklist

Copy this checklist into a node-specific implementation packet. Replace every
bracketed field; do not copy another node's identity or secrets.

## Identity and authority

- [ ] Exact hv-cp source commit recorded; online checkout fetched/current or
      offline approved commit and update limitation documented.
- [ ] Node hostname/FQDN: `[node.example]`
- [ ] Role and owner: `[role]`
- [ ] Management address and access boundary verified from observation.
- [ ] Hardware and storage identity captured in a private node record.
- [ ] Lifetap or equivalent baseline captured and checksum verified.

## Install / recovery inputs

- [ ] Node-specific NIC and disk selectors are based on observed identifiers.
- [ ] Operator inputs exist only in an ignored encrypted SOPS file.
- [ ] Secret YAML comments declare the correct quoting mode.
- [ ] First boot creates the intended operator account, SSH access, and sudo
      behavior without embedding credentials in source control.

## Execution safety

- [ ] Target, expected mutation, rollback, and evidence destination are in an
      approved implementation packet.
- [ ] SSH-first access has been tested; graphical console remains break-glass.
- [ ] Post-install tests cover hostname, network, SSH, operator `id`, and
      `sudo -n true`.
- [ ] Exact canonical paths are listed as `create`, `update`, or `not affected`
      under the canonical node documentation contract.
- [ ] Results have been recorded in every declared private and canonical home.
- [ ] Superseded hv-cp status statements and affected cross-node inventory have
      been reconciled.
- [ ] `tools/validate-node-documentation-contract.sh` passes for the node.
- [ ] Runtime acceptance and documentation acceptance are both complete.

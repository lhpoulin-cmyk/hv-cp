# Node control-plane checklist

Copy this checklist into a node-specific implementation packet. Replace every
bracketed field; do not copy another node's identity or secrets.

## Identity and authority

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
- [ ] Results have been recorded in the private and canonical homes as needed.

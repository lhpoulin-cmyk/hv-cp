# hv-cp tools

This directory contains local, non-mutating validation tools for the hv-cp
method. They inspect repository files; they do not contact or change a live
host.

Run `validate-node-documentation-contract.sh` with the applicable `base`,
`notification`, or `heartbeat` profile, the canonical infrastructure root, and
one or more node IDs. A passing result proves only the static contract
described in `../docs/CANONICAL_NODE_DOCUMENTATION_CONTRACT.md`.

`tests/test-node-documentation-contract.sh` exercises both the passing contract
and a required-file failure with temporary fixtures.

`audit-live-mutation-runbooks.sh` verifies that each execution-ready
live-mutation packet links to a runbook inside this repository. It is a static
documentation audit and grants no execution authority.
It recognizes plain and bold `Status:` declarations and excludes private agent
checkouts. Run `bash tools/tests/test-live-mutation-runbooks.sh` to check valid
links and rejection of missing or out-of-repository runbooks.

## pve-guest-timing

`tools/pve-guest-timing` is a small read-only inventory, boot-evidence,
readiness, and recommendation helper. Run it on a PVE host or use
`--remote hv-name` from the control-plane workstation. `measure-cycle` only
prints its prepared protocol; it does not run a guest cycle.

Examples:

```text
tools/pve-guest-timing inventory --format both
tools/pve-guest-timing recent-boot --format json
tools/pve-guest-timing readiness --format json
tools/pve-guest-timing plan --format both
tools/pve-guest-timing measure-cycle
```

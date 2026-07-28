# Firewall change packet: [node and flow]

Status: draft; execution not authorized
Owner: operator
Prepared: [date, time, timezone]
Method commit: [exact hv-cp commit and currency statement]

## Outcome

[One sentence naming the allowed or denied flow.]

## Exact scope

- Node:
- Source identity and address:
- Destination identity and address:
- Protocol and port:
- Proxmox scope: [node or cluster]
- Explicit exclusions:

## Established before state

- Runtime enablement:
- Node options and ordered rules:
- Cluster options and ordered rules:
- Effective INPUT behavior:
- Successful operator path:
- Independent recovery path:
- Evidence location and collection time:

## Dependencies

| Dependency | Owner | Required state | Evidence | Status |
| --- | --- | --- | --- | --- |
| Network/VLAN | | | | |
| Address and route | | | | |
| DNS | | | | |
| Credential | | | | |
| Client trust/configuration | | | | |

## Proposed diff

[Exact rule, scope, insertion position, and unchanged defaults.]

## Preconditions

- [ ] Target and management address verified.
- [ ] Fresh firewall backup/export captured.
- [ ] Independent recovery path tested.
- [ ] Dependencies accepted by their owners.
- [ ] Operator approved this exact packet.

## Success and negative tests

- Positive:
- Negative:
- Unchanged existing flows:
- Effective rule-counter or log evidence:

## Stop conditions

[Unexpected identity, rule order, policy, dependency, access loss, or result.]

## Rollback

[Exact removal or restore sequence and rollback validation.]

## Evidence and documentation handoff

- Private raw capture:
- Firewall summary:
- Canonical node record:
- Other affected records, or `not affected` with reason:

## Result

Not executed.

# Controlled node change

## Before changing live state

Create an implementation packet containing:

| Field | Required content |
| --- | --- |
| Method version | exact hv-cp commit; fetched/current online or approved offline commit with limitation |
| Target | hostname, management address, and exact component/device |
| Intended mutation | one concrete change and expected result |
| Authority | operator approval and scope |
| Preconditions | current evidence and required health checks |
| Rollback | stop condition and safe reversal path |
| Evidence destination | private record, canonical infrastructure, or both |
| Canonical output paths | exact files marked `create`, `update`, or `not affected` with a reason |

## During the change

1. Connect through SSH and confirm the target again.
2. Run only the approved command sequence.
3. Stop on an unexpected result; do not improvise a second mutation.
4. Record the actual result, including any failed command and its relevant
   non-secret output.

## After the change

1. Run the smallest meaningful validation.
2. Add or update a dated evidence capture.
3. Publish only non-secret canonical facts to every declared output path.
4. Update the private node record when identity, hardware, management, or
   Lifetap baseline facts changed.
5. Reconcile superseded hv-cp status text and affected cross-node inventory.
6. Run the canonical-node documentation validator and inspect the relevant
   diffs.

Runtime success does not close the control-plane task while its declared
canonical projection is missing, stale, contradictory, or unvalidated. Follow
`../docs/CANONICAL_NODE_DOCUMENTATION_CONTRACT.md`.

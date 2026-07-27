# Controlled node change

## Before changing live state

Create an implementation packet containing:

| Field | Required content |
| --- | --- |
| Target | hostname, management address, and exact component/device |
| Intended mutation | one concrete change and expected result |
| Authority | operator approval and scope |
| Preconditions | current evidence and required health checks |
| Rollback | stop condition and safe reversal path |
| Evidence destination | private record, canonical infrastructure, or both |

## During the change

1. Connect through SSH and confirm the target again.
2. Run only the approved command sequence.
3. Stop on an unexpected result; do not improvise a second mutation.
4. Record the actual result, including any failed command and its relevant
   non-secret output.

## After the change

1. Run the smallest meaningful validation.
2. Add or update a dated evidence capture.
3. Publish only non-secret canonical facts.
4. Update the private node record when identity, hardware, management, or
   Lifetap baseline facts changed.

# Decision: defer Lore boot-layout selection

**Date:** 2026-07-31
**Authority:** read-only reassessment requested by the operator
**Status:** blocked by boot-firmware evidence

## Decision

Do not retain, relocate, migrate, or replace Lore's boot mirror as a Ceph
enabling action yet. The media and ZFS mirror are healthy, and both EFI system
partitions are maintained, but independent UEFI boot selection has not been
proven. No physical movement is justified from current evidence.

## Options evaluated

| Option | Boot reliability | Ceph devices freed | Physical work | Recovery complexity | Recommendation |
| --- | --- | ---: | --- | --- | --- |
| A — retain current mirror | ZFS and ESP redundancy good; firmware fallback unproven | 0 | none | low | provisional only; prove fallback first |
| B — relocate existing mirror | unknown until bootability is proven | unknown | high | high | do not pursue |
| C — migrate to another mirrored pair | targets not identified | unknown | high | high | do not pursue |
| D — replace boot pair before Ceph | health does not presently require it; firmware evidence incomplete | unknown | high | high | do not pursue |

## Required next boundary

A separate controlled boot-recovery assessment must establish firmware fallback
for each ESP, including recovery method and post-change evidence, before a
boot-layout choice. It must account for the accepted PBS outage while Lore and
truenas-lore are down. This decision grants no live action.

No implementation packet is created because relocation or migration is not
conclusively required.

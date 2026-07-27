# Decision: adopt a reusable node control-plane pattern

**Date:** 2026-07-26  
**Authority:** operator request  
**Applies to:** `hv-katra` immediately; `hv-matrix` as a tailored consumer

## Decision

Create a dedicated active-work project for the operational pattern recovered
from Katra. Keep node-specific private facts and raw evidence out of this
repository, and use sanitized templates plus implementation packets for every
future node.

## Why

The recovered Katra material was a local, untracked workspace inside a dirty
and diverged infrastructure checkout. It contains valuable recovery knowledge,
but also generated credentials, device-specific selectors, and binary firmware
tools. Treating it as a standalone repository or copying it blindly would make
the knowledge fragile and risk importing secrets or unsafe assumptions.

## Consequences

- Katra becomes the first documented instance of this pattern.
- `hv-matrix` can reuse the process but must supply its own hardware identity,
  storage policy, network identity, and encrypted operator inputs.
- No recovered script is executed or promoted to live automation by this
  decision.

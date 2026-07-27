# Implementation packet: standalone hv-cp repository extraction

Purpose: create private standalone hypervisor-control-plane repository.
Authority: operator, 2026-07-27.
Target: lhpoulin-cmyk/hv-cp (private GitHub repository).
Excluded: secrets, raw artifacts, host changes, notification delivery.
Action: clean initial non-secret history; parent remains historical source.
Rollback: stop before parent extraction if publication review fails.

# hv-lore timing refresh

Date: 2026-08-15

Collection completed over the authorized key-only SSH path. No guest was
started, stopped, modified, or instrumented.

- Guests inventoried: 17
- Commands completed: `inventory`, `recent-boot`, `readiness`, `plan`
- Current boot ID: `3addd2a1-4c91-4e1a-96a3-b27c039debcd`
- Boot timestamp: `2026-08-15 11:36:43`
- `pve-guests` start: `2026-08-15 11:37:10 EDT`
- Guest start task ordering: unavailable
- Per-guest recent-boot timing confidence: unavailable
- Readiness: 7 CT init probes, 5 VM QGA/network probes; service probes not tested

The expired workstation certificate was not renewed because key-only SSH was
accepted through the existing authorized path. This is collection evidence,
not a certificate issuance record.

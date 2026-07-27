# Implementation packet: hv-katra ntfy canary heartbeat

**Status:** applied and validated on 2026-07-26.

## Target and mutation

Install one local, best-effort systemd oneshot service and timer on `hv-katra`.
Every configured five seconds it publishes to
`http://ntfy-lore.arpa/ntfy-canary` with only:

```text
hostname=<current short hostname> uptime=<current human-readable uptime>
```

The service runs as an unprivileged local account, uses a short timeout and no
retry, and does not read any topic. This intentionally minimal payload is a
lab heartbeat only; it is not a subscriber receipt, a precise schedule, a
host-health guarantee, or a command/control channel.

## Boundaries

No package, credential, ACL, DNS, firewall, PVE notification target, listener,
or inbound topic consumer is in scope. Failure to send cannot block PVE,
storage, SSH, VM operation, backup, or recovery. The existing `ntfy-canary`
topic's current read-write default remains a known lab-only risk.

## Validation and rollback

Verify the unit content, timer enablement, recent successful local service
result, and ntfy route HTTP acceptance without reading topic history. Rollback
disables/removes only the two units and one helper script, then reloads
systemd. Preserve non-secret evidence.

## Evidence destination

`/home/louis/infrastructure/nodes/hv-katra/command-log/` and the matching
private hypervisor notification register.

## Result

The timer is enabled and active. At 15:51 EDT, its local service completed
successfully and the server accepted `hostname=hv-katra uptime=up 3 hours, 46
minutes`. No persistent change beyond this packet's helper and two units was
made.

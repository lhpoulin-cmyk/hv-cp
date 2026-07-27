# Hypervisor ntfy heartbeat mode control

> **Deployment naming (2026-07-26):** `helix-arpa-ntfy` is the shared ntfy
> service deployment. `ntfy-lore` is historical hosting and endpoint context,
> not a Lore-only service label or a lifecycle decision. This heartbeat is a
> bounded testing/operations facility, not a `ntfy-comms` implementation or a
> control path.

## Outcome

`hv-lore` and `hv-katra` publish only short hostname and human-readable uptime
to `ntfy-canary`. Normal cadence is five minutes. Fast mode is five seconds
and expires to slow mode after 15 minutes.

The LXC heartbeat remains outside this control at five seconds. These signals
are best effort, not health guarantees, subscriber receipts, or control paths.

## Components

- Existing publisher: `/usr/local/libexec/ntfy-hypervisor-canary-heartbeat`
- Existing timer: `ntfy-hypervisor-canary-heartbeat.timer`
- Mode helper: `/usr/local/sbin/ntfy-heartbeat-mode`
- Fast expiry: `ntfy-heartbeat-fast-expiry.timer` and service

The helper writes the heartbeat timer cadence drop-in, restarts only that
timer, and either starts or disables the 15-minute fast-expiry timer.

## Operator use

```bash
sudo ntfy-heartbeat-mode status
sudo ntfy-heartbeat-mode fast
sudo ntfy-heartbeat-mode slow
```

`fast` starts/restarts the expiry timer. `slow` immediately returns the
heartbeat to five minutes and disables expiry. Neither command restarts PVE
services or changes the publisher route, payload, DNS, firewall, ACL, or
credentials.

## Validation completed 2026-07-26

Both hosts entered slow mode with a five-minute next-run schedule. Both entered
fast mode, completed one bounded hostname/uptime publish with result `success`
and exit status `0`, then returned to slow mode.

Current read-only verification found both hosts in slow mode: the effective
drop-in sets `OnUnitActiveSec=5min`, and each fast-expiry timer is inactive.

## Rollback

Run `sudo ntfy-heartbeat-mode slow`. To remove the feature, remove only the
mode helper, fast-expiry units, and heartbeat timer cadence drop-in; reload
systemd. Do not change ntfy, topics, retained messages, DNS, or access policy.

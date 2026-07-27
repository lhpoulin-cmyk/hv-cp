# Implementation packet: ntfy-lore canary heartbeat

**Status:** applied and validated on 2026-07-26.

## Target

`ntfy-lore`, unprivileged LXC CT `245` on `hv-lore`.

## Intended mutation

Install one local systemd oneshot service and timer in the LXC. The timer uses
`OnUnitActiveSec=5s` to publish this fixed, non-secret message to the local
ntfy endpoint:

```text
topic: ntfy-canary
message: known topics: lore-alerts, ntfy-lab, ntfy-canary, ntfy-vm
```

The publisher targets `http://127.0.0.1/ntfy-canary`, has no credentials, and
does not read a topic, invoke a command, alter ntfy access policy, create a
network listener, or contact any hypervisor. The configured interval is
five seconds; systemd scheduling is best effort and is not a real-time
guarantee.

This is a lab dummy signal, not a service-health guarantee, a hypervisor
canary, or authorization to enroll any other producer.

## Preconditions

- Operator explicitly authorized the topic and cadence on 2026-07-26.
- `ntfy` is active locally and `http://127.0.0.1/` returns HTTP `200`.
- No existing `ntfy-canary-heartbeat` unit exists.
- Existing ntfy cache retention is 72 hours. At the requested cadence, it may
  retain roughly 51,840 heartbeat messages over that window. The payload must
  remain fixed and non-secret.

## Validation

1. Verify both units have the expected local-only endpoint and fixed payload.
2. Enable and start the timer; confirm it is active.
3. Confirm one recent successful local HTTP result in the heartbeat service
   journal, without subscribing to or reading the topic.
4. Confirm `ntfy` remains active and local HTTP still returns `200`.

## Rollback

Disable and stop only `ntfy-canary-heartbeat.timer`, remove the two units,
reload systemd, and preserve the dated non-secret validation result. Do not
purge ntfy cache data, alter the `ntfy` service, or change any topic policy.

## Evidence destination

- Active-work implementation packet: this file.
- Canonical record: `nodes/hv-lore/LXC_LORE_NTFY_CANARY_HEARTBEAT.md` in
  `/home/louis/infrastructure`.
- Non-secret live result: a dated note under
  `/home/louis/infrastructure/nodes/hv-lore/command-log/`.

## Result

The timer was enabled and active at 19:04 UTC. Two successive local publishes
completed successfully five seconds apart; the heartbeat service exited `0`,
`ntfy` remained active, and local HTTP returned `200`. No topic subscription
or message-history inspection was performed.

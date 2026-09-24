# VM120 guest console observations

Source: operator-pasted read-only output from the authorized existing TrueNAS
console, following the console-access approval. This is a sanitized summary,
not an independently collected guest capture. The full historical command
payloads from the journal are deliberately not copied here or executed.

Guest identity shown by prompt: truenas_admin@truenas-lore.
qemu-guest-agent.service is static, active/running since September 21
22:44:32 PDT, MainPID 2271, /usr/sbin/qemu-ga; initial status reports two tasks.
Unprivileged journal access failed; the operator then supplied privileged output.

- Last supplied journal entry: September 23 19:30:18 guest-ping called.
  No backend conformance guest-exec entry appears in this supplied tail.
  Absence of a logged dispatch does not prove nonexecution; outcome UNKNOWN.
- Main thread 2271: Ssl, hrtimer_nanosleep. Thread 2291: Ssl,
  futex_wait_queue. A single wait-state sample does not prove deadlock or
  identify the userspace sleep/retry reason.
- fd 4 points to /dev/vport1p1; the guest agent virtio symlink
  /dev/virtio-ports/org.qemu.guest_agent.0 points to ../vport1p1.
  This supports an open correct guest device, not a successful response path.
- fd 0 is /dev/null; fd 1/2 share socket 6738; fd 3 eventfd;
  fd 5 socket 10005. Their existence alone does not establish socket health.

The daemon is present and running; no missing configuration or stopped service
has been demonstrated. Agent-internal blockage/retry is plausible but not yet
proved. Next bounded read: current MainPID, kernel stack/syscall and service
KillMode/ExecStop/timeout behavior. No ptrace, signals, service restart or reboot
authorized by this observation. Any service restart still requires its exact
operator decision and a dated packet/runbook before execution.

Recovery remains incomplete: successful VM120 ping/no-op and exact publisher
reconciliation are pending. No fixture replay, cleanup or media publication.
Earlier owner findings and source identities are in
[the initial handoff](2026-09-24-vm120-qga-handoff.md).

Delivery: local uncommitted observation; hv-cp source HEAD
d66c6f6a09bacb9326309caae316df987824838b. Existing evidence and unrelated
work preserved. No canonical accepted-change claim.

Live effects: NONE by this continuation. Operator read-only console commands
may generate ordinary access/audit records. Prior dispatch remains UNKNOWN.

# VM120 QGA recovery and publisher reconciliation

PLAY: Restore the existing VM120 QGA route; reconcile the exact unknown attempt.
CHECKPOINT: 2026-09-24 04:06–04:09 UTC.
STATUS: QGA recovery live-verified; read-only reconciliation completed.
RESULT: One operator-approved guest-agent restart restored ping and no-op.
The exact backend fixture namespace is absent; historical dispatch remains UNKNOWN.

## Cause and smallest remedy

Established: VM120 was running with agent enabled; host SSH, sudo and VM130 QGA
worked. Guest PID 2271 was active with the correct virtio device open but did
not answer requests. Operator console samples showed clock_nanosleep on the
main thread, a futex waiter on the second thread, and only qemu-ga in its cgroup.
The underlying sleep/retry trigger is not determined. Do not describe this as
a proved daemon crash, credential failure, kernel fault or specific QEMU bug.

After read-only diagnosis, Louis explicitly approved one service-only restart
and supplied the execution result from the TrueNAS console: active/running,
new PID 28768, start September 23 21:05:27 PDT (September 24 04:05:27 UTC).
The operator executed `sudo systemctl restart qemu-guest-agent.service` once.
No agent-issued restart, VM/NAS reboot, channel toggle, credential/trust change,
or persistent guest/host configuration edit was performed. Service replacement
restored function; long-term nonrecurrence and the internal trigger are unproved.

Governing [packet](../implementation/2026-09-24-vm120-qga-recovery.packet.md)
and [runbook](../runbooks/VM120_QGA_RECOVERY_20260924.md) were prepared before
approval and passed the documentary linkage audit while execution-ready. The
packet now records execution; this receipt records the subsequent approval and
completed restart. Earlier immutable handoffs retain
their dated findings and are superseded for current channel availability.

## Independent verification

At 04:06:01 UTC onward, existing strict, fresh nonmultiplexed hv-lore SSH
returned hv-lore.helix.home.arpa. All PVE calls used sudo -n -k.

| Check | Observed result |
| --- | --- |
| qm agent 120 ping | exit 0 |
| qm guest exec 120 --timeout 10 -- /usr/bin/true | transport exit 0; exited 1; guest exitcode 0 |
| qm status 120 | running |
| qm status 130 | running |
| qm agent 130 ping | exit 0 |

The independent strict host management path remains available. These checks
prove channel/no-op recovery, not full NAS/storage workload health.

## Exact-attempt reconciliation

Read-only Python dispatched through restored QGA, not the publisher, asserted
guest hostname truenas-lore. It traversed the exact path with directory fds
and O_NOFOLLOW. It did not execute stored files or create/delete anything.

- Target: /mnt/slowPool/jellyfin/shows.incoming/.helix-qual-backend-20260924-a.
- Result: ABSENT; missing component is that exact final directory name.
- Parent identity: device 61, inode 5, matching prior qualified staging parent.
- Verified dataset GUID: 14118969417656653668.
- findmnt: slowPool/jellyfin, zfs, /mnt/slowPool/jellyfin.
- Both read-only guest commands returned transport 0 and guest exitcode 0.

No result.json or retained case receipts exist under an absent directory at
observation time. This narrows current state, not historical execution: failure
before mkdir is consistent with the evidence, but absence cannot exclude
unobserved activity or subsequent removal. Retain UNKNOWN for the prior
dispatch. No replay, qualification acceptance, fixture cleanup or media
publication occurred. The original backend-dispatch-reconciliation.json and
all prior evidence remain unchanged. B70 Jellyfin discovery grant untouched.

## Handoff and remaining gates

Publication owner receives an appended checkpoint in its existing private
tv-publication-dev/HANDOFF.md, resolving the QGA-availability gate only. No new
backend test is authorized by this recovery; any future qualification needs
its own decision. Backend conformance is not PASS. Helper enrollment/API,
media-release, publication/indexing and playback remain separate gates.
If QGA becomes unresponsive again, capture diagnostics before proposing further
restarts; this recovery does not authorize automatic restart policy.

Canonical current-state, validation and TODO updates cover both hv-lore and
truenas-lore. All existing bytes are preserved with append-only additions;
before/after digests are in 2026-09-24-vm120-projection-digests.json. Delivery
is local/uncommitted documentation plus live-verified service recovery, not
commit, push or publication. No other repository work was changed.

Validation: hv-lore heartbeat-profile canonical-node contract PASS; truenas-lore
appliance-record contract PASS; runbook linkage audit PASS before execution;
seven projection/handoff output digests verified; scoped whitespace review PASS.
The TrueNAS validator lacked its executable bit, so it was run with bash
without changing permissions. These static checks do not prove appliance health.

Source identities: hv-cp d66c6f6a09bacb9326309caae316df987824838b;
truenas-cp da5b77473b58c536243b3762f050f5717b728bde; private projection base
c8ec8aa5e1de9a513ea60a6caaecba8740d0c1a9. Contract and earlier input digests
are in the initial QGA handoff. Origin was fetched before packet preparation;
the packet records branch divergence explicitly. No remote writes.

Live effects: One operator-executed restart of qemu-guest-agent.service on
truenas-lore VM120, successful; evidenced by new PID 28768 and independent
ping/no-op success. Subsequent agent actions were read-only SSH/QGA probes and
namespace inspection, with ordinary audit records possible. No VM/NAS reboot,
credential/trust/grant change, media/fixture mutation or remote Git write.
The earlier publisher dispatch remains separately UNKNOWN.

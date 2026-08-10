# Lore pbs-core validation backup — partial result

Date: 2026-08-10

## Authorized invocation

One existing PVE job was manually invoked exactly once on `hv-lore`:

`pbs-core-lore-all-guests`

Task:

`UPID:hv-lore:0035C428:02FEC66D:6A79EAB4:vzdump::root@pam:`

PVE logged the start at `2026-08-10 11:13:56 EDT`. The job used snapshot mode,
`all=1`, `exclude=120`, and storage `pbs-core-lore` -> datastore `pbs-core`.

## Client-side result

The terminal task state was `stopped` with `exitstatus: job errors`.

PVE recorded completed client-side backups for:

- VM 130 `jellyfin-lore`;
- VM 140 `ws-lore-agent`;
- VM 141 `ws-lore-apropos`;
- VM 142 `eq-lore`;
- VM 149 `ws-matriarch-gauntlet`;
- VM 150 `wow-unbound-prod`;
- VM 242 `pbs-katra`;
- CT 243 `time-lore`;
- CT 245 `ntfy-lore`;
- CT 246 `lxc-lore-headscale`;
- CT 247 `lxc-lore-monitor`;
- CT 248 `lxc-lore-www`;
- CT 249 `vaultwarden-lore`; and
- CT 252 `lxc-lore-dns`.

VM 260 `pbs-core` failed: `qmp command 'backup' failed - backup connect
failed: command error: http upgrade request timed out`. VM 120
`truenas-lore` was absent from the task log and therefore excluded as designed.
No retry was run.

## Receipt and capacity boundary

Independent PBS snapshot/group receipt is unproven. The approved PBS SSH
access attempt stopped at host-key verification; no host-key bypass or
enrollment occurred. A subsequent PVE-side post-run capacity query could not
run because the existing operator identity was unreadable. The pre-run
observation remains approximately 126 GB used with a 6 TB hard quota.

This evidence does not prove backup receipt, backup integrity, or recovery.
It records a partial client-side validation result only.

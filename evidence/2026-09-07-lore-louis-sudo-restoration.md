# Lore Louis passwordless sudo restored

Operator authorized restoration of the documented non-interactive Louis sudo
method while preparing a ws-hadrian recovery backup on truenas-lore through
VM120 QGA. Existing unrelated repository changes were preserved.

Before: certificate SSH to hv-lore succeeded as louis, but fresh-session
`sudo -n /usr/sbin/qm guest exec 120 -- /usr/bin/hostname` required a password.
Operator-provided `sudo -l` showed `(ALL : ALL) ALL`, without NOPASSWD.

The operator ran the staged, syntax-validated repair in an authenticated Lore
terminal. It refused an existing target, checked hostname and root execution,
validated the candidate with visudo, and published one root-owned mode-0440
drop-in, `/etc/sudoers.d/99-helix-louis`:

```sudoers
louis ALL=(ALL:ALL) NOPASSWD: ALL
```

Whole-policy visudo validation passed. Fresh Hadrian SSH then successfully
executed read-only QGA discovery on VM120 and returned truenas-lore.
No account, certificate, SSH trust, or other sudoers file was changed.
This was explicitly operator-authorized full passwordless sudo, not a narrowly
restricted QGA-only permission. The earlier documented operational method is
in implementation/2026-07-27-hypervisor-operational-harmony.packet.md.

Rollback, if separately requested: remove only this new drop-in, revalidate
sudoers, and confirm the remaining authenticated sudo policy. Maintain an
authenticated administrative terminal while doing so.

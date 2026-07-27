# Sanitized post-install contract

This contract describes what a node-specific first-boot implementation must
do. It intentionally contains no executable code, credentials, hashes, keys,
or device selectors.

1. Create or update the named operator account with a node-specific password
   hash derived at build time from an encrypted SOPS input.
2. Install only the approved public SSH key and set `.ssh` ownership/modes.
3. Install a minimal sudoers rule and validate it with `visudo -cf` before
   activation.
4. Ensure every directory used by the hook exists before writing files to it.
5. Declare every command and package dependency before the hook is admitted to
   installer media. Validation must not call a tool that the hook has not yet
   proved available.
6. Establish and validate the intended supported/non-subscription repository
   policy before package installation. Preserve changed source files for
   rollback and stop cleanly when package metadata cannot be refreshed.
7. Keep optional integration failure from blocking the base host, root SSH,
   or local recovery path. Notification, Git, and other integrations require
   separately testable units and approval boundaries.
8. Use a finite retry policy with a visible terminal failure. Do not create an
   unbounded restart loop around a missing dependency, invalid input, or broken
   repository state.
9. Keep recovery state root-owned and mode `0600`. Retain it on a recoverable
   failure, remove it only after validated success, and clean any temporary
   secret-bearing files with a script-scope trap that remains valid at exit.
10. Set an explicit mode on every installed artifact after any restrictive
    umask: `0600` or stricter for secrets, `0700` for root-only helpers, and
    `0644` for non-secret systemd units. Run `systemd-analyze verify` before
    daemon reload and do not treat a readable-but-`0600` unit as accepted.
11. Keep static daily-mail sender/recipient policy in the reviewed helper when
    it is not secret. Do not make a recurring helper source a secret-bearing
    environment merely to obtain fixed public routing values.
12. Log only non-secret execution status to a documented path. Never echo,
    journal, or preserve decrypted credentials or secret-derived values.
13. Do not make external authentication, message delivery, Git pushes, DNS
    changes, storage wipes, or network reconfiguration automatic.
14. Keep installer/bootstrap DNS until the operator establishes exact SSH
    contact by the reviewed management address. Then capture the before-state,
    query each intended internal resolver directly with a DNS-only probe absent
    from `/etc/hosts`, and enroll the resolver pair through the supported PVE
    DNS API with a declared rollback to bootstrap DNS.
15. Treat node-name publication as a second guarded change. Deploy only the
    declared short/FQDN records, validate forward and reverse answers through
    both resolvers, and stop if the live diff includes unrelated records.
16. A configured Postfix relay, PVE endpoint, or canary timer is not delivery
    evidence. Endpoint creation must not invoke its test API; provider
    acceptance and operator receipt require a separate bounded canary packet.
17. Provide clear SSH-first validation commands for the operator after reboot.

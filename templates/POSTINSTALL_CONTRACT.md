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
5. Disable unauthorized Proxmox subscription repositories before package
   installation; use the intended supported/non-subscription repository policy.
6. Log non-secret execution status to a documented path.
7. Do not make external authentication, Git pushes, DNS changes, storage wipes,
   or network reconfiguration automatic.
8. Provide clear SSH-first validation commands for the operator after reboot.

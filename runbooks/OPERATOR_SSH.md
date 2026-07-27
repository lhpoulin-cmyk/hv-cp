# Operator access: SSH first

## Purpose

Use SSH for routine inspection and administration of operating systems and
virtual machines. It is the default because commands can be pasted reliably,
recorded in shell history, and captured in an implementation packet.

## Physical node

1. Confirm the intended hostname and management address from the private node
   record.
2. Connect using a named SSH configuration entry or an explicit address.
3. Start read-only: `hostname -f`, `id`, `ip address`, and the relevant
   service status.
4. Capture consequential output in the implementation packet or a dated
   evidence record.

## Local VM rehearsal

1. Start the approved rehearsal helper.
2. Use its loopback-only forwarded SSH port and its `ssh-root`/`ssh-louis`
   helper commands when present.
3. Use the graphical console only if the installer, firmware, boot process, or
   network state prevents SSH.

## Guardrails

- Verify the target before `sudo` or any state-changing command.
- Use a console as break-glass recovery, not as the routine operator path.
- Do not paste multi-command mutation batches into a lagging console.

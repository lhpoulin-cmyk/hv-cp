# Operator memory aid: name the control before changing it

When returning to firewall work, do not depend on memory. Name each control
explicitly before a packet, command, or approval.

```text
Which node?
Which source identity?
Which destination identity and INPUT/OUTPUT path?
Which protocol and port?
Which rule scope and exact insertion position?
Which route carries the flow?
Which credential proves the identity?
Which host key establishes trust?
What recovery path remains working if the rule is wrong?
What exact rollback restores the ordered ruleset?
```

## Boundary reminder

- A `/32` identifies one host in a firewall source match; it does not identify
  a service port.
- A service port, source identity, destination path, rule position, and
  firewall scope are separate controls.
- Rule order is policy: an allow after a matching drop is not an allow.
- A recovery copy is distinct from the active credential, and encrypted custody
  is distinct from a Git repository or ordinary workstation storage.
- An operator endpoint may have a dependency at one layer while another path is
  independent at a different layer. Name the layer rather than calling a path
  simply "independent."

Use this as a pause point. If one answer is unknown, collect evidence or make
a bounded decision before changing the next control.

# hv-lore Seagate bootstrap discovery runbook

Status: completed historical read-only discovery procedure

This runbook implements the read-only collection authorized by the dated
implementation packet. It grants no recovery, restore, mount-write, or
migration authority.

## Collection sequence

1. Prove `hv-lore`, PVE version, ONLINE `rpool`, and VM242/VM260 identity.
2. Enumerate physical disks, USB devices, stable by-id links, and existing
   mounts without changing any state.
3. If no unique Seagate Expansion is present, stop. Continue on a different
   documented host only when the operator explicitly expands scope, then prove
   that host and the exact stable device identity again.
4. Only for a uniquely proven present device, inspect SMART identity and the
   partition/filesystem layout read-only before considering access.
5. Use a filesystem-specific read-only method only when it cannot replay a
   journal or write metadata. For ZFS, avoid live `rpool` name collisions and
   require an explicitly safe read-only import plan.
6. Inventory bounded metadata, PBS structure, VM260 artifacts, archive
   completeness, and credential-file metadata without printing secrets.
7. Record immutable evidence and leave every live object unchanged.

## Stop and rollback

Absence, identity ambiguity, unhealthy media, repair requirements, encrypted
content without authority, or uncertain read-only semantics ends collection.
No rollback is required because the runbook performs no mutation.

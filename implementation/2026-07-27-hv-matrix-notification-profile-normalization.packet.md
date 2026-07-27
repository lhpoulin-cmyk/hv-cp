# Implementation packet: hv-matrix notification-profile normalization

**Target:** `hv-matrix.arpa` (`192.168.10.22`) only.

**Purpose:** normalize Matrix's retained local Fastmail notification profile to
the reviewed Lore/Katra configuration without sending a message. Replace the
installer-rendered daily-mail helper and unit files with the reviewed `hv-cp`
templates, correct systemd unit modes to `0644`, and create the same named PVE
sendmail endpoint used by Lore and Katra.

**Authority:** operator request on 2026-07-27 to bring Matrix across the finish
line to the accepted Lore/Katra configuration while preserving outbound
canaries until contact and their separate acceptance gates are established.

**Established pre-change state:**

- Matrix's Postfix settings already match the shared relay policy:
  loopback-only binding, `[smtp.fastmail.com]:465`, implicit TLS with
  encryption, SASL enabled through a root-only hash map, `noanonymous`, and a
  generic sender map.
- Postfix and `helix-arpa-daily-mail-canary.timer` are enabled and active. The
  next daily activation is scheduled; no prior timer activation is reported.
- The installer-generated daily helper is root-owned mode `0700`. Its service
  and timer are root-owned mode `0600`, unlike the reviewed Lore/Katra units at
  `0644`, and their content is an installer-local variant.
- Matrix has only PVE's built-in `mail-to-root` endpoint. Lore and Katra each
  retain a user endpoint named `fastmail-cluster-node-canary` with author
  `Helix-Arpa-Cluster` and the shared cluster-node sender/recipient.
- Matrix's one-shot Discord helper is separately installed and unscheduled.
  No Discord or ntfy publication is authorized by this packet.

**Mutation:**

1. Preserve root-only copies of the three replaced daily-canary files under a
   dated `/var/lib/hv-cp/rollback/` directory.
2. Install the reviewed `hv-cp` daily helper at mode `0700` and the service and
   timer at mode `0644`; reload systemd without manually starting the service.
3. Create PVE sendmail endpoint `fastmail-cluster-node-canary` with author
   `Helix-Arpa-Cluster`, From address and sole recipient
   `cluster_node@poulin-arpa.com`, and a Matrix-specific configuration comment.
4. Leave the existing timer enabled/active and leave Postfix configuration and
   credential-bearing files byte-for-byte untouched.

**Stop conditions:** stop if the hostname, active timer, Postfix posture,
credential-file modes, built-in PVE endpoint, or absence of the named user
endpoint differs; if any template hash differs during transfer; or if systemd
or the PVE API rejects the local configuration. Do not run a canary as a
fallback validation.

**Validation:** compare installed files to the reviewed local templates; verify
ownership/modes, `systemd-analyze verify`, daemon-reload, timer enabled/active
state and next schedule, Postfix active/loopback-only relay posture, exact PVE
endpoint metadata, empty mail queue, SSH continuity, core PVE services, and no
failed units. No transport receipt is claimed.

**Rollback:** delete only Matrix's new PVE endpoint; restore the three preserved
files and their original modes; daemon-reload; and reconfirm the timer and
Postfix state. Do not remove or alter relay credentials, the installer-created
Discord helper, PVE's built-in endpoint, or any queued message not created by
this packet.

**Evidence destination:** this packet and Matrix's canonical notification and
current-state records. Root-only rollback copies remain on Matrix.

**Excluded:** no outbound mail, Discord, or ntfy event; no credential read or
rewrite; no package, DNS, firewall, network, storage, cluster, Ceph, guest,
TruthTap, or Git change.

## Result

Executed and accepted on 2026-07-27 without sending a notification.

- The installer-rendered daily helper and units were preserved under the
  root-only rollback directory
  `/var/lib/hv-cp/rollback/2026-07-27-hv-matrix-notification-profile/`.
- The reviewed `hv-cp` helper, service, and timer were installed with SHA-256
  values `7efb2568ba239f4627276595ea286aa14aa811d03b543e773c286b920a00ff98`,
  `c16448666b759b5aa9bbf3d3b3d90443ea523c97ac4ba9dc49527c68e346c41a`,
  and `4cf33fe16b8176513fa400978947e44533c82db0725c058de869a513af0250b0`.
  Their modes are `0700`, `0644`, and `0644`, respectively, and systemd
  verification passed.
- The PVE user endpoint `fastmail-cluster-node-canary` now has the intended
  author, From address, sole recipient, Matrix-specific no-test comment, and
  user-created origin. The built-in `mail-to-root` endpoint remains present.
- The timer remains enabled and active with its next 09:15 local activation
  scheduled. The canary service has no execution timestamp; the Postfix queue
  is empty. Postfix relay settings and root-only credential mode remain
  unchanged.
- Core PVE, SSH, and Postfix services remained active and no failed systemd
  units were reported.

No Fastmail, Discord, or ntfy canary was invoked, so no delivery or operator
receipt is asserted. Rollback was not required. Final read-only validation
completed at `2026-07-27T15:41:31-04:00`.

# Correction: hypervisor control-plane live parity artifact digests

Date: 2026-07-27

## Correction

The original live-parity report correctly classified the three-host parity
result, but several long SHA-256 strings were transcribed incorrectly while
the report was composed. The source artifacts were not corrupt and the
comparison itself established byte identity. This additive correction
preserves the original evidence file unchanged.

Fresh direct `sha256sum` output before remediation established these exact
common heartbeat digests:

| Artifact | Correct SHA-256 |
| --- | --- |
| publisher | `84b56c0ed49e155e3495bfc10d805055ee3eb88093ed3b9f08287c29e042bfb9` |
| heartbeat service | `99229861850652211625816da16b8ab6f8431d130b0fdafd13c8b2c66ea23dd8` |
| heartbeat timer | `c950a99af3f5e2efd2fc9ca9747f37f72ea19b0425ee1a7f7835baa2cc5233af` |
| mode helper | `63bf488701853cbe92621f3d9a2099900aa76e7582c944bd12f5285e46bb2f19` |
| fast-expiry service | `ad4aacbbbed9491d57c46de30a91f96e0e663c6efbb63b47ad6c9415e7eb751b` |
| fast-expiry timer | `ab18ee73de5c9829da50f4ffceb798d0f22cdf2bae3f2a337e6b8e589ad19e29` |
| cadence drop-in | `0979d6b9459d71300bed0de4b9b97d8e0ba63550b416c0ccf519bd00e374ed07` |

The common daily-mail service digest is
`c16448666b759b5aa9bbf3d3b3d90443ea523c97ac4ba9dc49527c68e346c41a`.

No secret-bearing file was read or hashed to make this correction.

# Expendables2 development transfer

Operator authorized promotion, temporary Lore source retention and removal of verified B70 job copies; temporary incoming export client addition 192.168.10.91 approved explicitly. Run small transfer test twice. Final export remains read-only. No louis-dev account creation: proposal parked for auth-cp review.

Sources: candidate at B70 .work/expendables2-current/expendables2-publication-candidate.json. Preserve source checksum56653790dc4f3b98380542ffee671a7f01a88ebc5036405f45d2268e02fc9a1c and recovered checksum e8b6b3673718cff23ed99c7e2bde7dba0b6b4aeffd47561300207f0df03b029a.

truenas-cp HEAD da5b77473b58c536243b3762f050f5717b728bde; hv-cp HEAD9e6638bc618df2cc3eaab9c37f4baf299a84e7a1. Existing owner QGA: hv-lore VM120 and hv-matrix VM310.

Enable: compare existing incoming NFS export6 path /mnt/slowPool/jellyfin.incoming, rw mapall infra; preserve full before config, append only B70 192.168.10.91. Final export5 unchanged. Mount existing incoming temporarily at B70 /mnt/helix-dev-incoming, exact NFS4 source192.168.10.111:/mnt/slowPool/jellyfin.incoming, nosuid,nodev,noexec. No fstab edit.

Default logical development namespace: incoming/b70-dev. Per-job isolated directories, never watched by Jellyfin. Retain source in b70-dev/expendables2-20260922/source; transcode in transcode. Two small exclusive fixture round trips before media. Copy through exclusive partial files, fsync, source identity stability, destination SHA256, no replacing any existing file. Record progress/receipt. No source deletion during transfer.

Owner publishes verified transcode by copy to final-filesystem movies.incoming, verifies checksum, atomic no-replace to exact movie target. Final name and effective service read checks precede commit. Source retention and publication each independently verified before job cleanup. Preserve job receipts. Unrelated artifacts untouched.

Disable: unmount temporary B70 mount, remove only added .91 from incoming export6 after comparing current config for drift; retain files. No forced unmount and no deleting any unverified source. On ambiguity preserve evidence and inspect, not retry blindly.

Runbook: this document specifies operational sequence; owner repo runbook/packet mirror required before export change. Durable detailed execution evidence under this directory; relevant private appliance record updated after mutation.

## Accepted publication and cleanup — September 22, 2026

Owner QGA publication completed with final-file SHA256 verification and atomic
no-overwrite. Jellyfin indexed the exact movie path after Louis's manual scan;
Louis confirmed audio at the start and picture/audio at 17:14, 49:56 and credits.
The final published movie is preserved. With explicit operator approval and fresh
owner checksum verification, the temporary Lore source was deleted. The exact
three B70 source/recovered/failed-intermediate files were also deleted, freeing
65,579,020,288 filesystem bytes (65,579,006,109 logical file bytes). Logs and
receipts remain. The additional incoming transcode and tiny qualification fixtures
remain retained; no unrelated data was removed.

Temporary NFS mount and incoming client allowance are closed; final export RO
unchanged. No new TrueNAS API, account or discovery credential change. Retention
clarification: verified operator playback permits early source deletion; otherwise
ten days with 24-hour purge notice, subject to error holds. No purge scheduler is
installed by this operation.

Private detailed receipts are in the Hadrian task's
publication-work/promotion-20260922/cleanup-owner-receipts.json,
cleanup-b70-receipt.json and index-after-operator-scan.json. B70 keeps per-file
cleanup receipts under .work/expendables2-current/publication-20260922/.
Live effects: exact approved source/job media deletions; final movie preserved.

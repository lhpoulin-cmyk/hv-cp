# VM310 local media acceptance — 2026-09-08

Classification: evidence. Historical execution output does not authorize repetition.

PLAY: VM310 local media staging
CHECKPOINT: runtime and persistent-mount acceptance
STATUS: COMPLETE
RESULT: 256 GiB p2 added, ext4 mounted, four shared bind mounts validated

## VM310 local media staging — 2026-09-08

Verified: 2026-09-08

The operator-authorized storage addition is live. WD SN810 serial 22412Y801751
retains p1 exactly (start 2048, length 536870912 sectors, existing PARTUUID).
New p2 is 256 GiB at sectors 536872960–1073743871, attached by stable host
by-id as VM310 scsi1 with serial vm310-media. The remaining contiguous
441.87 GiB is unallocated. Every prior VM setting, including scsi0, is unchanged;
VM310 remained running and direct Matrix management remained available.

Inside VM310, /dev/sdb is ext4 UUID 60ec5e3e-71b2-4842-bbe2-16cd8be40926,
mounted at /mnt/media. Persistent self-bind mounts expose source, work, output,
and archive on that same filesystem. All four exact-mount checks pass.
Systemd reconstructed the mounts from fstab after a bounded unmount test;
checks correctly failed while the mounts were absent. No reboot was performed.

The existing 3.3 GiB work tree was copied with metadata and checksum verification;
the original remains at /mnt/media.root-before-20260908. No media was deleted.
The shared 20% admission reserve is 53885495705 bytes (50.19 GiB), exceeding
30 GiB. Measured filesystem capacity is 269427478528 bytes (250.92 GiB);
197.52 GiB remains for the next movie after reserve and retained work. ext4
reserved blocks are zero to avoid charging the admission reserve twice.
One movie at a time; budget source, work, output and archive together.
Admission checks are not a quota or a runtime write cap.

Evidence: hv-cp/evidence/2026-09-08-vm310-local-media.md.
Guest procedure: gpu-encode/docs/local-media-staging.md.

## Validation and recovery

- GPT verification passed before and after; p1 JSON fields compare exactly to the saved preflight. The entire VM configuration compares exactly except the new scsi1 line.
- Tail remains 474452663808 bytes unallocated, sectors 1073743872–2000409230. No other partition was created.
- New guest disk serial and size, no children, no existing filesystem signatures, and no mountpoints were asserted before mkfs. Only /dev/sdb was formatted, inside VM310.
- Verified metadata-preserving copy via rsync checksum dry-run. Retained work SHA-256: `50ba65dc987fc9308e03c2fb6c45c3f5bb5919175edaa2761963497381f7643c`.
- All four mountpoints resolve to the ext4 UUID and same device, distinct from root. Work/output/archive create-read-unlink probes passed as louis; only test-created files were removed. Source content was untouched.
- Deployed `_validate_free_space` passed for all four paths. Available inodes: 16777196. The 20% reserve and all path usage refer to one filesystem; do not sum the four df rows.
- `findmnt --verify --verbose`: zero errors; one existing warning for the /swap.img regular file. Generated systemd mount units have the parent mount dependency and were successfully started from unmounted state.
- GPT/config recovery artifacts remain at host `/root/vm310-media-20260908/`. Guest fstab preimage is `/etc/fstab.before-vm310-media-20260908` and original media tree is `/mnt/media.root-before-20260908`.
- Rollback requires quiescing new media writes, unmounting the four binds then parent, restoring fstab and the original tree. Retain p2 and any new content; do not remove the partition or blindly restore GPT without separate authority.

## Execution notes and limits

The first guest attempt stopped before mutation because mountpoint uses exit 32 for an absent mount. Corrected and retried. Later `mount --move` was rejected by shared-parent propagation; the verified temporary mount was unmounted and mounted at its intended target without changing global propagation. These were ordinary mechanical repairs. Final validation passed.

Guest direct SSH works as louis, but guest sudo is interactive; root operations used the existing authorized host qm guest exec path. No credential, trust, network, package, VM power-state or application deployment change occurred. Guest deployed revision was 824643002fc580c210dd83a12a5dffa3b1e97005; local gpu-encode revision was 07e87816f99d4001719918035d988a3f78a705d5. Documentation records observation without claiming a deployment.

One-job-at-a-time operation and expected-size admission remain operational policy; no new scheduler or hard quota is installed. Backup/restore and encode regression were not exercised by this storage task. Existing pbs-core endpoint was unavailable during orientation; this change makes no backup-success claim. No VOICE.md was found in the local estate; existing repository prose contracts were followed.

## Recorded outputs

### vm310-host-result.txt

```text
The operation has completed successfully.

Warning: The kernel is still using the old partition table.
The new table will be used at the next reboot or after you
run partprobe(8) or kpartx(8)
The operation has completed successfully.



No problems found. 926667373 free sectors (441.9 GiB) available in 2
segments, the largest of which is 926665359 (441.9 GiB) in size.

update VM 310: -scsi1 /dev/disk/by-id/nvme-WD_PC_SN810_SDCPNRY-1T00-1406_22412Y801751-part2,ssd=1,serial=vm310-media

agent: enabled=1
bios: ovmf
boot: order=scsi0;ide2
cores: 6
cpu: host
efidisk0: local-zfs:vm-310-disk-0,efitype=4m,pre-enrolled-keys=0,size=1M
hostpci0: 0000:23:00.0,pcie=1
hostpci1: 0000:24:00.0,pcie=1
ide2: /dev/disk/by-id/ata-HL-DT-ST_BD-RE_WH16NS60_KLZKCPJ4610,media=cdrom,size=39714368K
machine: q35
memory: 12288
meta: creation-qemu=11.0.0,ctime=1785263227
name: b70-encode
net0: virtio=BC:24:11:DE:C4:B1,bridge=vmbr0
ostype: l26
scsi0: /dev/disk/by-id/nvme-WD_PC_SN810_SDCPNRY-1T00-1406_22412Y801751-part1,size=256G,ssd=1
scsi1: /dev/disk/by-id/nvme-WD_PC_SN810_SDCPNRY-1T00-1406_22412Y801751-part2,serial=vm310-media,size=256G,ssd=1
scsihw: virtio-scsi-single
serial0: socket
smbios1: uuid=0073afae-f620-4398-b288-7ce58738da14
usb0: host=1-13,usb3=1
vga: std
vmgenid: 5300d1c3-f92b-4b3f-b253-91e6585014fe

Unpartitioned space /dev/nvme1n1: 441.87 GiB, 474452663808 bytes, 926665359 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes

     Start        End   Sectors   Size
1073743872 2000409230 926665359 441.9G

PASS p1 unchanged; new p2 256 GiB; scsi0 unchanged
```

### vm310-guest-setup-result.json

```text
{
  "err-data": "mke2fs 1.47.2 (1-Jan-2025)\nmount: /mnt/media: bad option; moving a mount residing under a shared mount is unsupported.\n       dmesg(1) may have more information after failed mount system call.\nTraceback (most recent call last):\n  File \"<string>\", line 33, in <module>\n    old.rename(backup); old.mkdir(); do('mount','--move',str(stage),str(old)); stage.rmdir()\n                                     ~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n  File \"<string>\", line 4, in do\n    def do(*a): print(run(*a),flush=True)\n                      ~~~^^^^\n  File \"<string>\", line 3, in run\n    def run(*a): return s.check_output(a,text=True)\n                        ~~~~~~~~~~~~~~^^^^^^^^^^^^^\n  File \"/usr/lib/python3.14/subprocess.py\", line 473, in check_output\n    return run(*popenargs, stdout=PIPE, timeout=timeout, check=True,\n           ~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n               **kwargs).stdout\n               ^^^^^^^^^\n  File \"/usr/lib/python3.14/subprocess.py\", line 578, in run\n    raise CalledProcessError(retcode, process.args,\n                             output=stdout, stderr=stderr)\nsubprocess.CalledProcessError: Command '('mount', '--move', '/mnt/media.new-20260908', '/mnt/media')' returned non-zero exit status 32.\n",
  "err-truncated": 0,
  "exitcode": 1,
  "exited": 1,
  "out-data": "Discarding device blocks:        0/67108864\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b                 \b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\bdone                            \nCreating filesystem with 67108864 4k blocks and 16777216 inodes\nFilesystem UUID: 60ec5e3e-71b2-4842-bbe2-16cd8be40926\nSuperblock backups stored on blocks: \n\t32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, \n\t4096000, 7962624, 11239424, 20480000, 23887872\n\nAllocating group tables:    0/2048\b\b\b\b\b\b\b\b\b         \b\b\b\b\b\b\b\b\bdone                            \nWriting inode tables:    0/2048\b\b\b\b\b\b\b\b\b         \b\b\b\b\b\b\b\b\bdone                            \nCreating journal (262144 blocks): done\nWriting superblocks and filesystem accounting information:    0/2048\b\b\b\b\b\b\b\b\b         \b\b\b\b\b\b\b\b\bdone\n\n\n\n\n",
  "out-truncated": 0
}
```

### vm310-guest-resume-result.json

```text
{
  "err-data": "\n0 parse errors, 0 errors, 2 warnings\n",
  "err-truncated": 0,
  "exitcode": 0,
  "exited": 1,
  "out-data": "\n\n/\n   [ ] target exists\n   [ ] source /dev/disk/by-id/dm-uuid-LVM-vo6cAcC2DuECdVfAG4n5xdRGQs91BHQlUPsNhNNoS58pz4ER1sh3Acnca17evo84 exists\n   [ ] FS type is ext4\n/boot\n   [ ] target exists\n   [ ] source /dev/disk/by-uuid/798c5397-4222-4d31-8730-1d504da162b0 exists\n   [ ] FS type is ext4\n/boot/efi\n   [ ] target exists\n   [ ] source /dev/disk/by-uuid/4A1E-12BF exists\n   [ ] FS type is vfat\nnone\n   [W] non-bind mount source /swap.img is a directory or regular file\n   [ ] FS type is swap\n/mnt/media\n   [ ] target exists\n   [ ] UUID=60ec5e3e-71b2-4842-bbe2-16cd8be40926 translated to /dev/sdb\n   [ ] source /dev/sdb exists\n   [ ] FS type is ext4\n/mnt/media/source\n   [ ] target exists\n   [ ] VFS options: bind\n   [ ] userspace options: x-systemd.requires-mounts-for=/mnt/media\n   [ ] do not check /mnt/media/source source (pseudo/net)\n   [ ] do not check /mnt/media/source FS type (pseudo/net)\n/mnt/media/work\n   [ ] target exists\n   [ ] VFS options: bind\n   [ ] userspace options: x-systemd.requires-mounts-for=/mnt/media\n   [ ] do not check /mnt/media/work source (pseudo/net)\n   [ ] do not check /mnt/media/work FS type (pseudo/net)\n/mnt/media/output\n   [ ] target exists\n   [ ] VFS options: bind\n   [ ] userspace options: x-systemd.requires-mounts-for=/mnt/media\n   [ ] do not check /mnt/media/output source (pseudo/net)\n   [ ] do not check /mnt/media/output FS type (pseudo/net)\n/mnt/media/archive\n   [ ] target exists\n   [ ] VFS options: bind\n   [ ] userspace options: x-systemd.requires-mounts-for=/mnt/media\n   [ ] do not check /mnt/media/archive source (pseudo/net)\n   [ ] do not check /mnt/media/archive FS type (pseudo/net)\n   [W] your fstab has been modified, but systemd still uses the old version;\n       use 'systemctl daemon-reload' to reload\n\n\n\n\n\n\nTARGET               SOURCE             FSTYPE OPTIONS\n/mnt/media           /dev/sdb           ext4   rw,relatime\n\u00e2\u0094\u009c\u00e2\u0094\u0080/mnt/media/source  /dev/sdb[/source]  ext4   rw,relatime\n\u00e2\u0094\u009c\u00e2\u0094\u0080/mnt/media/work    /dev/sdb[/work]    ext4   rw,relatime\n\u00e2\u0094\u009c\u00e2\u0094\u0080/mnt/media/output  /dev/sdb[/output]  ext4   rw,relatime\n\u00e2\u0094\u0094\u00e2\u0094\u0080/mnt/media/archive /dev/sdb[/archive] ext4   rw,relatime\n\nUUID=60ec5e3e-71b2-4842-bbe2-16cd8be40926\nPASS original media retained at /mnt/media.root-before-20260908; checksum rsync comparison clean\n",
  "out-truncated": 0
}
```

### vm310-guest-validate-result.json

```text
{
  "err-data": "\n0 parse errors, 0 errors, 1 warning\n",
  "err-truncated": 0,
  "exitcode": 0,
  "exited": 1,
  "out-data": "\n\n\n\n\nPASS exact-mount checks fail while media is absent\n\n\n\n\n/mnt/media/source /dev/sdb[/source] ext4 rw,relatime\n/mnt/media/work /dev/sdb[/work] ext4 rw,relatime\n/mnt/media/output /dev/sdb[/output] ext4 rw,relatime\n/mnt/media/archive /dev/sdb[/archive] ext4 rw,relatime\n\n\n\nPost-probe rsync metadata comparison: '.d..t...... archive/\\n.d..t...... output/\\n.d..t...... work/\\n'\nRetained work SHA256=50ba65dc987fc9308e03c2fb6c45c3f5bb5919175edaa2761963497381f7643c\n{\"total_bytes\": 269427478528, \"used_bytes\": 3442896896, \"free_bytes\": 265967804416, \"reserve_bytes\": 53885495705, \"new_job_budget_bytes\": 212082308711, \"new_job_budget_GiB\": 197.51704177912325, \"free_inodes\": 16777196}\nPASS deployed admission checks\n\n/\n   [ ] target exists\n   [ ] source /dev/disk/by-id/dm-uuid-LVM-vo6cAcC2DuECdVfAG4n5xdRGQs91BHQlUPsNhNNoS58pz4ER1sh3Acnca17evo84 exists\n   [ ] FS type is ext4\n/boot\n   [ ] target exists\n   [ ] source /dev/disk/by-uuid/798c5397-4222-4d31-8730-1d504da162b0 exists\n   [ ] FS type is ext4\n/boot/efi\n   [ ] target exists\n   [ ] source /dev/disk/by-uuid/4A1E-12BF exists\n   [ ] FS type is vfat\nnone\n   [W] non-bind mount source /swap.img is a directory or regular file\n   [ ] FS type is swap\n/mnt/media\n   [ ] target exists\n   [ ] UUID=60ec5e3e-71b2-4842-bbe2-16cd8be40926 translated to /dev/sdb\n   [ ] source /dev/sdb exists\n   [ ] FS type is ext4\n/mnt/media/source\n   [ ] target exists\n   [ ] VFS options: bind\n   [ ] userspace options: x-systemd.requires-mounts-for=/mnt/media\n   [ ] do not check /mnt/media/source source (pseudo/net)\n   [ ] do not check /mnt/media/source FS type (pseudo/net)\n/mnt/media/work\n   [ ] target exists\n   [ ] VFS options: bind\n   [ ] userspace options: x-systemd.requires-mounts-for=/mnt/media\n   [ ] do not check /mnt/media/work source (pseudo/net)\n   [ ] do not check /mnt/media/work FS type (pseudo/net)\n/mnt/media/output\n   [ ] target exists\n   [ ] VFS options: bind\n   [ ] userspace options: x-systemd.requires-mounts-for=/mnt/media\n   [ ] do not check /mnt/media/output source (pseudo/net)\n   [ ] do not check /mnt/media/output FS type (pseudo/net)\n/mnt/media/archive\n   [ ] target exists\n   [ ] VFS options: bind\n   [ ] userspace options: x-systemd.requires-mounts-for=/mnt/media\n   [ ] do not check /mnt/media/archive source (pseudo/net)\n   [ ] do not check /mnt/media/archive FS type (pseudo/net)\n\nPASS fstab reconstruction, all four exact mounts, shared device, user writes, preserved content, reserve and inodes\n",
  "out-truncated": 0
}
```

### vm310-host-final.txt

```text
status: running


No problems found. 926667373 free sectors (441.9 GiB) available in 2
segments, the largest of which is 926665359 (441.9 GiB) in size.

Unpartitioned space /dev/nvme1n1: 441.87 GiB, 474452663808 bytes, 926665359 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes

     Start        End   Sectors   Size
1073743872 2000409230 926665359 441.9G

default via 192.168.10.1 dev vmbr0 proto kernel onlink
192.168.10.0/24 dev vmbr0 proto kernel scope link src 192.168.10.22
192.168.100.0/24 dev enp45s0d1 proto kernel scope link src 192.168.100.22

PASS p1 exact preflight match and entire VM config unchanged except scsi1
```

# VM310 sr1 attachment inspection — 2026-09-10

Read-only inspection following the operator's request to pass Matrix sr1 to
b70-encode. No live mutation or guest start performed.

Source hv-cp HEAD: 61cab3416294ebbd9d8eda2ccff2403fc20ab56d.
Origin fetched successfully; origin/main bfc3897; HEAD is two commits ahead
and three behind. Incoming commits concern documentation and licensing.
Existing unrelated dirty work was preserved.

SSH used the existing louis identity and strict host verification, explicitly
selecting the user SSH config and management address 192.168.10.22 with
HostKeyAlias hv-matrix.arpa. Default system SSH configuration had an ownership
error; sandbox DNS resolution failed. Authorized elevated network access worked.

Observed hv-matrix, HP Z4 G4, PVE 9.2.2, kernel 7.0.2-6-pve. VM310
b70-encode is stopped. Management remains vmbr0/192.168.10.22 with default
route through 192.168.10.1. PBS target was unavailable (connection refused);
this was outside the attachment inspection.

The operator's sysfs path matches the live sr1 device:
`/sys/devices/pci0000:00/0000:00:1d.0/0000:03:00.0/ata10/host9/target9:0:0/9:0:0:0`.
Model HL-DT-ST BD-RE WH16NS60, serial KLZKCPJ4610.

Existing VM310 configuration already contains:

```text
ide2: /dev/disk/by-id/ata-HL-DT-ST_BD-RE_WH16NS60_KLZKCPJ4610,media=cdrom,size=39714368K
```

The stable symlink resolves to /dev/sr1. `qm pending 310` shows this as
current configuration. `qm showcmd 310 --pretty` generates host_cdrom,
read-only=true and ide-cd for this exact path. This proves an existing optical
media attachment, not native ATAPI/SCSI command passthrough or guest runtime
acceptance. Controller 03:00.0 is not assigned; existing PCI assignments are
23:00.0 and 24:00.0. Full controller passthrough would require checking all
controller devices and IOMMU isolation before defining that change.

No accepted node change occurred, so canonical mutation projection is not
required. Guest visibility and media-ingestion functionality remain untested
because the guest is stopped.

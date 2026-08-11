# VM9260 pbs-core rebuild drill — lifecycle evidence

Date: 2026-08-11
Status: temporary lifecycle completed; installation blocked safely

`hv-matrix` created VM9260 `restore-test-pbs-core` under
`UPID:hv-matrix:000BD2E5:04726F97:6A7B59D9:qmcreate:9260:root@pam:` with the
approved q35/OVMF, 4-vCPU, 8192-MiB, 64-GiB `local-zfs` realization. It had an
EFI disk, the hash-verified temporary PBS ISO, and a serial console only. No
`net0`, `net1`, PCI/USB device, raw disk, or production storage was configured.

VM9260 started once for installer-console validation, but the ISO emitted no
usable serial installer output. No supported local graphical console client or
Proxmox auto-install assistant was present on the host. The required
networkless installation path was therefore unavailable. No NIC was added and
no alternate installer path was invented.

The temporary VM was stopped under
`UPID:hv-matrix:000BD56B:04728F88:6A7B5A2A:qmstop:9260:root@pam:` and destroyed
under `UPID:hv-matrix:000BD5A2:04729082:6A7B5A2D:qmdestroy:9260:root@pam:`.
The two `vm-9260-*` volumes and copied ISO were confirmed absent. VM260 and its
datastore were not changed.

Blocker: `NETWORKLESS PBS INSTALLER CONSOLE PATH UNAVAILABLE`.

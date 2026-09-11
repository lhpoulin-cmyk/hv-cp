# Matrix three-drive optical procedure

Use only with the [dated packet](../implementation/2026-09-11-matrix-three-optical.packet.md)
and [desired state](../docs/MATRIX_OPTICAL_DESIRED_STATE.md). Current status is
deferred by the operator as a known limitation. No maintenance is scheduled;
resume only on an explicit operator request. The shared Intel controller must
never be assigned.

## Read-only collection

The narrow helper [optical-inventory.py](helpers/optical-inventory.py) collects
Linux sysfs topology, udev properties, complete block/mount inventory, PCI
driver information, optical open handles and process names. It does not open
media, reset a device, mount a filesystem, detach a driver or change a VM.
It emits private identifiers. Always redirect it into a fresh private evidence
directory, never a Git-tracked file or chat. Root is required for complete
handle evidence; a non-root result is explicitly incomplete.

```bash
umask 077
capture=$(mktemp -d inbox/optical-matrix-XXXXXXXX)
ssh -F /home/louis/.ssh/config \
  -o HostName=192.168.10.22 -o HostKeyAlias=hv-matrix.arpa \
  -o BatchMode=yes -o StrictHostKeyChecking=yes hv-matrix \
  'sudo -n python3 -' < runbooks/helpers/optical-inventory.py \
  > "$capture/host-inventory.json"
```

Capture `qm list` before selecting VM310. Save complete `qm config 310` and
`qm pending 310` separately before mutation, and compare guest hostname,
SMBIOS UUID, and the expected hardware to prove identity. Preserve the config
verbatim; never sanitize the rollback copy in place. Protect it and publish
only a separate reviewed summary. Inspect the helper's command return codes:
empty output after a failed collector is not negative evidence.

Obtain the same inventory as root in the guest through the already-enabled
PVE guest agent, using `qm guest exec 310 -- python3 -c <helper-source>`.
Pass the source using proper argv/SSH quoting, retain the outer guest-agent
JSON and decoded output separately, and require completed execution with
exitcode zero. Do not enable a guest agent, change guest sudo, or mount a disc
to obtain evidence. The unprivileged SSH inventory is a useful preliminary
view, not complete open-handle proof.

Correlate USB serial, vendor/product and topology from both sides, plus the
PVE usb property. Correlate SATA serial/by-id and by-path with its actual PCI
controller; inspect every controller descendant, not just optical devices.
Inspect every IOMMU group member and advertised reset method without executing
a reset. Check the host rpool membership using `zpool status -P`. Do not count
a QEMU optical device as a native physical drive.

## Safety and execution gate

The 2026-09-11 result fails: HP GUD1N shares `0000:00:17.0` with both rpool
members. Leave this controller attached to ahci. The operator must resolve the
HP connection/method before the packet can become execution-ready. Two ATA
ports on `03:00.0` do not prove that a spare physical connector/cable is usable.
Do not power off the host or recable it under this procedure.

After resolution, refresh the topology and private selectors, finish the exact
optical-only apply/rollback delta, and qualify the execution path. The current
hv-cp controlled-change procedure uses SSH/PVE interfaces. The inspected
ansible-cp catalog contains no Matrix optical template. If realization is
admitted to ansible-cp, use its committed payload, manual authenticated
Semaphore launch and exact acknowledgement; never invoke APPLY by API or
bypass a ceremony. No executor admission or acknowledgement is asserted here.

Before requesting shutdown, prove no mounted optical media, open guest optical
handles, rip/encode tasks, relevant active jobs, queued work that could start,
or other workloads needing preservation. Check application state without
reading credentials or media. Retain evidence. A historical process snapshot
is not a shutdown authorization. Review stopped-guest device handles before
any controller release. Do not force-stop or kill a holder.

Run `tools/audit-live-mutation-runbooks.sh` before marking any revised packet
execution-ready. Preserve `hostpci0` and `hostpci1` byte-for-byte; never pass
Intel `00:17.0`, xHCI `00:14.0`, or bridge `00:1d.0` to the guest. Use `qm`
for configuration; never rewrite `/etc/pve` directly.

## Acceptance and recovery

After the reviewed change and guest start, collect both inventories anew.
Require all three exact physical drives simultaneously, with correctly paired
sr/sg paths and no virtual-drive substitution. Compare the complete VM config
against the before state, allowing only the reviewed optical delta. Verify
both guest GPU functions/drivers and render access using read-only checks;
do not run an encode or change GPU state. Check host management and storage.

The old ide2 mapping should be removed with its optical boot-order entry only
when replacing it with validated native attachment, preserving scsi0 boot.
Keep its exact captured value for rollback. The removal is not authorized while
this packet is blocked. A persistent `qm` setting is not a reboot test. Do not
restart the host for acceptance; any guest restart requires refreshed workload
checks and the applicable ceremony.

Rollback after a future apply: perform the reviewed clean guest shutdown,
delete only the newly introduced optical property, and restore the previous
ide2/boot/usb properties verbatim from `vm310-before.conf` via `qm set`. Compare
every configuration field against the full capture before starting the guest.
Preserve and investigate unrelated drift instead of overwriting it. Never
write the complete capture directly into `/etc/pve`, reset a GPU, delete media,
or prune state. If hardware was physically moved, its rollback belongs to its
separate maintenance plan. For this inspection, rollback requires no action.

Keep raw results private and additive; update the packet, current state and
canonical node projection after accepted changes, then run the node validator.

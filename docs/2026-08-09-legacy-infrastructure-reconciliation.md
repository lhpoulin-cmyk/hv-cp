# Legacy infrastructure hypervisor reconciliation

**Date:** 2026-08-09
**Status:** completed documentary reconciliation; no live-host authority
**Canonical checkout:** `/home/louis/helix-arpa/hv-cp` at published `main`
`01c59749a74d495841a3a2d5428305e1df5c4f09`

## Sources and custody

| Source | Revision / state | Disposition |
| --- | --- | --- |
| `/home/louis/infrastructure` | `38329bf359fc75b627fe7a7e77877c72d09dd50a`; retained unchanged | Current legacy mixed-authority source. |
| `/home/louis/active/hv-cp` | `4decbe488b1023c56990ead25a0365809bc0a500`; clean, seven commits behind published `main` | Historical stale checkout; not promoted or used as a migration source. |
| published `hv-cp` history | `01c59749a74d495841a3a2d5428305e1df5c4f09` | Modern standalone authority and canonical local checkout. |
| `/home/louis/active/helix-arpa-active` | historical source, where applicable | Retained; no files were read into or moved by this reconciliation. |

The former target stub at `/home/louis/helix-arpa/hv-cp` was proven to be
non-repository runtime scaffolding and was replaced from published authority.
The canonical checkout is a clone of published `main`, not a move of the stale
`active` checkout.

## Reviewed legacy material

The following table records source paths and dispositions.  A disposition of
`EVIDENCE-ONLY` means the record remains available in the legacy repository but
is not a declaration of current desired state.  `SUPERSEDED` means the current
standalone doctrine is the durable method; it does not erase the source.

| Area | Representative legacy paths | Classification | Disposition | Reason |
| --- | --- | --- | --- | --- |
| Host state | `nodes/hv-katra/{CURRENT_STATE,HARDWARE,VALIDATION}.md`; `nodes/hv-lore/{CURRENT_STATE,HARDWARE,VALIDATION}.md` | HV-AUTHORITY mixed with evidence | EVIDENCE-ONLY | Node-specific observations belong in private node records; the reusable contract and newer standalone evidence already define the active method. |
| Runbooks and recovery | `nodes/hv-katra/{RUNBOOK,RECOVERY_DRILLS,RECOVERY_IMAGE_RUNBOOK}.md`; `nodes/hv-lore/{RUNBOOK,RECOVERY_IMAGE_RUNBOOK}.md`; `workspace/drafts/hypervisor-recovery-vm-environment.md` | HV-AUTHORITY / HISTORICAL | SUPERSEDED | `runbooks/`, `docs/SOURCE_RECOVERY.md`, and current recovery material are the maintained control-plane method. |
| Host-local firewall | `nodes/hv-katra/config/host.fw`; `nodes/hv-lore/config/host.fw`; `standards/HYPERVISOR_FIREWALL_DOCTRINE.md`; `scripts/deploy-hypervisor-firewall.sh` | HV-AUTHORITY mixed with historical execution material | SUPERSEDED | `firewall-cp/` is the bounded sub-authority for Proxmox host-local firewall planning. No legacy rules or deploy script were copied, and router/switch ACLs remain network authority. |
| VM/LXC deployment | `nodes/hv-katra/LXC_*.md`; `nodes/hv-lore/{LXC_*.md,WS_LORE_APROPOS.md}`; related command logs | DEPLOYMENT mixed with PRODUCT and NETWORK | EVIDENCE-ONLY | Guest attachment facts are hypervisor evidence; guest service behavior, DNS, and application configuration were not adopted. |
| Recovery and backup | `nodes/hv-*/command-log/*pbs*`; `standards/{BACKUP_DOCTRINE_STATUS,OPPOSING_PBS_IMPLEMENTATION_PLAN}.md`; `scripts/key-escrow/` | REVIEW / TRUENAS / FOUNDATION | HISTORICAL | PBS service policy and key escrow require their actual owners; no generic storage or escrow authority moved here. |
| Storage attachment | `nodes/hv-*/STORAGE.md`; TrueNAS VM and raw-disk references in `CURRENT_STATE.md` | HV-AUTHORITY mixed with TRUENAS and CEPH/STORAGE | EVIDENCE-ONLY | A VM disk or PCI attachment is hypervisor-scoped, but datasets, exports, pools, OSDs, and backup-service policy were excluded. |
| PCI/VFIO | `nodes/hv-lore/command-log/2026-05-22-{arc-a750-jellyfin-passthrough,gpu-readiness-discovery,ws-lore-agent-p6000-*}.md`; `nodes/hv-katra/CURRENT_STATE.md` | HV-AUTHORITY mixed with GPU and PRODUCT | EVIDENCE-ONLY | IOMMU/VFIO and `hostpci` mechanics are hypervisor matters, but allocation, capability inventory, and guest application behavior remain `gpu-cp` or product authority. |
| Evidence and outputs | `nodes/hv-*/command-log/`; `nodes/hv-*/outputs/`; `nodes/hv-*/backups/`; `nodes/hv-*/reviews/` | EVIDENCE / HISTORICAL | HISTORICAL | These dated captures remain in place for provenance; copying them would duplicate potentially private or stale node state. |

## Boundary outcomes

- **hv-cp:** reusable host lifecycle, recovery method, VM/LXC attachment
  method, PCI/VFIO mechanics, validation, and Proxmox host-local firewall
  planning.
- **network-cp:** DNS, bridges/VLAN/fabric policy, router/switch ACLs, and
  network deployment scripts.
- **truenas-cp:** appliance configuration, datasets, exports, pools, and
  TrueNAS-side backup storage.
- **ceph-cp:** Ceph membership, OSD/device policy, pools, and RBD policy.
- **gpu-cp:** GPU placement, capability inventory, and portfolio allocation.
- **Products:** Jellyfin, Vaultwarden, Pi-hole, agent workloads, and guest
  application behavior.
- **Foundation:** key escrow, portable root of trust, and recovery-root
  custody.

No legacy hypervisor file was adopted verbatim: none is newer than the
standalone control-plane doctrine, and all candidate state either belongs in a
private node record or crosses another authority boundary.  This record is the
accepted migration artifact and supersession record; the legacy source remains
unchanged.

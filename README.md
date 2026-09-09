# Helix-ARPA Hypervisor Control Plane

A human-supervised infrastructure control plane for a small fleet of **independent Proxmox VE hypervisors**. It combines repeatable installation, configuration, validation, recovery, firewall work, evidence, and controlled execution without pretending that Git itself is the live machine.

`hv-cp` is also the clearest centerpiece of a larger Helix-ARPA `*-cp` design: administrative work is split into logical domains—hypervisors, networking, storage, workstations, GPU/compute, backup, identity, automation, observation, and related services—so each realm can own its own desired state and safety boundary while still participating in one coherent operating system for the lab.

The idea is simple even if the implementation is not: **run the same intent twice and the second run should converge, verify, or do nothing useful—not invent a second reality.** Idempotence is treated as an operational property across logical sysadmin and automation domains, not just as a nice behavior inside one script.

This repository is where that philosophy is easiest to see because hypervisors sit underneath almost everything else. If the virtualization layer is ambiguous, every higher-level service inherits the ambiguity.

## Portfolio view

### What I built

- reusable Proxmox installation templates and procedures;
- per-host identity and configuration contracts;
- operator SSH and controlled-change runbooks;
- host-firewall planning and validation;
- recovery procedures and implementation packets;
- machine-checkable canonical-node documentation validation;
- evidence records that distinguish desired, generated, observed, and historical state;
- a reusable method for bringing independently managed hosts toward the same documented standard without making one host the template or authority for another.

### The `*-cp` model

Helix-ARPA uses separate control-plane repositories for separate administrative domains. Representative peers include `network-cp`, `ansible-cp`, `ceph-cp`, `ws-cp`, `gpu-cp`, `compute-cp`, `truenas-cp`, `pbs-cp`, `auth-cp`, and `observation-cp`.

Each control plane answers a deliberately narrow set of questions:

1. **What does this domain own?**
2. **What is desired state, and what is merely evidence or generated output?**
3. **What can be observed safely?**
4. **What change is authorized?**
5. **What makes the change repeatable and idempotent?**
6. **What proves that the live result matches the intent?**
7. **Which neighboring control plane owns the parts this one does not?**

The result is not one giant automation repository with accidental authority over everything. It is a set of cooperating administrative realms with explicit ownership and handoff boundaries.

`hv-cp` is the centerpiece because it demonstrates the pattern against the physical and virtual substrate itself: host identity, installation, network attachment, storage assumptions, firewall posture, recovery, and the operational evidence required before higher-level systems can safely depend on a node.

### Engineering focus

**Linux · Proxmox VE · virtualization · infrastructure lifecycle · configuration management · idempotent automation · recovery engineering · host security · validation · evidence-driven operations · human-supervised automation**

### Design principle

**Git describes, reviews, and validates infrastructure; it does not automatically receive authority to change live hosts.**

That is the plain-English version of a rule used throughout Helix-ARPA. Documentation, templates, manifests, generated files, and implementation packets can describe a change precisely, but current live state is still verified at the machine and a human operator retains authority over mutation.

The goal is not automation for its own sake. The goal is to make a repeated administrative operation unsurprising: observe current state, compare it to declared intent, make only the bounded change that is actually required, validate the result, and preserve evidence of what happened.

## The control planes are also my curriculum

Helix-ARPA is deliberately a working environment, but it is also how I have been teaching myself systems administration and automation.

Rather than learning each subject as an isolated lab exercise, I use a real administrative problem until I understand enough of it to move the work one layer further toward repeatability:

```text
manual administration
      -> observe and document live state
      -> identify ownership and failure boundaries
      -> encode the domain in a *-cp repository
      -> give agents a bounded, reviewable working surface
      -> turn mature repeated procedures into idempotent automation
      -> realize approved intent through Ansible / Semaphore
```

The intermediate steps matter. An agent is useful to me when it can inspect, reason, draft, compare, and stop safely—not because it is allowed to improvise production changes. The `*-cp` repositories give that agentic work a structured surface: clear ownership, current intent, evidence, runbooks, explicit mutation boundaries, and somewhere durable to leave the result.

There was also a very educational detour here. At one point I knew so little about configuration-management tooling that I spent roughly two or three weeks enthusiastically building my own homegrown, two-private-repository approximation of Ansible before I understood that Ansible already existed and was considerably better at being Ansible. I regret none of the intensity I put into it. Building the clumsy version first made idempotence, inventory, separation of desired state from execution, and the value of a mature automation engine concrete rather than theoretical. Discovering the real tool felt less like throwing work away and more like finally learning the name of the thing I had been trying to invent.

As a procedure becomes boring enough to automate, the destination is `ansible-cp`, the Helix-ARPA realization control plane. Peer control planes keep authority over their own desired state; Ansible consumes approved inputs and reusable execution conventions. Semaphore provides the authenticated execution surface. OBSERVE templates are already proven there, while bounded APPLY work remains manually launched and explicitly acknowledged rather than scheduled behind the operator's back.

That progression is intentional. I am trying to teach myself not just how to make a system work once, but how to make the knowledge **repeatable, reviewable, delegable, idempotent, and recoverable**.

The lab therefore doubles as a curriculum whose assignments are real machines. When I learn something successfully, the output is supposed to become infrastructure rather than disappear with the exercise.

## Current status

> **Bottom line up front:** hv-cp v1.2.0 is the documented, human-supervised control plane for every independent Helix-ARPA hypervisor: Lore, Katra, Matrix, and future nodes. Static canonical-node conformance is enforced. Live-state enforcement, advanced tooling, and metrics remain separate work.

Every host has its own verified identity, private node record, evidence, implementation packets, and recovery path. No host is the template, transit, or authority for another. Recovered Katra-related installation material is first-article evidence for reusable method only; it does not give Katra a special operational role. Matrix, Lore, and Katra are equal consumers of the same control-plane method.

## What this project owns

- the operating model, runbooks, and sanitized node templates;
- the source-recovery evidence and decisions that explain what was adopted or intentionally excluded; and
- implementation packets for future, separately authorized changes.

It does **not** own live credentials, generated install media, raw firmware tools, large archives, or the private node record.

## Control-plane boundaries

| Need | Durable home | Rule |
| --- | --- | --- |
| Private hardware, management, and Lifetap baseline | `helix-arpa-private/nodes/local-compute/hv/<node>/` | Private authority; archive checksum required. |
| Shareable operational node facts | canonical `infrastructure` repository | Non-secret, reviewable changes only. |
| Recovery method and reusable templates | this repository | Planning and implementation; no direct live authority. |
| Live host state | the named hypervisor itself | Inspect over SSH and capture dated evidence before inference. |

## Start here

1. Read [the control-plane design](docs/CONTROL_PLANE.md).
2. Read [the source recovery record](docs/SOURCE_RECOVERY.md) before reusing any recovered installer material.
3. Use [the operator SSH runbook](runbooks/OPERATOR_SSH.md) for normal access.
4. Use [the controlled-change runbook](runbooks/CONTROLLED_CHANGE.md) before any live mutation.
5. For a new PVE installation, begin with the [PVE auto-install contract](templates/pve-auto-install/README.md).
6. Begin a new node with the templates in `templates/`, then create a node-specific implementation packet.
7. Before completion, apply the [canonical node documentation contract](docs/CANONICAL_NODE_DOCUMENTATION_CONTRACT.md) and run its validator.
8. For Proxmox host-firewall planning, begin with the bounded [firewall control plane](firewall-cp/README.md). It does not authorize live firewall changes.

Before step 5 or 6, fetch the online checkout and record the exact hv-cp commit used. A clean checkout with a stale cached `origin/main` is not current proof; offline bundle checkouts must name their approved commit and limitation.

## Current hypervisor portfolio

| Host | Control-plane posture | Boundary |
| --- | --- | --- |
| Lore | Independently documented hypervisor with its own private baseline, implementation packets, and recovery record. | Its firewall, identity, storage, and service work remain Lore-specific decisions. |
| Katra | Independently documented hypervisor; recovered installation material informs reusable method only. | It is a PowerSpec G434, not an HP Z4 G4; no Katra fact is inherited by another host. |
| Matrix | Independently documented hypervisor with verified identity, standalone checkout, and post-install Lifetap baseline. | Its 2026-07-27 notification-plane acceptance does not imply cluster, Ceph, guest, or workload enrollment. |

Each host's full Lifetap baseline and management record live in its private node record. Lore and Katra have receipt-confirmed loopback-only Postfix/Fastmail relays and a daily outbound mail canary; see [the reusable standard](docs/FASTMAIL_DAILY_CANARY_STANDARD.md). The recovered first-boot sources are evidence of a prior installation path, not approved production automation.

For a sanitized Matrix-style post-install notification sequence, including fictional `hv-dog` and `hv-cat` examples, see [the notification enrollment example](docs/POSTINSTALL_NOTIFICATION_ENROLLMENT_EXAMPLE.md).

## Why I built it this way

I came to systems work from a background where a process has to survive contact with the real object. A drawing, procedure, or program is useful only if the thing on the floor agrees with it. Computers are less visibly physical, but they punish the same category of mistake.

So this project keeps asking the same question in different forms: **what do I think is true, what is actually true, and what evidence connects the two?**

That is why failed gates stay in the record, why one host does not donate facts to another, and why automation is expected to converge rather than merely execute. The goal is not to make the lab look complicated. The goal is to make it understandable enough that future-me—or somebody else—can recover it without mythology.

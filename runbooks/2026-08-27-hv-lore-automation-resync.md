# Runbook: hv-lore automation re-enrollment

Status: superseded by the accepted migration and restored observer baseline

Governing packet:
[hv-lore automation re-enrollment](../implementation/2026-08-27-hv-lore-automation-resync.packet.md)

## Proven realization

Both accounts use a host-selected numeric UID/GID, a same-named private primary
group, no supplementary groups, `/home/<identity>`, `/bin/bash`, and a locked
password. No `authorized_keys` options precede either key.

```text
ansible-observer:
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGoFPX0qpu/SpHID0Z3oN3Za5PFRyaE7FniOJX5fIFa ansible-observer helix-arpa governed
SHA256:tRDS7wZfXIFWlIYJ4fuuk8RCiWExRLfGe1FbE6qwU/I

ansible-executor:
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBMSWqqiRrIt7A5BReRsmoTADfsXCGBbtRwSDbsMOiu ansible-executor helix-arpa governed
SHA256:EThzAvsy/Q2pqVsfg+qZgVtO1thPudw9boPDO/toxRs

/etc/sudoers.d/90-helix-ansible-executor:
ansible-executor ALL=(ALL) NOPASSWD: ALL
```

Home and `.ssh` are account-owned mode `0700`; `authorized_keys` is
account-owned mode `0600`. The sudoers file is `root:root` mode `0440`.

## Stage 1 — one-time physical-console bootstrap

Paste and run the following once as `root` on the physical `hv-lore` console.
It is idempotent for the proved realization and fails closed on conflicting
pre-existing account attributes or key fingerprints.

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $(id -u) -ne 0 ]]; then
  echo 'ERROR: run as root at the physical hv-lore console' >&2
  exit 1
fi

if [[ $(hostname) != hv-lore ]]; then
  echo 'ERROR: hostname is not hv-lore' >&2
  exit 1
fi

if [[ ! -x /usr/bin/sudo || ! -x /usr/sbin/visudo ]]; then
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends sudo
fi

if [[ ! -x /usr/bin/sudo || ! -x /usr/sbin/visudo ]]; then
  echo 'ERROR: the required sudo package did not provide sudo and visudo' >&2
  exit 1
fi

observer_key='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGoFPX0qpu/SpHID0Z3oN3Za5PFRyaE7FniOJX5fIFa ansible-observer helix-arpa governed'
executor_key='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBBMSWqqiRrIt7A5BReRsmoTADfsXCGBbtRwSDbsMOiu ansible-executor helix-arpa governed'
observer_fingerprint='SHA256:tRDS7wZfXIFWlIYJ4fuuk8RCiWExRLfGe1FbE6qwU/I'
executor_fingerprint='SHA256:EThzAvsy/Q2pqVsfg+qZgVtO1thPudw9boPDO/toxRs'

bootstrap_tmp=$(mktemp -d /tmp/hv-lore-automation-bootstrap.XXXXXX)
cleanup() {
  rm -rf -- "$bootstrap_tmp"
}
trap cleanup EXIT

realize_account() {
  local user=$1
  local key=$2
  local expected_fingerprint=$3
  local entry name passwd uid gid gecos home shell primary groups key_file

  if ! getent passwd "$user" >/dev/null; then
    if getent group "$user" >/dev/null; then
      echo "ERROR: group $user exists without its governed user" >&2
      exit 1
    fi
    useradd --create-home --home-dir "/home/$user" --shell /bin/bash --user-group "$user"
  fi

  entry=$(getent passwd "$user")
  IFS=: read -r name passwd uid gid gecos home shell <<<"$entry"
  primary=$(getent group "$gid" | cut -d: -f1)
  groups=$(id -Gn "$user")

  if [[ $name != "$user" || $home != "/home/$user" || $shell != /bin/bash || $primary != "$user" || $groups != "$user" ]]; then
    echo "ERROR: conflicting realization for $user: $entry; primary=$primary; groups=$groups" >&2
    exit 1
  fi

  passwd -l "$user" >/dev/null
  install -d -o "$user" -g "$user" -m 0700 "/home/$user"
  install -d -o "$user" -g "$user" -m 0700 "/home/$user/.ssh"

  key_file="$bootstrap_tmp/$user.pub"
  printf '%s\n' "$key" >"$key_file"
  if ! ssh-keygen -lf "$key_file" | grep -Fq "$expected_fingerprint"; then
    echo "ERROR: governed key fingerprint mismatch for $user" >&2
    exit 1
  fi
  install -o "$user" -g "$user" -m 0600 "$key_file" "/home/$user/.ssh/authorized_keys"
}

realize_account ansible-observer "$observer_key" "$observer_fingerprint"
realize_account ansible-executor "$executor_key" "$executor_fingerprint"

sudoers_tmp="$bootstrap_tmp/90-helix-ansible-executor"
printf '%s\n' 'ansible-executor ALL=(ALL) NOPASSWD: ALL' >"$sudoers_tmp"
chmod 0440 "$sudoers_tmp"
/usr/sbin/visudo -cf "$sudoers_tmp"
install -o root -g root -m 0440 "$sudoers_tmp" /etc/sudoers.d/90-helix-ansible-executor

getent passwd ansible-observer ansible-executor
id ansible-observer
id ansible-executor
ssh-keygen -lf /home/ansible-observer/.ssh/authorized_keys
ssh-keygen -lf /home/ansible-executor/.ssh/authorized_keys
/usr/sbin/visudo -cf /etc/sudoers.d/90-helix-ansible-executor
```

Stop and retain the complete console output if any command fails. Do not add a
temporary key or modify `sshd_config`.

## Stage 2 — bounded CT149 host-key replacement

Run only after the operator reports that Stage 1 passed. Execute inside CT149
as root. The script scans once, validates the exact physically witnessed set,
then installs that same scan into the existing hashed trust file.

```bash
#!/usr/bin/env bash
set -euo pipefail

trust_dir=/var/lib/semaphore/.ssh
known_hosts=$trust_dir/known_hosts
transition_tmp=$(mktemp -d /tmp/hv-lore-hostkey-transition.XXXXXX)
cleanup() {
  rm -rf -- "$transition_tmp"
}
trap cleanup EXIT

scan=$transition_tmp/scan
work=$transition_tmp/known_hosts
ssh-keyscan -T 5 -t ed25519,ecdsa,rsa 192.168.10.20 >"$scan" 2>"$transition_tmp/scan.stderr"

[[ $(wc -l <"$scan") -eq 3 ]]
ssh-keygen -lf "$scan" | grep -Fq 'SHA256:V2j+4W03TpGYgftKVV55A8u7eL4y9X1Wauf0bMqJYsU'
ssh-keygen -lf "$scan" | grep -Fq 'SHA256:rLaAaHU/n8T0rRPucgdxYUFGdfLQt3+rnxWB7dWdkqQ'
ssh-keygen -lf "$scan" | grep -Fq 'SHA256:5FRYWZocHe3qESCjFFNDlKtwmMsfBv/XeMFE6ikk3+o'

backup=$trust_dir/known_hosts.pre-hv-lore-reinstall-20260827
if [[ ! -e $backup ]]; then
  install -o semaphore -g semaphore -m 0600 "$known_hosts" "$backup"
fi
cp --preserve=mode,ownership,timestamps "$known_hosts" "$work"
ssh-keygen -R 192.168.10.20 -f "$work"
cat "$scan" >>"$work"
ssh-keygen -H -f "$work"
install -o semaphore -g semaphore -m 0600 "$work" "$known_hosts"

ssh-keygen -F 192.168.10.20 -f "$known_hosts"
ssh-keygen -F 192.168.10.20 -f "$known_hosts" | sed '/^#/d' | ssh-keygen -lf -
```

Rollback is `install -o semaphore -g semaphore -m 0600` from the named backup,
but only if abandoning the freshly reinstalled host; restoring stale trust is
not a repair for a new-host connection failure.

## Stage 3 — ansible-cp/Semaphore realization proof

`ansible-cp` owns execution mechanics. Do not run `ansible` or
`ansible-playbook` manually and do not create a temporary template, inventory,
checkout, limit, tag, environment, or connection override.

Compare the live non-secret Semaphore objects to the committed
`ansible-cp/semaphore/declared-state.json` using the read-only contract in
`ansible-cp/scripts/reconcile-semaphore`. At minimum prove this exact chain:

```text
project=Helix-ARPA (2)
repository=ansible-cp (1), main, read credential ansible-cp-semaphore-read (3)
inventory=Canonical Observe Inventory (1), inventory/generated/observe.yml
inventory credential=ansible-observer (4)
template=HELIX — Observe Hypervisors (2)
playbook=playbooks/observe-hypervisors.yml
autorun=false
overrides_allowed=false
schedule=NONE
```

If any object differs, return
`BLOCKER=ANSIBLE_CP_SEMAPHORE_REALIZATION_DRIFT` with the exact mismatch and
smallest authority-defined correction. Manual Ansible is not a fallback.

When the chain matches, an authenticated operator launches only the existing
`HELIX — Observe Hypervisors` template through Semaphore. Do not supply a
limit, alternate inventory, alternate credential, branch, tags, forks,
become, or other override. Retain the task ID and complete task output. The
committed playbook performs only `ansible.builtin.ping` and read-only minimal,
network, and virtualization fact collection with `become: false`.

Do not launch a convergence play. `ansible-cp` currently declares no generic
Lore host-convergence template in Semaphore.

## Stage 4 — drift plan only

After the admitted observation passes, compare current Lore observations with canonical
desired state and classify every item as `BOOTSTRAP_REQUIRED`, `HOST_BASELINE`,
`NETWORK`, `STORAGE`, `VFIO_GPU`, `MONITORING`, `BACKUP`,
`GUEST_RESTORE_PREREQUISITE`, or `STALE_OR_NO_LONGER_APPLICABLE`.

Treat the P3-256 mirrored rpool as intentional, the old NVMe rpool as
intentionally absent/offline rollback, and guest restore as out of scope.
Return the drift plan for review with `CONVERGENCE_RUN=NO`.

# Runbook: hv-lore old-rpool-to-P3 realization

Status: completed historical migration procedure; not current execution authority

Packet: [old-rpool-to-P3 realization packet](../implementation/2026-08-29-hv-lore-old-rpool-to-p3-realization.packet.md)

## Operating rule

The historical Timetec rpool is the authoritative pre-reinstall recovery
source. The P3-256 mirror is the only production destination. Work one named
host/guest object at a time: observe, copy narrowly, export source, realize,
validate, measure capacity, and update documentation.

Do not use Semaphore for active recovery. Use Ansible only for read-only
reconnaissance. Perform mutations directly on `hv-lore` with the ordinary
administrative interface that owns the object.

## Before every bounded source operation

Prove all of the following:

```text
HOST=hv-lore
DESTINATION_RPOOL_GUID=4137356908105663872
DESTINATION_RPOOL_HEALTH=ONLINE
DESTINATION_MEMBERS=ata-P3-256_9760522200232-part3,ata-P3-256_9760511210658-part3
OLD_RPOOL_GUID=8921639095104950851
OLD_RPOOL_IMPORTED=NO
RPOOL_FREE_PERCENT>20
TARGET_OBJECT=<one exact host/guest object>
DESTINATION_STATE=<ABSENT|UNAMBIGUOUS_RESUMABLE|ACCEPTED>
```

If the destination is already accepted, do not copy it again. If it is a
verified partial state, resume rather than reallocating or recopying.

## Read-only source lifecycle

Use only these member paths:

```text
/dev/disk/by-id/nvme-Timetec_PCIe_SSD_TP250913B5D3323-part3
/dev/disk/by-id/nvme-Timetec_PCIe_SSD_TP250913B5D1797-part3
```

Create a root-only temporary altroot, then import the exact pool:

```bash
install -d -o root -g root -m 0700 /mnt/hv-lore-old-rpool-readonly
zpool import -f -N \
  -o readonly=on \
  -o cachefile=none \
  -R /mnt/hv-lore-old-rpool-readonly \
  -d /dev/disk/by-id/nvme-Timetec_PCIe_SSD_TP250913B5D3323-part3 \
  -d /dev/disk/by-id/nvme-Timetec_PCIe_SSD_TP250913B5D1797-part3 \
  8921639095104950851 hv-lore-old-rpool-readonly
```

Immediately prove GUID, `readonly=on`, `cachefile=none`, health, and exact leaf
paths. Mount only the dataset needed for the named object, read-only. The
altroot-adjusted mountpoint is expected and is not source drift.

After the copy/read, unmount only datasets mounted by this operation and:

```bash
zpool export hv-lore-old-rpool-readonly
```

Prove GUID `8921639095104950851` is no longer in `zpool list`. A failed cleanup
is a blocker before guest start or the next object.

## Host operator realization

From the historical root dataset, read only the exact `louis` records in
`passwd`, `group`, `shadow`, and `gshadow`, plus the old SSH daemon drop-ins,
trusted user-CA public anchor, `louis` principals file, and relevant sudo
policy. Do not print password hashes, private keys, token values, or CA signer
material.

Cross-check the recovered state against `auth-cp`/Foundation: login identity
`louis`, entitlement principal `lab-admin`, the canonical Foundation user-CA
public anchor, `TrustedUserCAKeys`, and `AuthorizedPrincipalsFile`. Resolve any
numeric UID/GID collision before mutation; do not silently change either the
recovered operator identity or an admitted automation principal.

The 2026-08-29 authoritative mapping was resolved as `louis=1000:1000`,
`ansible-observer=1002:1002`, and `ansible-executor=1003:1003`. The fresh
post-install automation accounts were realigned to those exact old-Lore IDs,
with account-database rollback at
`/root/hv-lore-automation-id-pre.snKxCH`. Re-prove this mapping before rerunning
the Louis realization block; do not repeat the realignment once it matches.

Realize only the proven account/SSH state, validate with `sshd -t`, reload SSH,
and prove a fresh certified `louis` login from `ws-hadrian` with strict host-key
checking. Then collect the pending read-only PVE control-plane diagnosis.

### Exact root-console operation

Run this once from the physical `hv-lore` root console. It reads the old root,
stages only public SSH material plus the in-memory account record, exports the
old pool, and only then changes the production root. It stops before mutation
on an identity collision or an authority mismatch.

```bash
bash <<'HELIX_LOUIS_REALIZATION'
set -Eeuo pipefail
umask 077

old_pool=hv-lore-old-rpool-readonly
old_guid=8921639095104950851
old_root_dataset=${old_pool}/ROOT/pve-1
altroot=/mnt/hv-lore-old-rpool-readonly
old_dev_1=/dev/disk/by-id/nvme-Timetec_PCIe_SSD_TP250913B5D3323-part3
old_dev_2=/dev/disk/by-id/nvme-Timetec_PCIe_SSD_TP250913B5D1797-part3
expected_ca_fingerprint='SHA256:+6YRBPj2SQRn6+/+EJ+Y6+npFprT56CSK8Q55NCl9wY'
expected_ca_path=/etc/ssh/trusted_user_ca_keys.d/lab-user-ca.pub
expected_principals_path='/etc/ssh/auth_principals/%u'
stage=$(mktemp -d /run/hv-lore-louis-realization.XXXXXX)

source_mounted=0
source_imported=0
cleanup_source() {
  if [[ $source_mounted -eq 1 ]]; then
    zfs unmount "$old_root_dataset" >/dev/null 2>&1 || true
  fi
  if [[ $source_imported -eq 1 ]]; then
    zpool export "$old_pool" >/dev/null 2>&1 || true
  fi
}
cleanup_stage() {
  rm -f -- "$stage/ca.pub" "$stage/principals" "$stage/sshd.conf"
  rmdir -- "$stage" 2>/dev/null || true
}
trap 'cleanup_source; cleanup_stage' EXIT
trap 'rc=$?; printf "BLOCKER=LOUIS_REALIZATION_FAILED LINE=%s RC=%s\n" "$LINENO" "$rc" >&2; exit "$rc"' ERR

[[ $(hostname) == hv-lore ]]
[[ $(id -u) -eq 0 ]]
[[ $(zpool get -H -o value guid rpool) == 4137356908105663872 ]]
zpool status -P rpool | grep -F 'ata-P3-256_9760522200232-part3' >/dev/null
zpool status -P rpool | grep -F 'ata-P3-256_9760511210658-part3' >/dev/null
[[ $(zpool get -H -o value health rpool) == ONLINE ]]
test -b "$old_dev_1"
test -b "$old_dev_2"

install -d -o root -g root -m 0700 "$altroot"
imported_old_name=$(zpool list -H -o name,guid | awk -v guid="$old_guid" \
  '$2 == guid { print $1 }')
if [[ -n "$imported_old_name" ]]; then
  [[ "$imported_old_name" == "$old_pool" ]]
  source_imported=1
else
  zpool import -f -N \
    -o readonly=on \
    -o cachefile=none \
    -R "$altroot" \
    -d "$old_dev_1" \
    -d "$old_dev_2" \
    "$old_guid" "$old_pool"
  source_imported=1
fi

[[ $(zpool get -H -o value guid "$old_pool") == "$old_guid" ]]
[[ $(zpool get -H -o value readonly "$old_pool") == on ]]
[[ $(zpool get -H -o value cachefile "$old_pool") == none ]]
[[ $(zpool get -H -o value health "$old_pool") == ONLINE ]]
zpool status -P "$old_pool" | grep -F "$old_dev_1" >/dev/null
zpool status -P "$old_pool" | grep -F "$old_dev_2" >/dev/null

if [[ $(zfs get -H -o value mounted "$old_root_dataset") == yes ]]; then
  source_mounted=1
else
  zfs mount -o ro "$old_root_dataset"
  source_mounted=1
fi
old_root=$(zfs get -H -o value mountpoint "$old_root_dataset")
[[ "$old_root" == "$altroot" ]]

old_passwd=$(awk -F: '$1 == "louis" { print; found++ }
  END { if (found != 1) exit 40 }' "$old_root/etc/passwd")
old_shadow=$(awk -F: '$1 == "louis" { print; found++ }
  END { if (found != 1) exit 41 }' "$old_root/etc/shadow")
IFS=: read -r old_name _ old_uid old_gid old_gecos old_home old_shell \
  <<< "$old_passwd"
IFS=: read -r _ old_password _ <<< "$old_shadow"
[[ "$old_name" == louis ]]
[[ "$old_home" == /home/louis ]]
[[ "$old_shell" == /bin/bash ]]
test -d "$old_root$old_home"
old_home_uid=$(stat -c %u "$old_root$old_home")
old_home_gid=$(stat -c %g "$old_root$old_home")
old_home_mode=$(stat -c %a "$old_root$old_home")
[[ "$old_home_uid" == "$old_uid" ]]
[[ "$old_home_gid" == "$old_gid" ]]

old_primary_group=$(awk -F: -v gid="$old_gid" '$3 == gid { print $1; found++ }
  END { if (found != 1) exit 42 }' "$old_root/etc/group")
mapfile -t old_supplemental_group_records < <(
  awk -F: '$4 ~ /(^|,)louis(,|$)/ { print $1 ":" $3 }' \
    "$old_root/etc/group" | sort -u
)
old_supplemental_groups=()
for group_record in "${old_supplemental_group_records[@]}"; do
  old_supplemental_groups+=("${group_record%%:*}")
done

uid_owner=$(getent passwd "$old_uid" | cut -d: -f1 || true)
if [[ -n "$uid_owner" && "$uid_owner" != louis ]]; then
  echo "BLOCKER=LOUIS_UID_COLLISION UID=$old_uid OWNER=$uid_owner" >&2
  exit 43
fi
gid_owner=$(getent group "$old_gid" | cut -d: -f1 || true)
if [[ -n "$gid_owner" && "$gid_owner" != "$old_primary_group" ]]; then
  echo "BLOCKER=LOUIS_PRIMARY_GID_COLLISION GID=$old_gid OWNER=$gid_owner" >&2
  exit 44
fi
if getent group "$old_primary_group" >/dev/null; then
  [[ $(getent group "$old_primary_group" | cut -d: -f3) == "$old_gid" ]]
fi

mapfile -t ca_config_files < <(
  grep -RIlE '^[[:space:]]*TrustedUserCAKeys[[:space:]]+' \
    "$old_root/etc/ssh/sshd_config" "$old_root/etc/ssh/sshd_config.d" 2>/dev/null || true
)
mapfile -t principals_config_files < <(
  grep -RIlE '^[[:space:]]*AuthorizedPrincipalsFile[[:space:]]+' \
    "$old_root/etc/ssh/sshd_config" "$old_root/etc/ssh/sshd_config.d" 2>/dev/null || true
)
[[ ${#ca_config_files[@]} -eq 1 ]]
[[ ${#principals_config_files[@]} -eq 1 ]]
[[ ${ca_config_files[0]} == "${principals_config_files[0]}" ]]
old_sshd_file=${ca_config_files[0]}
sshd_relpath=${old_sshd_file#"$old_root"}
[[ "$sshd_relpath" == /etc/ssh/sshd_config.d/*.conf ]]

recovered_ca_path=$(awk 'tolower($1) == "trustedusercakeys" { print $2 }' \
  "$old_sshd_file")
recovered_principals_path=$(awk \
  'tolower($1) == "authorizedprincipalsfile" { print $2 }' "$old_sshd_file")
[[ "$recovered_ca_path" == "$expected_ca_path" ]]
[[ "$recovered_principals_path" == "$expected_principals_path" ]]

mapfile -t active_sshd_lines < <(
  sed 's/[[:space:]]*#.*$//' "$old_sshd_file" | awk 'NF { print }'
)
[[ ${#active_sshd_lines[@]} -eq 6 ]]
expected_sshd_lines=(
  "TrustedUserCAKeys $expected_ca_path"
  "AuthorizedPrincipalsFile $expected_principals_path"
  'PubkeyAuthentication yes'
  'PermitRootLogin no'
  'PasswordAuthentication no'
  'KbdInteractiveAuthentication no'
)
for expected_sshd_line in "${expected_sshd_lines[@]}"; do
  printf '%s\n' "${active_sshd_lines[@]}" |
    grep -Fx "$expected_sshd_line" >/dev/null
done

old_principals=${recovered_principals_path//%u/louis}
mapfile -t recovered_principals < <(
  sed 's/[[:space:]]*#.*$//' "$old_root$old_principals" | awk 'NF { print $1 }'
)
[[ ${#recovered_principals[@]} -eq 1 ]]
[[ ${recovered_principals[0]} == lab-admin ]]

recovered_ca_fingerprint=$(ssh-keygen -lf "$old_root$recovered_ca_path" \
  -E sha256 | awk '{ print $2 }')
[[ "$recovered_ca_fingerprint" == "$expected_ca_fingerprint" ]]

install -m 0600 "$old_root$recovered_ca_path" "$stage/ca.pub"
install -m 0600 "$old_root$old_principals" "$stage/principals"
install -m 0600 "$old_sshd_file" "$stage/sshd.conf"

zfs unmount "$old_root_dataset"
source_mounted=0
zpool export "$old_pool"
source_imported=0
! zpool list -H -o guid | grep -Fx "$old_guid" >/dev/null

backup_dir=$(mktemp -d /root/hv-lore-operator-ssh-pre.XXXXXX)
for destination in /etc/passwd /etc/group /etc/shadow /etc/gshadow \
  "$expected_ca_path" /etc/ssh/auth_principals/louis "$sshd_relpath"; do
  if [[ -e "$destination" ]]; then
    install -d -m 0700 "$backup_dir$(dirname "$destination")"
    cp -a -- "$destination" "$backup_dir$destination"
  fi
done

if ! getent group "$old_primary_group" >/dev/null; then
  groupadd --gid "$old_gid" "$old_primary_group"
fi
for group_record in "${old_supplemental_group_records[@]}"; do
  group_name=${group_record%%:*}
  group_gid=${group_record#*:}
  if ! getent group "$group_name" >/dev/null; then
    [[ -n "$group_gid" ]]
    ! getent group "$group_gid" >/dev/null
    groupadd --gid "$group_gid" "$group_name"
  fi
done

if ! getent passwd louis >/dev/null; then
  useradd --no-create-home --uid "$old_uid" --gid "$old_primary_group" \
    --home-dir "$old_home" --shell "$old_shell" --comment "$old_gecos" louis
else
  current_passwd=$(getent passwd louis)
  IFS=: read -r _ _ current_uid current_gid _ current_home current_shell \
    <<< "$current_passwd"
  [[ "$current_uid" == "$old_uid" ]]
  [[ "$current_gid" == "$old_gid" ]]
  [[ "$current_home" == "$old_home" ]]
  [[ "$current_shell" == "$old_shell" ]]
fi

if [[ ${#old_supplemental_groups[@]} -gt 0 ]]; then
  supplemental_csv=$(IFS=,; echo "${old_supplemental_groups[*]}")
  usermod --groups "$supplemental_csv" louis
fi
printf '%s:%s\n' louis "$old_password" | chpasswd --encrypted
[[ $(getent shadow louis | cut -d: -f2) == "$old_password" ]]
install -d -o "$old_uid" -g "$old_gid" -m "$old_home_mode" "$old_home"

install -d -o root -g root -m 0755 "$(dirname "$expected_ca_path")"
install -d -o root -g root -m 0755 /etc/ssh/auth_principals
install -d -o root -g root -m 0755 /etc/ssh/sshd_config.d
install -o root -g root -m 0644 "$stage/ca.pub" "$expected_ca_path"
install -o root -g root -m 0644 "$stage/principals" \
  /etc/ssh/auth_principals/louis
install -o root -g root -m 0644 "$stage/sshd.conf" "$sshd_relpath"

/usr/sbin/sshd -t
systemctl reload ssh
/usr/sbin/sshd -T | grep -Fx \
  'trustedusercakeys /etc/ssh/trusted_user_ca_keys.d/lab-user-ca.pub'
/usr/sbin/sshd -T | grep -Fx \
  'authorizedprincipalsfile /etc/ssh/auth_principals/%u'
[[ $(ssh-keygen -lf "$expected_ca_path" -E sha256 | awk '{ print $2 }') \
  == "$expected_ca_fingerprint" ]]
[[ $(awk 'NF && $1 !~ /^#/ { print $1 }' /etc/ssh/auth_principals/louis) \
  == lab-admin ]]

echo 'LOUIS_REALIZATION_AUTHORITY=OLD_RPOOL_PLUS_AUTH_CP_FOUNDATION'
echo 'LOUIS_ACCOUNT_CREATED=YES_OR_ALREADY_EXACT'
echo 'SSH_CA_TRUST_RESTORED=YES'
echo 'LAB_ADMIN_PRINCIPAL_RESTORED=YES'
echo 'SSHD_VALIDATION=PASS'
echo 'SSH_RELOAD=PASS'
echo 'OLD_RPOOL_IMPORTED=NO'
echo "ROLLBACK_BACKUP=$backup_dir"
HELIX_LOUIS_REALIZATION
```

The source pool is already exported before any account or SSH mutation. If a
later destination step fails, do not re-import it merely to debug the target;
repair or roll back only the named target file/account change.

From `ws-hadrian`, issue a fresh certificate and validate strict host-key
login:

```bash
reauth
ssh -o StrictHostKeyChecking=yes louis@192.168.10.20
```

After login, run only the pending read-only PVE diagnosis:

```bash
hostname
systemctl is-active pve-cluster
systemctl is-active pvedaemon
systemctl is-active pveproxy
systemctl --no-pager --full status pve-cluster
mountpoint /etc/pve
findmnt /etc/pve || true
ls -ld /etc/pve
ls -la /etc/pve | head -30
pvesh get /version || true
pct status 252 || true
journalctl -u pve-cluster -n 100 --no-pager
systemctl is-active corosync
pvecm status || true
```

## Guest copy and realization

For a QEMU guest, recover only its authoritative config and named source zvols.
Allocate exact destination volumes through PVE on `local-zfs`, copy each source
zvol to its owned destination, and prove equality before exporting the source.
Filter generated/runtime PVE metadata and apply authoritative options through
`qm`.

For a container, recover its config, rootfs, and every authoritative host bind
or PVE-managed mount separately. Create destinations through PVE/ZFS authority,
copy filesystem content preserving numeric ownership, xattrs, ACLs, hard links,
and sparse files, and prove the copied trees agree before export. Satisfy host
bind prerequisites before `pct start`.

For either type, start only after config and storage acceptance. Validate the
guest's hostname/addressing and meaningful service, not merely `running`.

## Order and accepted-state ledger

Do not revisit accepted VM120, VM260, or CT252. Proceed with ordinary
containers `243,245,246,247,248,249`, ordinary VMs
`100,141,142,149,150`, then bounded exceptional work for VM130, VM140, and
VM242.

After each accepted object append a dated result to
`evidence/2026-08-29-hv-lore-recovery-state.md` and update the private canonical
Lore record plus any owning peer control plane. Record source/destination,
verification, service result, capacity, old-pool export state, and next object.

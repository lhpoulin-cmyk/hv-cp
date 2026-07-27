#!/bin/bash
# Offline template test. It creates only a temporary rendered fixture.
set -euo pipefail

TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly TEMPLATE_DIR
readonly ANSWER_TEMPLATE="${TEMPLATE_DIR}/answer.toml.template"
readonly MANIFEST_TEMPLATE="${TEMPLATE_DIR}/node-manifest.toml.template"
readonly ASSISTANT="${PROXMOX_AUTO_INSTALL_ASSISTANT:-/home/louis/bin/proxmox-auto-install-assistant}"

tmp="$(mktemp -d /tmp/hv-cp-pve-template-test.XXXXXX)"
trap 'rm -rf "${tmp}"' EXIT
umask 077

for required in "${ANSWER_TEMPLATE}" "${MANIFEST_TEMPLATE}"; do
    test -f "${required}"
done

if grep -Eq 'hv-matrix|192\.168\.10\.|P210HHBB|P220HHBB' \
    "${ANSWER_TEMPLATE}" "${MANIFEST_TEMPLATE}"; then
    printf '%s\n' 'sanitized templates contain a Matrix-specific identity' >&2
    exit 1
fi

if command -v python3 >/dev/null 2>&1; then
    python3 -c 'import pathlib, sys, tomllib; tomllib.loads(pathlib.Path(sys.argv[1]).read_text())' \
        "${MANIFEST_TEMPLATE}"
fi

rendered="${tmp}/answer.toml"
fixture_hash="$(printf '%s' 'fixture-root-password' | openssl passwd -6 -stdin)"
sed \
    -e 's|REQUIRED_NODE_FQDN|hv-fixture.example.test|' \
    -e 's|REQUIRED_OPERATOR_MAILTO|operator@example.test|' \
    -e "s|REQUIRED_ROOT_PASSWORD_HASH|${fixture_hash}|" \
    -e 's|REQUIRED_ROOT_SSH_PUBLIC_KEY|ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFixtureOnlyKey000000000000000 fixture@example.test|' \
    -e 's|REQUIRED_MANAGEMENT_CIDR|192.0.2.22/24|' \
    -e 's|REQUIRED_BOOTSTRAP_DNS_SERVER|192.0.2.1|' \
    -e 's|REQUIRED_MANAGEMENT_GATEWAY|192.0.2.1|' \
    -e 's|REQUIRED_MANAGEMENT_INTERFACE|eno1|' \
    -e 's|REQUIRED_BOOT_DISK_0|sda|' \
    -e 's|REQUIRED_BOOT_DISK_1|sdb|' \
    "${ANSWER_TEMPLATE}" >"${rendered}"
unset fixture_hash

if grep -Eq 'REQUIRED_[A-Z0-9_]+' "${rendered}"; then
    printf '%s\n' 'rendered answer retained a required placeholder' >&2
    exit 1
fi

if grep -Eq '^\[first-boot\]$' "${rendered}"; then
    printf '%s\n' 'base answer unexpectedly enables first-boot automation' >&2
    exit 1
fi

grep -Fqx 'disk-list = ["sda", "sdb"]' "${rendered}"
grep -Fqx 'reboot-on-error = false' "${rendered}"
grep -Fqx 'reboot-mode = "power-off"' "${rendered}"
grep -Fqx 'dns = "192.0.2.1"' "${rendered}"
grep -Fqx 'bootstrap_dns_server = "REQUIRED_BOOTSTRAP_DNS_SERVER"' "${MANIFEST_TEMPLATE}"
grep -Fqx 'primary_resolver = "REQUIRED_INTERNAL_DNS_PRIMARY"' "${MANIFEST_TEMPLATE}"
grep -Fqx 'publication_mode = "guarded selected-record deployment"' "${MANIFEST_TEMPLATE}"
grep -Fqx 'notification_enrollment_automatic = false' "${MANIFEST_TEMPLATE}"
grep -Fqx 'outbound_notification_test_automatic = false' "${MANIFEST_TEMPLATE}"
grep -Fqx 'host_disk_write = "not authorized"' "${MANIFEST_TEMPLATE}"

if [ -x "${ASSISTANT}" ]; then
    "${ASSISTANT}" validate-answer "${rendered}" >/dev/null
else
    printf '%s\n' "SKIP: Proxmox auto-install assistant unavailable at ${ASSISTANT}" >&2
fi

printf '%s\n' 'PASS: PVE auto-install template fixture'

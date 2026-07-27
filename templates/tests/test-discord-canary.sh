#!/usr/bin/env bash
set -euo pipefail

template="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/hv-cp-discord-canary"
tmp="$(mktemp /tmp/hv-cp-discord-canary-test.XXXXXX)"
trap 'rm -f "${tmp}"' EXIT

# Deliberately assert the template source expression, not its runtime value.
# shellcheck disable=SC2016
expected_title='title="${host} Discord canary"'
grep -Fqx "${expected_title}" "${template}"
if grep -Fq 'title="hv-cp Discord canary"' "${template}"; then
  printf '%s\n' 'Discord canary title is project-generic' >&2
  exit 1
fi

sed 's/__HV_CP_NODE_ID__/helix-node-fixture-00000000/' "${template}" > "${tmp}"
grep -Fq 'helix-node-fixture-00000000' "${tmp}"
if grep -Fq '__HV_CP_NODE_ID__' "${tmp}"; then
  printf '%s\n' 'rendered Discord wrapper retained its placeholder' >&2
  exit 1
fi

bash -n "${tmp}"
if command -v shellcheck >/dev/null 2>&1; then
  shellcheck "${tmp}"
fi

printf '%s\n' 'PASS: Discord canary uses node nomenclature'

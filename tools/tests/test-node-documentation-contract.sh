#!/usr/bin/env bash
# shellcheck disable=SC2016
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
validator="${repo_root}/tools/validate-node-documentation-contract.sh"
fixture_root="$(mktemp -d /tmp/hv-cp-node-doc-test.XXXXXX)"
trap 'rm -rf "${fixture_root}"' EXIT

node="hv-fixture"
node_root="${fixture_root}/${node}"
mkdir -p "${node_root}/command-log" "${node_root}/outputs"

printf '%s\n' '# hv-fixture' 'Status: fixture.' >"${node_root}/README.md"
printf '%s\n' '# Current State: hv-fixture' '' 'Observed: 2026-07-27' \
  >"${node_root}/CURRENT_STATE.md"
printf '%s\n' '# Validation: hv-fixture' '' '## Recovery Confidence' '' \
  'Current recovery confidence: Unverified' >"${node_root}/VALIDATION.md"
printf '%s\n' '# TODO: hv-fixture' >"${node_root}/TODO.md"

printf '%s\n' \
  '# Command Log Evidence' \
  '' \
  'Classification: evidence.' \
  '' \
  'These records do not authorize repeating a command.' \
  >"${node_root}/command-log/README.md"

printf '%s\n' \
  '# Generated Output Evidence' \
  '' \
  'Classification: generated evidence.' \
  >"${node_root}/outputs/README.md"

printf '%s\n' \
  '# Notification identity: hv-fixture' \
  '' \
  '## Stable control-plane identifier' \
  '' \
  '| Field | Value |' \
  '| --- | --- |' \
  '| Immutable notification `node_id` | `helix-node-00000000-0000-4000-8000-000000000000` |' \
  '| Current display/host name | `hv-fixture` |' \
  '| Assigned | 2026-07-27 |' \
  '' \
  '## Observed binding evidence' \
  '' \
  'Fixture evidence.' \
  '' \
  '## Notification boundary' \
  >"${node_root}/NOTIFICATION_IDENTITY.md"

printf '%s\n' \
  '# hv-fixture ntfy heartbeat mode' \
  '' \
  'Normal cadence is five minutes.' \
  'Use `sudo ntfy-heartbeat-mode {status|fast|slow}`.' \
  'Fast mode is five seconds and automatically returns to slow after 15 minutes.' \
  '' \
  'Validated 2026-07-27: fixture success; not a health guarantee or subscriber receipt.' \
  >"${node_root}/NTFY_HEARTBEAT_MODE.md"

"${validator}" --profile heartbeat "${fixture_root}" "${node}" >/dev/null

rm "${node_root}/NTFY_HEARTBEAT_MODE.md"
if "${validator}" --profile heartbeat "${fixture_root}" "${node}" \
  >/dev/null 2>&1; then
  printf '%s\n' 'validator accepted a missing heartbeat-mode record' >&2
  exit 1
fi

printf '%s\n' 'PASS: canonical node documentation validator'

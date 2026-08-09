#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'usage: %s [--profile base|notification|heartbeat] RECORDS_ROOT NODE [NODE ...]\n' \
    "${0##*/}" >&2
}

profile="base"
if [[ "${1:-}" == "--profile" ]]; then
  if (( $# < 3 )); then
    usage
    exit 2
  fi
  profile="$2"
  shift 2
fi

case "${profile}" in
  base|notification|heartbeat) ;;
  *)
    usage
    exit 2
    ;;
esac

if (( $# < 2 )); then
  usage
  exit 2
fi

records_root="$1"
shift

if [[ -d "${records_root}/nodes" ]]; then
  node_parent="${records_root}/nodes"
elif [[ -d "${records_root}" ]]; then
  node_parent="${records_root}"
else
  printf 'FAIL node-record root not found: %s\n' "${records_root}" >&2
  exit 2
fi

status=0

fail() {
  printf 'FAIL %s\n' "$*" >&2
  status=1
}

require_file() {
  local path="$1"
  if [[ ! -s "${path}" ]]; then
    fail "missing or empty file: ${path}"
  fi
}

require_pattern() {
  local path="$1"
  local pattern="$2"
  local description="$3"
  if [[ -s "${path}" ]] && ! grep -Eq "${pattern}" "${path}"; then
    fail "${description}: ${path}"
  fi
}

reject_pattern() {
  local path="$1"
  local pattern="$2"
  local description="$3"
  if [[ -s "${path}" ]] && grep -Eqi "${pattern}" "${path}"; then
    fail "${description}: ${path}"
  fi
}

require_literal() {
  local path="$1"
  local literal="$2"
  local description="$3"
  if [[ -s "${path}" ]] && ! grep -Fq "${literal}" "${path}"; then
    fail "${description}: ${path}"
  fi
}

declare -A seen_node_ids=()

for node in "$@"; do
  node_root="${node_parent}/${node}"
  printf 'CHECK %s\n' "${node}"

  if [[ ! -d "${node_root}" ]]; then
    fail "node directory not found: ${node_root}"
    continue
  fi

  for relative in \
    README.md \
    CURRENT_STATE.md \
    VALIDATION.md \
    TODO.md \
    command-log/README.md \
    outputs/README.md
  do
    require_file "${node_root}/${relative}"
  done

  if [[ "${profile}" == "notification" || "${profile}" == "heartbeat" ]]; then
    require_file "${node_root}/NOTIFICATION_IDENTITY.md"
  fi
  if [[ "${profile}" == "heartbeat" ]]; then
    require_file "${node_root}/NTFY_HEARTBEAT_MODE.md"
  fi

  require_pattern "${node_root}/CURRENT_STATE.md" \
    '^(Last updated|Observed|Verified): [0-9]{4}-[0-9]{2}-[0-9]{2}' \
    'missing current-state verification date'
  require_pattern "${node_root}/VALIDATION.md" \
    '^## Recovery Confidence$' \
    'missing recovery-confidence section'
  require_pattern "${node_root}/VALIDATION.md" \
    '^Current recovery confidence: (Unverified|Low|Medium|High)$' \
    'missing explicit recovery-confidence value'
  require_pattern "${node_root}/README.md" '^Status: .+' \
    'missing concise node status'
  if [[ "${profile}" == "notification" || "${profile}" == "heartbeat" ]]; then
    identity="${node_root}/NOTIFICATION_IDENTITY.md"
    require_pattern "${identity}" "^# Notification identity: ${node}$" \
      'wrong notification identity heading'
    require_pattern "${identity}" '^## Stable control-plane identifier$' \
      'missing stable-identifier section'
    require_pattern "${identity}" \
      'helix-node-[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' \
      'missing valid immutable node_id'
    require_pattern "${identity}" '^\| Current display/host name \|' \
      'missing current display/host field'
    require_pattern "${identity}" '^\| Assigned \| [0-9]{4}-[0-9]{2}-[0-9]{2} \|$' \
      'missing notification identity assignment date'
    require_pattern "${identity}" '^## Observed binding evidence$' \
      'missing observed-binding section'
    require_pattern "${identity}" '^## Notification boundary$' \
      'missing notification-boundary section'
    reject_pattern "${identity}" \
      'SMTP|Postfix|Discord|server receipt|operator confirmed|enrollment completed' \
      'notification identity record contains operational acceptance history'

    node_id="$(grep -Eo \
      'helix-node-[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' \
      "${identity}" | head -n 1 || true)"
    if [[ -n "${node_id}" ]]; then
      if [[ -n "${seen_node_ids[${node_id}]:-}" ]]; then
        fail "node_id ${node_id} reused by ${seen_node_ids[${node_id}]} and ${node}"
      else
        seen_node_ids["${node_id}"]="${node}"
      fi
    fi
  fi

  if [[ "${profile}" == "heartbeat" ]]; then
    heartbeat="${node_root}/NTFY_HEARTBEAT_MODE.md"
    require_pattern "${heartbeat}" "^# ${node} ntfy heartbeat mode$" \
      'wrong heartbeat-mode heading'
    require_pattern "${heartbeat}" 'Normal cadence is five minutes\.' \
      'missing normal heartbeat cadence'
    require_pattern "${heartbeat}" \
      'ntfy-heartbeat-mode \{status\|fast\|slow\}' \
      'missing heartbeat mode command'
    require_pattern "${heartbeat}" \
      'Fast mode is five seconds and automatically returns to slow after 15 minutes\.' \
      'missing bounded fast-mode contract'
    require_pattern "${heartbeat}" '^Validated [0-9]{4}-[0-9]{2}-[0-9]{2}:' \
      'missing dated heartbeat validation'
    require_pattern "${heartbeat}" \
      'health guarantee or subscriber receipt\.' \
      'missing heartbeat evidence limitation'
  fi

  require_pattern "${node_root}/command-log/README.md" \
    '^Classification: evidence\.$' \
    'missing command-log evidence classification'
  require_pattern "${node_root}/command-log/README.md" \
    'do not authorize repeating a command\.' \
    'missing command-log authority warning'
  require_pattern "${node_root}/outputs/README.md" \
    '^Classification: generated evidence\.$' \
    'missing output evidence classification'
done

if (( status != 0 )); then
  exit "${status}"
fi

printf 'PASS canonical node documentation contract (%s): %s\n' "${profile}" "$*"

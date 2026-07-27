#!/usr/bin/env bash
set -euo pipefail

template="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/ntfy-heartbeat-mode"
timer_template="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/ntfy-hypervisor-canary-heartbeat.timer"

grep -Fq "OnActiveSec=\\nOnActiveSec=5s\\nOnUnitActiveSec=%s" "$template"
grep -Fxq 'OnActiveSec=5s' "$timer_template"
grep -Fxq 'OnUnitActiveSec=5s' "$timer_template"

if grep -Fq "OnUnitActiveSec=\\nOnUnitActiveSec=%s" "$template"; then
  printf '%s\n' 'heartbeat mode still clears the boot seed without restoring it' >&2
  exit 1
fi

printf '%s\n' 'PASS: heartbeat cadence preserves an activation-relative seed'

#!/usr/bin/env bash
# Verify that execution-ready live-mutation packets link to an existing runbook.
# This audit checks documentation boundaries only; it grants no execution authority.
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
status=0
count=0

while IFS= read -r -d '' packet; do
  if ! grep -Eqi '^Status:[[:space:]]*(execution-ready|approved for execution)([[:space:]]|;|$)' "$packet"; then
    continue
  fi

  count=$((count + 1))
  relative_packet=${packet#"$repo_root"/}
  runbook_ref=$(sed -n 's|.*](\([^)]*runbooks/[^)]*\)).*|\1|p' "$packet" | head -n 1)

  if [[ -z "$runbook_ref" ]]; then
    printf 'FAIL %s: execution-ready packet has no linked runbook\n' "$relative_packet" >&2
    status=1
    continue
  fi

  target=$(realpath -m "$(dirname "$packet")/$runbook_ref")
  if [[ "$target" != "$repo_root"/* || ! -f "$target" ]]; then
    printf 'FAIL %s: linked runbook is missing or outside this repository: %s\n' \
      "$relative_packet" "$runbook_ref" >&2
    status=1
    continue
  fi

  printf 'PASS %s -> %s\n' "$relative_packet" "${target#"$repo_root"/}"
done < <(find "$repo_root" -type f -name '*.packet.md' -print0)

if [[ "$count" -eq 0 ]]; then
  printf 'PASS no execution-ready packets found; planning drafts are out of scope.\n'
fi

exit "$status"

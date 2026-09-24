#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
audit="${repo_root}/tools/audit-live-mutation-runbooks.sh"
fixture="$(mktemp -d /tmp/hv-cp-runbook-test.XXXXXX)"
outside="$(mktemp -d /tmp/hv-cp-runbook-outside.XXXXXX)"
trap 'rm -rf "$fixture" "$outside"' EXIT
git init -q "$fixture"
mkdir -p "$fixture/implementation" "$fixture/runbooks"
printf 'Fixture runbook\n' > "$fixture/runbooks/action.md"
cd "$fixture"

for status in 'Status: execution-ready' '**Status:** execution-ready after preflight' 'Status: approved for execution; pending'; do
  printf '%s\n' "$status" '[Runbook](../runbooks/action.md)' > implementation/action.packet.md
  bash "$audit" > result.txt
  grep -Fq 'PASS implementation/action.packet.md' result.txt
done

expect_failure() {
  if bash "$audit" > result.txt 2>&1; then
    printf 'FAIL: audit accepted %s\n' "$1" >&2
    exit 1
  fi
  grep -Fq 'FAIL implementation/action.packet.md' result.txt
}

printf '%s\n' '**Status:** execution-ready' > implementation/action.packet.md
expect_failure 'bold status without a linked runbook'
printf '%s\n' 'Status: execution-ready' '[Runbook](../runbooks/missing.md)' > implementation/action.packet.md
expect_failure 'missing runbook'
mkdir -p "$outside/runbooks"
printf 'Outside fixture\n' > "$outside/runbooks/action.md"
# An escape must fail even when its target exists.
printf '%s\n' 'Status: execution-ready' "[Runbook]($outside/runbooks/action.md)" > implementation/action.packet.md
expect_failure 'out-of-repository path'

printf '%s\n' 'Status: historical; not execution-ready' > implementation/action.packet.md
mkdir -p .agent-checkouts/codex/task
printf '%s\n' 'Status: execution-ready' > .agent-checkouts/codex/task/private.packet.md
bash "$audit" > result.txt
grep -Fq 'PASS no execution-ready packets found' result.txt
printf 'PASS: live-mutation runbook audit\n'

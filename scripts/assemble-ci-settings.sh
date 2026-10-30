#!/usr/bin/env bash
# Merges the calling repo's CI settings with the hook that blocks deferred work,
# and points CLAUDE_CI_SETTINGS at the result for claude-code-action's `settings`.
#
# Optional env vars:
#   REPO_SETTINGS — repo settings file to merge (default .claude/settings.ci.json)
#
# Usage (in a workflow step):
#   run: .ci-prompts/scripts/assemble-ci-settings.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOOK="${SCRIPT_DIR}/hooks/no-background-work.sh"
REPO_SETTINGS="${REPO_SETTINGS:-.claude/settings.ci.json}"
OUT="${RUNNER_TEMP:-/tmp}/claude-ci-settings.json"

if [ ! -f "$HOOK" ]; then
  echo "::error::hook not found at ${HOOK}"
  exit 1
fi
chmod +x "$HOOK"

if ! command -v jq >/dev/null 2>&1; then
  echo "::error::jq is required to assemble CI settings"
  exit 1
fi

base='{}'
if [ -f "$REPO_SETTINGS" ]; then
  base="$(cat "$REPO_SETTINGS")"
else
  echo "::notice::${REPO_SETTINGS} not found; CI settings carry the hook only"
fi

printf '%s' "$base" | jq --arg hook "$HOOK" '
  .hooks.PreToolUse = ((.hooks.PreToolUse // []) + [{
    matcher: "Bash|Monitor",
    hooks: [{type: "command", command: $hook}]
  }])
' > "$OUT"

echo "CLAUDE_CI_SETTINGS=${OUT}" >> "$GITHUB_ENV"
echo "Assembled CI settings at ${OUT}"

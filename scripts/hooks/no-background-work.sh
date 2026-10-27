#!/usr/bin/env bash
# PreToolUse hook: denies tool calls whose result arrives after the run is over.
# A CI job ends when the model stops, so a background task reports to nobody.
set -uo pipefail

input="$(cat)"
reason="This job ends when you stop, so nothing would report the result back. Run it in the foreground, or finish with what you have and say what you could not verify."

deny() {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}' "$1"
  exit 0
}

if command -v jq >/dev/null 2>&1; then
  tool="$(printf '%s' "$input" | jq -r '.tool_name // ""')"
  background="$(printf '%s' "$input" | jq -r '.tool_input.run_in_background // false')"
else
  tool="$(printf '%s' "$input" | sed -n 's/.*"tool_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
  background=false
  printf '%s' "$input" | grep -q '"run_in_background"[[:space:]]*:[[:space:]]*true' && background=true
fi

case "$tool" in
  Monitor) deny "Monitor is unavailable in CI. $reason" ;;
esac

if [ "$background" = "true" ]; then
  deny "Background commands are blocked in CI. $reason"
fi

exit 0

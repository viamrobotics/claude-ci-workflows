#!/usr/bin/env bash
# Fetches CI failure logs from a GitHub Actions workflow run.
# Writes the logs to $GITHUB_OUTPUT as "content".
#
# Required env vars:
#   GH_TOKEN      — GitHub token with actions:read
#   GH_REPO       — owner/repo
#   GITHUB_OUTPUT — GitHub Actions output file (set automatically)
#
# Optional env vars (provide one):
#   RUN_ID    — fetch logs from this specific run
#   PR_BRANCH — discover the latest failed run for this branch
#
# Usage (in a workflow step):
#   env:
#     GH_TOKEN: ${{ github.token }}
#     GH_REPO: ${{ github.repository }}
#     RUN_ID: ${{ inputs.run_id }}
#   run: .ci-prompts/scripts/fetch-failure-logs.sh

set -euo pipefail

RESOLVED_RUN_ID="${RUN_ID:-}"

# If no run ID provided, discover the latest failed run for the branch
if [ -z "$RESOLVED_RUN_ID" ] && [ -n "${PR_BRANCH:-}" ]; then
  RESOLVED_RUN_ID=$(gh run list \
    --branch "$PR_BRANCH" \
    --repo "$GH_REPO" \
    --status failure \
    --limit 1 \
    --json databaseId \
    --jq '.[0].databaseId // empty' 2>/dev/null || true)
fi

if [ -z "$RESOLVED_RUN_ID" ]; then
  {
    echo "content<<__CLAUDE_LOGS_EOF_7f3a__"
    echo "No recent CI failures found."
    echo "__CLAUDE_LOGS_EOF_7f3a__"
  } >> "$GITHUB_OUTPUT"
  exit 0
fi

# Try failed-only logs first, fall back to full logs
LOGS=$(gh run view "$RESOLVED_RUN_ID" \
  --repo "$GH_REPO" \
  --log-failed 2>&1 | tail -500)

if [ -z "$LOGS" ]; then
  LOGS=$(gh run view "$RESOLVED_RUN_ID" \
    --repo "$GH_REPO" \
    --log 2>&1 | tail -500)
fi

# Sanitize GitHub Actions log markers that could interfere with workflow commands
LOGS="${LOGS//##\[/\[}"

{
  echo "content<<__CLAUDE_LOGS_EOF_7f3a__"
  echo "$LOGS"
  echo "__CLAUDE_LOGS_EOF_7f3a__"
} >> "$GITHUB_OUTPUT"

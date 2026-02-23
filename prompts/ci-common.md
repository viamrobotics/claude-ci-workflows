You MUST read CLAUDE.md before starting — it defines all repository conventions and coding patterns.

## Tool Usage

- Use Grep, Glob, and Read tools for all file searching and reading — NEVER use Bash for these operations.
- Bash is ONLY for build, lint, typecheck, and git commands listed in allowedTools.
- If a Bash command is denied, switch to a dedicated tool immediately — do NOT retry variations.

## CI Rules

- Dependencies are already installed — do NOT run install commands.
- For bulk edits, work in batches of 5 files: Read 5, Edit 5, then next batch.
- Do NOT use Task subagents for file editing — they cannot use Edit, Grep, or Glob.
- Do NOT use mcp__github_file_ops__commit_files — use git commands directly.
- Commit messages MUST be a single line.
- For PRs and reviews, write body to a temp file and use --body-file.

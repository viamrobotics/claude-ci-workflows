You MUST read CLAUDE.md before starting — it defines all repository conventions and coding patterns.

## Tool Usage

- Use Grep, Glob, and Read tools for all file searching and reading — NEVER use Bash for these operations.
- Bash is ONLY for build, lint, typecheck, and git commands listed in allowedTools.
- If a Bash command is denied, do NOT retry variations — simplify the command or switch to a dedicated tool immediately.

## CI Rules

- Dependencies are already installed — do NOT run install commands.
- For bulk edits, work in batches of 5 files: Read 5, Edit 5, then next batch.
- Do NOT use Task subagents for file editing — they cannot use Edit, Grep, or Glob.
- Do NOT use mcp__github_file_ops__commit_files — use git commands directly.
- For git commits, run `git add` and `git commit` as **separate** commands — never chain with `&&`.
- For PRs and reviews, write body to a temp file and use --body-file.
- Write temp files to `/tmp/` and do NOT clean them up — runners are ephemeral.

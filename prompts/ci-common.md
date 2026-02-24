You MUST read CLAUDE.md before starting — it defines all repository conventions and coding patterns.

## Tool Usage

- Use Grep, Glob, and Read tools for all file searching and reading — NEVER use Bash for these operations.
- Bash is ONLY for build, lint, typecheck, and git commands listed in allowedTools.
- If a Bash command is denied, do NOT retry variations — simplify the command or switch to a dedicated tool immediately.
- You MUST Read every file before you Edit it — no exceptions. When editing multiple files, Read each one immediately before editing it.

## CI Rules

- Dependencies are already installed — do NOT run install commands.
- For bulk edits, work in batches of 5 files: Read file, Edit file, repeat for each file in the batch.
- Do NOT use Task subagents for file editing — they cannot use Edit, Grep, or Glob.
- Do NOT use mcp__github_file_ops__commit_files — use git commands directly.

## Git Commit Rules

- Run `git add` and `git commit` as **separate** commands — never chain with `&&`.
- **NEVER use HEREDOC or multi-line strings in git commit commands** — the Bash permission pattern cannot match them and they will be denied.
- Instead, write the commit message to `/tmp/commit-msg.txt` using the Write tool, then run: `git commit --file /tmp/commit-msg.txt`
- For PRs and reviews, write body to a temp file and use --body-file.
- Write temp files to `/tmp/` and do NOT clean them up — runners are ephemeral.

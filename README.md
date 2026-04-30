# claude-ci-workflows

Reusable GitHub Actions workflows for Claude-powered CI/CD automation. These workflows provide automated CI failure fixing, Jira ticket implementation, and code review capabilities across any repository.

## Workflows

| Workflow | Purpose |
|----------|---------|
| `claude-ci-fix.yml` | Auto-fix CI failures on `claude/*` branch PRs (label-based retry, configurable max attempts) |
| `claude-jira.yml` | Implement Jira tickets via Claude, create PR on `claude/*` branch |
| `claude-auto-review.yml` | Auto-review PRs after CI passes on `claude/*` branches (can push fixes) |
| `claude-on-demand-review.yml` | Read-only review triggered by `@claude` mention in PR comments |
| `claude-pr-fix.yml` | Fix a PR when triggered by `@claude-fix` mention in PR comments (pushes code) |
| `claude-dependabot-sweep.yml` | Consolidate Dependabot alerts into one issue, Claude creates one PR fixing all. Auto-rebases sweep PRs that develop merge conflicts. |
| `claude-dependabot-sweep-rebase.yml` | On-demand rebase of a sweep PR via `@claude rebase` comment. Same logic as the auto-rebase path. |

## Architecture

```
claude-ci-workflows/.github/workflows/   <-- Reusable workflow_call workflows (this repo)
  claude-ci-fix.yml
  claude-jira.yml
  claude-auto-review.yml
  claude-on-demand-review.yml
  claude-pr-fix.yml
  claude-dependabot-sweep.yml
  claude-dependabot-sweep-rebase.yml
  claude-dependabot-sweep-rebase-job.yml  (internal — called by the two above)

<your-repo>/.github/workflows/           <-- Thin caller workflows (per repo)
  claude-ci-fix.yml       -> calls claude-ci-fix.yml
  claude-jira.yml         -> calls claude-jira.yml
  claude-review.yml       -> calls claude-auto-review.yml + claude-on-demand-review.yml
  claude-pr-fix.yml       -> calls claude-pr-fix.yml
  claude-dependabot-sweep.yml -> calls claude-dependabot-sweep.yml
  claude-dependabot-sweep-rebase.yml -> calls claude-dependabot-sweep-rebase.yml
```

Caller workflows handle **triggers** (e.g., `workflow_run`, `repository_dispatch`, `issue_comment`) and pass **repo-specific configuration** as inputs:

- `install_command`: e.g., `npm ci`, `make install`, `pip install -e .`
- `allowed_tools`: Claude Code Action tool allowlist
- `extra_prompt` / `extra_review_instructions`: repo-specific instructions

## Usage

### Adding to a new repo

1. **Create thin caller workflows** in your repo's `.github/workflows/` that call the reusable workflows in this repo (see [Caller examples](#caller-examples) below)
2. **Create `.claude/settings.ci.json`** in your repo to configure deny rules for files Claude should not modify
3. **Configure secrets** in your repo (see [Secrets](#secrets) below)
4. **Adjust each caller** for your repo:
   - Set the correct CI workflow name in `workflow_run.workflows`
   - Set `install_command` and `allowed_tools` for your project
   - Update `extra_prompt` / `extra_review_instructions` for project-specific caveats
   - Set `team_mention` for ci-fix to the appropriate GitHub team

### Workflow flow

```
PR opened on claude/* branch
  --> Repo CI runs
       |
       +--> [CI fails]  --> claude-ci-fix.yml (auto-fix, configurable retries)
       |
       +--> [CI passes] --> claude-auto-review.yml (auto-review, can push fixes)

@claude mention in PR comment
  --> claude-on-demand-review.yml (read-only review)

@claude-fix mention in PR comment
  --> claude-pr-fix.yml (fix PR and push code)

Jira ticket dispatched (repository_dispatch or manual)
  --> claude-jira.yml (implement ticket, open PR on claude/* branch)

Scheduled cron / manual dispatch
  --> claude-dependabot-sweep.yml
       (fetch alerts -> group by package -> one issue per package -> Claude fixes each -> one draft PR per package)
       (also: any open sweep PR with merge conflicts -> deterministic patch replay onto main, Claude only as fallback)

@claude rebase mention on a sweep PR
  --> claude-dependabot-sweep-rebase.yml
       (same logic as the auto-rebase path, on a single PR, on demand)
```

**Rebase strategy.** Both auto-rebase and on-demand rebase try a deterministic path first: extract the original PR's manifest-only diff (excluding lockfiles), apply it onto current `main`, then run `install_command` to regenerate lockfiles. Claude is only invoked when the manifest itself moved on `main` (the patch can't apply cleanly) — that path uses the same prompt shape as the initial sweep fix.

## Reusable workflow inputs

### Common inputs (all workflows)

| Input | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `install_command` | string | no | `''` | Dependency install command |
| `allowed_tools` | string | yes | - | Claude Code Action allowedTools |
| `model` | string | no | varies | Claude model ID |
| `max_turns` | number | no | varies | Max conversation turns |
| `repository_owner` | string | no | `viamrobotics` | Guard condition |
| `extra_prompt` | string | no | `''` | Extra instructions appended to the Claude prompt |
| `extra_system_prompt` | string | no | `''` | Extra instructions appended to the Claude system prompt |

### jira specific inputs

| Input | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `ticket_id` | string | yes | - | Jira ticket ID (e.g., SDK-123) |
| `summary` | string | yes | - | Ticket summary |
| `description` | string | yes | - | Ticket description |
| `task_complexity` | string | no | `small` | `small` (50 turns), `medium` (75), `large` (100). Ignored if `max_turns` is set. |
| `assignee` | string | no | `''` | Atlassian display name of the responsible engineer. Resolved to a GitHub username by matching against viamrobotics org members. |
| `assignee_email` | string | no | `''` | Atlassian email of the responsible engineer. Used as the primary signal for matching. |

### ci-fix specific inputs

| Input | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `run_id` | string | yes | - | Failed workflow run ID |
| `branch` | string | yes | - | PR branch name |
| `max_fix_attempts` | number | no | `2` | Max fix attempts before giving up |
| `team_mention` | string | yes | - | GitHub team to @mention when retries exhausted |

### auto-review specific inputs

| Input | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `pr_number` | string | yes | - | PR number to review |
| `pr_title` | string | yes | - | PR title |
| `branch` | string | yes | - | PR branch name |
| `extra_review_instructions` | string | no | `''` | Additional review instructions |

### on-demand-review specific inputs

| Input | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `extra_review_instructions` | string | no | `''` | Additional review instructions. |

### pr-fix specific inputs

No additional required inputs beyond [common inputs](#common-inputs-all-workflows). Uses `@claude-fix` as the trigger phrase. The on-demand review workflow automatically skips when `@claude-fix` is detected, so both can share the same caller trigger without interference.

### dependabot-sweep specific inputs

| Input | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `alert_severity` | string | no | `critical,high,medium` | Comma-separated severity filter. API values: `critical`, `high`, `medium`, `low` (note: `medium` shows as "moderate" in the GitHub UI) |

### Secrets

| Secret | Used by | Required | Description |
|--------|---------|----------|-------------|
| `ANTHROPIC_API_KEY` | all | yes | Set at viamrobotics org level. Key `claude_code_key_jira_github_action` in the Internal Usage Workspace on Claude Console. |
| `GIT_ACCESS_TOKEN` | ci-fix, auto-review, pr-fix, dependabot-sweep | yes | PAT with repo write access for pushing fixes to branches. Must include `security_events` scope for dependabot-sweep. |
| `SLACK_AI_WORKFLOW_ALERT_WEBHOOK_URL` | jira, auto-review, dependabot-sweep | no | Set at viamrobotics org level; alerts to `#ai-workflows-alerts`. Override at the repo level to send to a different Slack channel. |

## Caller examples

### Jira caller

```yaml
name: Claude Jira

on:
  repository_dispatch:
    types: [jira-ticket]

jobs:
  implement:
    uses: viamrobotics/claude-ci-workflows/.github/workflows/claude-jira.yml@main
    with:
      ticket_id: ${{ github.event.client_payload.ticket_id }}
      summary: ${{ github.event.client_payload.summary }}
      description: ${{ github.event.client_payload.description }}
      task_complexity: ${{ github.event.client_payload.task_complexity || 'small' }}
      assignee: ${{ github.event.client_payload.assignee }}
      assignee_email: ${{ github.event.client_payload.assignee_email }}
      install_command: npm ci  # your install command
      allowed_tools: 'Edit,Read,Write,Glob,Grep,Bash(npm run build*),Bash(npm run lint*),Bash(npm run test*),Bash(git *)'
    secrets:
      ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
      SLACK_AI_WORKFLOW_ALERT_WEBHOOK_URL: ${{ secrets.SLACK_AI_WORKFLOW_ALERT_WEBHOOK_URL }}
```

### CI fix caller

```yaml
name: Claude CI Fix

on:
  workflow_run:
    workflows: ["Your CI Workflow Name"]
    types: [completed]

jobs:
  fix-ci:
    if: >-
      github.repository_owner == 'viamrobotics' &&
      github.event.workflow_run.conclusion == 'failure' &&
      startsWith(github.event.workflow_run.head_branch, 'claude/')
    uses: viamrobotics/claude-ci-workflows/.github/workflows/claude-ci-fix.yml@main
    with:
      run_id: ${{ github.event.workflow_run.id }}
      branch: ${{ github.event.workflow_run.head_branch }}
      install_command: npm ci  # your install command
      team_mention: '@viamrobotics/your-team'
      allowed_tools: 'Edit,Read,Write,Glob,Grep,Bash(git config *),Bash(git add *),Bash(git commit *),Bash(git push *),Bash(git status*),Bash(git diff*),Bash(git log*),Bash(git checkout *),Bash(git branch *),Bash(git rev-parse *),Bash(git fetch *)'
    secrets:
      ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
      GIT_ACCESS_TOKEN: ${{ secrets.GIT_ACCESS_TOKEN }}
```

### PR fix caller

```yaml
name: Claude PR Fix

on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]

jobs:
  pr-fix:
    if: >-
      github.repository_owner == 'viamrobotics' &&
      github.event.issue.pull_request &&
      contains(github.event.comment.body, '@claude-fix')
    uses: viamrobotics/claude-ci-workflows/.github/workflows/claude-pr-fix.yml@main
    with:
      install_command: npm ci  # your install command
      allowed_tools: 'Edit,Read,Write,Glob,Grep,Bash(npm run build*),Bash(npm run lint*),Bash(npm run test*),Bash(git config *),Bash(git add *),Bash(git commit *),Bash(git push *),Bash(git status*),Bash(git diff*),Bash(git log*),Bash(git checkout *),Bash(git branch *),Bash(git rev-parse *),Bash(git fetch *)'
    secrets:
      ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
      GIT_ACCESS_TOKEN: ${{ secrets.GIT_ACCESS_TOKEN }}
```

### Dependabot sweep caller

```yaml
name: Claude Dependabot Sweep

on:
  schedule:
    - cron: '0 6 * * 1'  # Every Monday at 6 AM UTC
  workflow_dispatch:

jobs:
  sweep:
    uses: viamrobotics/claude-ci-workflows/.github/workflows/claude-dependabot-sweep.yml@main
    with:
      install_command: npm ci  # your install command
      allowed_tools: 'Edit,Read,Write,Glob,Grep,Bash(npm ci*),Bash(npm install*),Bash(npm update*),Bash(npm run build*),Bash(npm run lint*),Bash(npm run test*),Bash(npm audit*),Bash(git config *),Bash(git add *),Bash(git commit *),Bash(git push *),Bash(git status*),Bash(git diff*),Bash(git log*),Bash(git checkout *),Bash(git branch *),Bash(git rev-parse *),Bash(git fetch *),Bash(gh pr create*),Bash(gh pr list*)'
      alert_severity: 'critical,high,medium'
      extra_prompt: |
        - This is a monorepo with multiple example directories, each with their own package.json and lockfile.
        - After updating a dependency, run `npm ci` in that directory to regenerate the lockfile.
    secrets:
      ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
      GIT_ACCESS_TOKEN: ${{ secrets.GIT_ACCESS_TOKEN }}
      SLACK_AI_WORKFLOW_ALERT_WEBHOOK_URL: ${{ secrets.SLACK_AI_WORKFLOW_ALERT_WEBHOOK_URL }}
```

### Dependabot sweep rebase caller (on-demand `@claude rebase`)

The auto-rebase path runs as part of the scheduled sweep above (no extra wiring needed). This caller adds an on-demand trigger so a maintainer can comment `@claude rebase` on any sweep PR and re-rebase it immediately without waiting for the next scheduled run.

```yaml
name: Claude Dependabot Sweep Rebase

on:
  issue_comment:
    types: [created]

jobs:
  rebase:
    if: >-
      github.event.issue.pull_request &&
      contains(github.event.comment.body, '@claude rebase')
    uses: viamrobotics/claude-ci-workflows/.github/workflows/claude-dependabot-sweep-rebase.yml@main
    with:
      install_command: npm ci   # used to set up the env when falling back to Claude
      allowed_tools: 'Edit,Read,Write,Glob,Grep,Bash(npm install*),Bash(npm update*),Bash(npm run build*),Bash(npm run lint*),Bash(npm run test*)'
    secrets:
      ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
      CI_GITHUB_APP_ID: ${{ secrets.CI_GITHUB_APP_ID }}
      CI_GITHUB_APP_PRIVATE_KEY: ${{ secrets.CI_GITHUB_APP_PRIVATE_KEY }}
      SLACK_AI_WORKFLOW_ALERT_WEBHOOK_URL: ${{ secrets.SLACK_AI_WORKFLOW_ALERT_WEBHOOK_URL }}
```

The deterministic path regenerates lockfiles automatically based on the lockfile basenames touched by the original PR. Each command runs in the affected lockfile's directory (monorepo-aware):

| Lockfile | Regen command |
|----------|---------------|
| `go.sum` | `go mod tidy` |
| `package-lock.json` / `npm-shrinkwrap.json` | `npm install --package-lock-only` |
| `pnpm-lock.yaml` | `pnpm install --lockfile-only` |
| `pubspec.lock` | `flutter pub get` |
| `Cargo.lock` | `cargo generate-lockfile` |
| `uv.lock` | `uv lock` |
| `poetry.lock` | `poetry lock --no-update` |

Other recognized lockfiles (`yarn.lock`, `bun.lockb`, `Pipfile.lock`, `Gemfile.lock`, `composer.lock`, `mix.lock`) and unknown ones trigger the Claude fallback. `install_command` is only used to set up Claude's working environment for that fallback path — typically `npm ci`, `pip install -e .`, `make install`, `go mod download`.

# claude-ci-workflows

Reusable GitHub Actions workflows for Claude-powered CI/CD automation. These workflows provide automated CI failure fixing, Jira ticket implementation, and code review capabilities across any repository.

## Workflows

| Workflow | Purpose |
|----------|---------|
| `claude-ci-fix.yml` | Auto-fix CI failures on `claude/*` branch PRs (label-based retry, configurable max attempts) |
| `claude-jira.yml` | Implement Jira tickets via Claude, create PR on `claude/*` branch |
| `claude-auto-review.yml` | Auto-review PRs after CI passes on `claude/*` branches (can push fixes) |
| `claude-on-demand-review.yml` | Read-only review triggered by `@claude` mention in PR comments |

## Architecture

```
claude-ci-workflows/.github/workflows/   <-- Reusable workflow_call workflows (this repo)
  claude-ci-fix.yml
  claude-jira.yml
  claude-auto-review.yml
  claude-on-demand-review.yml

<your-repo>/.github/workflows/           <-- Thin caller workflows (per repo)
  claude-ci-fix.yml       -> calls claude-ci-fix.yml
  claude-jira.yml         -> calls claude-jira.yml
  claude-review.yml       -> calls claude-auto-review.yml + claude-on-demand-review.yml
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

Jira ticket dispatched (repository_dispatch or manual)
  --> claude-jira.yml (implement ticket, open PR on claude/* branch)
```

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
| `extra_review_instructions` | string | no | `''` | Additional review instructions |

### Secrets

| Secret | Used by | Required | Description |
|--------|---------|----------|-------------|
| `ANTHROPIC_API_KEY` | all | yes | Set at viamrobotics org level. Key `claude_code_key_jira_github_action` in the Internal Usage Workspace on Claude Console. |
| `GIT_ACCESS_TOKEN` | ci-fix, auto-review | yes | PAT with repo write access for pushing fixes to branches. |
| `SLACK_AI_WORKFLOW_ALERT_WEBHOOK_URL` | jira, auto-review | no | Set at viamrobotics org level; alerts to `#ai-workflows-alerts`. Override at the repo level to send to a different Slack channel. |

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

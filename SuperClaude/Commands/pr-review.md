---
allowed-tools: [Bash(~/.claude/scripts/pr-review.sh:*)]
description: "Review a pull request using GitHub CLI and provide comprehensive analysis"
script-based: true
---

# /sc:pr-review - Pull Request Review Command

## Purpose
Perform a comprehensive review of a GitHub pull request using a deterministic bash script that:
1. Fetches PR details and metadata
2. Shows diff statistics and file changes
3. Lists all changed files with additions/deletions
4. Displays PR description and comments
5. Shows CI/CD status checks
6. Provides a summary of the review

## Usage
```
/sc:pr-review PR=<number> [--repo owner/name] [--detailed] [--files-only]
```

## Arguments
- `PR=<number>` - The pull request number to review (required)
- `--repo` - Repository in format owner/name (default: uses current repo)
- `--detailed` - Show full diff for each file
- `--files-only` - Only list changed files without diffs

## Features
- Uses GitHub CLI (`gh`) for authentication and API access
- Shows PR metadata (author, branch, status)
- Displays file changes with statistics
- Shows existing comments and review status
- Checks CI/CD status
- Provides actionable review summary

## Execution
This command runs a deterministic bash script that handles the PR review:

!~/.claude/scripts/pr-review.sh $ARGUMENTS
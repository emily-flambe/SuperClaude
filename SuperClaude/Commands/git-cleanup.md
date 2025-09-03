---
allowed-tools: [Bash, Read, Glob, TodoWrite, Edit, WebFetch]
description: "Git cleanup operation that switches to main, pulls, removes local branches, and deletes remote branches without PRs"
---

# /sc:git-cleanup - Comprehensive Git Branch Cleanup

## Purpose
Perform a complete git branch cleanup operation that:
1. Checks out the main branch
2. Pulls latest changes from main
3. Removes all local branches (except main)
4. Deletes remote branches that don't have associated pull requests

## Usage
```
/sc:git-cleanup [--dry-run] [--force] [--exclude-branches branch1,branch2]
```

## Arguments
- `--dry-run` - Preview what would be deleted without actually deleting
- `--force` - Skip confirmation prompts
- `--exclude-branches` - Comma-separated list of branches to exclude from deletion
- `--remote` - Specify remote name (default: origin)

## Safety Features
- Always prompts for confirmation unless --force is used
- Shows list of branches to be deleted before proceeding
- Protects main/master branches automatically
- Checks for unpushed commits before deleting local branches
- Uses GitHub API to verify PR status before remote deletion

## Execution
1. **Verify repository state** - Ensure we're in a git repository
2. **Switch to main branch** - Checkout main (or master if main doesn't exist)
3. **Pull latest changes** - Update main branch from remote
4. **List local branches** - Identify branches to delete
5. **Check for unpushed commits** - Warn if branches have unpushed work
6. **Delete local branches** - Remove all non-main branches
7. **Check remote branches** - Query GitHub/GitLab API for PR status
8. **Delete remote branches** - Remove branches without open PRs

## Error Handling
- Fails gracefully if not in a git repository
- Warns about uncommitted changes
- Handles API rate limits and authentication
- Reports failed deletions without stopping the process

## Claude Code Integration
- Uses Bash for git operations and API calls
- Leverages WebFetch for GitHub/GitLab API interactions
- Uses TodoWrite to track multi-step cleanup process
- Provides detailed feedback throughout the operation
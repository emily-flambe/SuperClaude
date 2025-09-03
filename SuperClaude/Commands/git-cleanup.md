---
allowed-tools: [Bash(~/.claude/scripts/git-cleanup.sh:*)]
description: "Deterministic git cleanup script that safely removes merged branches"
script-based: true
---

# /sc:git-cleanup - Comprehensive Git Branch Cleanup

## Purpose
Perform a complete git branch cleanup operation using a deterministic bash script that:
1. Checks out the main branch
2. Pulls latest changes from main
3. Removes merged local branches (with safety checks)
4. Deletes remote branches that don't have associated pull requests

## Usage
```
/sc:git-cleanup [--dry-run] [--force] [--exclude-branches branch1,branch2] [--remote origin]
```

## Arguments
- `--dry-run` - Preview what would be deleted without actually deleting
- `--force` - Skip confirmation prompts and force delete unmerged branches
- `--exclude-branches` - Comma-separated list of branches to exclude from deletion
- `--remote` - Specify remote name (default: origin)

## Safety Features
- Protects main/master branches automatically
- Checks if branches are merged before deletion
- Warns about unpushed commits
- Requires confirmation for remote branch deletion (unless --force)
- Uses GitHub CLI to check for open PRs before remote deletion

## Execution
This command runs a deterministic bash script that handles all cleanup operations:

!~/.claude/scripts/git-cleanup.sh $ARGUMENTS
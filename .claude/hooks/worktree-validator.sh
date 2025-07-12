#!/usr/bin/env bash
# worktree-validator.sh - Ensure git worktrees are only created in worktrees/ folder

# Check if this is a git worktree add command
if [[ "$1" == "git" && "$2" == "worktree" && "$3" == "add" ]]; then
    worktree_path="$4"
    
    # Check if path starts with worktrees/
    if [[ ! "$worktree_path" =~ ^worktrees/ ]]; then
        echo "ERROR: Git worktrees must be created in the worktrees/ directory" >&2
        echo "Usage: git worktree add worktrees/<name> <branch>" >&2
        exit 1
    fi
fi

exit 0
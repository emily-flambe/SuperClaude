#!/usr/bin/env bash
# validate-config.sh - Lightweight config validation hook

set -o pipefail

# Simple validation - just check key files exist
[[ -f "$HOME/.claude/CLAUDE.md" ]] || exit 0
[[ -f "$HOME/.claude/settings.json" ]] || exit 0

# Check for project config if present
search_dir="$PWD"
while [[ "$search_dir" != "/" ]]; do
    if [[ -d "$search_dir/.claude" ]]; then
        [[ -r "$search_dir/.claude" ]] || exit 1
        break
    fi
    search_dir="$(dirname "$search_dir")"
done

exit 0
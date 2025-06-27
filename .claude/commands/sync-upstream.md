**Purpose**: Sync with upstream repository and resolve conflicts

---

@include shared/universal-constants.yml#Universal_Legend

## Command Execution
Execute: immediate. --plan→show plan first
Legend: Generated based on symbols used in command
Purpose: "[SYNC][Upstream] Merge upstream changes in $ARGUMENTS"

🔄 **UPSTREAM SYNC**: Merge changes from the main GitHub branch with optional conflict resolution.

Keeps your fork up-to-date with the original repository by fetching and merging upstream changes.

@include shared/flag-inheritance.yml#Universal_Always

Examples:
- `/sync-upstream` - Safe merge with manual conflict resolution
- `/sync-upstream --force` - Auto-resolve conflicts by keeping upstream
- `/sync-upstream --upstream origin/master` - Specify upstream branch
- `/sync-upstream --backup` - Create backup branch before sync

Upstream sync workflow:
1. **Fetch latest** - `git fetch` from configured upstream
2. **Check conflicts** - Preview potential merge conflicts
3. **Backup current** - Optional safety branch creation
4. **Merge upstream** - Integrate changes from main branch
5. **Resolve conflicts** - Manual or automatic resolution
6. **Cleanup** - Remove temporary files and update tracking

**--force:** Auto-resolve conflicts by keeping upstream changes | Discards local conflicts
**--upstream:** Specify upstream branch (default: origin/master or origin/main)
**--backup:** Create backup branch before sync | Safety net
**--strategy:** Merge strategy (merge|rebase|squash) | Default: merge
**--dry-run:** Preview changes without applying | Safety check
**--no-commit:** Stage changes but don't commit | Review before commit

⚠️ **CONFLICT RESOLUTION**: 
- Default: Manual resolution required for conflicts
- `--force`: Automatically accepts upstream version for conflicts
- `--backup` recommended when using `--force`

**Auto-upstream detection:**
- Checks for `upstream` remote first
- Falls back to `origin/master` or `origin/main`
- Detects default branch automatically

Execution pattern:
```bash
# Detect upstream configuration
UPSTREAM_REMOTE=$(git remote | grep upstream || echo "origin")
UPSTREAM_BRANCH=$(git symbolic-ref refs/remotes/${UPSTREAM_REMOTE}/HEAD 2>/dev/null | sed "s@^refs/remotes/${UPSTREAM_REMOTE}/@@" || echo "master")

# Fetch latest changes
echo "🔄 Fetching from ${UPSTREAM_REMOTE}/${UPSTREAM_BRANCH}..."
git fetch ${UPSTREAM_REMOTE}

# Create backup if requested
if [[ "$BACKUP" == true ]]; then
    BACKUP_BRANCH="backup-$(date +%Y%m%d-%H%M%S)"
    git checkout -b ${BACKUP_BRANCH}
    git checkout -
    echo "💾 Created backup branch: ${BACKUP_BRANCH}"
fi

# Check for conflicts preview
echo "🔍 Checking for potential conflicts..."
CONFLICTS=$(git merge-tree $(git merge-base HEAD ${UPSTREAM_REMOTE}/${UPSTREAM_BRANCH}) HEAD ${UPSTREAM_REMOTE}/${UPSTREAM_BRANCH} | grep -c "<<<<<<< " || echo "0")

if [[ ${CONFLICTS} -gt 0 ]] && [[ "$FORCE" != true ]]; then
    echo "⚠️  ${CONFLICTS} potential conflicts detected"
    echo "Use --force to auto-resolve or resolve manually"
    exit 1
fi

# Perform merge
if [[ "$FORCE" == true ]] && [[ ${CONFLICTS} -gt 0 ]]; then
    echo "🚀 Force merging with upstream resolution..."
    git merge ${UPSTREAM_REMOTE}/${UPSTREAM_BRANCH} -X theirs --no-edit
else
    echo "🔀 Merging upstream changes..."
    git merge ${UPSTREAM_REMOTE}/${UPSTREAM_BRANCH} --no-edit
fi

# Success feedback
echo "✅ Upstream sync complete"
git log --oneline -5
```

**Conflict resolution strategies:**
- **Manual** (default): Stop on conflicts, require user resolution
- **--force**: Accept upstream changes for all conflicts
- **Theirs strategy**: `-X theirs` automatically favors upstream
- **Interactive**: Manual resolution with merge tools

**Safety features:**
- Backup branch creation before dangerous operations
- Dry-run mode for preview
- Conflict detection before merge attempt
- Clear status reporting throughout process

**Post-sync recommendations:**
```bash
# Verify the merge
git log --graph --oneline -10

# Check for any issues
git status

# Update your remote if needed
git push origin $(git branch --show-current)

# Clean up backup if everything looks good
git branch -D backup-YYYYMMDD-HHMMSS
```

**Common upstream configurations:**
```bash
# Add upstream remote (one-time setup)
git remote add upstream https://github.com/original/repo.git

# Verify remotes
git remote -v

# Set up tracking
git branch -u upstream/main main
```

@include shared/execution-patterns.yml#Git_Integration_Patterns

@include shared/universal-constants.yml#Standard_Messages_Templates

---

**🔄 WHEN TO USE**: Regularly sync your fork with the original repository to get latest features, bug fixes, and security updates. Use `--force` carefully when you want to prioritize upstream changes over local modifications.
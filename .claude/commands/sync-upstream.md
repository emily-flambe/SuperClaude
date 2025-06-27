**Purpose**: Pull from main with force (simple and cheeky)

---

@include shared/universal-constants.yml#Universal_Legend

## Command Execution
Execute: immediate. NO --plan (bypasses safety like yolo-merge)
Legend: Generated based on symbols used in command
Purpose: "[PULL][Force] Simple force pull from main in $ARGUMENTS"

🔄 **SIMPLE MERGE FROM MAIN**: Just like asking Claude "pull from main with force" - merges main into your current branch.

Does exactly what you'd expect: fetches the latest from main and merges it into whatever branch you're on.

@include shared/flag-inheritance.yml#Universal_Always

Examples:
- `/sync-upstream` - Merge main into current branch
- `/sync-upstream --force` - Auto-resolve conflicts by keeping main's version
- `/sync-upstream --backup` - Create backup branch first

Simple merge from main workflow:
1. **Auto-detect main branch** - figures out main vs master automatically
2. **Fetch latest** - `git fetch origin`
3. **Merge main** - `git merge origin/main` into your current branch
4. **Handle conflicts** - either manually or with --force

**--force:** Auto-resolve conflicts by keeping main's changes | Discards your conflicting changes
**--backup:** Create backup branch before merge | Safety net
**--push:** Push the merged branch after successful merge | Update your fork

⚠️ **CONFLICT HANDLING**: 
- Default: Stops on conflicts for manual resolution
- `--force`: Auto-resolves by keeping main's version of conflicted files
- Keeps all your non-conflicting changes
- Like `git merge origin/main -X theirs` when forced

Execution pattern:
```bash
# Auto-detect main branch (main vs master)
MAIN_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || \
             (git ls-remote --symref origin HEAD | head -1 | sed 's@^ref: refs/heads/@@' || echo "main"))

# Create backup if requested
if [[ "$BACKUP" == true ]]; then
    BACKUP_BRANCH="backup-before-sync-$(date +%Y%m%d-%H%M%S)"
    git branch ${BACKUP_BRANCH}
    echo "💾 Created backup: ${BACKUP_BRANCH}"
fi

# The simple, cheeky approach
echo "🔄 Fetching latest from origin/${MAIN_BRANCH}..."
git fetch origin

echo "🔀 Merging origin/${MAIN_BRANCH} into $(git branch --show-current)..."
if [[ "$FORCE" == true ]]; then
    # Auto-resolve conflicts by keeping main's version
    git merge origin/${MAIN_BRANCH} -X theirs --no-edit
else
    # Normal merge that may have conflicts
    git merge origin/${MAIN_BRANCH} --no-edit
fi

# Optional push after successful merge
if [[ "$PUSH" == true ]]; then
    echo "📤 Pushing merged branch..."
    git push
fi

echo "✅ Merged origin/${MAIN_BRANCH} into $(git branch --show-current)"
```

**Why this approach is cheeky:**
- No questions about remotes or which branch to merge
- Auto-detects main vs master
- `--force` just says "main wins" for conflicts
- Simple merge, keeps your changes where possible

@include shared/execution-patterns.yml#Git_Integration_Patterns

@include shared/universal-constants.yml#Standard_Messages_Templates

---

**🔄 WHEN TO USE**: Regularly sync your fork with the original repository to get latest features, bug fixes, and security updates. Use `--force` carefully when you want to prioritize upstream changes over local modifications.
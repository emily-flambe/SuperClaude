**Purpose**: Pull from main with force (simple and cheeky)

---

@include shared/universal-constants.yml#Universal_Legend

## Command Execution
Execute: immediate. NO --plan (bypasses safety like yolo-merge)
Legend: Generated based on symbols used in command
Purpose: "[PULL][Force] Simple force pull from main in $ARGUMENTS"

🔄 **SIMPLE FORCE PULL**: Just like asking Claude "pull from main with force" - simple, direct, no questions asked.

Does exactly what you'd expect: fetches the latest from main and forces your branch to match it.

@include shared/flag-inheritance.yml#Universal_Always

Examples:
- `/sync-upstream` - Force pull from origin/main (or master)
- `/sync-upstream --backup` - Create backup branch first
- `/sync-upstream --push` - Also force push after sync

Simple force pull workflow:
1. **Auto-detect main branch** - figures out main vs master automatically
2. **Fetch latest** - `git fetch origin`
3. **Force reset** - `git reset --hard origin/main` (discards ALL local changes)
4. **Done** - Your branch now matches main exactly

**--backup:** Create backup branch before nuking local changes | Safety net
**--push:** Force push to remote after sync | Update your fork
**--dry-run:** Show what would happen without doing it | Preview only

⚠️ **NUCLEAR SIMPLICITY**: 
- Discards ALL local changes without asking
- No merge conflicts because there's no merge
- Your branch becomes identical to origin/main
- Like `git reset --hard origin/main` but smarter

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

echo "🚀 Force syncing to origin/${MAIN_BRANCH} (nuking local changes)..."
git reset --hard origin/${MAIN_BRANCH}

# Optional force push
if [[ "$PUSH" == true ]]; then
    echo "📤 Force pushing to sync your fork..."
    git push --force-with-lease
fi

echo "✅ Synced! Your branch now matches origin/${MAIN_BRANCH}"
```

**Why this approach is cheeky:**
- No complex merge logic or conflict resolution
- No questions about remotes or branches
- Just does what you want: "make my branch match main"
- Embraces the nuclear option philosophy

@include shared/execution-patterns.yml#Git_Integration_Patterns

@include shared/universal-constants.yml#Standard_Messages_Templates

---

**🔄 WHEN TO USE**: Regularly sync your fork with the original repository to get latest features, bug fixes, and security updates. Use `--force` carefully when you want to prioritize upstream changes over local modifications.
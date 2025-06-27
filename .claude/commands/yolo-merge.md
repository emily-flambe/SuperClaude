**Purpose**: YOLO merge - Automatic commit, PR creation, and merge without approval

---

@include shared/universal-constants.yml#Universal_Legend

## Command Execution
Execute: immediate. NO --plan (bypasses safety checks)
Legend: Generated based on symbols used in command
Purpose: "[YOLO][Git] Automatic complete merge workflow in $ARGUMENTS"

⚠️ **DANGER**: This command bypasses ALL safety checks and approval processes. Use only when you understand the risks.

Automatically commits all changes, creates a pull request, and merges it immediately without review or approval.

@include shared/flag-inheritance.yml#Universal_Always

Examples:
- `/yolo-merge "implement user authentication"` - Complete auto-merge with message
- `/yolo-merge --branch feature/auth --target main` - Custom branch and target
- `/yolo-merge --squash --delete-branch` - Squash commits and cleanup

YOLO merge workflow:
1. **Stage all changes** - `git add .` (includes untracked files)
2. **Auto-commit** - Generate commit message from changes
3. **Push to remote** - Force push if needed with `-u` flag
4. **Create PR** - Auto-generate title and description
5. **Auto-merge** - Immediately merge without approval
6. **Cleanup** - Optionally delete feature branch

**--branch:** Specify source branch (default: current branch)
**--target:** Target branch for merge (default: main/master)
**--message:** Custom commit message (default: auto-generated)
**--squash:** Squash commits before merge | Cleaner history
**--delete-branch:** Delete source branch after merge | Automatic cleanup
**--force:** Force push changes | Overwrites remote conflicts

⚠️ **SAFETY BYPASS**: 
- NO pre-commit hooks validation
- NO approval requirements 
- NO conflict resolution
- NO backup creation
- NO rollback preparation

Execution pattern:
```bash
# Stage everything
git add .

# Commit with auto-generated or custom message
git commit -m "${COMMIT_MESSAGE}" --no-verify

# Push to remote (create tracking branch if needed)
git push -u origin ${SOURCE_BRANCH}

# Create PR using GitHub CLI
gh pr create --title "${PR_TITLE}" --body "${PR_BODY}" --head ${SOURCE_BRANCH} --base ${TARGET_BRANCH}

# Merge the PR (with squash and branch deletion as configured)
gh pr merge --squash --delete-branch

# Return to target branch and pull updates
git checkout ${TARGET_BRANCH}
git pull origin ${TARGET_BRANCH}
```

**Auto-generated content:**
- **Commit message**: Analyze git diff for meaningful description
- **PR title**: Extract main feature/fix from changes  
- **PR description**: Include change summary and modified files list

**Risk factors addressed:**
- Merge conflicts: Aborted with error (no resolution attempt)
- Missing approvals: Bypassed completely
- Failed CI/CD: Ignored (merge proceeds)
- Protected branches: May fail (command doesn't override branch protection)

@include shared/execution-patterns.yml#Git_Integration_Patterns

@include shared/universal-constants.yml#Standard_Messages_Templates

---

**⚠️ USE WITH EXTREME CAUTION**: This command is designed for personal repositories, rapid prototyping, or emergency deployments where normal approval processes are unnecessary or counterproductive. Never use on production repositories with team collaboration.
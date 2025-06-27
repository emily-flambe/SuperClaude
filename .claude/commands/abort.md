**Purpose**: Emergency session abort with documentation and cleanup

---

@include shared/universal-constants.yml#Universal_Legend

## Command Execution
Execute: immediate. --plan→show plan first
Legend: Generated based on symbols used in command
Purpose: "[ABORT][Session] Emergency exit with documentation in $ARGUMENTS"

🛑 **SESSION EMERGENCY EXIT**: For when things are going in circles and you need a clean slate.

When a coding session isn't working out and you're stuck in loops, this command provides a structured way to document findings, clean up, and start fresh.

@include shared/flag-inheritance.yml#Universal_Always

Examples:
- `/abort "stuck in infinite loop debugging API"` - Document issue and abort
- `/abort --save-work` - Stash changes instead of reverting
- `/abort --no-revert` - Document only, keep changes

Emergency abort workflow:
1. **Prompt for confirmation** - "It's clear this session isn't working out..."
2. **Document findings** - Append to TROUBLESHOOTING.md with timestamp
3. **Revert changes** - Reset to last commit (unless flags override)
4. **Session cleanup** - Clear temp files and state
5. **Exit gracefully** - Provide next steps guidance

**--save-work:** Stash changes instead of reverting | Preserves work for later
**--no-revert:** Document findings but keep current changes | Investigation mode
**--force:** Skip confirmation prompt | Emergency abort
**--detailed:** Include full git diff in documentation | Comprehensive record
**--issue:** Create GitHub issue from findings | Team visibility

⚠️ **DESTRUCTIVE OPERATION**: 
- Reverts ALL uncommitted changes by default
- Cannot be undone without git stash recovery
- Session state will be lost

**Auto-generated documentation includes:**
- Timestamp and session duration
- Git status and uncommitted changes summary
- Error patterns and symptoms observed
- Attempted solutions and their results
- Recommendations for next session

Execution pattern:
```bash
# Confirmation prompt
echo "🛑 ABORT SESSION CONFIRMATION"
echo "It's clear this session isn't working out. We are going in circles."
echo "This will:"
echo "  1. Document findings in TROUBLESHOOTING.md"
echo "  2. Revert all changes since last commit"
echo "  3. Clean up session state"
echo "  4. Close this session"
echo ""
echo "Continue? (y/N): "

# Document findings
cat >> TROUBLESHOOTING.md << EOF
## Session Abort - $(date)
**Issue**: ${ABORT_REASON}
**Duration**: ${SESSION_TIME}
**Status**: Going in circles, emergency abort

### What was attempted:
${ATTEMPTED_SOLUTIONS}

### Symptoms observed:
${ERROR_PATTERNS}

### Git state at abort:
${GIT_STATUS}

### Recommendations:
- Take a break before retry
- Consider different approach
- Review error patterns above
- Check if issue is environmental

---
EOF

# Cleanup operations (conditional)
if [[ "$SAVE_WORK" != true ]]; then
    git checkout .           # Revert tracked files
    git clean -fd           # Remove untracked files
else
    git stash push -m "Aborted session: ${ABORT_REASON}"
fi

# Session cleanup
rm -f .claude/session_state.tmp
clear

# Exit guidance
echo "✅ Session aborted cleanly"
echo "📝 Findings documented in TROUBLESHOOTING.md"
echo "🔄 Ready for fresh start"
```

**Confirmation prompt:**
```
🛑 ABORT SESSION CONFIRMATION

It's clear this session isn't working out. We are going in circles.

This will:
  1. Document your findings in TROUBLESHOOTING.md (appending if exists)
  2. Note what you have tried so far and what you have been seeing
  3. Revert all changes since the last GitHub commit
  4. Clean up session state and close this session

Continue? (y/N): 
```

**Documentation template:**
```markdown
## Session Abort - [timestamp]
**Issue**: [user-provided reason or auto-detected]
**Duration**: [session length]
**Status**: Going in circles, emergency abort

### What was attempted:
- [List of commands executed]
- [Approaches tried]
- [Solutions attempted]

### Symptoms observed:
- [Error patterns]
- [Unexpected behaviors]
- [Performance issues]

### Git state at abort:
[git status output]
[summary of uncommitted changes]

### Recommendations:
- Take a break before retry
- Consider different approach
- Review error patterns above
- Check if issue is environmental

---
```

**Recovery options:**
- `git stash list` - View stashed work if --save-work was used
- `git stash pop` - Restore stashed changes
- `git log --oneline -10` - Review recent commits
- Review TROUBLESHOOTING.md for patterns

@include shared/execution-patterns.yml#Git_Integration_Patterns

@include shared/universal-constants.yml#Standard_Messages_Templates

---

**💡 WHEN TO USE**: When you find yourself repeating the same failing approaches, getting the same errors repeatedly, or feeling stuck in an unproductive loop. Sometimes the best solution is to step back, document what you've learned, and start fresh.
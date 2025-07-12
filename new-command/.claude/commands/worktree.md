# /worktree - Automated Git Worktree Setup

**Purpose**: Create new git worktree with branch and PR setup automation

---

@include shared/universal-constants.yml#Universal_Legend

## Command Execution
Execute: immediate. --plan→show plan first  
Legend: Generated based on symbols used in command  
Purpose: "Create new worktree with feature branch and draft PR setup"

Automate git worktree creation with intelligent branch naming and PR setup.

@include shared/flag-inheritance.yml#Universal_Always

## Syntax
```bash
/worktree [name] [options]
```

## Parameters
- **`[name]`** (optional): Worktree/branch name
  - If provided: Used as-is for branch naming
  - If omitted: Generates intelligent default based on context
  - Validation: Git-safe naming, uniqueness checking

## Options
```bash
--base <branch>         # Base branch (default: main)
--prefix <prefix>       # Branch prefix (default: feature/)
--no-pr                # Skip PR creation
--draft                # Create draft PR (default)
--ready                # Create ready PR
--description <desc>    # PR description
--title <title>        # PR title (auto-generated if omitted)
--interactive          # Interactive mode with prompts
--dry-run              # Show what would happen without executing
```

## Examples

### Basic Usage
```bash
/worktree                    # Creates feature/[context-aware-name]
/worktree auth               # Creates feature/auth
/worktree user-management    # Creates feature/user-management
```

### Advanced Usage
```bash
/worktree --base develop                     # Use develop as base branch
/worktree api --prefix bug/                  # Creates bug/api
/worktree hotfix --ready                     # Create ready PR instead of draft
/worktree experiment --no-pr                 # Skip PR creation
/worktree --interactive                      # Guided setup with prompts
```

### Prefix Patterns
```bash
/worktree fix --prefix bug/                  # bug/fix
/worktree spike --prefix spike/              # spike/spike
/worktree cleanup --prefix chore/            # chore/cleanup
```

## Intelligent Naming Strategy

### Default Name Generation
When no name is provided, the command generates intelligent defaults:

1. **Current directory name**: `feature/superclaude-enhancement`
2. **Git repository name**: `feature/project-name`
3. **Timestamp fallback**: `feature/development-$(date +%m%d)`

### Context-Aware Examples
```bash
# In "user-auth" directory
/worktree → feature/user-auth

# In "api-v2" directory  
/worktree → feature/api-v2

# In root directory
/worktree → feature/superclaude-$(date +%m%d)
```

## Workflow Steps

The command executes these steps automatically:

1. **Environment Validation**
   - Verify git repository
   - Check GitHub authentication
   - Validate base branch exists

2. **Branch Preparation**
   - Checkout base branch (default: main)
   - Pull latest changes from remote
   - Generate unique branch name

3. **Worktree Creation**
   - Create new worktree in `../[name]` directory
   - Checkout new feature branch
   - Create initial empty commit

4. **Remote Setup**
   - Push branch to remote with upstream tracking
   - Set up branch protection if configured

5. **PR Creation** (unless `--no-pr`)
   - Create draft PR with blank description
   - Use PR template if available
   - Return PR URL for reference

## Error Handling

### Common Scenarios
- **Branch exists**: Offers to delete/rename or use different name
- **Worktree exists**: Cleans up and retries with confirmation
- **Network issues**: Graceful degradation with offline mode
- **Auth failures**: Clear error messages with resolution steps

### Recovery Options
```bash
/worktree --cleanup                     # Remove orphaned worktrees
/worktree --status                      # List all active worktrees
/worktree [name] --force                # Force creation (overwrites existing)
```

## Configuration

### Default Settings
```yaml
# In shared/superclaude-commands.yml
worktree:
  default_base: main
  default_prefix: feature/
  auto_pr: true
  pr_template: ""
  naming_strategy: smart
```

### User Customization
```yaml
# In user's CLAUDE.md
worktree_config:
  base_branch: develop
  prefix: feat/
  auto_open_pr: false
  naming_pattern: "${prefix}${name}-$(date +%m%d)"
```

## Advanced Features

### Template Integration
```bash
/worktree api-endpoint --template rest      # Use REST API template
/worktree bug-fix --template hotfix         # Use hotfix template
```

### Batch Operations
```bash
/worktree --batch frontend backend database
# Creates: feature/frontend, feature/backend, feature/database
```

### Status Management
```bash
/worktree --list                           # List all worktrees
/worktree --cleanup                        # Remove merged worktrees
/worktree --archive [name]                 # Archive completed worktree
```

## Integration Points

### SuperClaude Commands
- Works with `/pr` command for advanced PR management
- Integrates with `/checkpoint` for project phase tracking
- Compatible with `/design` for feature planning

### Git Workflow
- Respects `.gitignore` and git hooks
- Maintains clean working tree requirements
- Supports custom git configurations

## Security Considerations

- Validates all user input for git safety
- Prevents directory traversal attacks
- Respects repository permissions
- Maintains audit trail of operations

## Prerequisites

### Required Tools
- Git (2.19+)
- GitHub CLI (`gh`)
- Active internet connection for remote operations

### Authentication
- GitHub CLI must be authenticated (`gh auth login`)
- Git remote must be configured for push operations
- Appropriate repository permissions required

## Troubleshooting

### Common Issues
1. **"Branch already exists"**: Use `--force` or choose different name
2. **"No GitHub auth"**: Run `gh auth login` first
3. **"Worktree path exists"**: Use `--cleanup` to remove orphaned worktrees
4. **"Network error"**: Check internet connection and GitHub status

### Debug Mode
```bash
/worktree [name] --debug                   # Enable verbose logging
/worktree [name] --trace                   # Full execution trace
```

## Related Commands

- `/pr` - Advanced PR management and templates
- `/checkpoint` - Project phase transitions
- `/design` - Feature design and planning
- Standard git commands for manual worktree management

---

**Risk Level**: 🟡 Medium - Creates new branches and PRs, modifies git state
**Complexity**: 🟡 Medium - Multi-step git workflow automation
**Maintenance**: 🟢 Low - Stable git and GitHub CLI dependencies

*Part of SuperClaude Advanced Git Workflow Suite*
# Fork Changes

This document tracks all custom changes made to this fork of [SuperClaude](https://github.com/NomenAK/SuperClaude).

## Overview

This fork extends the original SuperClaude framework with additional commands and enhancements focused on development workflow automation.

## New Commands Added

### 1. `/abort` - Emergency Session Exit
- **File**: `.claude/commands/abort.md`
- **Purpose**: Emergency session termination with recovery guidance
- **Added**: Commit 13d9aac

### 2. `/make-make` - Makefile and Workflow Automation
- **File**: `.claude/commands/make-make.md`
- **Purpose**: Generates Makefiles and GitHub Actions workflows
- **Added**: Commit b455571

### 3. `/next` - Smart Task Progression
- **File**: `.claude/commands/next.md`
- **Purpose**: Intelligent context-aware task automation
- **Added**: Implicit in index updates

### 4. `/pr` - Pull Request Automation
- **File**: `.claude/commands/pr.md`
- **Purpose**: Streamlines PR creation with automatic commit messages
- **Added**: Implicit in index updates

### 5. `/prompt` - Enhanced Context Management
- **File**: `.claude/commands/prompt.md`
- **Purpose**: Project context and prompt optimization
- **Added**: Implicit in index updates

### 6. `/pull-main` - Smart Branch Syncing
- **File**: `.claude/commands/pull-main.md`
- **Purpose**: Intelligently syncs current branch with main
- **Renamed from**: `/sync-upstream` (Commit a136dd7)
- **Added**: Commit 0430cf7

### 7. `/yolo-merge` - Automated PR Workflow
- **File**: `.claude/commands/yolo-merge.md`
- **Purpose**: Automatic commit, PR creation, and merge
- **Updated**: Commit 2a562a1 (changed to use PR workflow)
- **Added**: Commit 641741c

### 8. `/checkpoint` - Project Phase Transition
- **File**: `.claude/commands/checkpoint.md`
- **Purpose**: Audit and reorganize project planning documents during phase transitions
- **Features**:
  - Configurable phase definitions (--completed, --upcoming)
  - Isolated worktree workflow with audit trail
  - Smart detection of completed work from PRs, docs, and commits
  - Consolidation of duplicate plans with gap analysis
- **Added**: Commit da7a9b2 (PR #1)

## Infrastructure Enhancements

### Automated Fork Maintenance System
- **File**: `.github/workflows/sync-upstream.yml`
- **Purpose**: Professional fork maintenance with automated upstream synchronization
- **Features**:
  - Daily automated sync with upstream NomenAK/SuperClaude
  - Conflict detection and merge impact analysis
  - Security scanning of upstream changes
  - Automated tracking issue creation and management
  - Manual sync triggers for emergency updates
- **Branch Strategy**: 
  - `master` mirrors upstream exactly
  - `main` contains fork customizations
  - Proper git remote and tracking configuration
- **Monitoring**: PR #2 for continuous diff tracking
- **Added**: Infrastructure setup (Current session)

## New Features

### Smart Lint Hook
- **File**: `.claude/hooks/smart-lint.sh`
- **Purpose**: Intelligent linting with automatic fixes and caching
- **Features**:
  - Multi-language support
  - Automatic error fixing
  - Performance caching
  - Parallel processing


### Git Worktree Validation Hook
- **File**: `.claude/hooks/worktree-validator.sh`
- **Purpose**: Enforces git worktree organization by requiring all worktrees be created in `worktrees/` directory
- **Problem Solved**: Prevents scattered worktree creation and maintains project organization
- **Features**:
  - Intercepts `git worktree add` commands via PreCommand hook
  - Validates worktree path starts with `worktrees/`
  - Provides clear error messages with correct usage
  - Lightweight implementation with no side effects
- **Configuration**: Added to `~/.claude/settings.json` as PreCommand hook with `git worktree add.*` matcher
- **Added**: Current session

### Comprehensive Usage Guide
- **File**: `USAGE_GUIDE.md`
- **Purpose**: Detailed documentation for all features and workflows
- **Added**: Commit 4453561

## Documentation Updates

### CLAUDE.md
- Added fork maintenance rules
- Added new command documentation protocol
- Enhanced documentation standards

### COMMANDS.md
- Updated with all new commands
- Organized into categories
- Added command counts

### Command Index
- **File**: `.claude/commands/index.md`
- Updated total command count
- Added new commands to categories

## Installation Changes
- Modified `install.sh` for better portability
- **Enhanced install.sh with hooks installation**: Automatically installs hooks to global `~/.claude/hooks/` directory and configures `settings.json` during SuperClaude installation

## Development Philosophy

This fork maintains the core SuperClaude philosophy while adding:
- **Automation First**: Commands that reduce repetitive tasks
- **Developer Experience**: Workflow optimizations for faster development
- **Safety Mechanisms**: Emergency exits and smart syncing
- **Documentation**: Comprehensive guides and clear organization

## Fork Maintenance Infrastructure

### Automated Upstream Synchronization

**GitHub Actions Workflow**: `.github/workflows/sync-upstream.yml`
- **Schedule**: Daily sync at 8 AM UTC
- **Manual Trigger**: Available via GitHub Actions UI
- **Features**:
  - Automatic master branch sync with upstream
  - Conflict detection and analysis
  - Security scanning of upstream changes
  - Automated tracking issue creation
  - Merge impact assessment

### Branch Strategy

**Branch Structure**:
- `master` → Mirrors `NomenAK/SuperClaude` exactly (read-only)
- `main` → Development branch with fork customizations
- `feature/*` → Development branches for new features

**Git Configuration**:
```bash
# Remotes
origin    → https://github.com/emily-flambe/SuperClaude.git
upstream  → https://github.com/NomenAK/SuperClaude.git

# Branch tracking
master → upstream/master
main   → origin/main
```

### Pull Request Tracking

**PR #2: Fork Diff Tracking** (Always Open)
- **Purpose**: Shows all fork customizations vs upstream
- **Base**: `master` (upstream mirror)
- **Head**: `main` (fork customizations)
- **Usage**: Review fork additions, plan merges, maintain visibility

### Maintenance Procedures

**Daily Automated Process**:
1. GitHub Actions syncs `master` with upstream
2. Analyzes merge impact on `main`
3. Creates/updates tracking issues
4. Runs security scans on changes
5. Updates PR #2 with latest diff

**Manual Upstream Merge** (Weekly/Monthly):
```bash
# Sync master with upstream
git checkout master
git pull upstream master
git push origin master

# Merge upstream changes into main
git checkout main
git merge master
# Resolve conflicts (see strategy below)
git push origin main
```

**Emergency Sync**:
- Use GitHub Actions manual trigger
- Enable "force_sync" option for immediate sync
- Monitor tracking issues for conflict alerts

### Conflict Resolution Strategy

**Priority Matrix**:

| File Category | Resolution Strategy | Examples |
|---------------|-------------------|----------|
| **Fork Priority** | Always keep fork version | `CLAUDE.md`, `FORK_CHANGES.md`, custom commands |
| **Upstream Priority** | Accept upstream changes | Core SuperClaude functionality, bug fixes |
| **Manual Merge** | Case-by-case resolution | `README.md`, `COMMANDS.md`, shared documentation |

**Specific File Strategies**:

**Always Preserve (Fork Priority)**:
- `FORK_CHANGES.md` - Fork changelog
- `.claude/commands/checkpoint.md` - Custom commands
- `.claude/commands/yolo-merge.md`
- `.claude/commands/abort.md`
- `.claude/commands/pull-main.md`
- `.claude/commands/make-make.md`
- `.github/workflows/sync-upstream.yml`
- Fork maintenance sections in `CLAUDE.md`

**Review Carefully (Manual Resolution)**:
- `README.md` - May need introduction note about fork
- `COMMANDS.md` - Update counts while preserving new commands
- `.claude/commands/index.md` - Merge counts and references
- Core documentation that both branches modify

**Auto-Accept (Upstream Priority)**:
- Core SuperClaude system files
- Bug fixes and security updates
- New upstream features that don't conflict
- Shared configuration patterns

### Monitoring and Alerts

**Tracking Issues** (Auto-generated):
- Created for each upstream sync
- Include conflict analysis and merge instructions
- Labeled with `upstream-sync` and `maintenance`

**Security Scanning**:
- Automatic scan of all upstream changes
- Blocks sync if potential secrets detected
- Creates security alerts for manual review

**Health Checks**:
- Daily verification of branch sync status
- Automated conflict detection
- PR diff tracking for visibility

## Contributing

When adding new features to this fork:
1. Create the command file in `.claude/commands/[command].md`
2. Update `.claude/commands/index.md` (increment total count, add to categories)
3. Update `COMMANDS.md` (add to appropriate section, increment section count)
4. Update this file with the changes
5. Test thoroughly before deployment
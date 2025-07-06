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

## New Features

### Smart Lint Hook
- **File**: `.claude/hooks/smart-lint.sh`
- **Purpose**: Intelligent linting with automatic fixes and caching
- **Features**:
  - Multi-language support
  - Automatic error fixing
  - Performance caching
  - Parallel processing

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

## Development Philosophy

This fork maintains the core SuperClaude philosophy while adding:
- **Automation First**: Commands that reduce repetitive tasks
- **Developer Experience**: Workflow optimizations for faster development
- **Safety Mechanisms**: Emergency exits and smart syncing
- **Documentation**: Comprehensive guides and clear organization

## Maintenance

To keep this fork synchronized with upstream:
1. `master` branch tracks upstream exactly
2. `main` branch contains all custom changes
3. Regular merges from `master` to `main` preserve custom functionality
4. All custom commands are isolated in clearly marked files

## Contributing

When adding new features to this fork:
1. Create the command file in `.claude/commands/[command].md`
2. Update `.claude/commands/index.md` (increment total count, add to categories)
3. Update `COMMANDS.md` (add to appropriate section, increment section count)
4. Update this file with the changes
5. Test thoroughly before deployment
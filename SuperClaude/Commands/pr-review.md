---
allowed-tools: [Bash, Read, Grep, Glob, TodoWrite]
description: "AI-powered pull request review with GitHub integration"
---

# /sc:pr-review - AI-Powered Pull Request Review

## Purpose
Perform an intelligent, AI-powered review of a GitHub pull request that:
1. Checks for and uses `.github/copilot-instructions.md` review guidelines
2. Evaluates existing GitHub Copilot or bot comments for validity
3. Performs comprehensive code review following guidelines
4. Checks CI/CD status and incorporates failures into review
5. Posts categorized findings (CRITICAL, IMPORTANT, NON-BLOCKING) as PR comment

## Usage
```
/sc:pr-review PR=<number> [--repo owner/name] [--no-comment] [--guidelines path/to/file.md]
```

## Arguments
- `PR=<number>` - The pull request number to review (required)
- `--repo` - Repository in format owner/name (default: uses current repo)
- `--no-comment` - Perform review but don't post comment to GitHub (default: post comment)
- `--guidelines` - Custom path to guidelines file (default: .github/copilot-instructions.md)

## Features
### AI-Powered Review
- Uses review guidelines from repository (`.github/copilot-instructions.md`)
- Falls back to comprehensive default guidelines if not found
- Evaluates existing bot comments and determines their validity
- Provides specific, actionable feedback with line numbers
- Categorizes findings by severity

### Review Categories
- **CRITICAL**: Must fix before merge
  - Security vulnerabilities
  - Data loss risks
  - Breaking changes
  - Failed CI/CD checks
- **IMPORTANT**: Should be addressed
  - Performance issues
  - Missing tests
  - Poor error handling
  - Code quality concerns
- **NON-BLOCKING**: Nice to have
  - Style improvements
  - Minor optimizations
  - Documentation updates

### GitHub Integration
- Uses GitHub CLI for authentication
- Fetches complete PR context (diff, metadata, comments)
- Checks CI/CD status from GitHub Actions
- Posts formatted review comment directly to PR
- Preserves review history with timestamps

### Review Process
1. Fetches and applies repository-specific review guidelines
2. Analyzes existing bot comments (Copilot, etc.) for validity
3. Reviews code changes comprehensively
4. Checks CI/CD status and incorporates results
5. Generates categorized findings with clear TODOs
6. Posts professional review comment directly to PR (default behavior)

## Example Output
```
## 🤖 SuperClaude AI Code Review

**Pull Request:** #123
**Reviewed at:** 2024-01-20 15:30:00 UTC
**Review Type:** AI-Assisted with Guidelines

---

### Existing Bot Comments Evaluation
✓ Valid: "Missing error handling in API endpoint" - Incorporated into review
✗ Invalid: "Add semicolon" - Already fixed in latest commit

### CI/CD Status
❌ 2 checks failing:
- test-suite: TypeError in user.test.js
- build: Missing dependency @types/node

### Review Findings

#### 🚨 CRITICAL (Must fix before merge)
1. **Security Issue** - `api/auth.js:45`: Storing passwords in plain text
2. **CI/CD Failure** - Tests failing due to undefined variable

#### ⚠️ IMPORTANT (Should address)
1. **Missing Tests** - No test coverage for new UserService class
2. **Error Handling** - `api/users.js:78`: Unhandled promise rejection

#### 💡 NON-BLOCKING (Suggestions)
1. **Performance** - Consider caching user lookups in `getUser()`
2. **Code Style** - Inconsistent naming convention in variables

### Summary
This PR introduces good functionality but has critical security issues that must be addressed before merging. CI/CD is also failing and needs to be fixed.

---

*This review was performed by [SuperClaude](https://github.com/Shardj/SuperClaude) AI Code Review*
```

## Execution
This command performs the following steps:

1. **Fetch PR Information**: Use `gh pr view` to get PR metadata, files, and diff
2. **Check Guidelines**: Look for `.github/copilot-instructions.md` or use defaults
3. **Analyze CI/CD**: Check `gh pr checks` for test/build status
4. **Review Changes**: Analyze the diff for issues, categorize by severity
5. **Generate Review**: Create formatted review with findings
6. **Post Comment**: Use `gh pr comment` to post review to PR (unless `--no-comment`)

## Default Behavior
**By default, this command will post the review as a comment on the PR.** Use `--no-comment` if you only want to see the review locally without posting.

## Claude Code Integration
- Uses Bash to execute GitHub CLI commands
- Leverages native code analysis capabilities
- Posts results directly to GitHub
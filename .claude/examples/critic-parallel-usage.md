# Critic Parallel Usage Examples

## Basic Usage

### 1. Simple Parallel Critique
```bash
# Using existing persona with parallel flag
/analyze --persona-critic --parallel

# This automatically spawns:
# - Security critic subagent
# - Performance critic subagent  
# - Architecture critic subagent
# - Code quality critic subagent
# All running simultaneously
```

### 2. Using the Dedicated Command
```bash
# Full parallel analysis
/critic-parallel analyze-project

# Focused analysis
/critic-parallel --focus security,performance src/
```

## Integration with Existing Workflow

### Before (Sequential)
```bash
# Traditional approach - takes ~20 minutes
/analyze --persona-critic --security
/analyze --persona-critic --performance
/analyze --persona-critic --architecture
/analyze --persona-critic --quality
```

### After (Parallel)
```bash
# New approach - takes ~5 minutes
/analyze --persona-critic --parallel

# Or use the dedicated command
/critic-parallel analyze-codebase
```

## Advanced Patterns

### 1. PR Review Workflow
```bash
# Parallel critic review of PR changes
/review --pr 123 --persona-critic --parallel

# Or with the dedicated command
/critic-parallel --pr 123 --webhook $SLACK_WEBHOOK
```

### 2. Incremental Analysis
```bash
# Only analyze what changed
/critic-parallel --incremental --since HEAD~5
```

### 3. Collaborative Fix Cycle
```bash
# Critics work with other personas
/critic-parallel --collaborative --with analyzer,refactorer
```

## Behind the Scenes

When you use `--persona-critic --parallel`, SuperClaude:

1. **Spawns subagents** using the `/spawn` command internally
2. **Distributes work** across specialized critics
3. **Runs analysis concurrently** for 5x speed improvement
4. **Aggregates results** into unified report
5. **Prioritizes findings** by severity and consensus

## Example Output

```markdown
# Parallel Critic Analysis Report

## Executive Summary
- Total Issues: 147 (found in 4.2 minutes)
- Critical: 12 (consensus from 3+ critics)
- High: 34
- Medium: 67
- Low: 34

## Consensus Critical Issues
1. **SQL Injection + Performance Risk**
   - Flagged by: Security, Performance, Architecture Critics
   - Location: `src/db/queries.ts:45`
   - Fix: Parameterized queries with connection pooling

2. **Memory Leak + Architecture Flaw**
   - Flagged by: Performance, Architecture Critics
   - Location: `src/cache/manager.ts:89`
   - Fix: Implement proper cleanup lifecycle
```

## Tips for Best Results

1. **Use for large codebases** - Parallel mode shines with 1000+ lines
2. **Focus when needed** - Use `--focus` to reduce noise
3. **Combine with fixes** - Follow up with `/improve` or `/refactor`
4. **Monitor performance** - Check execution times in report
5. **Iterate based on findings** - Use incremental mode for continuous improvement
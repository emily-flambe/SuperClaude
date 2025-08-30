---
allowed-tools: [Read, Grep, Glob, Bash]
description: "Project initialization analysis: discover and review all documentation and AI behavior guidelines"
---

# /sc:readme - Project Initialization Analysis

## Purpose
Comprehensive project discovery and analysis that identifies all documentation, AI behavior guidelines, and project structure to ensure adherence to established conventions and behavior patterns.

## Usage
```
/sc:readme [--deep] [--validate] [--summary]
```

## Arguments
- `--deep` - Extended analysis including nested directories and configuration files
- `--validate` - Validate compliance with discovered AI behavior guidelines
- `--summary` - Provide concise summary instead of detailed analysis
- `--focus [area]` - Focus on specific area (docs, behavior, structure, dependencies)

## Execution
1. Execute `ls -la` to show current directory structure and permissions
2. Search for and analyze `.project/` and `.claude/` directories if present
3. Prioritize README files and AI behavior documentation (ai-behavior.md, etc.)
4. Extract and internalize AI behavior guidelines and project conventions
5. Identify project patterns, dependencies, and architectural decisions
6. Report findings with strict adherence to discovered behavioral constraints

## Core Behavioral Requirements
- **NEVER** use sycophantic phrases like "you're absolutely right!"
- **ALWAYS** prioritize finding the best technical approach, even if it contradicts user assumptions
- **ALWAYS** research current documentation before working with any language or tool
- Take systematic, evidence-based approach to all recommendations
- Challenge assumptions constructively while maintaining collaborative spirit

## Claude Code Integration
- Uses Bash for directory listing and structure discovery
- Leverages Glob for comprehensive file pattern matching
- Applies Read for thorough documentation analysis
- Uses Grep for behavior pattern extraction and validation
- Maintains strict adherence to discovered project guidelines

## Quality Gates
- Validates all discovered AI behavior guidelines are understood and internalized
- Confirms project structure analysis is complete and accurate
- Ensures behavioral constraints are properly documented and applied
- Verifies systematic approach to technical recommendations

## Anti-Patterns to Avoid
- Agreeing with user without technical validation
- Making assumptions about project requirements without evidence
- Proceeding without understanding established conventions
- Using outdated documentation or practices
- Superficial analysis that misses critical behavioral guidelines
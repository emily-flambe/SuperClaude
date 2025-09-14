# COMMANDS.md - SuperClaude Command Execution Framework

Command execution framework for Claude Code SuperClaude integration.

## Command System Architecture

### Core Command Structure
```yaml
---
command: "/{command-name}"
category: "Primary classification"
purpose: "Operational objective"
performance-profile: "optimization|standard|complex"
---
```

### Command Processing Pipeline
1. **Input Parsing**: `$ARGUMENTS` with `@<path>`, `!<command>`, `--<flags>`
2. **Context Resolution**: Auto-persona activation and MCP server selection
3. **Execution Strategy**: Tool orchestration and resource allocation
4. **Quality Gates**: Validation checkpoints and error handling

### Integration Layers
- **Claude Code**: Native slash command compatibility
- **Persona System**: Auto-activation based on command context
- **MCP Servers**: Context7, Sequential, Magic, Playwright integration

## Active Commands

### Analysis & Investigation

**`/analyze $ARGUMENTS`**
```yaml
---
command: "/analyze"
category: "Analysis & Investigation"
purpose: "Multi-dimensional code and system analysis"
performance-profile: "complex"
---
```
- **Auto-Persona**: Analyzer, Architect, Security
- **MCP Integration**: Sequential (primary), Context7 (patterns), Magic (UI analysis)
- **Tool Orchestration**: [Read, Grep, Glob, Bash, TodoWrite]
- **Arguments**: `[target]`, `@<path>`, `!<command>`, `--<flags>`

**`/troubleshoot [symptoms] [flags]`**
```yaml
---
command: "/troubleshoot"
category: "Analysis & Investigation"
purpose: "Problem investigation and root cause analysis"
performance-profile: "standard"
---
```
- **Auto-Persona**: Analyzer, QA
- **MCP Integration**: Sequential, Playwright
- **Tool Orchestration**: [Read, Grep, Bash, TodoWrite]
- **Arguments**: `[symptoms]`, `--depth`, `--focus`, `--<flags>`

### Development & Implementation

**`/implement $ARGUMENTS`**
```yaml
---
command: "/implement"
category: "Development & Implementation"
purpose: "Feature and code implementation"
performance-profile: "standard"
---
```
- **Auto-Persona**: Frontend, Backend, Architect, Security (context-dependent)
- **MCP Integration**: Magic (UI components), Context7 (patterns), Sequential (complex logic)
- **Tool Orchestration**: [Read, Write, Edit, MultiEdit, Bash, Glob, TodoWrite, Task]
- **Arguments**: `[feature-description]`, `--type component|api|service|feature`, `--framework <name>`, `--<flags>`

**`/prompt [request]`**
```yaml
---
command: "/prompt"
category: "Development & Implementation"
purpose: "Prompt optimization and scaffolding translator"
performance-profile: "optimization"
---
```
- **Auto-Persona**: Context-aware based on request type
- **MCP Integration**: Sequential (scaffolding), Context7 (best practices)
- **Tool Orchestration**: [Read, Grep, TodoWrite]
- **Arguments**: `[casual-request]`
- **Special Feature**: Translates casual requests into scaffolded prompts and executes immediately

### Documentation

**`/document [target] [flags]`**
```yaml
---
command: "/document"
category: "Documentation"
purpose: "Documentation generation and maintenance"
performance-profile: "standard"
---
```
- **Auto-Persona**: Scribe, Mentor
- **MCP Integration**: Context7, Sequential
- **Tool Orchestration**: [Read, Write, Edit, TodoWrite]
- **Arguments**: `[target]`, `--format`, `--audience`, `--<flags>`

**`/readme [flags]`**
```yaml
---
command: "/readme"
category: "Documentation"
purpose: "Project README analysis and generation"
performance-profile: "standard"
---
```
- **Auto-Persona**: Analyzer, Mentor
- **MCP Integration**: Sequential
- **Tool Orchestration**: [Read, Write, Edit, Grep]
- **Arguments**: `--analyze`, `--generate`, `--update`, `--<flags>`

### Code Quality & Maintenance

**`/cleanup [target] [flags]`**
```yaml
---
command: "/cleanup"
category: "Quality & Maintenance"
purpose: "Project cleanup and technical debt reduction"
performance-profile: "optimization"
---
```
- **Auto-Persona**: Refactorer
- **MCP Integration**: Sequential
- **Tool Orchestration**: [Read, Grep, Edit, MultiEdit, Bash]
- **Arguments**: `[target]`, `--type`, `--aggressive`, `--<flags>`

### Git Operations

**`/git-cleanup [flags]`**
```yaml
---
command: "/git-cleanup"
category: "Version Control"
purpose: "Git repository cleanup and maintenance"
performance-profile: "standard"
---
```
- **Auto-Persona**: DevOps
- **MCP Integration**: Sequential
- **Tool Orchestration**: [Bash, Read, TodoWrite]
- **Arguments**: `--branches`, `--tags`, `--history`, `--<flags>`

**`/pr-review [pr-url] [flags]`**
```yaml
---
command: "/pr-review"
category: "Version Control"
purpose: "Pull request review and analysis"
performance-profile: "complex"
---
```
- **Auto-Persona**: Critic, QA, Security
- **MCP Integration**: Sequential, Context7
- **Tool Orchestration**: [Read, Grep, Bash, TodoWrite]
- **Arguments**: `[pr-url]`, `--focus`, `--depth`, `--<flags>`

## Command Execution Matrix

### Performance Profiles
```yaml
optimization: "High-performance with caching and parallel execution"
standard: "Balanced performance with moderate resource usage"
complex: "Resource-intensive with comprehensive analysis"
```

### Command Categories
- **Analysis**: analyze, troubleshoot
- **Development**: implement, prompt
- **Documentation**: document, readme
- **Maintenance**: cleanup, git-cleanup
- **Review**: pr-review

### Integration Patterns
- All commands support standard SuperClaude flags
- Persona auto-activation based on command context
- MCP servers activate based on task requirements
- Quality gates apply to all operations
# SuperClaude Usage Guide

> **A comprehensive guide to mastering SuperClaude for efficient AI-assisted development**

## Table of Contents
1. [Getting Started](#getting-started)
2. [Core Architecture](#core-architecture) 
3. [Command Reference](#command-reference)
4. [Persona-Driven Development](#persona-driven-development)
5. [Complete Developer Workflows](#complete-developer-workflows)
6. [Advanced Features](#advanced-features)
7. [Best Practices & Troubleshooting](#best-practices--troubleshooting)

---

## Getting Started

### Installation & Setup

**Quick Installation:**
```bash
git clone https://github.com/NomenAK/SuperClaude.git
cd SuperClaude
./install.sh
```

**Verify Installation:**
```bash
/build --help
# Should show SuperClaude build command documentation
```

**Advanced Installation Options:**
```bash
./install.sh --dir /opt/claude        # Custom location
./install.sh --update                 # Update existing installation
./install.sh --dry-run --verbose      # Preview changes
```

### Your First Command

Start with a simple React app to see SuperClaude in action:

```bash
/build --react --magic --persona-frontend
```

This command:
- Creates a React application (`--react`)
- Generates AI-powered components (`--magic`)
- Uses frontend expertise (`--persona-frontend`)

### Essential Concepts

**Commands**: 19 specialized tools for different development tasks
**Personas**: 9 cognitive experts that provide domain-specific knowledge
**Flags**: Universal modifiers that work across all commands

### Quick Reference Card

**Most Common Patterns:**
```bash
# Quick project setup
/build --fullstack --tdd --magic

# Code review and improvement
/review --quality --evidence
/improve --quality --refactor

# Production troubleshooting
/troubleshoot --prod --five-whys
/analyze --profile --perf

# Security audit
/scan --security --owasp --persona-security
```

---

## Core Architecture

### Command System (19 Commands)

SuperClaude commands are organized into 4 categories:

**Development Commands (4):**
- `/build` - Universal project builder
- `/dev-setup` - Development environment configuration
- `/test` - Comprehensive testing framework
- `/make-make` - Makefile and workflow automation

**Analysis & Improvement Commands (5):**
- `/review` - AI-powered code review
- `/analyze` - Multi-dimensional analysis
- `/troubleshoot` - Systematic debugging
- `/improve` - Enhancement and optimization
- `/explain` - Technical documentation

**Operations Commands (9):**
- `/deploy` - Safe deployment with rollback
- `/migrate` - Database and code migrations
- `/scan` - Security auditing and compliance
- `/estimate` - Project estimation with risk assessment
- `/cleanup` - Project maintenance
- `/git` - Git workflow management
- `/yolo-merge` - Automatic commit/PR/merge (dangerous)
- `/abort` - Emergency session exit
- `/pull-main` - Merge main into current branch

**Design Commands (1):**
- `/design` - System architecture design

### Persona System (9 Cognitive Experts)

Each persona provides specialized knowledge and thinking patterns:

| Persona | Flag | Expertise | Best For |
|---------|------|-----------|----------|
| **Architect** | `--persona-architect` | Systems, scalability, patterns | Architecture decisions |
| **Frontend** | `--persona-frontend` | UI/UX, accessibility, performance | User interfaces |
| **Backend** | `--persona-backend` | APIs, databases, reliability | Server architecture |
| **Analyzer** | `--persona-analyzer` | Root cause analysis, evidence | Complex debugging |
| **Security** | `--persona-security` | Threat modeling, OWASP | Security audits |
| **Mentor** | `--persona-mentor` | Teaching, guided learning | Documentation |
| **Refactorer** | `--persona-refactorer` | Code quality, maintainability | Code cleanup |
| **Performance** | `--persona-performance` | Optimization, profiling | Performance tuning |
| **QA** | `--persona-qa` | Testing, edge cases | Quality assurance |

### Universal Flags

**Thinking Depth Control:**
```bash
--think           # Multi-file analysis (~4K tokens)
--think-hard      # Architecture-level analysis (~10K tokens)
--ultrathink      # Critical system analysis (~32K tokens)
```

**Token Optimization:**
```bash
--uc              # UltraCompressed mode (70% token reduction)
--ultracompressed # Same as --uc
```

**MCP Server Control:**
```bash
--c7              # Context7 documentation lookup
--seq             # Sequential thinking analysis
--magic           # Magic UI component generation
--pup             # Puppeteer browser automation
--all-mcp         # Enable all MCP servers
--no-mcp          # Disable all MCP servers
```

**Quality & Planning:**
```bash
--plan            # Show execution plan before running
--dry-run         # Preview changes without execution
--validate        # Enhanced safety checks
--introspect      # Deep transparency mode
```

---

## Command Reference

### Development Commands

#### `/build` - Universal Project Builder

**Basic Usage:**
```bash
/build --react                    # React application
/build --api --go                 # Go API server
/build --fullstack --tdd          # Full-stack with TDD
/build --mobile --react-native    # Mobile app
/build --cli --go                 # CLI application
```

**Advanced Options:**
```bash
/build --react --magic --persona-frontend --think-hard
# React app with AI components, frontend expertise, deep thinking
```

**Stack Templates:**
- `--react` - React frontend
- `--api` - API server
- `--fullstack` - Complete application
- `--mobile` - Mobile application
- `--cli` - Command-line interface

#### `/dev-setup` - Development Environment

**Basic Setup:**
```bash
/dev-setup --ci --monitor --testing
```

**Advanced Configuration:**
```bash
/dev-setup --docker --k8s --persona-backend --validate
```

#### `/test` - Comprehensive Testing

**Test Types:**
```bash
/test --unit --coverage           # Unit tests with coverage
/test --integration --e2e         # Integration and end-to-end
/test --performance --load        # Performance testing
/test --security --fuzzing        # Security testing
```

**Advanced Testing:**
```bash
/test --coverage --e2e --pup --persona-qa --think-hard
# Full test suite with browser automation and QA expertise
```

### Analysis & Improvement Commands

#### `/review` - AI-Powered Code Review

**Quality Review:**
```bash
/review --quality --evidence --persona-refactorer
```

**Security Review:**
```bash
/review --security --owasp --persona-security
```

**Performance Review:**
```bash
/review --performance --profile --persona-performance
```

#### `/analyze` - Multi-Dimensional Analysis

**Code Analysis:**
```bash
/analyze --code --architecture --persona-architect
```

**Performance Analysis:**
```bash
/analyze --profile --deep --persona-performance --pup
```

**Security Analysis:**
```bash
/analyze --security --forensic --persona-security --seq
```

#### `/troubleshoot` - Systematic Debugging

**Production Issues:**
```bash
/troubleshoot --prod --five-whys --persona-analyzer
```

**Performance Issues:**
```bash
/troubleshoot --perf --investigate --persona-performance
```

**Integration Issues:**
```bash
/troubleshoot --integration --dependencies --c7
```

### Operations Commands

#### `/deploy` - Safe Deployment

**Staging Deployment:**
```bash
/deploy --env staging --validate --persona-backend
```

**Production Deployment:**
```bash
/deploy --env prod --rollback --monitor --validate
```

**Rollback:**
```bash
/deploy --rollback --env prod --validate
```

#### `/scan` - Security Auditing

**Security Scan:**
```bash
/scan --security --owasp --deps --persona-security
```

**Compliance Scan:**
```bash
/scan --compliance --gdpr --hipaa --validate
```

**Vulnerability Scan:**
```bash
/scan --vulns --critical --persona-security --seq
```

---

## Persona-Driven Development

### Architect Workflows

**System Design:**
```bash
/design --api --ddd --persona-architect --ultrathink
/analyze --architecture --scalability --persona-architect
/review --architecture --patterns --persona-architect
```

**Use Cases:**
- Designing microservices architecture
- Planning system scalability
- Reviewing architectural decisions
- Creating technical specifications

### Frontend Specialist Workflows

**UI Development:**
```bash
/build --react --magic --persona-frontend --think-hard
/review --ui --accessibility --persona-frontend
/test --e2e --visual --persona-frontend --pup
```

**Use Cases:**
- Building responsive user interfaces
- Implementing accessibility features
- Creating design systems
- Optimizing frontend performance

### Backend Specialist Workflows

**API Development:**
```bash
/build --api --go --persona-backend --think-hard
/design --api --rest --persona-backend
/test --api --load --persona-backend
```

**Use Cases:**
- Building scalable APIs
- Designing database schemas
- Implementing authentication systems
- Creating microservices

### Security-First Development

**Security Workflow:**
```bash
/scan --security --owasp --persona-security
/analyze --security --forensic --persona-security --seq
/review --security --threats --persona-security
/improve --security --validate --persona-security
```

**Use Cases:**
- Conducting security audits
- Implementing threat modeling
- Fixing security vulnerabilities
- Ensuring compliance requirements

### Performance Optimization

**Performance Workflow:**
```bash
/analyze --profile --deep --persona-performance --pup
/troubleshoot --perf --investigate --persona-performance
/improve --performance --optimize --persona-performance
/test --performance --load --persona-performance
```

**Use Cases:**
- Identifying performance bottlenecks
- Optimizing database queries
- Improving application response times
- Conducting load testing

---

## Complete Developer Workflows

### Full-Stack Development Workflow

**Complete Feature Development:**
```bash
# 1. Design Phase
/design --api --ddd --persona-architect --ultrathink

# 2. Implementation Phase
/build --fullstack --tdd --magic --persona-frontend

# 3. Testing Phase
/test --coverage --e2e --pup --persona-qa

# 4. Deployment Phase
/deploy --env staging --validate --persona-backend
```

**Use Case: Building a User Authentication System**
```bash
# Step 1: Architecture Design
/design --api --auth --security --persona-architect --ultrathink

# Step 2: Backend Implementation
/build --api --go --jwt --persona-backend --think-hard

# Step 3: Frontend Implementation
/build --react --auth --magic --persona-frontend

# Step 4: Security Review
/scan --security --owasp --auth --persona-security

# Step 5: Testing
/test --integration --security --e2e --pup

# Step 6: Deployment
/deploy --env staging --validate --monitor
```

### Code Quality Enhancement Workflow

**Complete Quality Improvement:**
```bash
# 1. Initial Review
/review --quality --evidence --persona-refactorer

# 2. Deep Analysis
/analyze --code --technical-debt --persona-analyzer --seq

# 3. Improvements
/improve --quality --refactor --iterate --persona-refactorer

# 4. Validation
/test --coverage --mutation --persona-qa
```

**Use Case: Legacy Code Modernization**
```bash
# Step 1: Assess Current State
/analyze --code --legacy --technical-debt --persona-analyzer

# Step 2: Create Modernization Plan
/design --refactor --migration --persona-architect --ultrathink

# Step 3: Systematic Refactoring
/improve --modernize --patterns --persona-refactorer --iterate

# Step 4: Quality Validation
/review --quality --evidence --persona-qa
/test --coverage --regression --persona-qa

# Step 5: Performance Validation
/analyze --profile --performance --persona-performance
```

### Production Issue Resolution Workflow

**Critical Issue Response:**
```bash
# 1. Immediate Assessment
/troubleshoot --prod --critical --persona-analyzer --ultrathink

# 2. Root Cause Analysis
/analyze --profile --forensic --persona-performance --seq

# 3. Emergency Fix
/improve --hotfix --validate --persona-backend

# 4. Rollback if Needed
/deploy --rollback --env prod --validate
```

**Use Case: Database Performance Issue**
```bash
# Step 1: Identify the Problem
/troubleshoot --prod --database --five-whys --persona-analyzer

# Step 2: Analyze Database Performance
/analyze --profile --database --queries --persona-performance --pup

# Step 3: Optimize Queries
/improve --database --optimize --indexes --persona-performance

# Step 4: Test Performance
/test --performance --database --load --persona-performance

# Step 5: Deploy Fix
/deploy --env prod --validate --monitor --persona-backend
```

### Security-First Development Workflow

**Complete Security Implementation:**
```bash
# 1. Security Assessment
/scan --security --owasp --comprehensive --persona-security

# 2. Threat Analysis
/analyze --security --threats --forensic --persona-security --seq

# 3. Security Improvements
/improve --security --implement --validate --persona-security

# 4. Security Testing
/test --security --penetration --fuzzing --persona-security
```

**Use Case: Implementing Zero-Trust Architecture**
```bash
# Step 1: Current Security Analysis
/analyze --security --architecture --zero-trust --persona-security

# Step 2: Design Zero-Trust Implementation
/design --security --zero-trust --persona-architect --ultrathink

# Step 3: Implement Authentication & Authorization
/build --auth --rbac --mfa --persona-security --think-hard

# Step 4: Network Security
/improve --network --security --micro-segmentation --persona-security

# Step 5: Monitoring & Compliance
/scan --compliance --monitor --continuous --persona-security
```

---

## Advanced Features

### MCP Integration

**Context7 - Documentation Lookup:**
```bash
/review --quality --evidence --c7
# Automatically looks up best practices and documentation
```

**Sequential - Complex Analysis:**
```bash
/analyze --architecture --complex --seq
# Provides step-by-step analytical thinking
```

**Magic - AI Component Generation:**
```bash
/build --react --magic --persona-frontend
# Generates intelligent UI components
```

**Puppeteer - Browser Automation:**
```bash
/test --e2e --visual --pup
# Automated browser testing and validation
```

**All MCP Servers:**
```bash
/troubleshoot --prod --all-mcp --persona-analyzer
# Maximum AI capability for complex issues
```

### Multi-Agent Workflows

**Parallel Development:**
```bash
/build --fullstack --spawn-agents --persona-architect
# Spawns multiple agents for different parts of the application
```

**Complex Analysis:**
```bash
/analyze --comprehensive --spawn-agents --all-mcp
# Uses multiple agents for different analysis dimensions
```

### Token Optimization

**UltraCompressed Mode:**
```bash
/build --react --uc --persona-frontend
# 70% token reduction for large projects
```

**Thinking Depth Control:**
```bash
# Light analysis
/analyze --code --think

# Deep analysis
/analyze --architecture --think-hard

# Critical analysis
/analyze --security --ultrathink
```

### Team Collaboration

**Shared Workflows:**
```bash
# Create team configuration
/dev-setup --team --shared-config --persona-architect

# Team code review
/review --team --evidence --persona-refactorer --c7

# Team deployment
/deploy --team --validation --env staging
```

**Documentation Generation:**
```bash
/explain --architecture --team --persona-mentor --c7
# Generates team documentation with official references
```

---

## Best Practices & Troubleshooting

### Command Chaining Best Practices

**Effective Sequences:**
```bash
# Quality-First Development
/review --quality --evidence → /improve --quality --refactor → /test --coverage

# Security-First Development
/scan --security --owasp → /analyze --security --forensic → /improve --security

# Performance-First Development
/analyze --profile --perf → /troubleshoot --perf → /improve --performance
```

**Anti-Patterns to Avoid:**
```bash
# DON'T: Skip analysis before improvement
/improve --performance  # Without analysis

# DO: Analyze first, then improve
/analyze --profile --perf → /improve --performance
```

### Error Recovery

**Common Issues and Solutions:**

**1. MCP Server Connection Issues:**
```bash
# Problem: MCP servers not responding
# Solution: Reset MCP connections
/troubleshoot --mcp --reset --validate
```

**2. Performance Issues:**
```bash
# Problem: Commands taking too long
# Solution: Use UltraCompressed mode
/analyze --code --uc --think
```

**3. Token Limit Exceeded:**
```bash
# Problem: Complex analysis hits token limits
# Solution: Break down into smaller chunks
/analyze --code --files src/components/ --uc
/analyze --code --files src/utils/ --uc
```

### Performance Tips

**Optimization Strategies:**

**1. Choose Appropriate Thinking Depth:**
```bash
# Simple tasks
/review --quality --think

# Complex tasks
/analyze --architecture --think-hard

# Critical tasks
/design --security --ultrathink
```

**2. Selective MCP Usage:**
```bash
# For documentation tasks
/explain --architecture --c7

# For analysis tasks
/analyze --complex --seq

# For UI tasks
/build --react --magic

# For testing tasks
/test --e2e --pup
```

**3. Use UltraCompressed Mode:**
```bash
# For large codebases
/analyze --comprehensive --uc --persona-analyzer
```

### Security Guidelines

**Safe Development Practices:**

**1. Always Validate Before Deployment:**
```bash
/deploy --env staging --validate --persona-security
```

**2. Regular Security Scans:**
```bash
/scan --security --owasp --deps --persona-security
```

**3. Use Dry-Run for Dangerous Operations:**
```bash
/yolo-merge --dry-run --validate
```

**4. Emergency Procedures:**
```bash
# Emergency rollback
/deploy --rollback --env prod --validate

# Emergency abort
/abort --emergency --document
```

### Troubleshooting Common Scenarios

**Scenario 1: Build Failures**
```bash
# Debug build issues
/troubleshoot --build --dependencies --persona-analyzer

# Analyze build configuration
/analyze --build --config --persona-backend

# Fix build issues
/improve --build --fix --validate
```

**Scenario 2: Test Failures**
```bash
# Debug test issues
/troubleshoot --tests --flaky --persona-qa

# Analyze test coverage
/analyze --tests --coverage --persona-qa

# Improve test quality
/improve --tests --quality --persona-qa
```

**Scenario 3: Performance Problems**
```bash
# Profile performance
/analyze --profile --deep --persona-performance --pup

# Identify bottlenecks
/troubleshoot --perf --bottlenecks --persona-performance

# Optimize performance
/improve --performance --optimize --persona-performance
```

---

## Conclusion

SuperClaude provides a comprehensive framework for AI-assisted development that scales from simple tasks to complex enterprise workflows. By combining specialized commands, cognitive personas, and intelligent automation, it enables developers to work more efficiently while maintaining high quality standards.

**Key Takeaways:**
- Start with simple commands and gradually adopt more complex workflows
- Use personas to get domain-specific expertise
- Combine commands into workflows for maximum efficiency
- Leverage MCP integration for enhanced capabilities
- Always validate and test before deployment

**Next Steps:**
1. Practice with the quick reference examples
2. Experiment with different persona combinations
3. Create your own workflow patterns
4. Contribute to the SuperClaude community

For more information, visit the [SuperClaude GitHub repository](https://github.com/NomenAK/SuperClaude).

---

*SuperClaude Usage Guide v1.0 | Comprehensive developer workflow documentation*
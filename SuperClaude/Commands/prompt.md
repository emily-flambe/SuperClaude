# /prompt Command Reference

## Overview

The `/prompt` command provides an intelligent prompting system for Claude Code, offering structured prompt templates, context management, and persona-aware prompt optimization.

## Command Syntax

```bash
/prompt [operation] [template] [flags]
```

## Core Operations

### 1. Generate Prompts
```bash
/prompt generate [type] --context [domain]
```
- **Types**: feature, debug, refactor, review, test, document
- **Context**: Automatically includes relevant project context
- **Output**: Optimized prompt with context, constraints, and expected outcomes

### 2. Template Management
```bash
/prompt template [action] [name]
```
- **Actions**: create, list, apply, edit, delete
- **Templates**: Reusable prompt patterns for common tasks
- **Customization**: Domain-specific variables and placeholders

### 3. Context Injection
```bash
/prompt context [scope] --include [elements]
```
- **Scope**: file, module, project, system
- **Elements**: dependencies, tests, documentation, history
- **Smart Selection**: Auto-includes relevant context based on task

### 4. Persona-Optimized Prompts
```bash
/prompt with-persona [persona] [task]
```
- **Personas**: architect, frontend, backend, security, qa, etc.
- **Optimization**: Tailors prompt to persona's expertise and priorities
- **Auto-Selection**: Suggests best persona based on task type

## Prompt Templates

### Feature Implementation
```yaml
template: feature_implementation
variables:
  - feature_name: Required feature identifier
  - requirements: Functional requirements
  - constraints: Technical constraints
  - acceptance_criteria: Success metrics
context:
  - existing_patterns: Similar implementations
  - dependencies: Required modules
  - test_requirements: Coverage expectations
```

### Bug Investigation
```yaml
template: bug_investigation
variables:
  - symptoms: Observable issues
  - reproduction_steps: How to reproduce
  - expected_behavior: What should happen
  - actual_behavior: What actually happens
context:
  - error_logs: Recent error messages
  - recent_changes: Git history
  - related_tests: Test failures
```

### Code Review
```yaml
template: code_review
variables:
  - review_focus: security|performance|quality|architecture
  - severity_level: critical|high|medium|low
  - review_depth: surface|standard|deep
context:
  - pr_changes: Modified files
  - test_coverage: Coverage reports
  - standards: Coding standards
```

## Intelligent Features

### 1. Context-Aware Enhancement
- **Auto-Context**: Automatically includes relevant files and dependencies
- **Smart Boundaries**: Determines optimal context scope
- **History Integration**: Includes relevant git history and past decisions
- **Relationship Mapping**: Identifies and includes related components

### 2. Constraint Specification
- **Technical Constraints**: Framework versions, compatibility requirements
- **Business Constraints**: Performance budgets, deadlines, regulations
- **Quality Constraints**: Test coverage, code quality metrics
- **Security Constraints**: Compliance requirements, vulnerability limits

### 3. Output Formatting
- **Structured Responses**: Define expected response format
- **Validation Criteria**: Specify how to validate the response
- **Example Outputs**: Provide sample expected outputs
- **Error Handling**: Define error response patterns

## Advanced Usage

### Multi-Stage Prompting
```bash
/prompt chain [stage1] -> [stage2] -> [stage3]
```
- **Sequential Processing**: Each stage builds on previous
- **Context Propagation**: Results flow between stages
- **Conditional Branches**: Different paths based on outcomes
- **Rollback Support**: Revert to previous stages if needed

### Prompt Optimization
```bash
/prompt optimize [existing_prompt] --for [goal]
```
- **Goals**: clarity, specificity, brevity, completeness
- **Analysis**: Identifies ambiguities and gaps
- **Enhancement**: Suggests improvements
- **Validation**: Checks against best practices

### Batch Prompting
```bash
/prompt batch [template] --items [list]
```
- **Parallel Processing**: Generate multiple prompts efficiently
- **Variable Substitution**: Apply template to multiple items
- **Consistency**: Ensures uniform approach across items
- **Result Aggregation**: Combines outputs intelligently

## Integration with SuperClaude

### Persona Integration
- **Auto-Activation**: Suggests relevant personas based on prompt content
- **Persona Optimization**: Adjusts language and focus for selected persona
- **Cross-Persona**: Enables multi-persona collaboration prompts

### MCP Server Integration
- **Context7**: Includes library documentation in prompts
- **Sequential**: Structures complex multi-step prompts
- **Magic**: Enhances UI/component generation prompts
- **Playwright**: Adds test context to prompts

### Flag Support
- `--think`: Adds analytical depth to prompts
- `--validate`: Includes validation criteria
- `--uc`: Generates compressed prompts
- `--persona-[name]`: Optimizes for specific persona

## Best Practices

### 1. Prompt Structure
- **Clear Objective**: State the goal explicitly
- **Specific Context**: Include relevant background
- **Constraints**: Define boundaries and limitations
- **Success Criteria**: Specify expected outcomes

### 2. Context Management
- **Minimal Necessary**: Include only relevant context
- **Structured Format**: Organize context logically
- **Fresh Context**: Update stale information
- **Privacy Aware**: Exclude sensitive data

### 3. Template Design
- **Reusable Patterns**: Create templates for repeated tasks
- **Variable Placeholders**: Use clear, descriptive variables
- **Documentation**: Document template purpose and usage
- **Version Control**: Track template changes

## Examples

### Example 1: Feature Implementation Prompt
```bash
/prompt generate feature --name "user-authentication" --context security
```

### Example 2: Debug Investigation
```bash
/prompt generate debug --symptoms "API timeout" --include logs,traces
```

### Example 3: Code Review Request
```bash
/prompt with-persona critic review --focus security --depth deep
```

### Example 4: Documentation Generation
```bash
/prompt template apply technical-doc --component "AuthService"
```

### Example 5: Multi-Stage Refactoring
```bash
/prompt chain analyze -> plan -> implement --target "legacy-module"
```

## Error Handling

### Common Issues
- **Insufficient Context**: Prompt requests more context
- **Ambiguous Requirements**: Prompt asks for clarification
- **Conflicting Constraints**: Prompt identifies conflicts
- **Missing Dependencies**: Prompt lists requirements

### Recovery Strategies
- **Context Expansion**: Automatically add related files
- **Clarification Prompts**: Generate follow-up questions
- **Constraint Resolution**: Suggest compromise solutions
- **Dependency Resolution**: Identify and include dependencies

## Performance Optimization

### Token Efficiency
- **Smart Truncation**: Remove redundant context
- **Compression**: Use abbreviated formats when appropriate
- **Caching**: Reuse computed context
- **Batching**: Combine related prompts

### Quality Metrics
- **Clarity Score**: Measures prompt clarity
- **Completeness**: Checks for missing elements
- **Specificity**: Evaluates precision
- **Efficiency**: Token usage optimization

## Auto-Activation Patterns

The prompt command activates automatically when:
- User asks "how should I prompt for..."
- Complex tasks need structured prompting
- Multi-step operations require orchestration
- Context gathering is needed for effective prompting

## Quality Standards

- **Clarity**: Prompts must be unambiguous
- **Completeness**: Include all necessary context
- **Efficiency**: Optimize token usage
- **Reproducibility**: Consistent results from same inputs
# /prompt Command Reference

## Overview

The `/prompt` command is an intelligent translator that converts casual user requests into optimized Claude Code prompts using scaffolding best practices. It shows you the transformed prompt before executing it, so you can see exactly what's being submitted.

## Command Syntax

```bash
/prompt [user's casual request]
```

## Execution Flow

1. **Input**: Receive user's casual request
2. **Transform**: Apply scaffolding and optimization
3. **Display**: Show the scaffolded prompt that will be executed
4. **Execute**: Submit the optimized prompt to Claude Code

The command will display:
```
=== ORIGINAL REQUEST ===
[your casual input]

=== SCAFFOLDED PROMPT (EXECUTING) ===
[the optimized prompt that will be submitted]

=== EXECUTING NOW ===
[Claude begins work]
```

## Core Scaffolding Principles

### 1. Structured Prompt Template
Every optimized prompt follows this scaffolding pattern:

```
<context>
[Current state and relevant background]
</context>

<objective>
[Clear, specific goal statement]
</objective>

<constraints>
[Technical requirements and boundaries]
</constraints>

<steps>
1. [Explicit action]
2. [Explicit action]
3. [Explicit action]
</steps>

<validation>
[Success criteria and verification steps]
</validation>
```

### 2. Defensive Prompting
- Wraps user input in guardrails
- Adds explicit boundaries and constraints
- Specifies acceptable/unacceptable behaviors
- Includes error handling instructions

### 3. Layered Instructions
Combines multiple instruction types:
- **Role Assignment**: "Acting as a senior developer..."
- **Thinking Scaffold**: "First analyze, then plan, then implement..."
- **Format Specification**: "Output as structured steps with validation..."

## Translation Examples

### Example 1: Feature Implementation
**User Input:**
```
/prompt add dark mode
```

**Display Before Execution:**
```
=== ORIGINAL REQUEST ===
add dark mode

=== SCAFFOLDED PROMPT (EXECUTING) ===
<context>
Project uses [detected framework]. Current theming located in [theme files].
No existing dark mode implementation found.
</context>

<objective>
Implement a complete dark mode feature with theme switching capability
</objective>

<constraints>
- Preserve existing light theme functionality
- Use CSS variables for theme values
- Ensure accessibility (WCAG AA contrast ratios)
- Support system preference detection
- Persist user preference
</constraints>

<steps>
1. Analyze current theme implementation and color usage
2. Create dark theme color palette with proper contrast
3. Implement CSS variable system for theme switching
4. Add theme toggle component with accessibility features
5. Implement preference persistence (localStorage + system)
6. Update all components to use theme variables
7. Test across different screen sizes and browsers
</steps>

<validation>
✓ Toggle switches between themes without flash
✓ User preference persists across sessions
✓ Respects system dark mode preference
✓ All text meets WCAG AA contrast requirements
✓ No hardcoded colors remain
</validation>

=== EXECUTING NOW ===
```

### Example 2: Bug Investigation
**User Input:**
```
/prompt why is it slow
```

**Display Before Execution:**
```
=== ORIGINAL REQUEST ===
why is it slow

=== SCAFFOLDED PROMPT (EXECUTING) ===
<context>
Performance issue reported. No specific component identified.
Need systematic investigation of potential bottlenecks.
</context>

<objective>
Identify and resolve performance bottlenecks causing slowness
</objective>

<constraints>
- Measure before optimizing
- Preserve functionality
- Document findings
- Focus on biggest impact items first
</constraints>

<steps>
1. Profile application performance using browser DevTools
2. Identify slow operations (>100ms blocking time)
3. Check for:
   - Unnecessary re-renders (React DevTools)
   - Large bundle sizes (webpack-bundle-analyzer)
   - Slow API calls (Network tab)
   - Memory leaks (Memory profiler)
   - Inefficient queries (Database logs)
4. Document top 3 bottlenecks with metrics
5. Implement fixes starting with highest impact
6. Measure improvement after each fix
7. Add performance monitoring for regression prevention
</steps>

<validation>
✓ Performance metrics documented before/after
✓ Specific bottlenecks identified with data
✓ Measurable improvement achieved
✓ No functionality broken
✓ Monitoring in place
</validation>

=== EXECUTING NOW ===
```

### Example 3: Code Refactoring
**User Input:**
```
/prompt refactor this
```

**Display Before Execution:**
```
=== ORIGINAL REQUEST ===
refactor this

=== SCAFFOLDED PROMPT (EXECUTING) ===
<context>
Current file/module: [detected from context]
Code complexity metrics: [calculated]
Test coverage: [measured]
</context>

<objective>
Refactor code for improved maintainability while preserving behavior
</objective>

<constraints>
- All existing tests must pass
- No breaking changes to public APIs
- Follow project style guide
- Maintain or improve performance
</constraints>

<steps>
1. Run existing tests to establish baseline
2. Identify refactoring opportunities:
   - Extract duplicate code (DRY)
   - Simplify complex conditionals
   - Extract methods/functions (SRP)
   - Improve naming clarity
   - Add type definitions
3. Refactor incrementally with test verification
4. Add missing test coverage for edge cases
5. Update documentation and comments
6. Run linter and formatter
7. Verify no performance regression
</steps>

<validation>
✓ All tests passing
✓ Code coverage maintained/improved
✓ Cyclomatic complexity reduced
✓ No linter warnings
✓ Performance benchmarks stable
</validation>

=== EXECUTING NOW ===
```

## Optimization Strategies

### 1. Context Enrichment
Automatically adds:
- Current file/directory context
- Detected framework/language
- Recent git changes
- Related file dependencies
- Existing patterns in codebase

### 2. Explicit Over Implicit
Transforms vague instructions into specific actions:
- "make it better" → specific improvements with metrics
- "fix it" → systematic debugging with root cause analysis
- "add feature" → complete implementation with tests

### 3. Success Scaffolding
Every prompt includes:
- Clear success criteria
- Step-by-step verification
- Rollback considerations
- Testing requirements
- Documentation updates

## Advanced Features

### Multi-Phase Execution
Complex tasks are broken into phases:

```
### Phase 1: Investigation
[Analysis and planning steps]

### Phase 2: Implementation
[Core development steps]

### Phase 3: Validation
[Testing and verification steps]

### Phase 4: Finalization
[Documentation and cleanup steps]
```

### Adaptive Scaffolding
Adjusts based on task type:
- **Frontend**: Emphasizes visual, UX, accessibility
- **Backend**: Focuses on data, performance, security
- **DevOps**: Includes automation, monitoring, deployment
- **Debug**: Structures systematic investigation

### Safety Rails
Includes protective measures:
- "Do not delete without backup"
- "Verify before proceeding"
- "Test in isolation first"
- "Check breaking changes"

## Integration Patterns

### Automatic Enhancement
The command automatically:
- Detects project type and applies relevant patterns
- Includes framework-specific best practices
- Adds appropriate testing strategies
- Incorporates security considerations

### Smart Defaults
When not specified, includes:
- Error handling
- Input validation
- Basic tests
- Documentation updates
- Performance considerations

### Progressive Disclosure
Starts with essential steps, then:
- Adds optimization if needed
- Includes edge cases
- Suggests follow-up improvements

## Best Practices Applied

### Clear Structure
- Uses XML-like tags for organization
- Groups related instructions
- Provides explicit examples
- Uses consistent formatting

### Specific Instructions
- Replaces vague terms with measurable criteria
- Includes exact file paths when known
- Specifies tool usage
- Defines clear outputs

### Thinking Scaffolds
- "First analyze..."
- "Then plan..."
- "Next implement..."
- "Finally validate..."

## Usage Guidelines

1. **Be Natural**: Write as you normally would - scaffolding is automatic
2. **Review Output**: The scaffolded prompt is shown before execution
3. **Trust the Process**: The command adds necessary technical structure
4. **Provide Context**: Include any specific requirements you have

## Quality Assurance

Every scaffolded prompt ensures:
- **Clarity**: Unambiguous instructions
- **Completeness**: All necessary steps included
- **Safety**: Protective measures in place
- **Verifiability**: Clear success criteria
- **Efficiency**: Optimized for first-attempt success
- **Transparency**: You see exactly what's being submitted
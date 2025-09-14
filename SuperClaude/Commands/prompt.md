# /prompt Command

## Overview
Intelligent prompt optimizer that transforms casual requests into scaffolded, structured prompts for better Claude Code execution.

## Usage
```
/prompt [your casual request]
```

## Implementation

When invoked, this command:
1. Analyzes your request to determine type (feature, bugfix, performance, etc.)
2. Gathers project context (language, framework, files)
3. Transforms into a scaffolded prompt with context, objectives, constraints, steps, and validation
4. Shows you the transformation
5. Executes the optimized prompt

## Execution Script

```python
#!/usr/bin/env python3
import subprocess
import sys
import os

# Get the request from Claude Code
request = """$ARGUMENTS"""

# Path to the optimizer script
script_path = os.path.expanduser("~/.claude/scripts/prompt_optimizer.py")

# Run the optimizer
result = subprocess.run(
    [sys.executable, script_path, request],
    capture_output=True,
    text=True
)

# Output the result (which includes the scaffolded prompt)
print(result.stdout)

# The scaffolded prompt will be executed after this output
```

## Supported Request Types

- **Feature Implementation**: "add", "create", "implement", "build"
- **Bug Fixes**: "fix", "bug", "error", "broken"
- **Performance**: "slow", "optimize", "speed up"
- **Refactoring**: "refactor", "clean up", "improve"
- **Testing**: "test", "add tests", "coverage"
- **Documentation**: "document", "add docs", "readme"
- **Analysis**: "why", "analyze", "explain"

## Examples

### Simple Feature Request
```
/prompt add dark mode
```
Transforms into a structured prompt with steps for theme implementation, accessibility, and testing.

### Bug Investigation
```
/prompt fix login not working
```
Transforms into systematic debugging steps with root cause analysis.

### Performance Optimization
```
/prompt why is it slow
```
Transforms into performance profiling and optimization workflow.
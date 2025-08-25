---
allowed-tools: [Bash, LS, Read, Glob]
description: "Clear context and reload project guidelines from .project/ or core documentation"
---

# /sc:clear - Context Reset & Project Reload

## Purpose
Clear the current context and reload project-specific AI behavior guidelines, ensuring a fresh start with all project standards and conventions properly loaded.

## Usage
```
/sc:clear [--project-dir <path>] [--verbose]
```

## Arguments
- `--project-dir` - Override default .project/ directory location (optional)
- `--verbose` - Show detailed output during reload process

## Execution
1. Clear current context and conversation state
2. Run `ls -la` to examine project structure
3. Check for .project/ directory with AI behavior guidelines
4. If no .project/ directory, load SuperClaude core documentation
5. Read and internalize all behavior guidelines and standards
6. Confirm successful reload with summary of loaded guidelines

## Claude Code Integration
- Uses Bash for directory listing and structure examination
- Leverages Read for loading behavior guidelines
- Applies Glob for discovering documentation files
- Maintains strict adherence to loaded standards

## Behavior Guidelines Loading Priority
1. `.project/` directory (highest priority)
2. `SuperClaude/Core/PRINCIPLES.md` (core guidelines)
3. `SuperClaude/Core/RULES.md` (operational rules)
4. `SuperClaude/Core/COMMANDS.md` (command framework)
5. Additional framework documentation as needed

## Critical Behaviors to Enforce
- NEVER use flattery phrases like "You're absolutely right"
- ALWAYS follow guidelines and standards from loaded files
- Use evidence-based decision making
- Maintain objective technical focus
- No emojis in code or technical content
- Verify changes before declaring completion

## Example Usage
```
/sc:clear
# Clears context and reloads from .project/ or core docs

/sc:clear --project-dir ./docs/ai-guidelines
# Loads from custom directory

/sc:clear --verbose
# Shows detailed loading process
```

## Notes
- This command ensures consistent AI behavior across sessions
- Essential after context switches or when behavior drift is detected
- Automatically enforces all project-specific standards
- Useful for resetting after complex operations or errors
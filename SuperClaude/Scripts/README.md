# SuperClaude Scripts Directory

This directory contains deterministic bash scripts that can be executed by SuperClaude commands.

## Purpose

While most SuperClaude commands work by prompting Claude to interpret and execute tasks, some operations benefit from deterministic execution. This directory houses bash scripts that provide predictable, repeatable behavior for suitable commands.

## Structure

```
Scripts/
├── README.md           # This file
├── git-cleanup.sh      # Deterministic git branch cleanup
└── ...                 # Future deterministic scripts
```

## Script Requirements

1. **Executable**: All scripts must have executable permissions (`chmod +x`)
2. **Shebang**: Must start with appropriate shebang (e.g., `#!/bin/bash`)
3. **Error Handling**: Use `set -euo pipefail` for robust error handling
4. **Help Text**: Support `-h` or `--help` flag
5. **Exit Codes**: Return meaningful exit codes (0 for success, non-zero for errors)

## Usage in Commands

Commands can execute these scripts using the bash tool:

```markdown
---
allowed-tools: [Bash(~/.claude/scripts/script-name.sh:*)]
---
!~/.claude/scripts/script-name.sh $ARGUMENTS
```

## Installation

The SuperClaude installer handles:
1. Creating `~/.claude/scripts/` directory
2. Copying scripts from this directory
3. Setting executable permissions
4. Verifying script integrity

## Security Considerations

- Scripts run with user permissions
- Always validate inputs
- Avoid hardcoded credentials
- Use appropriate error handling
- Provide dry-run options for destructive operations

## Adding New Scripts

1. Create script in this directory
2. Add documentation to script header
3. Update command file to use the script
4. Test thoroughly with various inputs
5. Add to installer script list
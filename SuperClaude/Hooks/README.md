# SuperClaude Hooks

This directory contains pre-configured hooks for Claude Code to enhance behavior and prevent common issues.

## Available Hooks

### anti_sycophant.py

The anti-sycophant hook prevents Claude from using sycophantic language and enforces objective, technical communication. It detects and blocks phrases like:

- "You're absolutely right"
- "That's a brilliant point"
- "Excellent observation"

And similar sycophantic expressions that detract from professional, technical discourse.

## Installation

When SuperClaude is installed with the hooks component, these hooks are automatically:

1. Copied to `~/.claude/hooks/`
2. Configured in `~/.claude/settings.json`
3. Activated for all Claude Code sessions

## Configuration

The anti_sycophant hook is configured as a Stop hook in settings.json:

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/anti_sycophant.py",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

## Customization

You can customize the hook's behavior by editing the following variables in anti_sycophant.py:

- `BLOCK_AND_REVISE`: If True, blocks and asks for revision. If False, just warns.
- `SENSITIVITY`: "low", "medium", or "high" - how aggressive to be in detection.

## Technical Details

The hook:
- Runs after every Claude response
- Analyzes the response for sycophantic language patterns
- Either blocks the response (asking for revision) or warns about it
- Maintains context awareness to avoid false positives
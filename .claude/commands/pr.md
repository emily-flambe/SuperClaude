# How to Create a Pull Request Using GitHub CLI

This guide explains how to create pull requests using GitHub CLI in our project.

## Prerequisites

1. Install GitHub CLI if you haven't already:

   ```bash
   # macOS
   brew install gh

   # Windows
   winget install --id GitHub.cli

   # Linux
   # Follow instructions at https://github.com/cli/cli/blob/trunk/docs/install_linux.md
   ```

2. Authenticate with GitHub:
   ```bash
   gh auth login
   ```

## Creating a New Pull Request

1. **Template Enforcement**: This command will automatically use the PR template if `.github/pull_request_template.md` exists in the repository.

2. Use the `gh pr create` command to create a new pull request:

   ```bash
   # Basic command structure - will use template if it exists
   gh pr create --title "✨(scope): Your descriptive title" --body "Your PR description" --base main --draft
   ```

   **With Template Auto-Detection**:
   ```bash
   # The command will automatically detect and use .github/pull_request_template.md if it exists
   gh pr create --title "✨(scope): Your descriptive title" --base main --draft
   ```

   **Manual Template Usage**:
   ```bash
   # Explicitly use the template file
   gh pr create --title "✨(scope): Your descriptive title" --body-file .github/pull_request_template.md --base main --draft
   ```

## Best Practices

1. **PR Title Format**: Use conventional commit format with emojis

   - Always include an appropriate emoji at the beginning of the title
   - Use the actual emoji character (not the code representation like `:sparkles:`)
   - Examples:
     - `✨(supabase): Add staging remote configuration`
     - `🐛(auth): Fix login redirect issue`
     - `📝(readme): Update installation instructions`

2. **Description Template**: Always use our PR template structure from `.github/pull_request_template.md`:

   - Summary of changes
   - Type of change (bug fix, feature, etc.)
   - Changes made
   - Testing checklist
   - Related issues
   - Screenshots (if applicable)
   - Checklist items
   - Additional notes

3. **Template Accuracy**: Ensure your PR description precisely follows the template structure:

   - Keep all section headers exactly as they appear in the template
   - Fill out all required sections appropriately
   - Don't add custom sections that aren't in the template

4. **Draft PRs**: Start as draft when the work is in progress
   - Use `--draft` flag in the command
   - Convert to ready for review when complete using `gh pr ready`

### Common Mistakes to Avoid

1. **Incorrect Section Headers**: Always use the exact section headers from the template
2. **Incomplete Template**: Fill out all sections, don't leave template sections empty
3. **Adding Custom Sections**: Stick to the sections defined in the template
4. **Using Outdated Templates**: Always refer to the current `.github/pull_request_template.md` file

### Missing Sections

Always include all template sections, even if some are marked as "N/A" or "None"

## Additional GitHub CLI PR Commands

Here are some additional useful GitHub CLI commands for managing PRs:

```bash
# List your open pull requests
gh pr list --author "@me"

# Check PR status
gh pr status

# View a specific PR
gh pr view <PR-NUMBER>

# Check out a PR branch locally
gh pr checkout <PR-NUMBER>

# Convert a draft PR to ready for review
gh pr ready <PR-NUMBER>

# Add reviewers to a PR
gh pr edit <PR-NUMBER> --add-reviewer username1,username2

# Merge a PR
gh pr merge <PR-NUMBER> --squash
```

## Template Auto-Detection

GitHub CLI automatically detects and uses pull request templates:

1. **Automatic Template Usage**: If `.github/pull_request_template.md` exists, GitHub CLI will automatically use it when creating PRs
2. **Manual Template Override**: You can explicitly specify a template file:

```bash
gh pr create --title "feat(scope): Your title" --body-file .github/pull_request_template.md --base main --draft
```

3. **Template Validation**: Always ensure your PR follows the template structure before submitting

## Related Documentation

- [PR Template](.github/pull_request_template.md)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHub CLI documentation](https://cli.github.com/manual/)
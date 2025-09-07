#!/bin/bash
# SuperClaude PR Review Script
# AI-powered pull request review with GitHub integration

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Default values
PR_NUMBER=""
REPO=""
REVIEW_ONLY=false
POST_COMMENT=true
GUIDELINES_FILE=".github/copilot-instructions.md"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        PR=*)
            PR_NUMBER="${1#*=}"
            shift
            ;;
        --repo)
            REPO="$2"
            shift 2
            ;;
        --review-only)
            REVIEW_ONLY=true
            shift
            ;;
        --no-comment)
            POST_COMMENT=false
            shift
            ;;
        --guidelines)
            GUIDELINES_FILE="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 PR=<number> [options]"
            echo "Options:"
            echo "  PR=<number>      Pull request number (required)"
            echo "  --repo          Repository in format owner/name"
            echo "  --review-only   Only show review, don't post comment"
            echo "  --no-comment    Don't post review comment to PR"
            echo "  --guidelines    Path to guidelines file (default: .github/copilot-instructions.md)"
            echo "  -h, --help      Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Validate PR number
if [ -z "$PR_NUMBER" ]; then
    echo -e "${RED}Error: PR number is required. Use PR=<number>${NC}"
    exit 1
fi

# Function to print colored output
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to print section headers
print_header() {
    local title=$1
    echo
    print_color $BLUE "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    print_color $BLUE "  $title"
    print_color $BLUE "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Check if gh CLI is installed
check_gh_cli() {
    if ! command -v gh &> /dev/null; then
        print_color $RED "Error: GitHub CLI (gh) is not installed"
        print_color $YELLOW "Install it from: https://cli.github.com/"
        exit 1
    fi
}

# Get repository if not specified
get_repo() {
    if [ -z "$REPO" ]; then
        if git rev-parse --is-inside-work-tree &>/dev/null; then
            local origin_url=$(git config --get remote.origin.url)
            if [[ $origin_url =~ github.com[:/]([^/]+)/([^/]+)(\.git)?$ ]]; then
                REPO="${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
            fi
        fi
        
        if [ -z "$REPO" ]; then
            print_color $RED "Error: Could not determine repository. Use --repo owner/name"
            exit 1
        fi
    fi
}

# Check for review guidelines
check_guidelines() {
    print_header "Checking for Review Guidelines"
    
    local guidelines_content=""
    
    # Try to fetch guidelines from the repository
    guidelines_content=$(gh api repos/"$REPO"/contents/"$GUIDELINES_FILE" --jq '.content' 2>/dev/null | base64 -d 2>/dev/null || echo "")
    
    if [ -n "$guidelines_content" ]; then
        print_color $GREEN "✓ Found review guidelines at $GUIDELINES_FILE"
        echo "$guidelines_content" > /tmp/pr_review_guidelines.md
        return 0
    else
        print_color $YELLOW "⚠ No review guidelines found at $GUIDELINES_FILE"
        # Create default guidelines
        cat > /tmp/pr_review_guidelines.md << 'EOF'
# Default Code Review Guidelines

## Review Focus Areas
1. **Code Quality**: Clean, readable, and maintainable code
2. **Security**: No hardcoded secrets, proper input validation
3. **Performance**: Efficient algorithms and resource usage
4. **Testing**: Adequate test coverage for new functionality
5. **Documentation**: Clear comments and updated documentation
6. **Best Practices**: Follow language and framework conventions

## Review Categories
- **Critical**: Security issues, data loss risks, breaking changes
- **Important**: Performance issues, missing tests, poor error handling
- **Non-Blocking**: Style issues, minor improvements, suggestions
EOF
        return 1
    fi
}

# Get existing Copilot comments
get_copilot_comments() {
    print_header "Analyzing Existing Copilot Comments"
    
    # Fetch all comments on the PR
    local comments=$(gh pr view "$PR_NUMBER" --repo "$REPO" --json comments --jq '.comments[] | select(.author.login == "github-actions[bot]" or .author.login == "copilot[bot]" or .body | contains("[bot]")) | {author: .author.login, body: .body, createdAt: .createdAt}' 2>/dev/null || echo "")
    
    if [ -n "$comments" ]; then
        echo "$comments" > /tmp/pr_copilot_comments.json
        local comment_count=$(echo "$comments" | jq -s 'length' 2>/dev/null || echo "0")
        print_color $CYAN "Found $comment_count bot comments to evaluate"
        return 0
    else
        print_color $YELLOW "No existing bot comments found"
        return 1
    fi
}

# Get PR diff
get_pr_diff() {
    print_header "Fetching PR Changes"
    
    # Get the diff
    gh pr diff "$PR_NUMBER" --repo "$REPO" > /tmp/pr_diff.txt 2>/dev/null
    
    # Get file list
    gh pr view "$PR_NUMBER" --repo "$REPO" --json files --jq '.files[].path' > /tmp/pr_files.txt 2>/dev/null
    
    # Get PR metadata
    gh pr view "$PR_NUMBER" --repo "$REPO" --json title,body,author,baseRefName,headRefName > /tmp/pr_metadata.json 2>/dev/null
    
    print_color $GREEN "✓ Retrieved PR diff and metadata"
}

# Get CI/CD status
get_ci_status() {
    print_header "Checking CI/CD Status"
    
    # Get check runs
    local checks=$(gh pr checks "$PR_NUMBER" --repo "$REPO" 2>/dev/null)
    
    if [ -n "$checks" ]; then
        echo "$checks" > /tmp/pr_ci_status.txt
        local total_checks=$(echo "$checks" | wc -l)
        local passed_checks=$(echo "$checks" | grep -c "pass" || echo "0")
        local failed_checks=$(echo "$checks" | grep -c "fail" || echo "0")
        local pending_checks=$(echo "$checks" | grep -c "pending\|queued" || echo "0")
        
        print_color $CYAN "Total checks: $total_checks"
        if [ "$failed_checks" -gt 0 ]; then
            print_color $RED "Failed: $failed_checks"
        fi
        if [ "$passed_checks" -gt 0 ]; then
            print_color $GREEN "Passed: $passed_checks"
        fi
        if [ "$pending_checks" -gt 0 ]; then
            print_color $YELLOW "Pending: $pending_checks"
        fi
    else
        print_color $YELLOW "No CI checks found"
        echo "No CI checks configured" > /tmp/pr_ci_status.txt
    fi
}

# Perform AI review
perform_ai_review() {
    print_header "Performing AI Code Review"
    
    # Prepare the review prompt
    local review_prompt="/tmp/pr_review_prompt.txt"
    
    cat > "$review_prompt" << 'EOF'
You are an expert code reviewer. Review the following pull request changes and provide a comprehensive analysis.

## Review Guidelines
EOF
    
    # Add guidelines
    if [ -f /tmp/pr_review_guidelines.md ]; then
        cat /tmp/pr_review_guidelines.md >> "$review_prompt"
    fi
    
    # Add existing comments evaluation if present
    if [ -f /tmp/pr_copilot_comments.json ] && [ -s /tmp/pr_copilot_comments.json ]; then
        cat >> "$review_prompt" << 'EOF'

## Existing Bot Comments to Evaluate
Please evaluate each of these existing comments for validity and incorporate valid concerns into your review:

EOF
        jq -r '.body' /tmp/pr_copilot_comments.json >> "$review_prompt" 2>/dev/null || true
    fi
    
    # Add PR metadata
    cat >> "$review_prompt" << 'EOF'

## Pull Request Information
EOF
    jq -r '"Title: \(.title)\nBase: \(.baseRefName) ← Head: \(.headRefName)\nAuthor: \(.author.login)\n\nDescription:\n\(.body // "No description provided")"' /tmp/pr_metadata.json >> "$review_prompt"
    
    # Add CI/CD status
    cat >> "$review_prompt" << 'EOF'

## CI/CD Status
EOF
    if [ -f /tmp/pr_ci_status.txt ]; then
        cat /tmp/pr_ci_status.txt >> "$review_prompt"
    fi
    
    # Add the diff
    cat >> "$review_prompt" << 'EOF'

## Code Changes
```diff
EOF
    cat /tmp/pr_diff.txt >> "$review_prompt"
    cat >> "$review_prompt" << 'EOF'
```

## Review Instructions
1. If existing bot comments were provided, evaluate each one and state whether it's valid or can be ignored
2. Review the code changes following the guidelines provided
3. Consider the CI/CD status - if there are failing checks, include them in your analysis
4. Categorize all findings as:
   - **CRITICAL**: Must be fixed before merge (security issues, data loss, breaking changes, CI/CD failures)
   - **IMPORTANT**: Should be addressed (performance, missing tests, error handling)
   - **NON-BLOCKING**: Nice to have improvements (style, minor optimizations)
5. Be specific with line numbers and file names when pointing out issues
6. Acknowledge good practices and improvements
7. Provide actionable feedback with examples where applicable
8. If CI/CD is failing, recommend specific fixes based on the error messages

Format your response as a GitHub PR comment with clear sections for each category of findings.
EOF
    
    # Save the prompt for debugging
    cp "$review_prompt" /tmp/pr_review_prompt_debug.txt
    
    print_color $CYAN "Analyzing code changes..."
    
    # The actual AI review would happen here
    # For now, we'll prepare the structure for the review results
    cat > /tmp/pr_review_result.md << 'EOF'
## 🤖 AI Code Review

### Review Summary
This is where the AI review results would appear. The script has prepared all the necessary context:
- Review guidelines (if found)
- Existing bot comments for evaluation
- Complete PR diff
- PR metadata

To complete the AI review integration:
1. Add Claude API integration here
2. Send the prepared prompt to Claude
3. Parse and format the response
4. Post as a PR comment

### Prepared Context Files
- Guidelines: /tmp/pr_review_guidelines.md
- Copilot Comments: /tmp/pr_copilot_comments.json
- PR Diff: /tmp/pr_diff.txt
- PR Metadata: /tmp/pr_metadata.json
- Review Prompt: /tmp/pr_review_prompt_debug.txt
EOF
    
    print_color $GREEN "✓ Review analysis complete"
}

# Format review comment
format_review_comment() {
    local timestamp=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
    
    cat > /tmp/pr_review_comment.md << EOF
## 🤖 SuperClaude AI Code Review

**Pull Request:** #$PR_NUMBER
**Reviewed at:** $timestamp
**Review Type:** AI-Assisted with Guidelines

---

EOF
    
    # Add the review results
    cat /tmp/pr_review_result.md >> /tmp/pr_review_comment.md
    
    # Add footer
    cat >> /tmp/pr_review_comment.md << 'EOF'

---

*This review was performed by [SuperClaude](https://github.com/Shardj/SuperClaude) AI Code Review*
EOF
}

# Post comment to PR
post_pr_comment() {
    if [ "$POST_COMMENT" = true ] && [ "$REVIEW_ONLY" = false ]; then
        print_header "Posting Review Comment"
        
        # Check if we should post
        read -p "Post this review as a comment on PR #$PR_NUMBER? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            gh pr comment "$PR_NUMBER" --repo "$REPO" --body-file /tmp/pr_review_comment.md
            print_color $GREEN "✓ Review comment posted successfully"
        else
            print_color $YELLOW "Review comment not posted"
        fi
    fi
}

# Display review locally
display_review() {
    print_header "Review Results"
    cat /tmp/pr_review_comment.md
}

# Main execution
main() {
    print_color $BLUE "🔍 SuperClaude AI PR Review"
    print_color $BLUE "============================"
    
    # Check dependencies
    check_gh_cli
    
    # Get repository
    get_repo
    print_color $GREEN "Repository: $REPO"
    print_color $GREEN "Pull Request: #$PR_NUMBER"
    
    # Check for review guidelines
    check_guidelines
    
    # Get existing Copilot comments
    get_copilot_comments
    
    # Get PR diff and metadata
    get_pr_diff
    
    # Get CI/CD status
    get_ci_status
    
    # Perform AI review
    perform_ai_review
    
    # Format the review comment
    format_review_comment
    
    # Display the review
    display_review
    
    # Post comment if requested
    post_pr_comment
    
    echo
    print_color $GREEN "✨ Review complete!"
}

# Run main function
main
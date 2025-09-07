#!/bin/bash
# SuperClaude PR Review Script
# Comprehensive pull request review using GitHub CLI

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
DETAILED=false
FILES_ONLY=false

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
        --detailed)
            DETAILED=true
            shift
            ;;
        --files-only)
            FILES_ONLY=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 PR=<number> [options]"
            echo "Options:"
            echo "  PR=<number>      Pull request number (required)"
            echo "  --repo          Repository in format owner/name"
            echo "  --detailed      Show full diff for each file"
            echo "  --files-only    Only list changed files"
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
        # Try to get repo from current directory
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

# Fetch PR metadata
fetch_pr_metadata() {
    print_header "Pull Request #$PR_NUMBER"
    
    # Get PR details
    local pr_data=$(gh pr view "$PR_NUMBER" --repo "$REPO" --json title,author,state,body,baseRefName,headRefName,mergeable,isDraft,createdAt,url 2>/dev/null)
    
    if [ $? -ne 0 ]; then
        print_color $RED "Error: Could not fetch PR #$PR_NUMBER from $REPO"
        exit 1
    fi
    
    # Parse PR data
    local title=$(echo "$pr_data" | jq -r '.title')
    local author=$(echo "$pr_data" | jq -r '.author.login')
    local state=$(echo "$pr_data" | jq -r '.state')
    local base=$(echo "$pr_data" | jq -r '.baseRefName')
    local head=$(echo "$pr_data" | jq -r '.headRefName')
    local mergeable=$(echo "$pr_data" | jq -r '.mergeable')
    local is_draft=$(echo "$pr_data" | jq -r '.isDraft')
    local created=$(echo "$pr_data" | jq -r '.createdAt')
    local url=$(echo "$pr_data" | jq -r '.url')
    local body=$(echo "$pr_data" | jq -r '.body // "No description provided"')
    
    # Display metadata
    print_color $CYAN "Title: $title"
    print_color $CYAN "Author: @$author"
    print_color $CYAN "State: $state"
    if [ "$is_draft" = "true" ]; then
        print_color $YELLOW "Status: DRAFT"
    fi
    print_color $CYAN "Branch: $head → $base"
    print_color $CYAN "Created: $created"
    print_color $CYAN "URL: $url"
    
    if [ "$mergeable" = "CONFLICTING" ]; then
        print_color $RED "⚠️  Has merge conflicts!"
    elif [ "$mergeable" = "MERGEABLE" ]; then
        print_color $GREEN "✓ Ready to merge"
    fi
    
    echo
    print_color $CYAN "Description:"
    echo "$body" | sed 's/^/  /'
}

# Show PR statistics
show_pr_stats() {
    print_header "Change Statistics"
    
    # Get diff stats
    local stats=$(gh pr diff "$PR_NUMBER" --repo "$REPO" --name-only 2>/dev/null | wc -l)
    print_color $CYAN "Files changed: $stats"
    
    # Get additions/deletions
    local diff_stat=$(gh pr diff "$PR_NUMBER" --repo "$REPO" --stat 2>/dev/null | tail -1)
    if [[ $diff_stat =~ ([0-9]+)\ file.*changed ]]; then
        print_color $GREEN "$diff_stat"
    fi
}

# List changed files
list_changed_files() {
    print_header "Changed Files"
    
    # Get file list with stats
    gh pr diff "$PR_NUMBER" --repo "$REPO" --stat 2>/dev/null | head -n -1 | while IFS= read -r line; do
        if [[ $line =~ ^[[:space:]]*(.*\|.*) ]]; then
            # Extract filename and changes
            local file=$(echo "$line" | awk -F'|' '{print $1}' | xargs)
            local changes=$(echo "$line" | awk -F'|' '{print $2}')
            
            # Color based on file type
            if [[ $file =~ \.(js|ts|jsx|tsx)$ ]]; then
                print_color $YELLOW "📄 $file"
            elif [[ $file =~ \.(md|txt|rst)$ ]]; then
                print_color $CYAN "📝 $file"
            elif [[ $file =~ \.(sh|bash)$ ]]; then
                print_color $GREEN "🔧 $file"
            elif [[ $file =~ \.(yml|yaml|json)$ ]]; then
                print_color $MAGENTA "⚙️  $file"
            else
                echo "📄 $file"
            fi
            
            # Show changes inline
            echo "   $changes"
        fi
    done
}

# Show detailed diffs
show_detailed_diff() {
    if [ "$DETAILED" = true ] && [ "$FILES_ONLY" = false ]; then
        print_header "Detailed Changes"
        gh pr diff "$PR_NUMBER" --repo "$REPO" --color always 2>/dev/null | less -R
    fi
}

# Check CI status
check_ci_status() {
    print_header "CI/CD Status"
    
    # Get check runs
    local checks=$(gh pr checks "$PR_NUMBER" --repo "$REPO" 2>/dev/null)
    
    if [ -n "$checks" ]; then
        echo "$checks" | while IFS=$'\t' read -r name status conclusion; do
            case "$conclusion" in
                "success")
                    print_color $GREEN "✓ $name"
                    ;;
                "failure")
                    print_color $RED "✗ $name"
                    ;;
                "skipped")
                    print_color $YELLOW "⊘ $name (skipped)"
                    ;;
                *)
                    if [ "$status" = "in_progress" ]; then
                        print_color $YELLOW "⏳ $name (running)"
                    else
                        echo "• $name: $status"
                    fi
                    ;;
            esac
        done
    else
        print_color $YELLOW "No CI checks found"
    fi
}

# Show comments and reviews
show_comments() {
    print_header "Comments & Reviews"
    
    # Get comment count
    local comment_count=$(gh pr view "$PR_NUMBER" --repo "$REPO" --json comments --jq '.comments | length' 2>/dev/null || echo "0")
    local review_count=$(gh pr view "$PR_NUMBER" --repo "$REPO" --json reviews --jq '.reviews | length' 2>/dev/null || echo "0")
    
    print_color $CYAN "Comments: $comment_count"
    print_color $CYAN "Reviews: $review_count"
    
    # Show latest reviews
    if [ "$review_count" -gt 0 ]; then
        echo
        print_color $CYAN "Latest Reviews:"
        gh pr view "$PR_NUMBER" --repo "$REPO" --json reviews --jq '.reviews[-3:] | reverse | .[] | "  • \(.author.login): \(.state)"' 2>/dev/null || true
    fi
}

# Provide review summary
provide_summary() {
    print_header "Review Summary"
    
    # Get PR state info
    local pr_data=$(gh pr view "$PR_NUMBER" --repo "$REPO" --json mergeable,reviews,isDraft,state 2>/dev/null)
    local mergeable=$(echo "$pr_data" | jq -r '.mergeable')
    local is_draft=$(echo "$pr_data" | jq -r '.isDraft')
    local state=$(echo "$pr_data" | jq -r '.state')
    
    # Check approvals
    local approvals=$(echo "$pr_data" | jq -r '[.reviews[] | select(.state == "APPROVED")] | length')
    local changes_requested=$(echo "$pr_data" | jq -r '[.reviews[] | select(.state == "CHANGES_REQUESTED")] | length')
    
    # Summary
    if [ "$state" = "CLOSED" ]; then
        print_color $RED "❌ This PR is closed"
    elif [ "$state" = "MERGED" ]; then
        print_color $GREEN "✅ This PR has been merged"
    else
        if [ "$is_draft" = "true" ]; then
            print_color $YELLOW "📝 This is a draft PR"
        fi
        
        if [ "$mergeable" = "CONFLICTING" ]; then
            print_color $RED "❌ Has merge conflicts that need to be resolved"
        fi
        
        if [ "$changes_requested" -gt 0 ]; then
            print_color $YELLOW "🔄 Changes requested by reviewers"
        fi
        
        if [ "$approvals" -gt 0 ]; then
            print_color $GREEN "✅ Has $approvals approval(s)"
        else
            print_color $YELLOW "⏳ Awaiting review approval"
        fi
        
        # Check CI status
        local failed_checks=$(gh pr checks "$PR_NUMBER" --repo "$REPO" 2>/dev/null | grep -c "fail" || echo "0")
        if [ "$failed_checks" -gt 0 ]; then
            print_color $RED "❌ $failed_checks CI check(s) failing"
        fi
    fi
}

# Main execution
main() {
    print_color $BLUE "🔍 SuperClaude PR Review"
    print_color $BLUE "========================"
    
    # Check dependencies
    check_gh_cli
    
    # Get repository
    get_repo
    print_color $GREEN "Repository: $REPO"
    
    # Fetch and display PR information
    fetch_pr_metadata
    
    if [ "$FILES_ONLY" = false ]; then
        show_pr_stats
    fi
    
    list_changed_files
    
    if [ "$FILES_ONLY" = false ]; then
        check_ci_status
        show_comments
        show_detailed_diff
        provide_summary
    fi
    
    echo
    print_color $GREEN "✨ Review complete!"
}

# Run main function
main
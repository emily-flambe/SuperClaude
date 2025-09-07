#!/bin/bash
# SuperClaude Git Cleanup Script
# Deterministic implementation of git branch cleanup

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
DRY_RUN=false
FORCE=false
EXCLUDE_BRANCHES=""
REMOTE="origin"
MAIN_BRANCH=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --exclude-branches)
            EXCLUDE_BRANCHES="$2"
            shift 2
            ;;
        --remote)
            REMOTE="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --dry-run           Preview what would be deleted"
            echo "  --force             Skip confirmation prompts"
            echo "  --exclude-branches  Comma-separated list of branches to exclude"
            echo "  --remote           Remote name (default: origin)"
            echo "  -h, --help         Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Function to print colored output
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        print_color $RED "Error: Not in a git repository"
        exit 1
    fi
}

# Function to determine main branch (main or master)
find_main_branch() {
    if git show-ref --quiet refs/heads/main; then
        MAIN_BRANCH="main"
    elif git show-ref --quiet refs/heads/master; then
        MAIN_BRANCH="master"
    else
        print_color $RED "Error: No main or master branch found"
        exit 1
    fi
}

# Function to check for uncommitted changes
check_uncommitted_changes() {
    if ! git diff-index --quiet HEAD --; then
        print_color $YELLOW "Warning: You have uncommitted changes"
        if [ "$FORCE" = false ] && [ "$DRY_RUN" = false ]; then
            read -p "Continue anyway? (y/N) " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
        fi
    fi
}

# Function to switch to main branch and pull latest
update_main_branch() {
    print_color $BLUE "🔄 Switching to $MAIN_BRANCH branch..."
    if [ "$DRY_RUN" = false ]; then
        git checkout "$MAIN_BRANCH"
        print_color $BLUE "📥 Pulling latest changes..."
        git pull "$REMOTE" "$MAIN_BRANCH"
    else
        print_color $YELLOW "[DRY RUN] Would switch to $MAIN_BRANCH and pull latest"
    fi
}

# Function to check if a branch is merged
is_branch_merged() {
    local branch=$1
    git merge-base --is-ancestor "$branch" "$MAIN_BRANCH" 2>/dev/null
}

# Function to check if a branch has unpushed commits
has_unpushed_commits() {
    local branch=$1
    local upstream=$(git rev-parse --abbrev-ref "$branch@{upstream}" 2>/dev/null)
    
    if [ -z "$upstream" ]; then
        # No upstream branch
        return 0
    fi
    
    local ahead=$(git rev-list --count "$upstream..$branch" 2>/dev/null || echo "0")
    [ "$ahead" -gt 0 ]
}

# Function to delete local branches
delete_local_branches() {
    print_color $BLUE "🗑️  Cleaning up local branches..."
    
    # Get list of local branches (excluding main/master and current branch)
    local branches=$(git branch | grep -v "^\*" | grep -v "^  $MAIN_BRANCH$" | grep -v "^  master$" | sed 's/^  //')
    
    # Convert exclude list to array
    if [ -n "$EXCLUDE_BRANCHES" ]; then
        IFS=',' read -ra EXCLUDE_ARRAY <<< "$EXCLUDE_BRANCHES"
    else
        EXCLUDE_ARRAY=()
    fi
    
    # Always exclude production branch
    EXCLUDE_ARRAY+=("production")
    
    local deleted_count=0
    local skipped_count=0
    
    for branch in $branches; do
        # Skip if in exclude list
        local skip=false
        for exclude in "${EXCLUDE_ARRAY[@]}"; do
            if [ "$branch" = "$exclude" ]; then
                skip=true
                break
            fi
        done
        
        if [ "$skip" = true ]; then
            print_color $YELLOW "⏭️  Skipping excluded branch: $branch"
            ((skipped_count++))
            continue
        fi
        
        # Check if merged
        if is_branch_merged "$branch"; then
            if [ "$DRY_RUN" = true ]; then
                print_color $YELLOW "[DRY RUN] Would delete merged branch: $branch"
            else
                if git branch -d "$branch" 2>/dev/null; then
                    print_color $GREEN "✅ Deleted merged branch: $branch"
                    ((deleted_count++))
                else
                    print_color $RED "❌ Failed to delete branch: $branch"
                fi
            fi
        else
            # Check for unpushed commits
            if has_unpushed_commits "$branch"; then
                print_color $YELLOW "⚠️  Branch has unpushed commits: $branch"
            else
                print_color $YELLOW "⚠️  Branch not fully merged: $branch"
            fi
            
            if [ "$FORCE" = true ]; then
                if [ "$DRY_RUN" = true ]; then
                    print_color $YELLOW "[DRY RUN] Would force delete: $branch"
                else
                    if git branch -D "$branch" 2>/dev/null; then
                        print_color $GREEN "✅ Force deleted branch: $branch"
                        ((deleted_count++))
                    else
                        print_color $RED "❌ Failed to force delete branch: $branch"
                    fi
                fi
            else
                ((skipped_count++))
            fi
        fi
    done
    
    print_color $BLUE "📊 Local cleanup complete: $deleted_count deleted, $skipped_count skipped"
}

# Function to check if a remote branch has an open PR (GitHub)
has_open_pr_github() {
    local branch=$1
    local repo_url=$(git config --get remote.origin.url)
    
    # Extract owner/repo from URL
    local owner_repo=""
    if [[ $repo_url =~ github.com[:/]([^/]+)/([^/]+)(\.git)?$ ]]; then
        owner_repo="${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
    else
        return 1  # Can't determine repo, assume no PR
    fi
    
    # Check if gh CLI is available
    if ! command -v gh &> /dev/null; then
        return 1  # Can't check, assume has PR for safety
    fi
    
    # Check for open PRs
    local pr_count=$(gh pr list --repo "$owner_repo" --head "$branch" --state open --json number --jq 'length' 2>/dev/null || echo "1")
    
    [ "$pr_count" -gt 0 ]
}

# Function to delete remote branches
delete_remote_branches() {
    print_color $BLUE "🌐 Cleaning up remote branches..."
    
    # Fetch latest remote info
    git fetch --prune "$REMOTE"
    
    # Get list of remote branches
    local branches=$(git branch -r | grep "^  $REMOTE/" | grep -v "$REMOTE/HEAD" | grep -v "$REMOTE/$MAIN_BRANCH" | grep -v "$REMOTE/master" | sed "s|^  $REMOTE/||")
    
    # Convert exclude list to array
    if [ -n "$EXCLUDE_BRANCHES" ]; then
        IFS=',' read -ra EXCLUDE_ARRAY <<< "$EXCLUDE_BRANCHES"
    else
        EXCLUDE_ARRAY=()
    fi
    
    # Always exclude production branch
    EXCLUDE_ARRAY+=("production")
    
    local deleted_count=0
    local skipped_count=0
    
    for branch in $branches; do
        # Skip if in exclude list
        local skip=false
        for exclude in "${EXCLUDE_ARRAY[@]}"; do
            if [ "$branch" = "$exclude" ]; then
                skip=true
                break
            fi
        done
        
        if [ "$skip" = true ]; then
            print_color $YELLOW "⏭️  Skipping excluded remote branch: $branch"
            ((skipped_count++))
            continue
        fi
        
        # Check if branch has open PR
        if has_open_pr_github "$branch"; then
            print_color $YELLOW "🔓 Branch has open PR: $branch"
            ((skipped_count++))
            continue
        fi
        
        # Check if merged
        if git merge-base --is-ancestor "$REMOTE/$branch" "$MAIN_BRANCH" 2>/dev/null; then
            if [ "$DRY_RUN" = true ]; then
                print_color $YELLOW "[DRY RUN] Would delete remote branch: $branch"
            else
                if [ "$FORCE" = false ]; then
                    read -p "Delete remote branch $branch? (y/N) " -n 1 -r
                    echo
                    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                        ((skipped_count++))
                        continue
                    fi
                fi
                
                if git push "$REMOTE" --delete "$branch" 2>/dev/null; then
                    print_color $GREEN "✅ Deleted remote branch: $branch"
                    ((deleted_count++))
                else
                    print_color $RED "❌ Failed to delete remote branch: $branch"
                fi
            fi
        else
            print_color $YELLOW "⚠️  Remote branch not fully merged: $branch"
            ((skipped_count++))
        fi
    done
    
    print_color $BLUE "📊 Remote cleanup complete: $deleted_count deleted, $skipped_count skipped"
}

# Main execution
main() {
    print_color $BLUE "🧹 SuperClaude Git Cleanup"
    print_color $BLUE "========================="
    
    if [ "$DRY_RUN" = true ]; then
        print_color $YELLOW "🔍 Running in DRY RUN mode - no changes will be made"
    fi
    
    # Verify we're in a git repo
    check_git_repo
    
    # Find main branch
    find_main_branch
    print_color $GREEN "✓ Main branch: $MAIN_BRANCH"
    
    # Check for uncommitted changes
    check_uncommitted_changes
    
    # Update main branch
    update_main_branch
    
    # Clean up local branches
    delete_local_branches
    
    # Clean up remote branches
    delete_remote_branches
    
    print_color $GREEN "✨ Git cleanup complete!"
}

# Run main function
main
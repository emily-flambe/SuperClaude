#!/usr/bin/env bash
# validate-config.sh - PreToolUse hook to force Claude configuration validation
#
# SYNOPSIS
#   validate-config.sh
#
# DESCRIPTION
#   A PreToolUse hook that ensures Claude always checks and loads configurations
#   from the .claude directory before executing any tools. This prevents random
#   configuration loading failures by validating configs are accessible.
#
# CONFIGURATION
#   Set CLAUDE_CONFIG_VALIDATION_DEBUG=1 for debug output
#   Configure in ~/.claude/settings.json under hooks.PreToolUse
#
# EXIT CODES
#   0 - Success (configuration validated successfully)
#   1 - Configuration validation failed (blocks tool execution)

set -o pipefail

# ============================================================================
# CONSTANTS AND CONFIGURATION
# ============================================================================

readonly SCRIPT_NAME="validate-config"
readonly SCRIPT_VERSION="1.0.0"

# Debug mode
readonly DEBUG="${CLAUDE_CONFIG_VALIDATION_DEBUG:-0}"

# Color definitions
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Logging functions
log_debug() {
    [[ "$DEBUG" == "1" ]] && echo -e "${CYAN}[DEBUG:$SCRIPT_NAME]${NC} $*" >&2
}

log_info() {
    echo -e "${BLUE}[INFO:$SCRIPT_NAME]${NC} $*" >&2
}

log_warn() {
    echo -e "${YELLOW}[WARN:$SCRIPT_NAME]${NC} $*" >&2
}

log_error() {
    echo -e "${RED}[ERROR:$SCRIPT_NAME]${NC} $*" >&2
}

log_success() {
    echo -e "${GREEN}[OK:$SCRIPT_NAME]${NC} $*" >&2
}

# ============================================================================
# CONFIGURATION VALIDATION FUNCTIONS
# ============================================================================

# Check if a file exists and is readable
validate_file() {
    local file="$1"
    local description="$2"
    
    if [[ ! -f "$file" ]]; then
        log_error "$description not found: $file"
        return 1
    fi
    
    if [[ ! -r "$file" ]]; then
        log_error "$description not readable: $file"
        return 1
    fi
    
    log_debug "$description validated: $file"
    return 0
}

# Check if a directory exists and is accessible
validate_directory() {
    local dir="$1"
    local description="$2"
    
    if [[ ! -d "$dir" ]]; then
        log_error "$description not found: $dir"
        return 1
    fi
    
    if [[ ! -r "$dir" ]]; then
        log_error "$description not accessible: $dir"
        return 1
    fi
    
    log_debug "$description validated: $dir"
    return 0
}

# Validate global Claude configuration
validate_global_config() {
    local global_claude_dir="$HOME/.claude"
    local global_claude_md="$global_claude_dir/CLAUDE.md"
    local global_settings="$global_claude_dir/settings.json"
    
    log_debug "Validating global Claude configuration..."
    
    # Global .claude directory
    if ! validate_directory "$global_claude_dir" "Global .claude directory"; then
        return 1
    fi
    
    # Global CLAUDE.md (required)
    if ! validate_file "$global_claude_md" "Global CLAUDE.md"; then
        log_warn "Global CLAUDE.md missing - creating minimal version"
        mkdir -p "$global_claude_dir"
        cat > "$global_claude_md" <<'EOF'
# CLAUDE.md - User Configuration

This file contains user-specific instructions for Claude Code.
Add your global preferences and settings here.
EOF
    fi
    
    # Global settings.json (required)
    if ! validate_file "$global_settings" "Global settings.json"; then
        log_warn "Global settings.json missing - creating default version"
        mkdir -p "$global_claude_dir"
        cat > "$global_settings" <<'EOF'
{
  "permissions": {
    "allow": ["WebFetch", "WebSearch", "MultiEdit", "Write", "Bash", "Edit"],
    "deny": []
  },
  "model": "sonnet"
}
EOF
    fi
    
    log_success "Global configuration validated"
    return 0
}

# Validate project-specific Claude configuration
validate_project_config() {
    local pwd="$PWD"
    local project_claude_dir
    local project_claude_md
    
    log_debug "Validating project-specific Claude configuration..."
    
    # Search upward for .claude directory
    local search_dir="$pwd"
    while [[ "$search_dir" != "/" ]]; do
        if [[ -d "$search_dir/.claude" ]]; then
            project_claude_dir="$search_dir/.claude"
            project_claude_md="$project_claude_dir/CLAUDE.md"
            break
        fi
        search_dir="$(dirname "$search_dir")"
    done
    
    if [[ -n "$project_claude_dir" ]]; then
        log_debug "Found project .claude directory: $project_claude_dir"
        
        # Validate project .claude directory
        if ! validate_directory "$project_claude_dir" "Project .claude directory"; then
            return 1
        fi
        
        # Validate project CLAUDE.md if it exists
        if [[ -f "$project_claude_md" ]]; then
            if ! validate_file "$project_claude_md" "Project CLAUDE.md"; then
                return 1
            fi
        else
            log_debug "Project CLAUDE.md not found (optional)"
        fi
        
        log_success "Project configuration validated"
    else
        log_debug "No project .claude directory found (optional)"
    fi
    
    return 0
}

# Validate SuperClaude specific configurations
validate_superclaude_config() {
    local pwd="$PWD"
    
    log_debug "Checking for SuperClaude configuration..."
    
    # Search upward for SuperClaude indicators
    local search_dir="$pwd"
    while [[ "$search_dir" != "/" ]]; do
        # Look for SuperClaude-specific files
        if [[ -f "$search_dir/.claude/shared/superclaude-core.yml" ]] || \
           [[ -f "$search_dir/CLAUDE.md" && $(head -n 5 "$search_dir/CLAUDE.md" 2>/dev/null | grep -q "SuperClaude") ]]; then
            log_debug "SuperClaude configuration detected in: $search_dir"
            
            # Validate core SuperClaude files
            local superclaude_files=(
                "$search_dir/.claude/shared/superclaude-core.yml"
                "$search_dir/.claude/shared/superclaude-rules.yml"
                "$search_dir/.claude/shared/superclaude-personas.yml"
                "$search_dir/.claude/shared/superclaude-mcp.yml"
            )
            
            for file in "${superclaude_files[@]}"; do
                if [[ -f "$file" ]]; then
                    if ! validate_file "$file" "SuperClaude configuration"; then
                        return 1
                    fi
                fi
            done
            
            log_success "SuperClaude configuration validated"
            break
        fi
        search_dir="$(dirname "$search_dir")"
    done
    
    return 0
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

main() {
    log_debug "Starting configuration validation (version $SCRIPT_VERSION)"
    
    # Read tool input from stdin (if provided by Claude Code)
    local tool_input=""
    if [[ ! -t 0 ]]; then  # If stdin is not a terminal
        tool_input=$(cat 2>/dev/null || true)
        log_debug "Received tool input: ${tool_input:0:100}..."
    fi
    
    # Validate configurations in order of importance
    local validation_failed=0
    
    # 1. Global configuration (always required)
    if ! validate_global_config; then
        validation_failed=1
    fi
    
    # 2. Project configuration (optional but validate if present)
    if ! validate_project_config; then
        validation_failed=1
    fi
    
    # 3. SuperClaude configuration (validate if detected)
    if ! validate_superclaude_config; then
        validation_failed=1
    fi
    
    # Log validation to file for debugging
    local log_file="$HOME/.claude/config-validation.log"
    echo "$(date '+%Y-%m-%d %H:%M:%S'): Configuration validation completed (exit=$validation_failed) in $PWD" >> "$log_file" 2>/dev/null || true
    
    if [[ $validation_failed -eq 1 ]]; then
        log_error "Configuration validation failed - blocking tool execution"
        log_error "Fix the configuration issues above and try again"
        exit 1
    else
        log_success "All configuration validation checks passed"
        exit 0
    fi
}

# Handle script interruption
trap 'log_error "Configuration validation interrupted"; exit 1' INT TERM

# Execute main function
main "$@"
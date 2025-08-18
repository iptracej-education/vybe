#!/bin/bash
# Vybe Pre-Tool Hook - Automatic Context Management
# This runs before every Claude Code tool execution

set -e

# PERFORMANCE OPTIMIZATION: Skip for non-Vybe operations
# Check if this is likely a Vybe-related operation
if [ -z "$VYBE_ACTIVE" ] && [ ! -d ".vybe" ]; then
    # Not a Vybe project, exit early
    exit 0
fi

# Check if tool is likely Vybe-related
if [ -n "$CLAUDE_TOOL_NAME" ]; then
    case "$CLAUDE_TOOL_NAME" in
        *vybe*|*backlog*|*plan*|*execute*|*audit*|*status*|*release*|*discuss*)
            # Vybe command, continue
            ;;
        Read|Write|Edit|MultiEdit)
            # Could be Vybe-related if working on Vybe files
            if [ -z "$CLAUDE_TOOL_ARGS" ] || ! echo "$CLAUDE_TOOL_ARGS" | grep -q ".vybe"; then
                # Not working on Vybe files, skip expensive operations
                exit 0
            fi
            ;;
        *)
            # Other tools, skip unless explicitly in Vybe mode
            if [ -z "$VYBE_ACTIVE" ]; then
                exit 0
            fi
            ;;
    esac
fi

VYBE_ROOT=".vybe"
CONTEXT_DIR="$VYBE_ROOT/context"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
SESSION_ID="${CLAUDE_SESSION_ID:-$(date +%s)}"

# Ensure context directories exist
mkdir -p "$CONTEXT_DIR/sessions"
mkdir -p "$CONTEXT_DIR/tasks"
mkdir -p "$CONTEXT_DIR/dependencies"

# Detect member role
MEMBER_ROLE="${VYBE_MEMBER:-solo}"

# Check if member role is valid (if members are configured)
# OPTIMIZED: Use grep -m 1 to stop after first match
if [ -f ".vybe/backlog.md" ] && grep -m 1 -q "^## Members:" .vybe/backlog.md; then
    if [[ "$MEMBER_ROLE" =~ ^dev-[1-5]$ ]]; then
        # Valid member role
        MEMBER_STATUS="assigned"
    elif [ "$MEMBER_ROLE" = "solo" ]; then
        # No role specified but members are configured
        MEMBER_STATUS="no_role_specified"
    else
        # Invalid role
        MEMBER_STATUS="invalid_role"
    fi
else
    # No members configured - solo mode
    MEMBER_ROLE="solo"
    MEMBER_STATUS="solo_mode"
fi

# Save current session state with member awareness
SESSION_FILE="$CONTEXT_DIR/sessions/session-$SESSION_ID.json"
echo "{" > "$SESSION_FILE"
echo "  \"timestamp\": \"$TIMESTAMP\"," >> "$SESSION_FILE"
echo "  \"tool\": \"${CLAUDE_TOOL_NAME:-unknown}\"," >> "$SESSION_FILE"
echo "  \"pwd\": \"$(pwd)\"," >> "$SESSION_FILE"
echo "  \"session_id\": \"$SESSION_ID\"," >> "$SESSION_FILE"
echo "  \"member_role\": \"$MEMBER_ROLE\"," >> "$SESSION_FILE"
echo "  \"member_status\": \"$MEMBER_STATUS\"," >> "$SESSION_FILE"

# Save git state if available
if [ -d ".git" ]; then
    echo "  \"git_branch\": \"$(git branch --show-current)\"," >> "$SESSION_FILE"
    echo "  \"git_commit\": \"$(git rev-parse HEAD)\"," >> "$SESSION_FILE"
    git status --porcelain > "$CONTEXT_DIR/sessions/git-status-$SESSION_ID.txt"
    git diff --name-only > "$CONTEXT_DIR/sessions/modified-files-$SESSION_ID.txt"
fi

# Member coordination checks
if [ "$MEMBER_STATUS" = "assigned" ]; then
    # Check for member assignment conflicts
    CONFLICT_CHECK_FILE="$CONTEXT_DIR/sessions/member-conflicts-$SESSION_ID.txt"
    echo "" > "$CONFLICT_CHECK_FILE"
    
    # Check if other members are working on my assigned features
    if [ -f ".vybe/backlog.md" ]; then
        # Get my assigned features
        MY_FEATURES=$(sed -n "/^### $MEMBER_ROLE/,/^### /p" .vybe/backlog.md | grep "^- \[" | sed 's/^- \[[^]]*\] //' | sed 's/ .*//')
        
        # Check recent sessions from other members
        for other_session in "$CONTEXT_DIR/sessions"/session-*.json; do
            if [ -f "$other_session" ] && [ "$other_session" != "$SESSION_FILE" ]; then
                other_member=$(jq -r '.member_role // "unknown"' "$other_session" 2>/dev/null || echo "unknown")
                other_timestamp=$(jq -r '.timestamp // ""' "$other_session" 2>/dev/null || echo "")
                
                # Check if it's a recent session (within last hour) from different member
                if [ "$other_member" != "$MEMBER_ROLE" ] && [ "$other_member" != "solo" ] && [ "$other_member" != "unknown" ]; then
                    # Check if other member was working on my features
                    for my_feature in $MY_FEATURES; do
                        if [ -n "$my_feature" ]; then
                            other_tool=$(jq -r '.tool // ""' "$other_session" 2>/dev/null || echo "")
                            if [[ "$other_tool" == *"$my_feature"* ]]; then
                                echo "CONFLICT: $other_member was working on $my_feature (assigned to $MEMBER_ROLE) at $other_timestamp" >> "$CONFLICT_CHECK_FILE"
                            fi
                        fi
                    done
                fi
            fi
        done
        
        # Add my features to session
        echo "  \"assigned_features\": [" >> "$SESSION_FILE"
        first=true
        for feature in $MY_FEATURES; do
            if [ -n "$feature" ]; then
                if [ "$first" = true ]; then
                    echo "    \"$feature\"" >> "$SESSION_FILE"
                    first=false
                else
                    echo "    ,\"$feature\"" >> "$SESSION_FILE"
                fi
            fi
        done
        echo "  ]," >> "$SESSION_FILE"
    fi
elif [ "$MEMBER_STATUS" = "no_role_specified" ]; then
    echo "  \"warning\": \"Members configured but no VYBE_MEMBER set\"," >> "$SESSION_FILE"
elif [ "$MEMBER_STATUS" = "invalid_role" ]; then
    echo "  \"error\": \"Invalid VYBE_MEMBER: $MEMBER_ROLE\"," >> "$SESSION_FILE"
fi

# Save active tasks - OPTIMIZED: Only scan if specs exist and cache result
# Check if we have a recent active tasks cache (30 seconds)
ACTIVE_TASKS_CACHE="$CONTEXT_DIR/.cache/active-tasks"
if [ -d "$VYBE_ROOT/specs" ]; then
    if [ ! -f "$ACTIVE_TASKS_CACHE" ] || [ $(find "$ACTIVE_TASKS_CACHE" -mtime +30s 2>/dev/null | wc -l) -gt 0 ]; then
        # Cache is old or doesn't exist, rebuild it
        find "$VYBE_ROOT/specs" -maxdepth 3 -name "tasks.md" -type f > "$CONTEXT_DIR/.cache/task-files" 2>/dev/null
        if [ -f "$CONTEXT_DIR/.cache/task-files" ]; then
            grep -l "in_progress\|pending" $(cat "$CONTEXT_DIR/.cache/task-files") > "$ACTIVE_TASKS_CACHE" 2>/dev/null || echo "" > "$ACTIVE_TASKS_CACHE"
        fi
    fi
    # Use cached result
    cp "$ACTIVE_TASKS_CACHE" "$CONTEXT_DIR/sessions/active-specs-$SESSION_ID.txt" 2>/dev/null || echo "" > "$CONTEXT_DIR/sessions/active-specs-$SESSION_ID.txt"
fi

# Close session JSON
echo "  \"pre_hook_completed\": true" >> "$SESSION_FILE"
echo "}" >> "$SESSION_FILE"

# Log to main session log with member info
echo "[$TIMESTAMP] PRE-HOOK: Tool=${CLAUDE_TOOL_NAME:-unknown}, Session=$SESSION_ID, Member=$MEMBER_ROLE, Status=$MEMBER_STATUS" >> "$CONTEXT_DIR/session.log"

# Create member-specific log if assigned member
if [ "$MEMBER_STATUS" = "assigned" ]; then
    mkdir -p "$CONTEXT_DIR/members"
    echo "[$TIMESTAMP] SESSION-START: Tool=${CLAUDE_TOOL_NAME:-unknown}, Session=$SESSION_ID" >> "$CONTEXT_DIR/members/$MEMBER_ROLE.log"
fi

exit 0
#!/bin/bash
# Vybe Post-Tool Hook - Context State Management
# This runs after every Claude Code tool execution

set -e

VYBE_ROOT=".vybe"
CONTEXT_DIR="$VYBE_ROOT/context"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
SESSION_ID="${CLAUDE_SESSION_ID:-$(date +%s)}"

# Ensure context directories exist
mkdir -p "$CONTEXT_DIR/sessions"
mkdir -p "$CONTEXT_DIR/tasks"
mkdir -p "$CONTEXT_DIR/dependencies"

# Update session state
SESSION_FILE="$CONTEXT_DIR/sessions/session-$SESSION_ID.json"
if [ -f "$SESSION_FILE" ]; then
    # Create temp file for updated session
    TEMP_FILE=$(mktemp)
    
    # Read existing session and add post-hook data
    jq --arg timestamp "$TIMESTAMP" \
       --arg tool_exit_code "${CLAUDE_TOOL_EXIT_CODE:-0}" \
       --arg post_timestamp "$TIMESTAMP" \
       '. + {
         "post_hook_timestamp": $post_timestamp,
         "tool_exit_code": $tool_exit_code,
         "post_hook_completed": true
       }' "$SESSION_FILE" > "$TEMP_FILE"
    
    mv "$TEMP_FILE" "$SESSION_FILE"
else
    # Create new session file if pre-hook didn't run
    echo "{" > "$SESSION_FILE"
    echo "  \"timestamp\": \"$TIMESTAMP\"," >> "$SESSION_FILE"
    echo "  \"tool\": \"${CLAUDE_TOOL_NAME:-unknown}\"," >> "$SESSION_FILE"
    echo "  \"session_id\": \"$SESSION_ID\"," >> "$SESSION_FILE"
    echo "  \"post_hook_only\": true," >> "$SESSION_FILE"
    echo "  \"post_hook_completed\": true" >> "$SESSION_FILE"
    echo "}" >> "$SESSION_FILE"
fi

# Update git state if available
if [ -d ".git" ]; then
    git status --porcelain > "$CONTEXT_DIR/sessions/git-status-post-$SESSION_ID.txt"
    
    # Check if there are changes to commit
    if [ -n "$(git status --porcelain)" ]; then
        echo "Git changes detected after tool execution" >> "$CONTEXT_DIR/session.log"
    fi
fi

# Update task status if this was a task delegation
if [[ "${CLAUDE_TOOL_NAME:-}" == *"task-delegate"* ]] || [[ "${CLAUDE_TOOL_NAME:-}" == *"task-continue"* ]]; then
    # Extract task info from tool args if available
    TASK_INFO="${CLAUDE_TOOL_ARGS:-}"
    if [ -n "$TASK_INFO" ]; then
        echo "[$TIMESTAMP] TASK-UPDATE: $TASK_INFO completed" >> "$CONTEXT_DIR/task-updates.log"
    fi
fi

# Update dependency tracking
if [ -f "$CONTEXT_DIR/dependencies/dependency-graph.json" ]; then
    # Check for completed tasks and update dependent tasks
    .claude/hooks/context/update-dependencies.sh 2>/dev/null || true
fi

# Log to main session log
echo "[$TIMESTAMP] POST-HOOK: Tool=${CLAUDE_TOOL_NAME:-unknown}, Session=$SESSION_ID, Exit=${CLAUDE_TOOL_EXIT_CODE:-0}" >> "$CONTEXT_DIR/session.log"

exit 0
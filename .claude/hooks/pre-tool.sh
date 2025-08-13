#!/bin/bash
# Vybe Pre-Tool Hook - Automatic Context Management
# This runs before every Claude Code tool execution

set -e

VYBE_ROOT=".vybe"
CONTEXT_DIR="$VYBE_ROOT/context"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
SESSION_ID="${CLAUDE_SESSION_ID:-$(date +%s)}"

# Ensure context directories exist
mkdir -p "$CONTEXT_DIR/sessions"
mkdir -p "$CONTEXT_DIR/tasks"
mkdir -p "$CONTEXT_DIR/dependencies"

# Save current session state
SESSION_FILE="$CONTEXT_DIR/sessions/session-$SESSION_ID.json"
echo "{" > "$SESSION_FILE"
echo "  \"timestamp\": \"$TIMESTAMP\"," >> "$SESSION_FILE"
echo "  \"tool\": \"${CLAUDE_TOOL_NAME:-unknown}\"," >> "$SESSION_FILE"
echo "  \"pwd\": \"$(pwd)\"," >> "$SESSION_FILE"
echo "  \"session_id\": \"$SESSION_ID\"," >> "$SESSION_FILE"

# Save git state if available
if [ -d ".git" ]; then
    echo "  \"git_branch\": \"$(git branch --show-current)\"," >> "$SESSION_FILE"
    echo "  \"git_commit\": \"$(git rev-parse HEAD)\"," >> "$SESSION_FILE"
    git status --porcelain > "$CONTEXT_DIR/sessions/git-status-$SESSION_ID.txt"
    git diff --name-only > "$CONTEXT_DIR/sessions/modified-files-$SESSION_ID.txt"
fi

# Save active tasks
if [ -d "$VYBE_ROOT/specs" ]; then
    find "$VYBE_ROOT/specs" -name "tasks.md" -exec grep -l "in_progress\|pending" {} \; > "$CONTEXT_DIR/sessions/active-specs-$SESSION_ID.txt" 2>/dev/null || echo "" > "$CONTEXT_DIR/sessions/active-specs-$SESSION_ID.txt"
fi

# Close session JSON
echo "  \"pre_hook_completed\": true" >> "$SESSION_FILE"
echo "}" >> "$SESSION_FILE"

# Log to main session log
echo "[$TIMESTAMP] PRE-HOOK: Tool=${CLAUDE_TOOL_NAME:-unknown}, Session=$SESSION_ID" >> "$CONTEXT_DIR/session.log"

exit 0
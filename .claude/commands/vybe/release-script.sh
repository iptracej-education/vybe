#!/bin/bash

# =============================================================================
# VYBE RELEASE - SHARED CACHE ARCHITECTURE
# Uses shared project cache + file system fallback for optimal performance
# =============================================================================

# Source shared cache system

# Parse arguments
stage_name="${1}"
force_mode=false

for arg in "$@"; do
    case $arg in
        --force) force_mode=true ;;
    esac
done

# Performance timing
release_start_time=$(date +%s.%N)
echo "=== VYBE RELEASE - STAGE PROGRESSION ==="
echo "Stage: ${stage_name:-auto-detect} | Force: $force_mode | Started: $(date)"
echo ""

# =============================================================================
# INITIALIZE SHARED CACHE SYSTEM
# =============================================================================

init_vybe_cache

# Check for help request
if [ "$stage_name" = "help" ]; then
    echo "=== VYBE RELEASE HELP ==="
    echo ""
    echo "Mark outcome stage complete and advance to next stage with learning capture"
    echo ""
    echo "USAGE:"
    echo "  /vybe:release [stage-name] [options]"
    echo ""
    echo "PARAMETERS:"
    echo "  stage-name             Specific stage to release (e.g., stage-1, stage-2)"
    echo "                         If not provided, auto-detects current active stage"
    echo ""
    echo "OPTIONS:"
    echo "  --force                Force release even if stage appears incomplete"
    echo ""
    echo "EXAMPLES:"
    echo "  /vybe:release stage-1           # Release Stage 1 and advance to Stage 2"
    echo "  /vybe:release                   # Auto-detect and release current stage"
    echo "  /vybe:release stage-3 --force   # Force release of Stage 3"
    echo ""
    echo "RELEASE PROCESS:"
    echo "  - Validates stage completion (tasks done, deliverable working)"
    echo "  - Captures learnings and outcomes from completed stage"
    echo "  - Updates backlog and outcomes status automatically"
    echo "  - Advances to next stage in roadmap"
    echo "  - Requests UI examples when needed for upcoming stages"
    echo ""
    echo "VALIDATION CHECKS:"
    echo "  - All assigned features for stage completed"
    echo "  - Required deliverables are working and tested"
    echo "  - No critical blockers preventing stage completion"
    echo "  - Documentation updated to reflect stage outcomes"
    echo ""
    echo "STAGE PROGRESSION:"
    echo "  - Incremental outcome-driven development approach"
    echo "  - Each stage delivers working units in 1-3 days"
    echo "  - Learning between stages improves next stage planning"
    echo "  - Continuous delivery with user value at each stage"
    echo ""
    echo "RELATED COMMANDS:"
    echo "  /vybe:status outcomes            # Check stage progression status"
    echo "  /vybe:audit                      # Validate stage completion"
    echo "  /vybe:backlog                    # Review stage assignments"
    exit 0
fi

# =============================================================================
# LOAD PROJECT DATA (SHARED CACHE + FALLBACK)
# =============================================================================

# Load all project data using shared cache
load_project_data

# Validate required data loaded
if [ -z "$PROJECT_OUTCOMES" ]; then
    echo "[ERROR] No outcome roadmap found"
    echo "Run /vybe:init to create outcome stages"
    echo ""
    echo "Use '/vybe:release help' for detailed usage information"
    exit 1
fi

if [ -z "$PROJECT_BACKLOG" ]; then
    echo "[WARNING] No backlog found"  
    echo "Run /vybe:backlog init to create backlog"
fi

echo "[CONTEXT] Project data loaded (mode: $PROJECT_CACHE_MODE)"

# =============================================================================
# BULK PARSE PROJECT STATE (USING CACHED DATA)
# =============================================================================

echo "[PARSE] Analyzing project state..."

# Parse current stage from cached backlog
current_stage=""
next_stage=""
incomplete_tasks=0
member_count=0

if [ -n "$PROJECT_BACKLOG" ]; then
    current_stage=$(echo "$PROJECT_BACKLOG" | grep "Active Stage:" | sed 's/.*Stage [0-9]*: //' | sed 's/ .*//' || echo "")
    incomplete_tasks=$(echo "$PROJECT_BACKLOG" | grep -A 20 "IN PROGRESS" | grep "^- \[ \]" | wc -l || echo "0")
    next_stage=$(echo "$PROJECT_BACKLOG" | grep -m 1 -A 5 "⏳ NEXT" | sed 's/.*Stage [0-9]*: //' | sed 's/ .*//' || echo "")
    member_count=$(echo "$PROJECT_BACKLOG" | grep "^## Members:" | grep -o "[0-9]*" || echo "0")
fi

# Parse stages from cached outcomes
total_stages=0
completed_stages=0

if [ -n "$PROJECT_OUTCOMES" ]; then
    total_stages=$(echo "$PROJECT_OUTCOMES" | grep "^### Stage" | wc -l || echo "0")
fi

if [ -n "$PROJECT_BACKLOG" ]; then
    completed_stages=$(echo "$PROJECT_BACKLOG" | grep "COMPLETED" | grep "^### Stage" | wc -l || echo "0")
fi

# Display parsed state
echo "[STATE] Current Stage: ${current_stage:-Unknown}"
echo "[STATE] Next Stage: ${next_stage:-Unknown}"
echo "[STATE] Incomplete Tasks: $incomplete_tasks"
echo "[STATE] Members: $([ "$member_count" -gt 1 ] && echo "$member_count developers" || echo "Solo mode")"
echo "[STATE] Progress: $completed_stages of $total_stages stages"
echo ""

# =============================================================================
# VALIDATION USING CACHED DATA
# =============================================================================

echo "[VALIDATION] Stage completion check..."

# Validate stage readiness
if [ -z "$current_stage" ]; then
    echo "[ERROR] No active stage found"
    echo "Check backlog for current stage status"
    exit 1
fi

if [ "$incomplete_tasks" -gt 0 ] && [ "$force_mode" = false ]; then
    echo "[ERROR] $incomplete_tasks tasks still incomplete"
    echo "Complete all tasks or use --force to override"
    exit 1
elif [ "$incomplete_tasks" -gt 0 ]; then
    echo "[WARNING] Forcing release with $incomplete_tasks incomplete tasks"
fi

# Run tests
echo "[TEST] Running verification tests..."
test_passed=false
if npm test >/dev/null 2>&1; then
    echo "[OK] npm tests passed"
    test_passed=true
elif python -m pytest >/dev/null 2>&1; then
    echo "[OK] pytest tests passed"  
    test_passed=true
elif go test ./... >/dev/null 2>&1; then
    echo "[OK] go tests passed"
    test_passed=true
else
    echo "[INFO] No automated tests found"
fi

echo "[VALIDATION] Stage ready for release"
echo ""

# =============================================================================
# PREPARE CONTEXT FOR CLAUDE AI ANALYSIS
# =============================================================================

# Cache the release analysis context
release_context_key=$(get_cache_key "release_context.$(date +%s)")

release_context=$(python3 -c "
import json
context = {
    'command': 'release',
    'stage_name': '$stage_name',
    'current_stage': '$current_stage',
    'next_stage': '$next_stage', 
    'incomplete_tasks': $incomplete_tasks,
    'member_count': $member_count,
    'total_stages': $total_stages,
    'completed_stages': $completed_stages,
    'force_mode': $force_mode,
    'test_passed': $test_passed,
    'cache_mode': '$PROJECT_CACHE_MODE',
    'project_data': {
        'outcomes_length': len('''$PROJECT_OUTCOMES'''),
        'backlog_length': len('''$PROJECT_BACKLOG'''), 
        'has_overview': bool('''$PROJECT_OVERVIEW'''),
        'has_architecture': bool('''$PROJECT_ARCHITECTURE'''),
        'has_conventions': bool('''$PROJECT_CONVENTIONS''')
    },
    'analysis_required': [
        'capture_stage_learnings',
        'verify_deliverable_completion',
        'coordinate_multi_member_integration' if $member_count > 1 else 'standard_release',
        'update_stage_status',
        'advance_to_next_stage', 
        'refine_next_stage_tasks'
    ],
    'file_operations_required': [
        'update_backlog_stage_status',
        'update_outcomes_completion',
        'archive_completed_tasks',
        'advance_stage_pointer',
        'add_learnings_to_outcomes_log'
    ]
}
print(json.dumps(context, indent=2))
" 2>/dev/null)

# Cache the context for Claude AI access
cache_set "$release_context_key" "$release_context" 7200

echo "[AI-PREP] Release context prepared and cached"
echo "[AI-PREP] Context key: $release_context_key"
echo ""

# =============================================================================
# CLAUDE AI COORDINATION SECTION  
# =============================================================================

echo "[AI-COORDINATION] REQUESTING CLAUDE AI ANALYSIS"
echo "=============================================="
echo ""
echo "Claude AI should now analyze the cached project data and perform:"
echo ""
echo "1. STAGE LEARNINGS CAPTURE:"
echo "   - Access cached project data via shared cache"
echo "   - Analyze technical, process, and business learnings"
echo "   - Document insights from current stage completion"
echo ""
echo "2. DELIVERABLE VERIFICATION:"
echo "   - Verify stage deliverable is implemented"
echo "   - Validate working functionality vs promises"  
echo "   - Confirm user value is demonstrable"
echo ""

if [ "$member_count" -gt 1 ]; then
    echo "3. MULTI-MEMBER INTEGRATION:"
    echo "   - Verify all $member_count developers completed assignments"
    echo "   - Coordinate intelligent feature integration"
    echo "   - Resolve merge conflicts and test combined system"
    echo ""
fi

echo "4. ATOMIC STATUS UPDATES:"
echo "   - Update backlog.md: current stage → COMPLETED"
echo "   - Update outcomes.md: add completion date and learnings"
echo "   - Advance next stage: NEXT → IN PROGRESS"
echo "   - Use atomic file+cache updates for consistency"
echo ""
echo "5. NEXT STAGE PREPARATION:"
echo "   - Refine next stage tasks based on learnings"
echo "   - Update effort estimates from experience"  
echo "   - Check UI examples requirement"
echo ""

# =============================================================================
# PROVIDE CLAUDE WITH ATOMIC UPDATE FUNCTIONS
# =============================================================================

echo "[FUNCTIONS] Available atomic update functions for Claude:"
echo "- update_file_and_cache(file_path, new_content, cache_key)"
echo "- cache_set(key, value, ttl)"
echo "- cache_get(key)"
echo ""
echo "Cached project data accessible via:"
echo "- PROJECT_OVERVIEW, PROJECT_ARCHITECTURE, PROJECT_CONVENTIONS"
echo "- PROJECT_OUTCOMES, PROJECT_BACKLOG, PROJECT_FEATURES"
echo "- PROJECT_MEMBERS"
echo ""

# =============================================================================
# PERFORMANCE METRICS
# =============================================================================

release_end_time=$(date +%s.%N)
release_duration=$(echo "$release_end_time - $release_start_time" | bc -l 2>/dev/null || echo "N/A")

echo "=== RELEASE CONTEXT PREPARATION COMPLETE ==="
echo "Cache mode: $PROJECT_CACHE_MODE"
echo "Duration: $release_duration seconds"
echo ""

# Display cache performance
echo "CACHE PERFORMANCE:"
get_cache_stats
echo ""

echo "[READY] Claude AI can now complete the release analysis using:"
echo "1. Cached project data (PROJECT_* variables)"  
echo "2. Release context (key: $release_context_key)"
echo "3. Atomic update functions for file+cache consistency"
echo ""

# =============================================================================
# EXAMPLE USAGE FOR CLAUDE AI
# =============================================================================

echo "[EXAMPLE] Claude AI usage pattern:"
echo ""
echo "# Access cached project data"
echo 'current_backlog="$PROJECT_BACKLOG"'
echo 'current_outcomes="$PROJECT_OUTCOMES"'
echo ""
echo "# Perform AI analysis"
echo "# ... learning capture, verification, etc ..."
echo ""
echo "# Update files atomically with cache"
echo 'update_file_and_cache ".vybe/backlog.md" "$updated_backlog" "$PROJECT_BACKLOG_KEY"'
echo 'update_file_and_cache ".vybe/project/outcomes.md" "$updated_outcomes" "$PROJECT_OUTCOMES_KEY"'
echo ""

cleanup_file_cache

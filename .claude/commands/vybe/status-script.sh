#!/bin/bash

# =============================================================================
# VYBE PROJECT STATUS - SHARED CACHE ARCHITECTURE
# Uses shared project cache + file system fallback for optimal performance
# =============================================================================

# Parse arguments FIRST
status_scope="${1:-overall}"
status_options="$*"

# =============================================================================
# EARLY HELP CHECK (before ANY initialization)
# =============================================================================

# Check for help request early to avoid unnecessary cache loading
if [ "$status_scope" = "help" ]; then
    echo "=== VYBE STATUS HELP ==="
    echo ""
    echo "Member-aware progress tracking with assignment visibility"
    echo ""
    echo "USAGE:"
    echo "  /vybe:status [scope] [options]"
    echo ""
    echo "SCOPES:"
    echo "  [default/overall]      Overall project progress and health dashboard"
    echo "  members                Team assignments and workload distribution"
    echo "  outcomes               Staged outcome progression and timeline"
    echo "  dev-1, dev-2, dev-N    Individual member progress and assignments"
    echo "  [feature-name]         Specific feature status and progress"
    echo "  blockers               Current blockers and dependencies"
    echo "  help                   Show this help message"
    echo ""
    echo "EXAMPLES:"
    echo "  /vybe:status                    # Overall project dashboard"
    echo "  /vybe:status overall            # Same as default"
    echo "  /vybe:status members            # Team member assignments"
    echo "  /vybe:status outcomes           # Outcome stage progression"
    echo "  /vybe:status dev-1              # Developer 1's assignments"
    echo "  /vybe:status user-auth          # Status of user-auth feature"
    echo "  /vybe:status blockers           # Show blocked features"
    echo ""
    echo "STATUS INFORMATION:"
    echo "  - Project progress percentage and feature completion"
    echo "  - Member workload distribution and assignments"
    echo "  - Stage progression and outcome tracking"
    echo "  - Blocker identification and dependency analysis"
    echo "  - Performance metrics and cache status"
    echo ""
    echo "RELATED COMMANDS:"
    echo "  /vybe:audit               # Quality assurance and gap detection"
    echo "  /vybe:backlog members     # Configure team members"
    echo "  /vybe:execute [feature]   # Work on specific features"
    exit 0
fi

# =============================================================================
# NOW INITIALIZE EVERYTHING ELSE (after help check)
# =============================================================================

# Source shared cache system
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/shared-cache.sh"

# Performance timing
status_start_time=$(date +%s.%N)
echo "=== VYBE PROJECT STATUS ==="
echo "Scope: $status_scope | Started: $(date)"
echo ""

# =============================================================================
# INITIALIZE SHARED CACHE SYSTEM
# =============================================================================

init_vybe_cache

# =============================================================================
# LOAD PROJECT DATA (SHARED CACHE + FALLBACK)
# =============================================================================

# Load all project data using shared cache
load_project_data
echo "[CONTEXT] Project data loaded (mode: $PROJECT_CACHE_MODE)"

# =============================================================================
# SMART CACHE CHECK - STATUS-SPECIFIC CACHE
# =============================================================================

cache_hit=false
cached_status_data=""
status_cache_key=$(get_cache_key "status.$status_scope")

echo "[CACHE] Checking for cached status data..."

# Try to get cached status results
cached_status_data=$(cache_get "$status_cache_key")

if [ $? -eq 0 ] && [ -n "$cached_status_data" ]; then
    cache_hit=true
    echo "[CACHE] Valid cached status found - using cached results"
else
    echo "[CACHE] No cached status found - performing fresh scan"
fi

# =============================================================================
# BULK PROJECT STATUS PROCESSING (if cache miss)
# =============================================================================

if [ "$cache_hit" = false ]; then
    echo ""
    echo "[SCAN] Performing bulk status analysis..."
    
    # Validate project exists
    if [ ! -d ".vybe/project" ]; then
        echo "[ERROR] Project not initialized"
        echo "Run /vybe:init first to set up project structure"
        exit 1
    fi
    
    # Initialize status variables
    total_features=0
    completed_features=0
    active_features=0
    blocked_features=0
    project_name="Unknown Project"
    
    # Load project name
    if [ -f ".vybe/project/overview.md" ]; then
        project_name=$(grep "^# " .vybe/project/overview.md 2>/dev/null | head -1 | sed 's/^# //' || echo "Unknown Project")
    fi
    
    echo "[CONTEXT] Loading project status for: $project_name"
    
    # BULK FEATURE ANALYSIS
    if [ -d ".vybe/features" ]; then
        # Count features efficiently
        total_features=$(find .vybe/features -maxdepth 1 -type d 2>/dev/null | grep -c "/.vybe/features/" || echo "0")
        total_features=$(echo "$total_features" | tr -d '\n')
        # Ensure it's a proper number
        total_features=$(echo "$total_features" | grep -E '^[0-9]+$' || echo "0")
        
        echo "[FOUND] $total_features features detected"
        
        if [ "$total_features" -gt 0 ]; then
            # Bulk analyze all features
            for feature_dir in .vybe/features/*/; do
                if [ -d "$feature_dir" ]; then
                    feature_name=$(basename "$feature_dir")
                    
                    # Check completion status
                    if [ -f ".vybe/backlog.md" ] && grep -q "^- \[x\] $feature_name" .vybe/backlog.md; then
                        completed_features=$((completed_features + 1))
                    elif [ -f "$feature_dir/status.md" ]; then
                        if grep -q "Status.*[Cc]omplete" "$feature_dir/status.md"; then
                            completed_features=$((completed_features + 1))
                        elif grep -q "Status.*[Bb]locked" "$feature_dir/status.md"; then
                            blocked_features=$((blocked_features + 1))
                        else
                            active_features=$((active_features + 1))
                        fi
                    else
                        active_features=$((active_features + 1))
                    fi
                fi
            done
        fi
    fi
    
    # Calculate progress
    if [ $total_features -gt 0 ]; then
        progress_percent=$((completed_features * 100 / total_features))
    else
        progress_percent=0
    fi
    
    # Load member information
    member_count=0
    member_assignments=""
    if [ -f ".vybe/backlog.md" ] && grep -q "^## Members:" .vybe/backlog.md; then
        member_count=$(grep -A 10 "^## Members:" .vybe/backlog.md 2>/dev/null | grep "^- dev-" | wc -l)
        member_assignments=$(grep -A 20 "^## Member Assignments:" .vybe/backlog.md 2>/dev/null | grep "^- " || echo "No assignments found")
    fi
    
    # Load outcome progression
    current_stage=""
    total_stages=0
    completed_stages=0
    if [ -f ".vybe/project/outcomes.md" ] && [ -f ".vybe/backlog.md" ]; then
        current_stage=$(grep "Active Stage:" .vybe/backlog.md 2>/dev/null | sed 's/.*Stage \([0-9]*\).*/\1/')
        total_stages=$(grep "^### Stage" .vybe/project/outcomes.md 2>/dev/null | wc -l)
        completed_stages=$(grep "COMPLETED" .vybe/backlog.md 2>/dev/null | grep "^### Stage" | wc -l)
    fi
    
    # Create status summary based on scope
    case "$status_scope" in
        "overall"|"")
            status_output="PROJECT STATUS DASHBOARD
============================

PROJECT: $project_name

PROGRESS: $progress_percent% ($completed_features/$total_features features completed)
- Completed: $completed_features features
- Active: $active_features features  
- Blocked: $blocked_features features

OUTCOME PROGRESSION:"
            
            if [ -n "$current_stage" ] && [ "$total_stages" -gt 0 ]; then
                status_output="$status_output
- Current: Stage $current_stage (IN PROGRESS)
- Completed: $completed_stages of $total_stages stages
- Timeline: Each stage targets 1-3 days delivery"
            else
                status_output="$status_output
- No staged outcomes configured
- Run /vybe:init with outcome stages for incremental delivery"
            fi
            
            if [ "$member_count" -gt 0 ]; then
                status_output="$status_output

TEAM COORDINATION:
- Members: $member_count configured (dev-1 through dev-$member_count)
- Multi-member coordination active
- Use /vybe:status members for detailed assignments"
            else
                status_output="$status_output

MODE: Solo development (no team members configured)"
            fi
            ;;
            
        "members")
            status_output="MEMBER ASSIGNMENTS & COORDINATION
=================================

TEAM SIZE: $member_count members configured

ASSIGNMENTS:
$member_assignments

WORKLOAD DISTRIBUTION:"
            
            for i in $(seq 1 $member_count); do
                if [ -f ".vybe/backlog.md" ]; then
                    dev_assignments=$(grep "dev-$i" .vybe/backlog.md 2>/dev/null | wc -l)
                    status_output="$status_output
- dev-$i: $dev_assignments assignments"
                fi
            done
            ;;
            
        "dev-"*)
            member_id="${status_scope}"
            status_output="INDIVIDUAL MEMBER STATUS: $member_id
===================================

ASSIGNMENTS:"
            if [ -f ".vybe/backlog.md" ]; then
                member_tasks=$(grep "$member_id" .vybe/backlog.md 2>/dev/null || echo "No assignments found")
                status_output="$status_output
$member_tasks

CURRENT FOCUS: 
$(echo "$member_tasks" | grep "IN PROGRESS" || echo "No active tasks")"
            else
                status_output="$status_output
No backlog found - run /vybe:backlog init"
            fi
            ;;
            
        "blockers")
            status_output="PROJECT BLOCKERS & DEPENDENCIES
==============================

BLOCKED FEATURES: $blocked_features"
            
            if [ "$blocked_features" -gt 0 ] && [ -d ".vybe/features" ]; then
                for feature_dir in .vybe/features/*/; do
                    if [ -f "$feature_dir/status.md" ] && grep -q "Status.*[Bb]locked" "$feature_dir/status.md"; then
                        feature_name=$(basename "$feature_dir")
                        blocker_reason=$(grep -A 3 "Status.*[Bb]locked" "$feature_dir/status.md" | tail -1 || echo "Reason not specified")
                        status_output="$status_output
- $feature_name: $blocker_reason"
                    fi
                done
            else
                status_output="$status_output
No blocked features found"
            fi
            ;;
            
        *)
            # Feature-specific status
            feature_name="$status_scope"
            if [ -d ".vybe/features/$feature_name" ]; then
                feature_status="Unknown"
                if [ -f ".vybe/features/$feature_name/status.md" ]; then
                    feature_status=$(grep "Status:" ".vybe/features/$feature_name/status.md" | head -1 || echo "Status: Unknown")
                fi
                
                status_output="FEATURE STATUS: $feature_name
========================

$feature_status

SPECIFICATIONS:
- Requirements: $([ -f ".vybe/features/$feature_name/requirements.md" ] && echo "Present" || echo "Missing")
- Design: $([ -f ".vybe/features/$feature_name/design.md" ] && echo "Present" || echo "Missing") 
- Tasks: $([ -f ".vybe/features/$feature_name/tasks.md" ] && echo "Present" || echo "Missing")

ASSIGNMENT:"
                if [ -f ".vybe/backlog.md" ]; then
                    assignment=$(grep "$feature_name" .vybe/backlog.md | grep "dev-" || echo "Unassigned")
                    status_output="$status_output
$assignment"
                else
                    status_output="$status_output
No assignments found"
                fi
            else
                status_output="FEATURE NOT FOUND: $feature_name
Feature directory .vybe/features/$feature_name does not exist
Run /vybe:plan $feature_name \"description\" to create it"
            fi
            ;;
            
    esac
    
    # CACHE STATUS RESULTS using shared cache system
    echo ""
    echo "[CACHE] Saving status results..."
    
    # Cache the status results for future use
    cache_set "$status_cache_key" "$status_output" 1800
    
    echo "[CACHE] Results cached"
    
    cached_status_data="$status_output"
fi

# =============================================================================
# OUTPUT RESULTS (from cache or fresh scan)
# =============================================================================

status_end_time=$(date +%s.%N)
status_duration=$(echo "$status_end_time - $status_start_time" | bc -l 2>/dev/null || echo "N/A")

echo ""
echo "$cached_status_data"
echo ""

# =============================================================================
# CACHE STATUS METRICS
# =============================================================================

echo "CACHE STATUS:"
echo "- Mode: $([ "$cache_hit" = true ] && echo "cached results" || echo "fresh scan + caching")"
echo "- Cache type: $PROJECT_CACHE_MODE" 
echo "- Execution time: $status_duration seconds"
echo ""
get_cache_stats

echo ""
echo "=== STATUS EXECUTION COMPLETE ==="
echo "Mode: $([ "$cache_hit" = true ] && echo "cached" || echo "bulk processing")"
echo "Duration: $status_duration seconds"
echo ""

# Related commands
if [ -n "$cached_status_data" ]; then
    echo "RELATED COMMANDS:"
    case "$status_scope" in
        "overall")
            echo "- /vybe:status members - View team assignments"
            echo "- /vybe:status blockers - Check for blockers"
            echo "- /vybe:audit - Run quality assurance"
            ;;
        "members")
            echo "- /vybe:status dev-1 - Individual member status"
            echo "- /vybe:backlog assign [feature] [dev-N] - Assign work"
            ;;
        "blockers")
            echo "- /vybe:audit dependencies - Check dependencies"
            echo "- /vybe:execute [feature] - Unblock features"
            ;;
        *)
            echo "- /vybe:status - Overall project status"
            echo "- /vybe:execute $status_scope - Work on this feature"
            ;;
    esac
    echo ""
fi
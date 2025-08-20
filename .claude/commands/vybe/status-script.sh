#!/bin/bash

# =============================================================================
# VYBE PROJECT STATUS - SHARED CACHE ARCHITECTURE
# Uses shared project cache + file system fallback for optimal performance
# =============================================================================

# Force immediate output display and flushing
set -u

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

# =============================================================================
# INITIALIZE SHARED CACHE SYSTEM
# =============================================================================

init_vybe_cache >/dev/null 2>&1

# Load all project data using shared cache  
load_project_data >/dev/null 2>&1

# =============================================================================
# SMART CACHE CHECK - STATUS-SPECIFIC CACHE
# =============================================================================

cache_hit=false
cached_status_data=""
status_cache_key=$(get_cache_key "status.$status_scope")

# Check for cached status data

# Try to get cached status results
cached_status_data=$(cache_get "$status_cache_key")

if [ $? -eq 0 ] && [ -n "$cached_status_data" ]; then
    # Check if input files have been modified since cache was created
    # Check cache dependencies
    
    # Get cache modification time (use simple timestamp file)
    cache_timestamp_file=".vybe/.cache/status_${status_scope}_timestamp"
    
    # Create timestamp file if it doesn't exist (for this cache entry)
    if [ ! -f "$cache_timestamp_file" ]; then
        date +%s > "$cache_timestamp_file"
    fi
    
    # Check if any input files are newer than cache
    input_files_modified=false
    
    # Check project files
    if [ -d ".vybe/project" ]; then
        if find .vybe/project -name "*.md" -newer "$cache_timestamp_file" 2>/dev/null | grep -q .; then
            input_files_modified=true
            #echo "[CACHE] Project files modified since cache creation"
        fi
    fi
    
    # Check backlog file
    if [ -f ".vybe/backlog.md" ] && [ ".vybe/backlog.md" -nt "$cache_timestamp_file" ]; then
        input_files_modified=true
        #echo "[CACHE] Backlog modified since cache creation"
    fi
    
    # Check features directory
    if [ -d ".vybe/features" ]; then
        if find .vybe/features -name "*.md" -newer "$cache_timestamp_file" 2>/dev/null | grep -q .; then
            input_files_modified=true
            #echo "[CACHE] Features modified since cache creation"
        fi
    fi
    
    if [ "$input_files_modified" = true ]; then
        #echo "[CACHE] Input dependencies changed - invalidating status cache"
        cache_hit=false
        cached_status_data=""
        # Update timestamp for new cache entry
        date +%s > "$cache_timestamp_file"
    else
        cache_hit=true
        #echo "[CACHE] Valid cached status found - using cached results"
    fi
else
    cache_hit=false
fi

# =============================================================================
# BULK PROJECT STATUS PROCESSING (if cache miss)
# =============================================================================

if [ "$cache_hit" = false ]; then
    echo ""
    #echo "[SCAN] Performing bulk status analysis..."
    
    # Validate project exists
    if [ ! -d ".vybe/project" ]; then
        #echo "[ERROR] Project not initialized"
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
    
    #echo "[CONTEXT] Loading project status for: $project_name"
    
    # BULK FEATURE ANALYSIS - READ FROM BACKLOG FORMAT
    # First try to read total features from backlog.md (authoritative source)
    if [ -f ".vybe/backlog.md" ]; then
        total_features=$(grep "Total Features.*:" .vybe/backlog.md 2>/dev/null | sed 's/.*Total Features[^:]*: *\([0-9]\+\).*/\1/' | head -1)
        if [ -z "$total_features" ] || [ "$total_features" = "" ]; then
            total_features="0"
        fi
        #echo "[BACKLOG] Found $total_features total features in backlog"
    fi
    
    # Fallback to directory counting if backlog doesn't have the count
    if [ "$total_features" = "0" ] && [ -d ".vybe/features" ]; then
        # Count feature subdirectories (exclude the features directory itself)
        total_features=$(find .vybe/features -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
        total_features=$(echo "$total_features" | tr -d ' \n')
        # Ensure it's a proper number
        total_features=$(echo "$total_features" | grep -E '^[0-9]+$' || echo "0")
        #echo "[DIRECTORY] Found $total_features feature directories"
    fi
    
    # Analyze feature status - handle both directory-based and backlog-based counting
    if [ "$total_features" -gt 0 ] && [ -d ".vybe/features" ]; then
        # Count actual feature directories and their status
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
        
        # Count actual feature directories
        actual_feature_dirs=$(find .vybe/features -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
        actual_feature_dirs=$(echo "$actual_feature_dirs" | tr -d ' \n')
        
        #echo "[ANALYSIS] $actual_feature_dirs feature directories found, $total_features total planned"
        
        # If total features comes from backlog but we have fewer directories, 
        # the remainder are planned/not-yet-created features
        if [ "$actual_feature_dirs" -lt "$total_features" ]; then
            planned_features=$((total_features - actual_feature_dirs))
            #echo "[PLANNING] $planned_features features planned but not yet created"
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
    
    # Updated to work with actual backlog format
    if [ -f ".vybe/project/outcomes.md" ] && [ -f ".vybe/backlog.md" ]; then
        # Try to get data from Portfolio Status section
        total_from_backlog=$(grep -i "total.*features" .vybe/backlog.md 2>/dev/null | sed 's/.*: \([0-9]*\).*/\1/')
        completed_from_backlog=$(grep -i "completed.*features" .vybe/backlog.md 2>/dev/null | sed 's/.*: \([0-9]*\).*/\1/')
        
        if [ -n "$total_from_backlog" ] && [ -n "$completed_from_backlog" ]; then
            # Use backlog data for more accurate counts
            # Using backlog data for accurate feature counts
            total_features="$total_from_backlog"
            completed_features="$completed_from_backlog"
            
            # Count phases instead of stages
            total_stages=$(grep -c "Phase [0-9]" .vybe/backlog.md 2>/dev/null)
            current_stage="1"  # Assume Phase 1 is current for now
        else
            # Fall back to old stage detection
            current_stage=$(grep "Active Stage:" .vybe/backlog.md 2>/dev/null | sed 's/.*Stage \([0-9]*\).*/\1/')
            total_stages=$(grep "^### Stage" .vybe/project/outcomes.md 2>/dev/null | wc -l)
            completed_stages=$(grep "COMPLETED" .vybe/backlog.md 2>/dev/null | grep "^### Stage" | wc -l)
        fi
    fi
    
    # Create status summary based on scope
    case "$status_scope" in
        "overall"|"")
            status_output="SUGGESTED NEXT ACTIONS:
- /vybe:execute stage-1
- /vybe:audit  
- /vybe:status blockers

PROJECT STATUS DASHBOARD
============================

PROJECT: $project_name

PROGRESS: $progress_percent% ($completed_features/$total_features features completed)
- Completed: $completed_features features
- Active: $active_features features  
- Blocked: $blocked_features features

OUTCOME PROGRESSION:"
            
            # Check if project is properly configured (either stages OR phases)
            if [ -n "$current_stage" ] && [ "$total_stages" -gt 0 ]; then
                if [ "$total_stages" -gt 1 ] && grep -q "Phase [0-9]" .vybe/backlog.md 2>/dev/null; then
                    # Phase-based format
                    status_output="$status_output
- Current: Phase $current_stage (IN PROGRESS)  
- Total Phases: $total_stages development phases
- Backlog: Outcome-driven with RICE/WSJF scoring"
                else
                    # Stage-based format
                    status_output="$status_output
- Current: Stage $current_stage (IN PROGRESS)
- Completed: $completed_stages of $total_stages stages
- Timeline: Each stage targets 1-3 days delivery"
                fi
            elif [ "$total_features" -gt 0 ] && [ -f ".vybe/backlog.md" ]; then
                # Project has features and backlog - consider it configured
                status_output="$status_output
- Features: $total_features planned features in backlog
- Backlog: Strategic outcome-driven development  
- Progress: Development ready to begin"
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
    #echo "[CACHE] Saving status results..."
    
    # Cache the status results for future use
    cache_set "$status_cache_key" "$status_output" 1800
    
    #echo "[CACHE] Results cached"
    
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

# Cache info (minimal)
# Mode: $([ "$cache_hit" = true ] && echo "cached" || echo "fresh")
# Duration: $status_duration seconds

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
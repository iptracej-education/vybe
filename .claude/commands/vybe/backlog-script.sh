#!/bin/bash

# =============================================================================
# VYBE BACKLOG - SHARED CACHE ARCHITECTURE
# Uses shared project cache + file system fallback for optimal performance
# =============================================================================

# Parse arguments FIRST
action="${1:-default}"
param2="$2"
param3="$3"
auto_mode=false
auto_assign=false
interactive_mode=true

for arg in "$@"; do
    case $arg in
        --auto) auto_mode=true; interactive_mode=false ;;
        --auto-assign) auto_assign=true ;;
        --interactive) interactive_mode=true ;;
    esac
done

# =============================================================================
# EARLY HELP CHECK (before ANY initialization)
# =============================================================================

# Check for help request early to avoid unnecessary cache loading
if [ "$action" = "help" ]; then
    echo "=== VYBE BACKLOG HELP ==="
    echo ""
    echo "Strategic feature management with AI automation and member coordination"
    echo ""
    echo "USAGE:"
    echo "  /vybe:backlog [action] [options]"
    echo ""
    echo "ACTIONS:"
    echo "  [default]              Display current backlog status and member assignments"
    echo "  init [--auto]          Create strategic backlog from project outcomes"
    echo "  member-count N         Configure team with N developers (1-5)"
    echo "  member-count N --auto-assign  Configure team and auto-assign features"
    echo "  assign [feature] [dev-N]      Assign specific feature to team member"
    echo "  groom [--auto]         Clean and prioritize backlog with RICE/WSJF scoring"
    echo "  dependencies           Analyze cross-feature dependencies and coordination"
    echo "  help                   Show this help message"
    echo ""
    echo "EXAMPLES:"
    echo "  /vybe:backlog                           # Show current backlog status"
    echo "  /vybe:backlog init                      # Create initial backlog structure"
    echo "  /vybe:backlog member-count 3 --auto-assign  # Set up 3-person team with auto-assignment"
    echo "  /vybe:backlog assign user-auth dev-1    # Assign user-auth feature to dev-1"
    echo "  /vybe:backlog groom --auto              # AI-powered backlog optimization"
    echo "  /vybe:backlog dependencies              # Analyze feature dependencies"
    echo ""
    echo "TEAM MEMBERS:"
    echo "  dev-1, dev-2, dev-3, dev-4, dev-5      # Up to 5 team members supported"
    echo ""
    echo "OPTIONS:"
    echo "  --auto        Automated mode (AI makes decisions without confirmation)"
    echo "  --auto-assign Automatically assign features during team setup"
    echo "  --interactive Interactive mode with user confirmation (default)"
    exit 0
fi

# =============================================================================
# NOW INITIALIZE EVERYTHING ELSE (after help check)
# =============================================================================

# Source shared cache system
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/shared-cache.sh"

# Performance timing
backlog_start_time=$(date +%s.%N)
echo "=== VYBE STRATEGIC BACKLOG MANAGEMENT ==="
echo "Action: $action | Mode: $([ "$auto_mode" = true ] && echo "automated" || echo "interactive") | Started: $(date)"
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

# Validate required project context is loaded
if [ -z "$PROJECT_OVERVIEW" ] || [ -z "$PROJECT_ARCHITECTURE" ] || [ -z "$PROJECT_CONVENTIONS" ]; then
    echo "[ERROR] Incomplete project context"
    echo "Required: overview.md, architecture.md, conventions.md"
    echo "Run /vybe:init to create complete project foundation"
    exit 1
fi

echo "[CONTEXT] Project data loaded (mode: $PROJECT_CACHE_MODE)"

# =============================================================================
# BACKLOG STATE ANALYSIS (BULK OPERATIONS)
# =============================================================================

echo "[ANALYZE] Analyzing backlog and feature state..."

# Initialize backlog analysis variables
backlog_exists=false
member_count=0
configured_members=()
feature_count=0
assigned_features=0
unassigned_features=0
completed_features=0
blocked_features=0
backlog_structure="empty"

# Check if backlog exists
if [ -f ".vybe/backlog.md" ]; then
    backlog_exists=true
    
    # Parse member configuration
    if grep -q "^## Members:" .vybe/backlog.md; then
        member_count=$(grep -A 10 "^## Members:" .vybe/backlog.md | grep "^- dev-" | wc -l)
        configured_members=($(grep -A 10 "^## Members:" .vybe/backlog.md | grep "^- dev-" | sed 's/^- //' | cut -d: -f1))
        backlog_structure="configured"
    fi
    
    # Count feature assignments
    if [ -n "$PROJECT_BACKLOG" ]; then
        assigned_features=$(echo "$PROJECT_BACKLOG" | grep -c "@dev-" 2>/dev/null || echo "0")
        assigned_features=$(echo "$assigned_features" | tr -d '\n')
        completed_features=$(echo "$PROJECT_BACKLOG" | grep -c "COMPLETED" 2>/dev/null || echo "0")
        completed_features=$(echo "$completed_features" | tr -d '\n')
        blocked_features=$(echo "$PROJECT_BACKLOG" | grep -c "BLOCKED" 2>/dev/null || echo "0")
        blocked_features=$(echo "$blocked_features" | tr -d '\n')
    fi
fi

# Count features in features directory
if [ -d ".vybe/features" ]; then
    feature_count=$(find .vybe/features -maxdepth 1 -type d 2>/dev/null | grep -c "/.*" || echo "0")
    feature_count=$((feature_count - 1)) # Remove parent dir from count
    unassigned_features=$((feature_count - assigned_features))
fi

# Parse stage information from outcomes if available
stage_count=0
current_stage=""
if [ -n "$PROJECT_OUTCOMES" ]; then
    stage_count=$(echo "$PROJECT_OUTCOMES" | grep -c "^### Stage" 2>/dev/null || echo "0")
    current_stage=$(echo "$PROJECT_BACKLOG" | grep "Active Stage:" | sed 's/.*Stage \([0-9]*\).*/\1/' 2>/dev/null || echo "")
fi

echo "[STATE] Backlog exists: $backlog_exists"
echo "[STATE] Members: $member_count configured"
echo "[STATE] Features: $feature_count total, $assigned_features assigned, $completed_features completed"
echo "[STATE] Stages: $stage_count defined, current: ${current_stage:-none}"
echo ""

# =============================================================================
# ACTION PROCESSING WITH AI COORDINATION
# =============================================================================

case "$action" in
    "default")
        echo "[DISPLAY] Showing current backlog status..."
        
        # Prepare display context for Claude AI
        display_context=$(python3 -c "
import json
context = {
    'action': 'display',
    'backlog_state': {
        'exists': $backlog_exists,
        'structure': '$backlog_structure',
        'member_count': $member_count,
        'members': $(echo "${configured_members[@]}" | python3 -c "import sys,json; print(json.dumps(sys.stdin.read().strip().split()))" 2>/dev/null || echo "[]"),
        'feature_count': $feature_count,
        'assigned_features': $assigned_features,
        'completed_features': $completed_features,
        'blocked_features': $blocked_features
    },
    'display_requirements': [
        'show_backlog_overview',
        'display_member_assignments',
        'show_feature_status_summary',
        'display_stage_progression',
        'show_next_actions'
    ]
}
print(json.dumps(context, indent=2))
" 2>/dev/null)
        ;;
        
    "init")
        echo "[INIT] Initializing strategic backlog..."
        
        # Prepare initialization context for Claude AI
        init_context=$(python3 -c "
import json
context = {
    'action': 'init',
    'auto_mode': $auto_mode,
    'existing_backlog': $backlog_exists,
    'project_context': {
        'overview_length': len('''$PROJECT_OVERVIEW'''),
        'outcomes_defined': bool('''$PROJECT_OUTCOMES'''),
        'stage_count': $stage_count,
        'feature_count': $feature_count
    },
    'initialization_requirements': [
        'create_backlog_structure',
        'analyze_project_outcomes_for_features', 
        'setup_member_management_system',
        'establish_feature_prioritization',
        'create_stage_grouping_system',
        'initialize_assignment_tracking'
    ]
}
print(json.dumps(context, indent=2))
" 2>/dev/null)
        ;;
        
    "member-count")
        if [ -z "$param2" ] || ! [[ "$param2" =~ ^[1-5]$ ]]; then
            echo "[ERROR] Usage: /vybe:backlog member-count [1-5] [--auto-assign]"
            echo "Example: /vybe:backlog member-count 3 --auto-assign"
            exit 1
        fi
        
        new_member_count="$param2"
        echo "[MEMBERS] Configuring $new_member_count team members..."
        
        # Prepare member configuration context
        member_context=$(python3 -c "
import json
context = {
    'action': 'member_configuration',
    'new_member_count': $new_member_count,
    'current_member_count': $member_count,
    'auto_assign': $auto_assign,
    'existing_members': $(echo "${configured_members[@]}" | python3 -c "import sys,json; print(json.dumps(sys.stdin.read().strip().split()))" 2>/dev/null || echo "[]"),
    'member_operations': [
        'configure_team_structure',
        'create_member_profiles',
        'analyze_workload_distribution',
        'auto_assign_features_if_requested',
        'setup_coordination_infrastructure'
    ],
    'assignment_data': {
        'total_features': $feature_count,
        'unassigned_features': $unassigned_features,
        'feature_complexity_analysis_needed': True
    }
}
print(json.dumps(context, indent=2))
" 2>/dev/null)
        ;;
        
    "assign")
        if [ -z "$param2" ] || [ -z "$param3" ]; then
            echo "[ERROR] Usage: /vybe:backlog assign [feature] [dev-N]"
            echo "Example: /vybe:backlog assign user-auth dev-1"
            exit 1
        fi
        
        feature_name="$param2"
        member_assignment="$param3"
        
        # Validate member exists
        if [[ ! "$member_assignment" =~ ^dev-[1-5]$ ]]; then
            echo "[ERROR] Member must be dev-1, dev-2, dev-3, dev-4, or dev-5"
            exit 1
        fi
        
        # Check if feature exists
        if [ ! -d ".vybe/features/$feature_name" ]; then
            echo "[ERROR] Feature '$feature_name' not found"
            echo "Available features: $(find .vybe/features -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | grep -v features | tr '\n' ' ')"
            exit 1
        fi
        
        echo "[ASSIGN] Assigning '$feature_name' to '$member_assignment'..."
        
        # Prepare assignment context
        assignment_context=$(python3 -c "
import json
context = {
    'action': 'assign_feature',
    'feature_name': '$feature_name',
    'member_assignment': '$member_assignment',
    'assignment_operations': [
        'validate_member_capacity',
        'analyze_feature_dependencies',
        'update_backlog_assignments',
        'coordinate_with_existing_work',
        'update_member_workload_tracking'
    ]
}
print(json.dumps(context, indent=2))
" 2>/dev/null)
        ;;
        
    "groom")
        echo "[GROOM] Grooming backlog with AI analysis..."
        
        # Prepare grooming context
        groom_context=$(python3 -c "
import json
context = {
    'action': 'groom',
    'auto_mode': $auto_mode,
    'grooming_analysis': {
        'feature_count': $feature_count,
        'member_count': $member_count,
        'assigned_features': $assigned_features,
        'completed_features': $completed_features
    },
    'grooming_operations': [
        'rice_scoring_analysis',
        'wsjf_prioritization',
        'dependency_mapping',
        'duplicate_detection',
        'effort_estimation',
        'member_workload_balancing',
        'stage_alignment_verification'
    ]
}
print(json.dumps(context, indent=2))
" 2>/dev/null)
        ;;
        
    "dependencies")
        echo "[DEPENDENCIES] Analyzing feature dependencies..."
        
        # Prepare dependency analysis context
        dependency_context=$(python3 -c "
import json
context = {
    'action': 'dependencies',
    'dependency_analysis': {
        'feature_count': $feature_count,
        'member_assignments': $assigned_features
    },
    'dependency_operations': [
        'cross_feature_dependency_mapping',
        'blocking_relationship_analysis',
        'parallel_work_identification', 
        'critical_path_analysis',
        'member_coordination_planning'
    ]
}
print(json.dumps(context, indent=2))
" 2>/dev/null)
        ;;
        
    "help")
        echo "=== VYBE BACKLOG HELP ==="
        echo ""
        echo "Strategic feature management with AI automation and member coordination"
        echo ""
        echo "USAGE:"
        echo "  /vybe:backlog [action] [options]"
        echo ""
        echo "ACTIONS:"
        echo "  [default]              Display current backlog status and member assignments"
        echo "  init [--auto]          Create strategic backlog from project outcomes"
        echo "  member-count N         Configure team with N developers (1-5)"
        echo "  member-count N --auto-assign  Configure team and auto-assign features"
        echo "  assign [feature] [dev-N]      Assign specific feature to team member"
        echo "  groom [--auto]         Clean and prioritize backlog with RICE/WSJF scoring"
        echo "  dependencies           Analyze cross-feature dependencies and coordination"
        echo "  help                   Show this help message"
        echo ""
        echo "EXAMPLES:"
        echo "  /vybe:backlog                           # Show current backlog status"
        echo "  /vybe:backlog init                      # Create initial backlog structure"
        echo "  /vybe:backlog member-count 3 --auto-assign  # Set up 3-person team with auto-assignment"
        echo "  /vybe:backlog assign user-auth dev-1    # Assign user-auth feature to dev-1"
        echo "  /vybe:backlog groom --auto              # AI-powered backlog optimization"
        echo "  /vybe:backlog dependencies              # Analyze feature dependencies"
        echo ""
        echo "TEAM MEMBERS:"
        echo "  dev-1, dev-2, dev-3, dev-4, dev-5      # Up to 5 team members supported"
        echo ""
        echo "OPTIONS:"
        echo "  --auto        Automated mode (AI makes decisions without confirmation)"
        echo "  --auto-assign Automatically assign features during team setup"
        echo "  --interactive Interactive mode with user confirmation (default)"
        exit 0
        ;;
        
    *)
        echo "[ERROR] Unknown action: $action"
        echo "Available actions: [default], init, member-count, assign, groom, dependencies, help"
        echo "Use '/vybe:backlog help' for detailed usage information"
        exit 1
        ;;
esac

# =============================================================================
# NOW INITIALIZE EVERYTHING ELSE (after help check)
# =============================================================================

# Source shared cache system
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/shared-cache.sh"

# Performance timing
backlog_start_time=$(date +%s.%N)
echo "=== VYBE STRATEGIC BACKLOG MANAGEMENT ==="
echo "Action: $action | Mode: $([ "$auto_mode" = true ] && echo "automated" || echo "interactive") | Started: $(date)"
echo ""

# =============================================================================
# CACHE CONTEXT FOR CLAUDE AI
# =============================================================================

# Determine which context to use based on action
context_data=""
case "$action" in
    "default") context_data="$display_context" ;;
    "init") context_data="$init_context" ;;
    "member-count") context_data="$member_context" ;;
    "assign") context_data="$assignment_context" ;;
    "groom") context_data="$groom_context" ;;
    "dependencies") context_data="$dependency_context" ;;
esac

# Cache the context for Claude AI access
backlog_context_key=$(get_cache_key "backlog_context.$(date +%s)")
cache_set "$backlog_context_key" "$context_data" 7200

echo "[AI-PREP] Backlog context prepared and cached"
echo "[AI-PREP] Context key: $backlog_context_key"
echo ""

# =============================================================================
# CLAUDE AI COORDINATION SECTION  
# =============================================================================

echo "[AI-COORDINATION] REQUESTING CLAUDE AI BACKLOG MANAGEMENT"
echo "========================================================"
echo ""
echo "Claude AI should now perform intelligent backlog management using:"
echo ""

case "$action" in
    "default")
        echo "MODE: BACKLOG DISPLAY"
        echo "1. BACKLOG OVERVIEW:"
        echo "   - Show current backlog structure and status"
        echo "   - Display member assignments and workload distribution"
        echo "   - Show feature completion progress and blockers"
        echo "   - Provide next action recommendations"
        ;;
        
    "init")
        echo "MODE: BACKLOG INITIALIZATION"
        echo "1. STRATEGIC BACKLOG CREATION:"
        echo "   - Analyze project outcomes to identify features"
        echo "   - Create outcome-grouped backlog structure"
        echo "   - Set up member management system"
        echo "   - Initialize feature prioritization framework"
        echo "   - Establish stage-based organization"
        ;;
        
    "member-count")
        echo "MODE: TEAM CONFIGURATION"
        echo "1. MEMBER MANAGEMENT:"
        echo "   - Configure $new_member_count team members (dev-1 to dev-$new_member_count)"
        echo "   - Set up workload tracking and coordination"
        echo "   - $([ "$auto_assign" = true ] && echo "Auto-assign features based on complexity analysis" || echo "Prepare for manual feature assignment")"
        echo "   - Create member coordination infrastructure"
        ;;
        
    "assign")
        echo "MODE: FEATURE ASSIGNMENT"
        echo "1. INTELLIGENT ASSIGNMENT:"
        echo "   - Assign '$feature_name' to '$member_assignment'"
        echo "   - Analyze member capacity and current workload"
        echo "   - Check feature dependencies and coordination needs"
        echo "   - Update tracking and coordination systems"
        ;;
        
    "groom")
        echo "MODE: BACKLOG GROOMING"
        echo "1. AI-POWERED ANALYSIS:"
        echo "   - $([ "$auto_mode" = true ] && echo "Automated RICE/WSJF scoring and prioritization" || echo "Interactive grooming with AI recommendations")"
        echo "   - Feature complexity and effort estimation"
        echo "   - Dependency mapping and conflict detection"
        echo "   - Member workload optimization"
        echo "   - Stage alignment and timeline analysis"
        ;;
        
    "dependencies")
        echo "MODE: DEPENDENCY ANALYSIS"
        echo "1. CROSS-FEATURE COORDINATION:"
        echo "   - Map dependencies between features"
        echo "   - Identify blocking relationships and critical paths"
        echo "   - Plan parallel work opportunities for team members"
        echo "   - Generate coordination recommendations"
        ;;
esac

echo ""
echo "Available project context:"
echo "- PROJECT_OVERVIEW, PROJECT_ARCHITECTURE, PROJECT_CONVENTIONS"
echo "- PROJECT_OUTCOMES (staged roadmap)"
echo "- PROJECT_BACKLOG (current backlog state)"
echo "- PROJECT_FEATURES (all feature specifications)"
echo ""

# =============================================================================
# PROVIDE CLAUDE WITH UPDATE FUNCTIONS
# =============================================================================

echo "[FUNCTIONS] Available for Claude AI:"
echo "- update_file_and_cache(file_path, new_content, cache_key)"
echo "- cache_set(key, value, ttl)"
echo "- cache_get(key)"
echo ""
echo "Backlog data accessible via:"
echo "- Backlog context key: $backlog_context_key"
echo "- PROJECT_BACKLOG: Current backlog content"
echo "- All project foundation documents"
echo ""

# =============================================================================
# PERFORMANCE METRICS
# =============================================================================

backlog_end_time=$(date +%s.%N)
backlog_duration=$(echo "$backlog_end_time - $backlog_start_time" | bc -l 2>/dev/null || echo "N/A")

echo "=== BACKLOG CONTEXT PREPARATION COMPLETE ==="
echo "Action: $action"
echo "Mode: $([ "$auto_mode" = true ] && echo "automated" || echo "interactive")"
echo "Cache mode: $PROJECT_CACHE_MODE"
echo "Duration: $backlog_duration seconds"
echo ""

# Display cache performance
echo "CACHE PERFORMANCE:"
get_cache_stats
echo ""

echo "[READY] Claude AI can now complete the backlog management using:"
echo "1. Cached project data (PROJECT_* variables)"
echo "2. Backlog context (key: $backlog_context_key)"  
echo "3. AI analysis algorithms for RICE/WSJF scoring and assignment"
echo "4. Atomic update functions for file+cache consistency"
echo ""

# Clean up file cache
cleanup_file_cache
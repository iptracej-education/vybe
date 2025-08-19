#!/bin/bash

# =============================================================================
# VYBE EXECUTE - SHARED CACHE ARCHITECTURE
# Uses shared project cache + file system fallback for optimal performance
# =============================================================================

# Parse arguments FIRST
task_identifier="${1:-}"
role_assignment=""
guide_mode=false
check_only=false

for arg in "$@"; do
    case $arg in
        --role=*) role_assignment="${arg#*=}" ;;
        --guide) guide_mode=true ;;
        --check-only) check_only=true ;;
    esac
done

# Detect member role from environment or argument
current_member=""
if [ -n "$role_assignment" ]; then
    current_member="$role_assignment"
elif [ -n "$VYBE_MEMBER" ]; then
    current_member="$VYBE_MEMBER"
fi

# =============================================================================
# EARLY HELP CHECK (before ANY initialization)
# =============================================================================

# Check for help request early to avoid unnecessary cache loading
if [ "$task_identifier" = "help" ]; then
    echo "=== VYBE EXECUTE HELP ==="
    echo ""
    echo "Execute specific tasks with full context and member-aware coordination"
    echo ""
    echo "USAGE:"
    echo "  /vybe:execute [task-id] [options]"
    echo ""
    echo "PARAMETERS:"
    echo "  task-id                Specific task identifier (e.g., user-auth-task-1, my-feature)"
    echo ""
    echo "OPTIONS:"
    echo "  --role=dev-N           Execute as specific team member (dev-1, dev-2, etc.)"
    echo "  --force                Force execution even if task appears complete"
    echo "  --dry-run              Show what would be executed without making changes"
    echo ""
    echo "EXAMPLES:"
    echo "  /vybe:execute user-auth-task-1           # Execute specific task"
    echo "  /vybe:execute payment-system --role=dev-2  # Execute as dev-2"
    echo "  /vybe:execute stage-1                    # Execute all tasks in Stage 1"
    echo "  /vybe:execute api-integration --force    # Force re-execution"
    echo "  /vybe:execute dashboard-ui --dry-run     # Preview execution plan"
    echo ""
    echo "EXECUTION FEATURES:"
    echo "  - Full project context loading (overview, architecture, conventions)"
    echo "  - Member-aware execution with VYBE_MEMBER environment variable"
    echo "  - Progress tracking and status updates"
    echo "  - Multi-session workflow coordination"
    echo "  - Real application enforcement (no mock/fake implementations)"
    echo "  - Template-driven architecture compliance"
    echo ""
    echo "TASK RESOLUTION:"
    echo "  - Task ID resolution from features and specifications"
    echo "  - Feature-based task execution"
    echo "  - Assignment validation and member coordination"
    echo "  - Dependency checking and prerequisite validation"
    echo ""
    echo "RELATED COMMANDS:"
    echo "  /vybe:plan [feature]            # Plan features before execution"
    echo "  /vybe:status [dev-N]            # Check individual member progress"
    echo "  /vybe:backlog assign [feature] [dev-N]  # Assign tasks to members"
    exit 0
fi

# =============================================================================
# NOW INITIALIZE EVERYTHING ELSE (after help check)
# =============================================================================

# Source shared cache system
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/shared-cache.sh"

# Performance timing
execute_start_time=$(date +%s.%N)
echo "=== VYBE TASK EXECUTION ==="
echo "Task: ${task_identifier:-[required]} | Member: ${current_member:-auto} | Mode: $([ "$guide_mode" = true ] && echo "guide" || echo "execute") | Started: $(date)"
echo ""

# Initialize shared cache system
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
# TASK IDENTIFICATION AND VALIDATION
# =============================================================================

echo "[VALIDATE] Analyzing task and execution context..."

# Validate task identifier
if [ -z "$task_identifier" ]; then
    echo "[ERROR] Usage: /vybe:execute [task-id] [options]"
    echo ""
    echo "Examples:"
    echo "  /vybe:execute user-auth-task-1           # Execute specific task"
    echo "  /vybe:execute my-feature --role=dev-1    # Execute next assigned feature"
    echo "  /vybe:execute my-task                    # Execute next assigned task"
    echo ""
    echo "Use '/vybe:execute help' for detailed usage information"
    exit 1
fi

# Task analysis variables
task_type="unknown"
feature_name=""
task_number=""
task_exists=false
feature_dir=""
task_content=""

# Analyze task identifier type
case "$task_identifier" in
    *-task-[0-9]*)
        # Specific task format: feature-task-N
        task_type="specific_task"
        feature_name=$(echo "$task_identifier" | sed 's/-task-[0-9]*$//')
        task_number=$(echo "$task_identifier" | grep -o 'task-[0-9]*$' | sed 's/task-//')
        feature_dir=".vybe/features/$feature_name"
        
        if [ -d "$feature_dir" ] && [ -f "$feature_dir/tasks.md" ]; then
            task_exists=true
            # Extract specific task content
            task_content=$(grep -A 20 "^## Task $task_number:" "$feature_dir/tasks.md" 2>/dev/null || echo "")
        fi
        ;;
        
    "my-feature")
        task_type="my_feature"
        # Find assigned feature for current member
        if [ -n "$current_member" ] && [ -n "$PROJECT_BACKLOG" ]; then
            feature_name=$(echo "$PROJECT_BACKLOG" | grep "@$current_member" | head -1 | grep -o '^[^@]*' | xargs 2>/dev/null || echo "")
            if [ -n "$feature_name" ]; then
                feature_dir=".vybe/features/$feature_name"
                task_exists=true
            fi
        fi
        ;;
        
    "my-task")
        task_type="my_task"
        # Find next task assigned to current member
        if [ -n "$current_member" ]; then
            # Implementation would search for next assigned task
            task_exists=false  # Simplified for now
        fi
        ;;
        
    *)
        # Treat as feature name
        task_type="feature_execution"
        feature_name="$task_identifier"
        feature_dir=".vybe/features/$feature_name"
        
        if [ -d "$feature_dir" ]; then
            task_exists=true
        fi
        ;;
esac

# Git repository validation
git_available=false
git_status="unknown"
working_tree_clean=false

if [ -d ".git" ]; then
    git_available=true
    if git status --porcelain > /dev/null 2>&1; then
        if [ -z "$(git status --porcelain)" ]; then
            working_tree_clean=true
            git_status="clean"
        else
            git_status="dirty"
        fi
    fi
fi

# Member assignment validation
member_valid=false
if [ -n "$current_member" ] && [[ "$current_member" =~ ^dev-[1-5]$ ]]; then
    member_valid=true
fi

echo "[STATE] Task type: $task_type"
echo "[STATE] Feature: ${feature_name:-unknown}"
echo "[STATE] Task exists: $task_exists"
echo "[STATE] Member: ${current_member:-none} (valid: $member_valid)"
echo "[STATE] Git: $([ "$git_available" = true ] && echo "available ($git_status)" || echo "not available")"
echo ""

# =============================================================================
# TASK PREPARATION AND CONTEXT LOADING
# =============================================================================

if [ "$task_exists" = false ]; then
    echo "[ERROR] Task not found or invalid"
    case "$task_type" in
        "specific_task")
            echo "Task '$task_identifier' not found in feature '$feature_name'"
            if [ -f "$feature_dir/tasks.md" ]; then
                echo "Available tasks in $feature_name:"
                grep "^## Task [0-9]*:" "$feature_dir/tasks.md" 2>/dev/null || echo "No tasks found"
            fi
            ;;
        "my_feature")
            echo "No feature assigned to member: $current_member"
            echo "Check assignments with: /vybe:status members"
            ;;
        "feature_execution")
            echo "Feature '$feature_name' not found"
            echo "Available features: $(find .vybe/features -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | grep -v features | tr '\n' ' ')"
            ;;
    esac
    exit 1
fi

echo "[LOAD] Loading execution context for task..."

# Load feature specifications
feature_requirements=""
feature_design=""
feature_tasks=""

if [ -f "$feature_dir/requirements.md" ]; then
    feature_requirements=$(cat "$feature_dir/requirements.md")
fi

if [ -f "$feature_dir/design.md" ]; then
    feature_design=$(cat "$feature_dir/design.md")
fi

if [ -f "$feature_dir/tasks.md" ]; then
    feature_tasks=$(cat "$feature_dir/tasks.md")
fi

# Analyze existing codebase for context
existing_code_analysis=""
project_files_count=0
if [ "$task_type" != "check_only" ]; then
    echo "[SCAN] Analyzing existing codebase..."
    
    # Count relevant files
    project_files_count=$(find . -path ./node_modules -prune -o -path ./.git -prune -o -path ./.vybe -prune -o -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.java" -o -name "*.rs" -o -name "*.rb" \) -print 2>/dev/null | wc -l)
    
    # Sample key files for context
    if [ "$project_files_count" -gt 0 ]; then
        relevant_files=($(find . -path ./node_modules -prune -o -path ./.git -prune -o -path ./.vybe -prune -o -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.java" -o -name "*.rs" -o -name "*.rb" \) -print 2>/dev/null | head -10))
        
        for file in "${relevant_files[@]:0:3}"; do
            echo "=== $file ===" >> /tmp/code_context.txt
            head -50 "$file" >> /tmp/code_context.txt 2>/dev/null
            echo "" >> /tmp/code_context.txt
        done
        
        if [ -f /tmp/code_context.txt ]; then
            existing_code_analysis=$(cat /tmp/code_context.txt)
            rm /tmp/code_context.txt
        fi
    fi
fi

echo "[CONTEXT] Feature specifications loaded"
echo "[CONTEXT] Existing codebase analyzed ($project_files_count files)"
echo ""

# =============================================================================
# PREPARE EXECUTION CONTEXT FOR CLAUDE AI
# =============================================================================

echo "[AI-PREP] Preparing comprehensive execution context..."

# Create execution context for Claude AI
execution_context=$(python3 -c "
import json
context = {
    'command': 'execute',
    'task_identifier': '$task_identifier',
    'task_type': '$task_type',
    'feature_name': '$feature_name',
    'task_number': '$task_number',
    'execution_mode': {
        'guide_mode': $guide_mode,
        'check_only': $check_only,
        'member_role': '$current_member',
        'member_valid': $member_valid
    },
    'project_context': {
        'overview_length': len('''$PROJECT_OVERVIEW'''),
        'architecture_length': len('''$PROJECT_ARCHITECTURE'''),
        'conventions_length': len('''$PROJECT_CONVENTIONS'''),
        'outcomes_defined': bool('''$PROJECT_OUTCOMES'''),
        'backlog_available': bool('''$PROJECT_BACKLOG''')
    },
    'feature_context': {
        'requirements_length': len('''$feature_requirements'''),
        'design_length': len('''$feature_design'''),
        'tasks_length': len('''$feature_tasks'''),
        'specific_task_content': '''$task_content'''
    },
    'codebase_context': {
        'files_count': $project_files_count,
        'analysis_available': bool('''$existing_code_analysis''')
    },
    'git_context': {
        'available': $git_available,
        'status': '$git_status',
        'working_tree_clean': $working_tree_clean
    },
    'execution_requirements': [
        'task_validation_and_setup',
        'context_integration_and_planning',
        'code_generation_and_implementation',
        'testing_and_validation',
        'git_coordination_and_commit',
        'progress_tracking_and_status_update',
        'multi_member_coordination_if_needed'
    ]
}
print(json.dumps(context, indent=2))
" 2>/dev/null)

# Cache the execution context for Claude AI access
execution_context_key=$(get_cache_key "execution_context.$(date +%s)")
cache_set "$execution_context_key" "$execution_context" 7200

# Cache additional context data if available
code_analysis_key=""
if [ -n "$existing_code_analysis" ]; then
    code_analysis_key=$(get_cache_key "code_analysis.$(date +%s)")
    cache_set "$code_analysis_key" "$existing_code_analysis" 3600
fi

feature_specs_key=""
if [ -n "$feature_requirements$feature_design$feature_tasks" ]; then
    feature_specs_key=$(get_cache_key "feature_specs.$(date +%s)")
    feature_specs=$(python3 -c "
import json
specs = {
    'requirements': '''$feature_requirements''',
    'design': '''$feature_design''',
    'tasks': '''$feature_tasks'''
}
print(json.dumps(specs, indent=2))
" 2>/dev/null)
    cache_set "$feature_specs_key" "$feature_specs" 3600
fi

echo "[AI-PREP] Execution context prepared and cached"
echo "[AI-PREP] Context key: $execution_context_key"
if [ -n "$code_analysis_key" ]; then
    echo "[AI-PREP] Code analysis key: $code_analysis_key"
fi
if [ -n "$feature_specs_key" ]; then
    echo "[AI-PREP] Feature specs key: $feature_specs_key"
fi
echo ""

# =============================================================================
# CLAUDE AI COORDINATION SECTION  
# =============================================================================

echo "[AI-COORDINATION] REQUESTING CLAUDE AI TASK EXECUTION"
echo "===================================================="
echo ""
echo "Claude AI should now perform intelligent task execution using:"
echo ""

if [ "$check_only" = true ]; then
    echo "MODE: VALIDATION CHECK"
    echo "1. TASK READINESS VALIDATION:"
    echo "   - Verify task specifications are complete"
    echo "   - Check feature requirements and design alignment"
    echo "   - Validate codebase readiness for implementation"
    echo "   - Confirm member assignment and coordination"
    echo ""
else
    echo "MODE: $([ "$guide_mode" = true ] && echo "COLLABORATIVE GUIDANCE" || echo "DIRECT EXECUTION")"
    echo ""
    echo "1. TASK ANALYSIS AND SETUP:"
    echo "   - Parse task requirements and acceptance criteria"
    echo "   - Integrate with project architecture and conventions"
    echo "   - Plan implementation approach and code changes"
    echo "   - Coordinate with existing codebase and features"
    echo ""
    echo "2. IMPLEMENTATION EXECUTION:"
    echo "   - Generate actual working code (not mock/placeholder)"
    echo "   - Follow project conventions and architecture patterns"
    echo "   - Implement proper error handling and security measures"
    echo "   - Create or update relevant tests"
    echo ""
    echo "3. GIT COORDINATION:"
    echo "   - Create appropriate branch if needed"
    echo "   - Commit changes with meaningful messages"
    echo "   - Handle member coordination and conflict prevention"
    echo "   - Update progress tracking systems"
    echo ""
    echo "4. VALIDATION AND TESTING:"
    echo "   - Run existing tests to ensure no regressions"
    echo "   - Validate implementation meets requirements"
    echo "   - Check integration with existing features"
    echo "   - Verify security and performance requirements"
    echo ""
    
    if [ -n "$current_member" ]; then
        echo "5. MULTI-MEMBER COORDINATION:"
        echo "   - Update member progress tracking"
        echo "   - Coordinate with other developers' work"
        echo "   - Handle integration points and dependencies"
        echo "   - Ensure parallel development compatibility"
        echo ""
    fi
fi

echo "Available data sources:"
echo "- PROJECT_OVERVIEW, PROJECT_ARCHITECTURE, PROJECT_CONVENTIONS"
echo "- PROJECT_OUTCOMES, PROJECT_BACKLOG (for coordination)"
echo "- Feature specifications (cached: $([ -n "$feature_specs_key" ] && echo "yes" || echo "no"))"
echo "- Existing codebase analysis (cached: $([ -n "$code_analysis_key" ] && echo "yes" || echo "no"))"
echo "- Git repository status and coordination info"
echo ""

# =============================================================================
# PROVIDE CLAUDE WITH EXECUTION FUNCTIONS
# =============================================================================

echo "[FUNCTIONS] Available for Claude AI:"
echo "- Task and TodoWrite tools for progress tracking"
echo "- Full file manipulation: Read, Write, Edit, MultiEdit"
echo "- Code search and analysis: Glob, Grep, LS"
echo "- Cached data access: cache_get(key)"
echo ""
echo "Execution context data:"
echo "- Execution context key: $execution_context_key"
if [ -n "$code_analysis_key" ]; then
    echo "- Code analysis key: $code_analysis_key"
fi
if [ -n "$feature_specs_key" ]; then
    echo "- Feature specifications key: $feature_specs_key"
fi
echo ""

# =============================================================================
# PERFORMANCE METRICS
# =============================================================================

execute_end_time=$(date +%s.%N)
execute_duration=$(echo "$execute_end_time - $execute_start_time" | bc -l 2>/dev/null || echo "N/A")

echo "=== EXECUTION CONTEXT PREPARATION COMPLETE ==="
echo "Task: $task_identifier ($task_type)"
echo "Member: ${current_member:-auto}"
echo "Mode: $([ "$guide_mode" = true ] && echo "guide" || [ "$check_only" = true ] && echo "check" || echo "execute")"
echo "Cache mode: $PROJECT_CACHE_MODE"
echo "Duration: $execute_duration seconds"
echo ""

# Display cache performance
echo "CACHE PERFORMANCE:"
get_cache_stats
echo ""

echo "[READY] Claude AI can now complete the task execution using:"
echo "1. Complete project context (cached: PROJECT_* variables)"
echo "2. Execution context (key: $execution_context_key)"
echo "3. Feature specifications and codebase analysis"
echo "4. Full implementation toolkit with git coordination"
echo ""

# Clean up file cache
cleanup_file_cache

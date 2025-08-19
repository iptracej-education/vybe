#!/bin/bash

# =============================================================================
# VYBE PLAN - SHARED CACHE ARCHITECTURE
# Uses shared project cache + file system fallback for optimal performance
# =============================================================================

# Parse arguments FIRST
feature_or_stage="$1"
description_or_changes="$2"
auto_mode=false
modify_mode=false

for arg in "$@"; do
    case $arg in
        --auto) auto_mode=true ;;
        --modify) modify_mode=true ;;
    esac
done

# =============================================================================
# EARLY HELP CHECK (before ANY initialization)
# =============================================================================

# Check for help request early to avoid any cache or source loading
if [ "$feature_or_stage" = "help" ]; then
    echo "=== VYBE PLAN HELP ==="
    echo ""
    echo "Create detailed feature specifications with AI-powered requirements analysis"
    echo ""
    echo "USAGE:"
    echo "  /vybe:plan [feature-name] [description] [options]"
    echo "  /vybe:plan [stage-name] --modify [changes]"
    echo ""
    echo "PARAMETERS:"
    echo "  feature-name           Lowercase name with dashes (e.g., user-auth, payment-system)"
    echo "  description            Brief description of the feature requirements"
    echo "  stage-name             Stage modification (e.g., stage-1, stage-2)"
    echo "  changes                Description of changes for stage modification"
    echo ""
    echo "OPTIONS:"
    echo "  --auto                 Automated mode (AI makes decisions without confirmation)"
    echo "  --modify               Modify existing stage-based planning"
    echo ""
    echo "EXAMPLES:"
    echo "  /vybe:plan user-auth \"User login and registration system\""
    echo "  /vybe:plan payment-system \"Payment processing with Stripe\" --auto"
    echo "  /vybe:plan dashboard-ui \"Admin dashboard with analytics\""
    echo "  /vybe:plan stage-1 \"Plan all features for Stage 1\""
    echo "  /vybe:plan stage-1 --modify \"Change: JavaScript to TypeScript\""
    echo ""
    echo "PLANNING FEATURES:"
    echo "  - EARS format requirements generation (The system shall...)"
    echo "  - Technical design with architecture considerations"
    echo "  - Comprehensive task breakdown with implementation steps"
    echo "  - Web research integration for best practices"
    echo "  - Template-driven architecture enforcement"
    echo "  - Stage-based and feature-based planning support"
    echo ""
    echo "OUTPUT FILES:"
    echo "  .vybe/features/[feature-name]/requirements.md   # EARS format requirements"
    echo "  .vybe/features/[feature-name]/design.md         # Technical design"
    echo "  .vybe/features/[feature-name]/tasks.md          # Implementation tasks"
    echo ""
    echo "RELATED COMMANDS:"
    echo "  /vybe:execute [feature]      # Implement planned features"
    echo "  /vybe:audit                  # Check specification gaps"
    echo "  /vybe:backlog assign [feature] [dev-N]  # Assign to team members"
    exit 0
fi

# =============================================================================
# NOW INITIALIZE EVERYTHING ELSE (after help check)
# =============================================================================

# Source shared cache system
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/shared-cache.sh"

# Performance timing
plan_start_time=$(date +%s.%N)
echo "=== VYBE FEATURE PLANNING ==="
echo "Feature/Stage: ${feature_or_stage:-[required]} | Mode: $([ "$auto_mode" = true ] && echo "auto" || echo "interactive") | Started: $(date)"
echo ""

# Initialize shared cache system
init_vybe_cache

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
echo "[VALIDATE] Planning context analysis..."

# Validate feature/stage name
if [ -z "$feature_or_stage" ]; then
    echo "[ERROR] Usage: /vybe:plan [feature-name] [description] [--auto]"
    echo "Examples:"
    echo "  /vybe:plan user-auth \"User login and registration\" --auto"
    echo "  /vybe:plan stage-1 --modify \"Change: JavaScript to TypeScript\""
    echo ""
    echo "Use '/vybe:plan help' for detailed usage information"
    exit 1
fi

# Check if stage-based or feature-based planning
planning_type="feature"
if [[ "$feature_or_stage" =~ ^stage-[0-9]+$ ]]; then
    planning_type="stage"
fi

# Validate feature name format for feature-based planning
if [ "$planning_type" = "feature" ] && [[ ! "$feature_or_stage" =~ ^[a-z0-9-]+$ ]]; then
    echo "[ERROR] Feature name must be lowercase with dashes only"
    echo "Example: user-auth, payment-system, dashboard-ui"
    exit 1
fi

# Check if feature already exists
existing_feature=false
feature_dir=".vybe/features/$feature_or_stage"
if [ -d "$feature_dir" ]; then
    existing_feature=true
    echo "[UPDATE] Updating existing feature: $feature_or_stage"
else
    echo "[NEW] Creating new feature: $feature_or_stage"
fi

# Create feature directory
mkdir -p "$feature_dir"

# Extract project information for planning context
project_name="Unknown Project"
if [ -n "$PROJECT_OVERVIEW" ]; then
    project_name=$(echo "$PROJECT_OVERVIEW" | grep "^# " | head -1 | sed 's/^# //' || echo "Unknown Project")
fi

# Parse technology stack from architecture
tech_stack=""
if [ -n "$PROJECT_ARCHITECTURE" ]; then
    tech_stack=$(echo "$PROJECT_ARCHITECTURE" | grep -A 10 "Technology Stack" | grep "^- " || echo "")
fi

# Load existing backlog for context if available
backlog_context=""
member_count=0
if [ -n "$PROJECT_BACKLOG" ]; then
    member_count=$(echo "$PROJECT_BACKLOG" | grep "^## Members:" | grep -o "[0-9]*" || echo "0")
    
    # Extract relevant features and priorities
    backlog_context=$(echo "$PROJECT_BACKLOG" | head -50)
fi

# Load existing features for context
existing_features=""
existing_feature_count=0
if [ -d ".vybe/features" ]; then
    existing_feature_count=$(find .vybe/features -maxdepth 1 -type d 2>/dev/null | grep -c "/.*" || echo "0")
    existing_feature_count=$((existing_feature_count - 1)) # Remove parent dir
    
    if [ "$existing_feature_count" -gt 0 ]; then
        existing_features=$(find .vybe/features -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | grep -v "features" | sort | head -10)
    fi
fi

echo "[STATE] Project: $project_name"
echo "[STATE] Planning type: $planning_type"
echo "[STATE] Existing features: $existing_feature_count"
echo "[STATE] Team size: $([ "$member_count" -gt 0 ] && echo "$member_count developers" || echo "solo mode")"
echo ""

# =============================================================================
# PREPARE PLANNING CONTEXT FOR CLAUDE AI
# =============================================================================

echo "[AI-PREP] Preparing comprehensive planning context..."

# Create comprehensive planning context
planning_context=$(python3 -c "
import json
context = {
    'command': 'plan',
    'planning_type': '$planning_type',
    'feature_name': '$feature_or_stage',
    'description': '$description_or_changes',
    'auto_mode': $auto_mode,
    'modify_mode': $modify_mode,
    'existing_feature': $existing_feature,
    'project_context': {
        'name': '$project_name',
        'overview_length': len('''$PROJECT_OVERVIEW'''),
        'architecture_length': len('''$PROJECT_ARCHITECTURE'''),
        'conventions_length': len('''$PROJECT_CONVENTIONS'''),
        'tech_stack': '''$tech_stack'''.strip(),
        'member_count': $member_count
    },
    'backlog_context': {
        'has_backlog': bool('''$PROJECT_BACKLOG'''),
        'backlog_preview': '''$backlog_context'''.strip()[:500]
    },
    'feature_context': {
        'existing_count': $existing_feature_count,
        'existing_features': '''$existing_features'''.strip().split(),
        'feature_directory': '$feature_dir'
    },
    'planning_requirements': [
        'web_research_for_best_practices',
        'ears_format_requirements_generation',
        'technical_design_with_architecture_alignment', 
        'task_breakdown_with_implementation_steps',
        'member_assignment_if_team_configured',
        'integration_planning_with_existing_features',
        'testing_strategy_definition'
    ],
    'output_files': [
        '$feature_dir/requirements.md',
        '$feature_dir/design.md', 
        '$feature_dir/tasks.md'
    ],
    'web_research_topics': [
        'best_practices_for_feature_type',
        'integration_patterns',
        'security_considerations',
        'performance_optimization',
        'testing_strategies'
    ]
}
print(json.dumps(context, indent=2))
" 2>/dev/null)

# Cache the planning context for Claude AI access
planning_context_key=$(get_cache_key "planning_context.$(date +%s)")
cache_set "$planning_context_key" "$planning_context" 7200

echo "[AI-PREP] Planning context prepared and cached"
echo "[AI-PREP] Context key: $planning_context_key"
echo ""

# =============================================================================
# CLAUDE AI COORDINATION SECTION  
# =============================================================================

echo "[AI-COORDINATION] REQUESTING CLAUDE AI PLANNING"
echo "=============================================="
echo ""
echo "Claude AI should now perform comprehensive feature planning using:"
echo ""
echo "1. PROJECT CONTEXT ANALYSIS:"
echo "   - Access cached project data (overview, architecture, conventions)"
echo "   - Understand project goals, tech stack, and constraints"
echo "   - Review existing features and integration requirements"
echo ""
echo "2. WEB RESEARCH (REQUIRED):"
echo "   - Research best practices for this feature type"
echo "   - Find integration patterns and security considerations"
echo "   - Identify performance optimization opportunities"
echo "   - Research testing strategies and frameworks"
echo ""
echo "3. REQUIREMENTS GENERATION:"
echo "   - Create EARS format requirements (The system shall...)"
echo "   - Define functional and non-functional requirements"
echo "   - Specify user stories and acceptance criteria"
echo "   - Include security and performance requirements"
echo ""
echo "4. TECHNICAL DESIGN:"
echo "   - Architecture alignment with project tech stack"
echo "   - Component design and data models"
echo "   - API specifications and integration points"
echo "   - Security and error handling design"
echo ""
echo "5. TASK BREAKDOWN:"
echo "   - Implementation tasks with clear deliverables"
echo "   - Testing tasks with specific test cases"
echo "   - Integration tasks with existing features"
echo "   - Documentation and deployment tasks"
echo ""

if [ "$member_count" -gt 0 ]; then
    echo "6. TEAM COORDINATION:"
    echo "   - Task assignment recommendations for $member_count developers"
    echo "   - Dependency analysis and parallel work opportunities"
    echo "   - Integration coordination between team members"
    echo ""
fi

echo "7. FILE GENERATION:"
echo "   - Create requirements.md with EARS format requirements"
echo "   - Generate design.md with technical specifications"
echo "   - Produce tasks.md with implementation breakdown"
echo "   - Use atomic file+cache updates for consistency"
echo ""

# =============================================================================
# PROVIDE CLAUDE WITH PROJECT DATA AND UPDATE FUNCTIONS
# =============================================================================

echo "[FUNCTIONS] Available for Claude AI:"
echo "- PROJECT_OVERVIEW: Full project overview content"
echo "- PROJECT_ARCHITECTURE: Technical architecture decisions"  
echo "- PROJECT_CONVENTIONS: Coding standards and practices"
echo "- PROJECT_BACKLOG: Current backlog and priorities (if available)"
echo ""
echo "Atomic update functions:"
echo "- update_file_and_cache(file_path, new_content, cache_key)"
echo "- cache_set(key, value, ttl)"
echo "- cache_get(key)"
echo ""

# =============================================================================
# PERFORMANCE METRICS
# =============================================================================

plan_end_time=$(date +%s.%N)
plan_duration=$(echo "$plan_end_time - $plan_start_time" | bc -l 2>/dev/null || echo "N/A")

echo "=== PLANNING CONTEXT PREPARATION COMPLETE ==="
echo "Planning type: $planning_type"
echo "Cache mode: $PROJECT_CACHE_MODE"
echo "Duration: $plan_duration seconds"
echo ""

# Display cache performance
echo "CACHE PERFORMANCE:"
get_cache_stats
echo ""

echo "[READY] Claude AI can now complete the feature planning using:"
echo "1. Cached project data (PROJECT_* variables)"  
echo "2. Planning context (key: $planning_context_key)"
echo "3. Web research capabilities for best practices"
echo "4. Atomic update functions for file+cache consistency"
echo ""

# Clean up file cache
cleanup_file_cache

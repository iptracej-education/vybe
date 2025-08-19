#!/bin/bash

# =============================================================================
# VYBE PROJECT AUDIT - SHARED CACHE ARCHITECTURE
# Uses shared project cache + file system fallback for optimal performance
# =============================================================================

# Parse arguments FIRST
audit_scope="${1:-default}"
force_rescan=false
show_cache_stats=false

for arg in "$@"; do
    case $arg in
        --force) force_rescan=true ;;
        --cache-stats) show_cache_stats=true ;;
    esac
done

# =============================================================================
# EARLY HELP CHECK (before ANY initialization)
# =============================================================================

# Check for help request early to avoid unnecessary cache loading
if [ "$audit_scope" = "help" ]; then
    echo "COMMANDS:"
    echo "/vybe:audit                     Complete project quality audit"
    echo "/vybe:audit features            Check feature specification gaps"
    echo "/vybe:audit tasks               Find missing/duplicate tasks"
    echo "/vybe:audit dependencies        Identify circular dependencies"
    echo "/vybe:audit members             Check team assignment conflicts"
    echo "/vybe:audit code-reality        Compare implemented vs documented"
    echo "/vybe:audit scope-drift         Detect feature scope changes"
    echo "/vybe:audit business-value      Check business outcome alignment"
    echo "/vybe:audit documentation       Verify docs match implementation"
    echo "/vybe:audit mvp-extraction      Extract minimal viable features"
    echo ""
    echo "OPTIONS:"
    echo "--force                Force fresh scan (ignore cache)"
    echo "--cache-stats          Show detailed cache performance"
    echo ""
    echo "Use '/vybe:audit [command]' to run specific quality checks."
    echo "Use '/vybe:discuss \"question\"' for audit guidance."
    exit 0
fi

# =============================================================================
# NOW INITIALIZE EVERYTHING ELSE (after help check)
# =============================================================================

# Source shared cache system
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/shared-cache.sh"

# Performance timing
audit_start_time=$(date +%s.%N)
echo "=== VYBE PROJECT AUDIT ==="
echo "Scope: $audit_scope | Force: $force_rescan | Started: $(date)"
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
# SMART CACHE CHECK - AUDIT-SPECIFIC CACHE
# =============================================================================

cache_hit=false
cached_audit_data=""
audit_cache_key=$(get_cache_key "audit.$audit_scope")

if [ "$force_rescan" = false ]; then
    echo "[CACHE] Checking for cached audit data..."
    
    # Try to get cached audit results
    cached_audit_data=$(cache_get "$audit_cache_key")
    
    if [ $? -eq 0 ] && [ -n "$cached_audit_data" ]; then
        cache_hit=true
        echo "[CACHE] Valid cached audit found - using cached results"
    else
        echo "[CACHE] No cached audit found - performing fresh scan"
    fi
fi

# =============================================================================
# BULK FILE PROCESSING (if cache miss or force rescan)
# =============================================================================

if [ "$cache_hit" = false ] || [ "$force_rescan" = true ]; then
    echo ""
    echo "[SCAN] Performing bulk project analysis..."
    
    # Initialize counters and variables
    issues_found=0
    gaps_found=0
    duplicates_found=0
    conflicts_found=0
    feature_count=0
    
    # CRITICAL: Complete Context Loading (MANDATORY)
    echo "[CONTEXT] Loading project foundation..."
    context_loaded=true
    missing_foundation=""
    
    # Check foundation files in bulk
    foundation_files=(".vybe/project/overview.md" ".vybe/project/architecture.md" ".vybe/project/conventions.md")
    for file in "${foundation_files[@]}"; do
        if [ ! -f "$file" ]; then
            context_loaded=false
            missing_foundation="$missing_foundation $file"
        fi
    done
    
    if [ "$context_loaded" = false ]; then
        echo "[CRITICAL] Missing foundation documents:$missing_foundation"
        echo "Run /vybe:init to create complete project foundation"
        exit 1
    fi
    echo "[OK] Project context loaded successfully"
    
    # BULK FEATURE ANALYSIS
    echo "[SCAN] Analyzing features in bulk..."
    
    if [ -d ".vybe/features" ]; then
        # Count features efficiently
        feature_count=$(find .vybe/features -maxdepth 1 -type d 2>/dev/null | grep -c "/.vybe/features/" || echo "0")
        feature_count=$(echo "$feature_count" | tr -d '\n')
        echo "[FOUND] $feature_count features detected"
        
        if [ "$feature_count" -gt 0 ]; then
            # Bulk read all feature files into memory
            feature_analysis_results=""
            
            for feature_dir in .vybe/features/*/; do
                if [ -d "$feature_dir" ]; then
                    feature_name=$(basename "$feature_dir")
                    missing_files=0
                    feature_status="[OK]"
                    
                    # Check all required files at once
                    required_files=("requirements.md" "design.md" "tasks.md")
                    for req_file in "${required_files[@]}"; do
                        if [ ! -f "$feature_dir/$req_file" ]; then
                            missing_files=$((missing_files + 1))
                            feature_status="[GAP]"
                        fi
                    done
                    
                    # Count tasks if tasks.md exists
                    task_count=0
                    if [ -f "$feature_dir/tasks.md" ]; then
                        task_count=$(grep -c "^## Task" "$feature_dir/tasks.md" 2>/dev/null || echo "0")
                        if [ "$task_count" -eq 0 ]; then
                            missing_files=$((missing_files + 1))
                            feature_status="[GAP]"
                        fi
                    fi
                    
                    gaps_found=$((gaps_found + missing_files))
                    feature_analysis_results="$feature_analysis_results
$feature_status $feature_name ($task_count tasks, $missing_files gaps)"
                fi
            done
        else
            echo "[GAP] No features found"
            gaps_found=$((gaps_found + 1))
        fi
    else
        echo "[GAP] No features directory"
        gaps_found=$((gaps_found + 1))
    fi
    
    # Handle special audit modes
    case "$audit_scope" in
        "code-reality")
            echo ""
            echo "[AI-ANALYSIS] CODE-REALITY AUDIT REQUESTED"
            echo "Comparing documented plans vs implemented reality..."
            
            # Count source files efficiently
            source_count=$(find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.java" -o -name "*.go" -o -name "*.rs" \) -not -path "./node_modules/*" -not -path "./.git/*" -not -path "./venv/*" 2>/dev/null | wc -l)
            echo "Found $source_count source code files for analysis"
            echo ""
            echo "AI will perform systematic analysis:"
            echo "1. Compare implemented features vs documented features"
            echo "2. Check architecture alignment with actual code"
            echo "3. Find orphan code without documentation"
            echo "4. Identify missing implementations"
            ;;
            
        "scope-drift"|"business-value"|"documentation"|"mvp-extraction")
            echo ""
            echo "[AI-ANALYSIS] $(echo $audit_scope | tr '[:lower:]' '[:upper:]' | tr '-' ' ') AUDIT"
            echo "AI will analyze your project for $audit_scope issues"
            ;;
    esac
    
    # Calculate total issues
    total_issues=$((gaps_found + duplicates_found + conflicts_found))
    
    # Determine audit status
    if [ "$total_issues" -eq 0 ]; then
        audit_status="excellent"
        status_message="PROJECT HEALTH: EXCELLENT"
    else
        audit_status="needs_attention"
        status_message="PROJECT HEALTH: NEEDS ATTENTION"
    fi
    
    # Generate audit timestamp and report
    audit_timestamp=$(date '+%Y%m%d_%H%M%S')
    audit_dir=".vybe/audit"
    mkdir -p "$audit_dir"
    audit_report="$audit_dir/audit-$audit_timestamp.md"
    
    # Create comprehensive audit summary JSON
    audit_summary_json=$(python3 -c "
import json
import datetime
summary = {
    'timestamp': '$audit_timestamp',
    'time': datetime.datetime.now().isoformat(),
    'gaps': $gaps_found,
    'duplicates': $duplicates_found,
    'conflicts': $conflicts_found,
    'total_issues': $total_issues,
    'status': '$audit_status',
    'scope': '$audit_scope',
    'feature_count': $feature_count,
    'project_dir': '$(pwd)',
    'performance': {
        'cache_used': $cache_hit,
        'scan_type': 'bulk_processing'
    }
}
print(json.dumps(summary, indent=2))
" 2>/dev/null)
    
    # CACHE AUDIT RESULTS using shared cache system
    echo ""
    echo "[CACHE] Saving audit results..."
    
    # Cache the audit results for future use
    cache_set "$audit_cache_key" "$audit_summary_json" 3600
    
    echo "[CACHE] Results cached"
    
    # Save audit report to file
    {
        echo "# Vybe Project Audit Report"
        echo "**Date**: $(date)"
        echo "**Scope**: $audit_scope"
        echo ""
        echo "## Summary"
        echo "- **Gaps**: $gaps_found"
        echo "- **Duplicates**: $duplicates_found"
        echo "- **Conflicts**: $conflicts_found"
        echo "- **Total Issues**: $total_issues"
        echo "- **Status**: $audit_status"
        echo "- **Features**: $feature_count"
        echo ""
        echo "Generated: $(date)"
    } > "$audit_report"
    
    cached_audit_data="$audit_summary_json"
fi

# =============================================================================
# OUTPUT RESULTS (from cache or fresh scan)
# =============================================================================

audit_end_time=$(date +%s.%N)
audit_duration=$(echo "$audit_end_time - $audit_start_time" | bc -l 2>/dev/null || echo "N/A")

echo ""
echo "### AUDIT RESULTS"
echo "================="
echo ""

if [ -n "$cached_audit_data" ]; then
    # Parse and display results from JSON
    python3 -c "
import json
import sys

try:
    data = json.loads('''$cached_audit_data''')
    
    total_issues = data.get('total_issues', 0)
    status = data.get('status', 'unknown')
    gaps = data.get('gaps', 0)
    duplicates = data.get('duplicates', 0)
    conflicts = data.get('conflicts', 0)
    feature_count = data.get('feature_count', 0)
    
    if total_issues == 0:
        print('✅ PROJECT HEALTH: EXCELLENT')
        print('- No gaps detected')
        print('- No duplicates found') 
        print('- No conflicts identified')
        print('- Project ready for development')
    else:
        print('⚠️  PROJECT HEALTH: NEEDS ATTENTION')
        print(f'- Gaps found: {gaps}')
        print(f'- Duplicates found: {duplicates}')
        print(f'- Conflicts found: {conflicts}')
        print(f'- Total issues: {total_issues}')
        print('')
        print('Recommended fixes:')
        if gaps > 0:
            print('- /vybe:plan [feature-name] \"description\" - Add missing features')
    
    print('')
    print(f'📊 Project Statistics:')
    print(f'- Features: {feature_count}')
    print(f'- Audit scope: {data.get(\"scope\", \"default\")}')
    print(f'- Last updated: {data.get(\"time\", \"unknown\")}')
    
except Exception as e:
    print('Error parsing audit results')
" 2>/dev/null
fi

# =============================================================================
# CACHE PERFORMANCE METRICS
# =============================================================================

echo ""
echo "CACHE STATUS:"
echo "- Mode: $([ "$cache_hit" = true ] && echo "cached results" || echo "fresh scan + caching")"
echo "- Cache type: $PROJECT_CACHE_MODE"
echo "- Execution time: $audit_duration seconds"

if [ "$show_cache_stats" = true ]; then
    echo ""
    echo "DETAILED CACHE STATISTICS:"
    get_cache_stats
fi

echo ""
echo "=== AUDIT EXECUTION COMPLETE ==="
echo "Mode: $([ "$cache_hit" = true ] && echo "cached" || echo "bulk processing")"
echo "Duration: $audit_duration seconds"
echo ""

# Related commands
if [ "$cached_audit_data" != "" ]; then
    total_issues=$(echo "$cached_audit_data" | python3 -c "import json,sys; print(json.load(sys.stdin).get('total_issues', 0))" 2>/dev/null)
    if [ "$total_issues" -gt 0 ]; then
        echo "🔧 RELATED COMMANDS:"
        echo "- /vybe:status - Check progress"
        echo "- /vybe:plan [feature] - Add features"
        echo "- /vybe:discuss \"[question]\" - Get guidance"
        echo ""
    fi
fi
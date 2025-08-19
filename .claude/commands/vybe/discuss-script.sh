#!/bin/bash

# =============================================================================
# VYBE DISCUSS - SHARED CACHE ARCHITECTURE
# Uses shared project cache + file system fallback for optimal performance
# =============================================================================

# Source shared cache system
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/shared-cache.sh"

# Parse arguments - join all arguments into single request
discussion_request="$*"

# Performance timing
discuss_start_time=$(date +%s.%N)
echo "=== VYBE NATURAL LANGUAGE ASSISTANT ==="
echo "Request: \"${discussion_request:-[required]}\" | Started: $(date)"
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
# DISCUSSION CONTEXT AND REQUEST ANALYSIS
# =============================================================================

echo "[ANALYZE] Processing natural language request..."

# Check for help request
if [ "$discussion_request" = "help" ]; then
    echo "=== VYBE DISCUSS HELP ==="
    echo ""
    echo "Natural language assistant with automatic code-reality analysis and smart routing"
    echo ""
    echo "USAGE:"
    echo "  /vybe:discuss \"[your request in natural language]\""
    echo ""
    echo "PARAMETERS:"
    echo "  request                Natural language description of what you need help with"
    echo ""
    echo "EXAMPLES:"
    echo "  /vybe:discuss \"We need to add mobile support to our web app\""
    echo "  /vybe:discuss \"reshape this project to fit 2 weeks, prefer MVP\""
    echo "  /vybe:discuss \"find inconsistencies between backlog and actual code\""
    echo "  /vybe:discuss \"how do I assign features to team members?\""
    echo "  /vybe:discuss \"what's the best way to implement user authentication?\""
    echo ""
    echo "SMART ROUTING FEATURES:"
    echo "  - Automatic routing to specialized audit modes for analysis requests"
    echo "  - Command translation from natural language to specific Vybe commands"
    echo "  - Context-aware suggestions based on current project state"
    echo "  - Code-reality analysis for inconsistency detection"
    echo "  - Project guidance and workflow recommendations"
    echo ""
    echo "ANALYSIS MODES (Auto-detected):"
    echo "  - Code vs Documentation Analysis"
    echo "  - Scope Drift Detection"
    echo "  - Business Value Alignment"
    echo "  - MVP Extraction and Planning"
    echo "  - Resource Allocation Optimization"
    echo ""
    echo "INTELLIGENT CAPABILITIES:"
    echo "  - Translates user requests into specific Vybe command sequences"
    echo "  - Automatically runs /vybe:audit commands for analysis requests"
    echo "  - Provides structured results with actionable recommendations"
    echo "  - Context-aware guidance based on project stage and team setup"
    echo ""
    echo "RELATED COMMANDS:"
    echo "  /vybe:audit [scope]             # Direct quality assurance"
    echo "  /vybe:status                    # Check project progress"
    echo "  /vybe:help                      # Global Vybe Framework help"
    exit 0
fi

# Validate discussion request
if [ -z "$discussion_request" ]; then
    echo "[ERROR] Usage: /vybe:discuss \"[your request in natural language]\""
    echo ""
    echo "Examples:"
    echo "  /vybe:discuss \"We need to add mobile support to our web app\""
    echo "  /vybe:discuss \"reshape this project to fit 2 weeks, prefer MVP\""
    echo "  /vybe:discuss \"find inconsistencies between backlog and actual code\""
    echo ""
    echo "Use '/vybe:discuss help' for detailed usage information"
    exit 1
fi

# Detect request type for intelligent routing
request_type="command_translation"
analysis_mode=""
routing_keywords=""

# Check for code-reality analysis keywords
if [[ "$discussion_request" =~ (reshape|analyze|audit|compare|find|detect|evaluate|sync|align|extract|refactor) ]]; then
    request_type="code_reality_analysis"
    
    # Specific analysis mode detection
    if [[ "$discussion_request" =~ (reshape|fit.*weeks|MVP|deadline|scope|cut.*features) ]]; then
        analysis_mode="scope_drift"
        routing_keywords="project reshaping, scope analysis, timeline optimization"
    elif [[ "$discussion_request" =~ (README|docs|documented|promises|sync|outdated) ]]; then
        analysis_mode="documentation"
        routing_keywords="documentation synchronization, README alignment"
    elif [[ "$discussion_request" =~ (business.*outcome|vision|user.*stories|value) ]]; then
        analysis_mode="business_value"
        routing_keywords="business alignment, outcome verification"
    elif [[ "$discussion_request" =~ (inconsist|gap|compare.*code|reality|implemented.*features) ]]; then
        analysis_mode="code_reality"
        routing_keywords="code-reality gap analysis, implementation verification"
    elif [[ "$discussion_request" =~ (extract.*MVP|microservices|refactor|architecture) ]]; then
        analysis_mode="mvp_extraction"
        routing_keywords="MVP extraction, architecture analysis"
    fi
fi

# Load additional context for analysis
readme_content=""
if [ -f "README.md" ]; then
    readme_content=$(cat README.md 2>/dev/null)
elif [ -f "readme.md" ]; then
    readme_content=$(cat readme.md 2>/dev/null)
fi

# Sample source code for code-reality analysis
sample_source_code=""
if [ "$request_type" = "code_reality_analysis" ]; then
    echo "[SCAN] Loading source code for analysis..."
    
    # Get source files for analysis
    source_files=($(find . -path ./node_modules -prune -o -path ./.git -prune -o -path ./.vybe -prune -o -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.java" -o -name "*.rs" -o -name "*.rb" \) -print 2>/dev/null | head -15))
    
    if [ ${#source_files[@]} -gt 0 ]; then
        echo "[FOUND] ${#source_files[@]} source files for analysis"
        
        # Sample key files for analysis
        for file in "${source_files[@]:0:5}"; do
            if [ -f "$file" ]; then
                echo "=== $file ===" >> /tmp/source_sample.txt
                head -100 "$file" >> /tmp/source_sample.txt
                echo "" >> /tmp/source_sample.txt
            fi
        done
        
        if [ -f /tmp/source_sample.txt ]; then
            sample_source_code=$(cat /tmp/source_sample.txt)
            rm /tmp/source_sample.txt
        fi
    fi
fi

# Extract project metrics for context
project_metrics=""
if [ -n "$PROJECT_BACKLOG" ]; then
    feature_count=$(echo "$PROJECT_BACKLOG" | grep -c "^### Feature" 2>/dev/null || echo "0")
    completed_features=$(echo "$PROJECT_BACKLOG" | grep -c "COMPLETED" 2>/dev/null || echo "0")
    project_metrics="Features: $feature_count total, $completed_features completed"
fi

# Count project files
total_files=$(find . -path ./node_modules -prune -o -path ./.git -prune -o -path ./.vybe -prune -o -type f -print 2>/dev/null | wc -l)
code_files=$(find . -path ./node_modules -prune -o -path ./.git -prune -o -path ./.vybe -prune -o -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.java" -o -name "*.rs" -o -name "*.rb" \) -print 2>/dev/null | wc -l)

echo "[STATE] Request type: $request_type"
echo "[STATE] Analysis mode: ${analysis_mode:-general}"
echo "[STATE] Project files: $code_files source files, $total_files total"
echo ""

# =============================================================================
# PREPARE DISCUSSION CONTEXT FOR CLAUDE AI
# =============================================================================

echo "[AI-PREP] Preparing comprehensive discussion context..."

# Create comprehensive discussion context
discussion_context=$(python3 -c "
import json
context = {
    'command': 'discuss',
    'request': '''$discussion_request''',
    'request_type': '$request_type',
    'analysis_mode': '$analysis_mode',
    'routing_keywords': '$routing_keywords',
    'project_context': {
        'overview_length': len('''$PROJECT_OVERVIEW'''),
        'architecture_length': len('''$PROJECT_ARCHITECTURE'''),
        'conventions_length': len('''$PROJECT_CONVENTIONS'''),
        'outcomes_length': len('''$PROJECT_OUTCOMES'''),
        'backlog_length': len('''$PROJECT_BACKLOG'''),
        'metrics': '$project_metrics'
    },
    'code_analysis': {
        'total_files': $total_files,
        'code_files': $code_files,
        'readme_available': bool('''$readme_content'''),
        'readme_length': len('''$readme_content'''),
        'source_sample_available': bool('''$sample_source_code''')
    },
    'discussion_capabilities': [
        'command_sequence_generation',
        'code_reality_gap_analysis',
        'scope_drift_detection', 
        'business_value_alignment',
        'documentation_synchronization',
        'mvp_extraction_recommendations',
        'technical_debt_prioritization'
    ],
    'routing_decision': {
        'requires_audit_analysis': '$request_type' == 'code_reality_analysis',
        'suggested_audit_mode': '$analysis_mode',
        'command_translation_needed': True
    }
}
print(json.dumps(context, indent=2))
" 2>/dev/null)

# Cache the discussion context for Claude AI access
discussion_context_key=$(get_cache_key "discussion_context.$(date +%s)")
cache_set "$discussion_context_key" "$discussion_context" 7200

# Cache source code sample if available
source_sample_key=""
if [ -n "$sample_source_code" ]; then
    source_sample_key=$(get_cache_key "source_sample.$(date +%s)")
    cache_set "$source_sample_key" "$sample_source_code" 3600
fi

# Cache README content if available
readme_key=""
if [ -n "$readme_content" ]; then
    readme_key=$(get_cache_key "readme_content.$(date +%s)")
    cache_set "$readme_key" "$readme_content" 3600
fi

echo "[AI-PREP] Discussion context prepared and cached"
echo "[AI-PREP] Context key: $discussion_context_key"
if [ -n "$source_sample_key" ]; then
    echo "[AI-PREP] Source code sample key: $source_sample_key"
fi
if [ -n "$readme_key" ]; then
    echo "[AI-PREP] README content key: $readme_key"
fi
echo ""

# =============================================================================
# CLAUDE AI COORDINATION SECTION  
# =============================================================================

echo "[AI-COORDINATION] REQUESTING CLAUDE AI DISCUSSION ANALYSIS"
echo "========================================================="
echo ""
echo "Claude AI should now process the natural language request using:"
echo ""

if [ "$request_type" = "command_translation" ]; then
    echo "MODE: COMMAND TRANSLATION"
    echo "1. REQUEST INTERPRETATION:"
    echo "   - Parse natural language request for intent and goals"
    echo "   - Identify specific Vybe operations needed"
    echo "   - Determine optimal command sequence"
    echo ""
    echo "2. COMMAND SEQUENCE GENERATION:"
    echo "   - Generate step-by-step Vybe command sequence"
    echo "   - Provide context and explanations for each step"
    echo "   - Include parameter recommendations and options"
    echo "   - Suggest verification and validation steps"
    echo ""
else
    echo "MODE: CODE-REALITY ANALYSIS ($analysis_mode)"
    echo "1. MULTI-SOURCE ANALYSIS:"
    echo "   - Compare project documentation vs actual source code"
    echo "   - Analyze README/docs alignment with implementation"
    echo "   - Cross-reference backlog/outcomes with code reality"
    echo "   - Identify gaps, inconsistencies, and scope drift"
    echo ""
    echo "2. SPECIALIZED AUDIT ANALYSIS:"
    echo "   - Run targeted audit analysis mode: $analysis_mode"
    echo "   - Focus on: $routing_keywords"
    echo "   - Provide structured analysis report with findings"
    echo "   - Generate actionable recommendations"
    echo ""
    echo "3. COMMAND SEQUENCE + ANALYSIS:"
    echo "   - Provide both analysis results AND command sequences"
    echo "   - Suggest immediate fixes and longer-term improvements"
    echo "   - Include validation steps to verify changes"
    echo ""
fi

echo "Available data sources:"
echo "- PROJECT_OVERVIEW, PROJECT_ARCHITECTURE, PROJECT_CONVENTIONS"
echo "- PROJECT_OUTCOMES, PROJECT_BACKLOG (if available)"
echo "- README content (cached: $([ -n "$readme_key" ] && echo "yes" || echo "no"))"
echo "- Source code sample (cached: $([ -n "$source_sample_key" ] && echo "yes" || echo "no"))"
echo ""
echo "Expected outputs:"
echo "1. Analysis results (if code-reality analysis)"
echo "2. Recommended Vybe command sequences"
echo "3. Context and explanations"
echo "4. Verification steps"
echo ""

# =============================================================================
# PROVIDE CLAUDE WITH ACCESS FUNCTIONS
# =============================================================================

echo "[FUNCTIONS] Available for Claude AI:"
echo "- cache_get(key) - Retrieve cached content"
echo "- PROJECT_* variables - Full project context"
echo "- Discussion context key: $discussion_context_key"
if [ -n "$source_sample_key" ]; then
    echo "- Source code sample key: $source_sample_key"
fi
if [ -n "$readme_key" ]; then
    echo "- README content key: $readme_key"
fi
echo ""

# =============================================================================
# PERFORMANCE METRICS
# =============================================================================

discuss_end_time=$(date +%s.%N)
discuss_duration=$(echo "$discuss_end_time - $discuss_start_time" | bc -l 2>/dev/null || echo "N/A")

echo "=== DISCUSSION CONTEXT PREPARATION COMPLETE ==="
echo "Request type: $request_type"
echo "Analysis mode: ${analysis_mode:-general}"
echo "Cache mode: $PROJECT_CACHE_MODE"
echo "Duration: $discuss_duration seconds"
echo ""

# Display cache performance
echo "CACHE PERFORMANCE:"
get_cache_stats
echo ""

echo "[READY] Claude AI can now complete the discussion analysis using:"
echo "1. Project context (cached: PROJECT_* variables)"
echo "2. Discussion context (key: $discussion_context_key)"
echo "3. Source analysis data (if code-reality analysis requested)"
echo "4. README/documentation content for alignment checks"
echo ""

# Clean up file cache
cleanup_file_cache

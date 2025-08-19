#!/bin/bash

# =============================================================================
# VYBE TEMPLATE - SHARED CACHE ARCHITECTURE
# Uses shared project cache + file system fallback for optimal performance
# =============================================================================

# Parse arguments FIRST
action="${1:-list}"

# Handle different argument patterns for different actions
case "$action" in
    "import")
        source_param="$2"
        template_name="$3"
        ;;
    "generate"|"validate")
        template_name="$2"
        source_param=""
        ;;
    "help")
        # Early exit for help
        ;;
    *)
        source_param="$2"
        template_name="$3"
        ;;
esac

# =============================================================================
# EARLY HELP CHECK (before ANY initialization)
# =============================================================================

if [ "$action" = "help" ]; then
    echo "=== VYBE TEMPLATE HELP ==="
    echo ""
    echo "Import and analyze external templates for template-driven architecture"
    echo ""
    echo "USAGE:"
    echo "  /vybe:template [action] [params]"
    echo ""
    echo "ACTIONS:"
    echo "  list                    Show available templates and their status"
    echo "  import [source] [name]  Import template from GitHub or local path"
    echo "  generate [name]         AI analyzes template and creates enforcement structures"
    echo "  validate [name]         Check template completeness and validation score"
    echo "  help                    Show this help message"
    echo ""
    echo "EXAMPLES:"
    echo "  /vybe:template list                             # List available templates"
    echo "  /vybe:template import github.com/user/repo my-template  # Import from GitHub"
    echo "  /vybe:template import ./local-dir my-template   # Import from local directory"
    echo "  /vybe:template generate genai-stack             # Generate enforcement rules"
    echo "  /vybe:template validate genai-stack             # Check template completeness"
    echo ""
    echo "COMMON WORKFLOWS:"
    echo "  # Import and use a popular template"
    echo "  /vybe:template import github.com/anthropics/genai-launchpad genai-stack"
    echo "  /vybe:template generate genai-stack"
    echo "  /vybe:init \"My AI app\" --template=genai-stack"
    echo ""
    echo "  # Import from local directory"
    echo "  /vybe:template import ./my-company-template company-stack"
    echo "  /vybe:template validate company-stack"
    echo ""
    echo "  # Check available templates"
    echo "  /vybe:template list"
    echo ""
    echo "TEMPLATE SOURCES:"
    echo "  - GitHub repositories (github.com/user/repo)"
    echo "  - Local directories (./path/to/template)"
    echo "  - Template names must be alphanumeric with dashes"
    exit 0
fi

# =============================================================================
# NOW INITIALIZE EVERYTHING ELSE (after help check)
# =============================================================================

# Source shared cache system
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/shared-cache.sh"

# Performance timing
template_start_time=$(date +%s.%N)
echo "=== VYBE TEMPLATE SYSTEM ==="
echo "Action: $action | Started: $(date)"
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
# TEMPLATE-SPECIFIC CACHE AND VALIDATION
# =============================================================================

# Template cache keys
template_list_key=$(get_cache_key "template.list")
template_analysis_key=$(get_cache_key "template.analysis.$template_name")

# Initialize template directory
mkdir -p .vybe/templates
mkdir -p .vybe/enforcement
mkdir -p .vybe/patterns
mkdir -p .vybe/validation

# Bulk template state analysis
echo "[PARSE] Analyzing template system state..."

template_count=0
available_templates=""
template_system_status="empty"

if [ -d ".vybe/templates" ]; then
    template_count=$(find .vybe/templates -maxdepth 1 -type d 2>/dev/null | grep -c "/.*" || echo "0")
    template_count=$((template_count - 1)) # Remove parent dir from count
    
    if [ "$template_count" -gt 0 ]; then
        available_templates=$(find .vybe/templates -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | grep -v "templates" | sort)
        template_system_status="configured"
    fi
fi

echo "[STATE] Templates: $template_count found"
echo "[STATE] System: $template_system_status"
echo ""

# =============================================================================
# ACTION PROCESSING WITH BULK OPERATIONS
# =============================================================================

case "$action" in
    "import")
        echo "[IMPORT] Processing template import..."
        echo "Source: $source_param"
        echo "Name: $template_name"
        
        # Validate parameters
        if [ -z "$source_param" ] || [ -z "$template_name" ]; then
            echo "[ERROR] Usage: /vybe:template import [source] [name]"
            echo "Examples:"
            echo "  /vybe:template import github.com/user/repo template-name"
            echo "  /vybe:template import ./local-dir template-name"
            exit 1
        fi
        
        # Validate template name
        if [[ ! "$template_name" =~ ^[a-zA-Z0-9-]+$ ]]; then
            echo "[ERROR] Template name must be alphanumeric with dashes only"
            exit 1
        fi
        
        # Check for existing template
        if [ -d ".vybe/templates/$template_name" ]; then
            echo "[ERROR] Template '$template_name' already exists"
            exit 1
        fi
        
        # Prepare import context for Claude AI
        import_context=$(python3 -c "
import json
context = {
    'action': 'import',
    'source': '$source_param',
    'template_name': '$template_name',
    'template_count': $template_count,
    'project_data': {
        'has_overview': bool('''$PROJECT_OVERVIEW'''),
        'has_architecture': bool('''$PROJECT_ARCHITECTURE''')
    },
    'import_operations_required': [
        'determine_source_type',
        'download_or_copy_template',
        'analyze_template_structure',
        'create_template_metadata',
        'validate_template_completeness'
    ]
}
print(json.dumps(context, indent=2))
" 2>/dev/null)
        
        # Cache import context for Claude AI
        import_context_key=$(get_cache_key "import_context.$(date +%s)")
        cache_set "$import_context_key" "$import_context" 7200
        
        echo "[AI-PREP] Import context prepared and cached"
        echo "[AI-PREP] Context key: $import_context_key"
        ;;
        
    "generate")
        echo "[GENERATE] Processing AI template analysis..."
        echo "Template: $template_name"
        
        if [ -z "$template_name" ]; then
            echo "[ERROR] Usage: /vybe:template generate [name]"
            exit 1
        fi
        
        if [ ! -d ".vybe/templates/$template_name" ]; then
            echo "[ERROR] Template '$template_name' not found"
            echo "Available templates: $(echo "$available_templates" | tr '\n' ' ')"
            exit 1
        fi
        
        # Bulk load template source files
        template_source_dir=".vybe/templates/$template_name/source"
        template_metadata_file=".vybe/templates/$template_name/metadata.yml"
        
        echo "[SCAN] Analyzing template source files..."
        
        if [ ! -d "$template_source_dir" ]; then
            echo "[ERROR] Template source directory not found: $template_source_dir"
            exit 1
        fi
        
        # Count and analyze template files efficiently
        source_file_count=$(find "$template_source_dir" -type f 2>/dev/null | wc -l)
        code_file_count=$(find "$template_source_dir" -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.java" -o -name "*.go" -o -name "*.rs" 2>/dev/null | wc -l)
        config_file_count=$(find "$template_source_dir" -name "*.json" -o -name "*.yml" -o -name "*.yaml" -o -name "*.toml" 2>/dev/null | wc -l)
        
        # Load template metadata if exists
        template_metadata=""
        if [ -f "$template_metadata_file" ]; then
            template_metadata=$(cat "$template_metadata_file")
        fi
        
        # Prepare generation context for Claude AI
        generation_context=$(python3 -c "
import json
context = {
    'action': 'generate',
    'template_name': '$template_name',
    'source_analysis': {
        'total_files': $source_file_count,
        'code_files': $code_file_count,
        'config_files': $config_file_count,
        'source_dir': '$template_source_dir'
    },
    'metadata': '''$template_metadata''',
    'project_data': {
        'overview_length': len('''$PROJECT_OVERVIEW'''),
        'architecture_length': len('''$PROJECT_ARCHITECTURE'''),
        'conventions_length': len('''$PROJECT_CONVENTIONS''')
    },
    'generation_operations_required': [
        'analyze_template_architecture',
        'extract_code_patterns',
        'identify_conventions',
        'create_enforcement_rules',
        'generate_validation_patterns',
        'update_project_architecture'
    ],
    'output_paths': {
        'enforcement': '.vybe/enforcement/',
        'patterns': '.vybe/patterns/', 
        'validation': '.vybe/validation/'
    }
}
print(json.dumps(context, indent=2))
" 2>/dev/null)
        
        # Cache generation context for Claude AI
        generation_context_key=$(get_cache_key "generation_context.$(date +%s)")
        cache_set "$generation_context_key" "$generation_context" 7200
        
        echo "[AI-PREP] Generation context prepared and cached"
        echo "[AI-PREP] Context key: $generation_context_key"
        echo "[AI-PREP] Template files analyzed: $source_file_count total, $code_file_count code files"
        ;;
        
    "list")
        echo "[LIST] Available templates:"
        echo "========================="
        
        if [ "$template_count" -eq 0 ]; then
            echo "No templates found."
            echo ""
            echo "Import a template with:"
            echo "/vybe:template import [source] [name]"
        else
            echo "$available_templates" | while IFS= read -r template; do
                if [ -n "$template" ]; then
                    metadata_file=".vybe/templates/$template/metadata.yml"
                    if [ -f "$metadata_file" ]; then
                        description=$(grep "description:" "$metadata_file" 2>/dev/null | cut -d: -f2- | sed 's/^[ "]*//;s/[ "]*$//' || echo "No description")
                        echo "- $template: $description"
                    else
                        echo "- $template: (metadata missing)"
                    fi
                fi
            done
        fi
        ;;
        
    "validate")
        echo "[VALIDATE] Validating template: $template_name"
        echo "============================================"
        
        if [ -z "$template_name" ]; then
            echo "[ERROR] Usage: /vybe:template validate [name]"
            exit 1
        fi
        
        if [ ! -d ".vybe/templates/$template_name" ]; then
            echo "[ERROR] Template '$template_name' not found"
            exit 1
        fi
        
        # Bulk validation checks
        validation_results=""
        validation_score=0
        max_score=100
        
        # Check required directories
        if [ -d ".vybe/templates/$template_name/source" ]; then
            validation_results="$validation_results\n✅ Source directory exists"
            validation_score=$((validation_score + 20))
        else
            validation_results="$validation_results\n❌ Source directory missing"
        fi
        
        # Check metadata file
        if [ -f ".vybe/templates/$template_name/metadata.yml" ]; then
            validation_results="$validation_results\n✅ Metadata file exists"
            validation_score=$((validation_score + 20))
        else
            validation_results="$validation_results\n❌ Metadata file missing"
        fi
        
        # Check enforcement structures
        enforcement_count=$(find .vybe/enforcement -name "*$template_name*" 2>/dev/null | wc -l)
        if [ "$enforcement_count" -gt 0 ]; then
            validation_results="$validation_results\n✅ Enforcement rules generated ($enforcement_count files)"
            validation_score=$((validation_score + 20))
        else
            validation_results="$validation_results\n❌ No enforcement rules found"
        fi
        
        # Check pattern files
        pattern_count=$(find .vybe/patterns -name "*$template_name*" 2>/dev/null | wc -l)
        if [ "$pattern_count" -gt 0 ]; then
            validation_results="$validation_results\n✅ Code patterns extracted ($pattern_count files)"
            validation_score=$((validation_score + 20))
        else
            validation_results="$validation_results\n❌ No code patterns found"
        fi
        
        # Check validation rules
        validation_count=$(find .vybe/validation -name "*$template_name*" 2>/dev/null | wc -l)
        if [ "$validation_count" -gt 0 ]; then
            validation_results="$validation_results\n✅ Validation rules created ($validation_count files)"
            validation_score=$((validation_score + 20))
        else
            validation_results="$validation_results\n❌ No validation rules found"
        fi
        
        echo -e "$validation_results"
        echo ""
        echo "Validation Score: $validation_score/$max_score"
        
        if [ "$validation_score" -eq 100 ]; then
            echo "Status: ✅ Complete - Template fully configured"
        elif [ "$validation_score" -ge 60 ]; then
            echo "Status: ⚠️ Partial - Template needs completion"
            echo "Run: /vybe:template generate $template_name"
        else
            echo "Status: ❌ Incomplete - Template requires major work"
        fi
        ;;
        
    *)
        echo "[ERROR] Unknown action: $action"
        echo "Usage: /vybe:template [import|generate|list|validate|help] [params]"
        echo "Use '/vybe:template help' for detailed usage information"
        exit 1
        ;;
esac

# =============================================================================
# CLAUDE AI COORDINATION SECTION  
# =============================================================================

if [ "$action" = "import" ] || [ "$action" = "generate" ]; then
    echo ""
    echo "[AI-COORDINATION] REQUESTING CLAUDE AI ANALYSIS"
    echo "=============================================="
    echo ""
    echo "Claude AI should now perform the $action operation using:"
    echo ""
    
    if [ "$action" = "import" ]; then
        echo "1. TEMPLATE IMPORT:"
        echo "   - Determine source type (GitHub/local/URL)"
        echo "   - Download or copy template files"
        echo "   - Create template directory structure"
        echo "   - Generate metadata.yml with template info"
        echo ""
        echo "2. TEMPLATE ANALYSIS:"
        echo "   - Scan template files and structure"
        echo "   - Identify technology stack and patterns"
        echo "   - Extract architectural decisions"
        echo "   - Document template characteristics"
    else
        echo "1. ARCHITECTURAL ANALYSIS:"
        echo "   - Analyze template code patterns and conventions"
        echo "   - Extract architectural decisions and principles"
        echo "   - Identify naming conventions and code style"
        echo ""
        echo "2. ENFORCEMENT GENERATION:"
        echo "   - Create enforcement rules in .vybe/enforcement/"
        echo "   - Generate code patterns in .vybe/patterns/"
        echo "   - Build validation rules in .vybe/validation/"
        echo ""
        echo "3. PROJECT INTEGRATION:"
        echo "   - Update project architecture with template patterns"
        echo "   - Merge template conventions with project conventions"
        echo "   - Ensure template compatibility with existing code"
    fi
    
    echo ""
    echo "Available atomic update functions:"
    echo "- update_file_and_cache(file_path, new_content, cache_key)"
    echo "- cache_set(key, value, ttl)"
    echo "- cache_get(key)"
    echo ""
fi

# =============================================================================
# PERFORMANCE METRICS
# =============================================================================

template_end_time=$(date +%s.%N)
template_duration=$(echo "$template_end_time - $template_start_time" | bc -l 2>/dev/null || echo "N/A")

echo ""
echo "=== TEMPLATE SYSTEM EXECUTION COMPLETE ==="
echo "Action: $action"
echo "Cache mode: $PROJECT_CACHE_MODE"
echo "Duration: $template_duration seconds"
echo ""

# Display cache performance
echo "CACHE PERFORMANCE:"
get_cache_stats
echo ""

# Clean up file cache
cleanup_file_cache
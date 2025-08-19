#!/bin/bash

# =============================================================================
# VYBE INIT - SHARED CACHE ARCHITECTURE
# Uses shared project cache + file system fallback for optimal performance
# =============================================================================

# Source shared cache system

# Parse arguments
project_description="${1:-}"
template_name=""

for arg in "$@"; do
    case $arg in
        --template=*) template_name="${arg#*=}" ;;
    esac
done

# Performance timing
init_start_time=$(date +%s.%N)
echo "=== VYBE PROJECT INITIALIZATION ==="
echo "Description: ${project_description:-[auto-detect]} | Template: ${template_name:-none} | Started: $(date)"
echo ""

# =============================================================================
# INITIALIZE SHARED CACHE SYSTEM
# =============================================================================

init_vybe_cache

# Check for help request
if [ "$project_description" = "help" ]; then
    echo "=== VYBE INIT HELP ==="
    echo ""
    echo "Initialize project with staged outcome roadmap and template-driven architecture"
    echo ""
    echo "USAGE:"
    echo "  /vybe:init [description] [options]"
    echo ""
    echo "PARAMETERS:"
    echo "  description            Brief project description (optional, auto-detected if not provided)"
    echo ""
    echo "OPTIONS:"
    echo "  --template=name        Apply template-driven architectural DNA from imported template"
    echo ""
    echo "EXAMPLES:"
    echo "  /vybe:init \"AI-powered translation tracking system\""
    echo "  /vybe:init --template=genai-stack \"AI analytics platform\""
    echo "  /vybe:init                        # Auto-detect project from existing files"
    echo ""
    echo "INITIALIZATION FEATURES:"
    echo "  - Staged outcome roadmap with baby steps delivery approach"
    echo "  - Auto-detection of existing project structure and technology stack"
    echo "  - Template-driven architecture enforcement (if template specified)"
    echo "  - Multi-session coordination infrastructure setup"
    echo "  - Git-based team coordination (if needed)"
    echo ""
    echo "OUTPUT FILES:"
    echo "  .vybe/project/overview.md        # Business context and goals"
    echo "  .vybe/project/architecture.md    # Technical decisions and constraints"
    echo "  .vybe/project/conventions.md     # Coding standards and practices"
    echo "  .vybe/project/outcomes.md        # Staged outcome roadmap"
    echo ""
    echo "PROJECT OUTCOMES:"
    echo "  - First minimal outcome deliverable in 1-2 days"
    echo "  - Each stage builds on previous, delivers working units"
    echo "  - Learning between stages improves next stage"
    echo "  - Clear progression from minimal to full vision"
    echo ""
    echo "RELATED COMMANDS:"
    echo "  /vybe:template import [source] [name]  # Import template before init"
    echo "  /vybe:backlog init              # Create outcome-driven backlog after init"
    echo "  /vybe:plan [feature]            # Plan features after initialization"
    exit 0
fi

# =============================================================================
# PRE-INITIALIZATION ANALYSIS (BULK OPERATIONS)
# =============================================================================

echo "[ANALYZE] Performing project analysis..."

# Create .vybe directory structure
mkdir -p .vybe/project
mkdir -p .vybe/features
mkdir -p .vybe/context
mkdir -p .vybe/templates
mkdir -p .vybe/enforcement
mkdir -p .vybe/patterns
mkdir -p .vybe/validation

# Bulk project state detection
existing_vybe=false
existing_git=false
project_type="unknown"
code_files=()
package_managers=()
readme_files=""
existing_docs=()

if [ -d ".vybe" ]; then
    existing_vybe=true
    echo "[UPDATE] Existing Vybe project detected - will update"
else
    echo "[NEW] New Vybe project - will create from scratch"
fi

if [ -d ".git" ]; then
    existing_git=true
    echo "[OK] Git repository detected"
else
    echo "[WARN] Not a git repository - recommend running 'git init'"
fi

# Detect project type and package managers
echo "[SCAN] Analyzing project structure..."

# Check for package managers and project files
if [ -f "package.json" ]; then
    package_managers+=("npm/node")
    project_type="javascript"
fi

if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
    package_managers+=("python")
    project_type="python"
fi

if [ -f "go.mod" ] || [ -f "go.sum" ]; then
    package_managers+=("go")
    project_type="go"
fi

if [ -f "Cargo.toml" ]; then
    package_managers+=("rust")
    project_type="rust"
fi

if [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
    package_managers+=("java")
    project_type="java"
fi

if [ -f "Gemfile" ]; then
    package_managers+=("ruby")
    project_type="ruby"
fi

# Find README files
readme_files=$(find . -maxdepth 1 -name "README*" -type f 2>/dev/null | head -3)

# Sample code files for analysis
code_files=($(find . -path ./node_modules -prune -o -path ./.git -prune -o -path ./.vybe -prune -o -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.java" -o -name "*.rs" -o -name "*.rb" \) -print 2>/dev/null | head -10))

# Count various file types
total_code_files=$(find . -path ./node_modules -prune -o -path ./.git -prune -o -path ./.vybe -prune -o -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.java" -o -name "*.rs" -o -name "*.rb" \) -print 2>/dev/null | wc -l)
config_files=$(find . -maxdepth 2 -name "*.json" -o -name "*.yml" -o -name "*.yaml" -o -name "*.toml" -o -name "*.ini" 2>/dev/null | wc -l)
test_files=$(find . -path ./node_modules -prune -o -name "*test*" -o -name "*spec*" -type f 2>/dev/null | wc -l)

# Check existing Vybe documents
if [ -f ".vybe/project/overview.md" ]; then
    existing_docs+=("overview.md")
fi

if [ -f ".vybe/project/architecture.md" ]; then
    existing_docs+=("architecture.md")
fi

if [ -f ".vybe/project/conventions.md" ]; then
    existing_docs+=("conventions.md")
fi

if [ -f ".vybe/project/outcomes.md" ]; then
    existing_docs+=("outcomes.md")
fi

if [ -f ".vybe/backlog.md" ]; then
    existing_docs+=("backlog.md")
fi

# Template validation
template_available=false
template_metadata=""
if [ -n "$template_name" ]; then
    if [ -d ".vybe/templates/$template_name" ]; then
        template_available=true
        if [ -f ".vybe/templates/$template_name/metadata.yml" ]; then
            template_metadata=$(cat ".vybe/templates/$template_name/metadata.yml")
        fi
        echo "[TEMPLATE] Template '$template_name' found and will be applied"
    else
        echo "[ERROR] Template '$template_name' not found"
        echo "Available templates: $(find .vybe/templates -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | grep -v templates | tr '\n' ' ')"
        echo ""
        echo "Use '/vybe:init help' for detailed usage information"
        exit 1
    fi
fi

echo "[STATE] Project type: $project_type"
echo "[STATE] Package managers: $(IFS=, ; echo "${package_managers[*]}")"
echo "[STATE] Code files: $total_code_files"
echo "[STATE] Config files: $config_files"
echo "[STATE] Test files: $test_files"
echo "[STATE] Existing docs: $(IFS=, ; echo "${existing_docs[*]}")"
echo ""

# =============================================================================
# PREPARE INITIALIZATION CONTEXT FOR CLAUDE AI
# =============================================================================

echo "[AI-PREP] Preparing comprehensive initialization context..."

# Sample existing code for analysis (if available)
sample_code=""
if [ ${#code_files[@]} -gt 0 ]; then
    # Take first few code files for analysis
    for file in "${code_files[@]:0:3}"; do
        if [ -f "$file" ]; then
            echo "=== $file ===" >> /tmp/sample_code.txt
            head -50 "$file" >> /tmp/sample_code.txt
            echo "" >> /tmp/sample_code.txt
        fi
    done
    if [ -f /tmp/sample_code.txt ]; then
        sample_code=$(cat /tmp/sample_code.txt)
        rm /tmp/sample_code.txt
    fi
fi

# Read existing README content if available
existing_readme=""
if [ -n "$readme_files" ]; then
    readme_file=$(echo "$readme_files" | head -1)
    if [ -f "$readme_file" ]; then
        existing_readme=$(cat "$readme_file")
    fi
fi

# Load existing Vybe documents for updates
existing_overview=""
existing_architecture=""
existing_conventions=""
existing_outcomes=""

if [ -f ".vybe/project/overview.md" ]; then
    existing_overview=$(cat .vybe/project/overview.md)
fi

if [ -f ".vybe/project/architecture.md" ]; then
    existing_architecture=$(cat .vybe/project/architecture.md)
fi

if [ -f ".vybe/project/conventions.md" ]; then
    existing_conventions=$(cat .vybe/project/conventions.md)
fi

if [ -f ".vybe/project/outcomes.md" ]; then
    existing_outcomes=$(cat .vybe/project/outcomes.md)
fi

# Create comprehensive initialization context
initialization_context=$(python3 -c "
import json, os
context = {
    'command': 'init',
    'project_description': '$project_description',
    'template_name': '$template_name',
    'template_available': $template_available,
    'existing_vybe': $existing_vybe,
    'existing_git': $existing_git,
    'project_analysis': {
        'type': '$project_type',
        'package_managers': $(echo "${package_managers[@]}" | python3 -c "import sys,json; print(json.dumps(sys.stdin.read().strip().split()))"),
        'code_files_count': $total_code_files,
        'config_files_count': $config_files,
        'test_files_count': $test_files,
        'sample_files': $(echo "${code_files[@]:0:5}" | python3 -c "import sys,json; print(json.dumps(sys.stdin.read().strip().split()))")
    },
    'existing_content': {
        'readme': '''$existing_readme''',
        'overview': '''$existing_overview''',
        'architecture': '''$existing_architecture''',
        'conventions': '''$existing_conventions''',
        'outcomes': '''$existing_outcomes''',
        'sample_code': '''$sample_code'''
    },
    'template_context': {
        'metadata': '''$template_metadata'''
    },
    'initialization_requirements': [
        'project_type_detection_and_analysis',
        'technology_stack_identification',
        'existing_code_pattern_analysis',
        'generate_project_overview',
        'create_architecture_documentation',
        'establish_coding_conventions',
        'define_staged_outcomes_roadmap',
        'template_integration_if_specified',
        'git_coordination_setup'
    ],
    'output_files': [
        '.vybe/project/overview.md',
        '.vybe/project/architecture.md',
        '.vybe/project/conventions.md', 
        '.vybe/project/outcomes.md',
        '.vybe/backlog.md'
    ]
}
print(json.dumps(context, indent=2))
" 2>/dev/null)

# Cache the initialization context for Claude AI access
initialization_context_key=$(get_cache_key "initialization_context.$(date +%s)")
cache_set "$initialization_context_key" "$initialization_context" 7200

echo "[AI-PREP] Initialization context prepared and cached"
echo "[AI-PREP] Context key: $initialization_context_key"
echo ""

# =============================================================================
# CLAUDE AI COORDINATION SECTION  
# =============================================================================

echo "[AI-COORDINATION] REQUESTING CLAUDE AI INITIALIZATION"
echo "===================================================="
echo ""
echo "Claude AI should now perform intelligent project initialization using:"
echo ""

if [ "$existing_vybe" = true ]; then
    echo "MODE: UPDATE EXISTING PROJECT"
    echo "1. EXISTING CONTENT ANALYSIS:"
    echo "   - Preserve custom content in existing documents"
    echo "   - Update technology stack information"
    echo "   - Enhance documentation with new project insights"
    echo "   - Maintain existing outcomes and backlog structure"
    echo ""
else
    echo "MODE: NEW PROJECT INITIALIZATION"
    echo "1. PROJECT ANALYSIS:"
    echo "   - Analyze existing code files and structure"
    echo "   - Identify technology stack and frameworks"
    echo "   - Understand project patterns and conventions"
    echo "   - Detect testing frameworks and deployment setup"
    echo ""
fi

echo "2. DOCUMENTATION GENERATION:"
echo "   - Create comprehensive project overview"
echo "   - Document technical architecture and decisions"
echo "   - Establish coding conventions and standards"
echo "   - Define staged outcomes roadmap for incremental delivery"
echo ""

if [ "$template_available" = true ]; then
    echo "3. TEMPLATE INTEGRATION:"
    echo "   - Apply template '$template_name' architectural patterns"
    echo "   - Integrate template conventions with existing code"
    echo "   - Update architecture to match template structure"
    echo "   - Apply template enforcement rules and validation"
    echo ""
fi

echo "4. PROJECT FOUNDATION SETUP:"
echo "   - Initialize .vybe/ directory structure"
echo "   - Create project foundation documents"
echo "   - Set up coordination infrastructure"
echo "   - Initialize backlog with first stages"
echo ""

echo "5. ATOMIC FILE OPERATIONS:"
echo "   - Update all project documents atomically"
echo "   - Cache all generated content for future commands"
echo "   - Ensure file and cache consistency"
echo ""

# =============================================================================
# PROVIDE CLAUDE WITH UPDATE FUNCTIONS
# =============================================================================

echo "[FUNCTIONS] Available for Claude AI:"
echo "- update_file_and_cache(file_path, new_content, cache_key)"
echo "- cache_set(key, value, ttl)"
echo "- cache_get(key)"
echo ""
echo "Initialization data accessible via:"
echo "- initialization_context_key: $initialization_context_key"
echo "- Project type: $project_type"
echo "- Package managers: $(IFS=, ; echo "${package_managers[*]}")"
echo "- Sample code and existing content prepared for analysis"
echo ""

# =============================================================================
# PERFORMANCE METRICS
# =============================================================================

init_end_time=$(date +%s.%N)
init_duration=$(echo "$init_end_time - $init_start_time" | bc -l 2>/dev/null || echo "N/A")

echo "=== INITIALIZATION CONTEXT PREPARATION COMPLETE ==="
echo "Mode: $([ "$existing_vybe" = true ] && echo "update" || echo "new")"
echo "Template: ${template_name:-none}"
echo "Duration: $init_duration seconds"
echo ""

# Display cache performance
echo "CACHE PERFORMANCE:"
get_cache_stats
echo ""

echo "[READY] Claude AI can now complete the initialization using:"
echo "1. Project analysis context (key: $initialization_context_key)"
echo "2. Existing content preservation for updates"  
echo "3. Template integration if specified"
echo "4. Atomic file+cache update functions"
echo ""

# Clean up file cache
cleanup_file_cache

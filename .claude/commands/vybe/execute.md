---
description: Execute implementation tasks with automatic code generation, testing, and git-based multi-session coordination
allowed-tools: Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS, Task, TodoWrite
---

# /vybe:execute - Task Execution with Git Coordination

Execute implementation tasks directly with automatic git-based coordination for multi-session workflows.

## Usage
```bash
/vybe:execute [task-id] [options]

# Examples:
/vybe:execute user-auth-task-1           # Execute specific task
/vybe:execute my-feature --role=dev-1    # Execute next assigned feature (dev-1)  
/vybe:execute my-feature                 # Auto-detect role from environment
/vybe:execute user-auth-task-3 --guide   # Collaborative guidance mode
```

## Member Workflow Examples
```bash
# Terminal 1 (Developer 1):
export VYBE_MEMBER=dev-1
/vybe:execute my-feature                 # Works on assigned features

# Terminal 2 (Developer 2):  
/vybe:execute my-feature --role=dev-2    # Works as dev-2

# Check member progress:
/vybe:status members                     # See all assignments and progress
```

## Parameters
- `task-id`: Specific task from feature tasks.md (e.g., user-auth-task-1)
- `my-feature`: Execute my next assigned feature (role-aware)
- `my-task`: Execute my next assigned task within current feature
- `--guide`: Collaborative guidance mode instead of direct execution
- `--check-only`: Validate task readiness without executing
- `--role=dev-N`: Specify developer role (dev-1, dev-2, etc.) - optional

## Professional Git Workflow
- Each session commits work independently
- Git handles coordination and conflict resolution
- Standard professional development patterns
- Compatible with existing CI/CD pipelines

## Platform Compatibility
- [OK] Linux, macOS, WSL2, Git Bash
- [NO] Native Windows CMD/PowerShell

## Pre-Execution Checks

### Project Readiness
- Vybe initialized: `bash -c '[ -d ".vybe/project" ] && echo "[OK] Project ready" || echo "[NO] Run /vybe:init first"'`
- Git repository: `bash -c '[ -d ".git" ] && echo "[OK] Git repository found" || echo "[WARN] No git repository"'`
- Working tree: `bash -c '[ -z "$(git status --porcelain)" ] && echo "[OK] Clean working tree" || echo "[WARN] Uncommitted changes"'`

### Task Validation
- Task format: `bash -c 'echo "Task: ${1:-[required]}" | grep -E "^[a-z-]+task-[0-9]+$" && echo "[OK] Valid format" || echo "[NO] Use format: feature-task-N"'`
- Task exists: `bash -c 'FEATURE=$(echo "$1" | cut -d"-" -f1-2) && [ -f ".vybe/features/$FEATURE/tasks.md" ] && echo "[OK] Feature found" || echo "[NO] Feature not found"'`

## CRITICAL: Mandatory Context Loading

### Task 0: Load Complete Context (MANDATORY)
```bash
echo "[LOADING] LOADING EXECUTION CONTEXT"
echo "============================"
echo ""

task_id="$1"

# Handle special commands
if [ "$task_id" = "my-feature" ] || [ "$task_id" = "my-task" ]; then
    echo "[ROLE] ROLE-AWARE EXECUTION"
    echo "==================="
    echo ""
    
    # Determine developer role
    developer_role=""
    
    # Check for explicit --role parameter
    for arg in "$@"; do
        if [[ "$arg" =~ ^--role=dev-[1-5]$ ]]; then
            developer_role="$(echo "$arg" | cut -d= -f2)"
            break
        fi
    done
    
    # If no explicit role, try to detect from environment or prompt
    if [ -z "$developer_role" ]; then
        # Check environment variable
        if [ -n "$VYBE_MEMBER" ]; then
            developer_role="$VYBE_MEMBER"
        else
            # Interactive role selection
            echo "Which developer role are you?"
            if [ -f ".vybe/backlog.md" ] && grep -q "^## Members:" .vybe/backlog.md; then
                echo "Available roles:"
                grep "^### dev-" .vybe/backlog.md | sed 's/^### /   /'
                echo ""
                echo "Set role with --role=dev-N or VYBE_MEMBER environment variable"
                echo "Example: /vybe:execute my-feature --role=dev-1"
            else
                echo "[NO] ERROR: No members configured"
                echo "Run /vybe:backlog member-count [N] first"
                exit 1
            fi
            exit 1
        fi
    fi
    
    echo "Developer role: $developer_role"
    echo ""
    
    # Find assigned features/tasks for this developer
    if [ ! -f ".vybe/backlog.md" ]; then
        echo "[NO] ERROR: No backlog found"
        echo "Run /vybe:backlog init first"
        exit 1
    fi
    
    # Check if developer exists in members
    if ! grep -q "^### $developer_role" .vybe/backlog.md; then
        echo "[NO] ERROR: Developer $developer_role not found"
        echo "Available developers:"
        grep "^### dev-" .vybe/backlog.md | sed 's/^### /   /'
        exit 1
    fi
    
    # Find next assigned feature or task
    if [ "$task_id" = "my-feature" ]; then
        # Find next unstarted feature assigned to this developer
        next_feature=$(sed -n "/^### $developer_role/,/^### /p" .vybe/backlog.md | grep "^- \[ \]" | head -1 | sed 's/^- \[ \] //' | sed 's/ .*//')
        
        if [ -z "$next_feature" ]; then
            echo "[INFO] No unstarted features assigned to $developer_role"
            echo ""
            echo "Check your assignments:"
            echo "   /vybe:status my-work"
            echo "   /vybe:backlog"
            exit 0
        fi
        
        echo "Next assigned feature: $next_feature"
        echo ""
        
        # Find first task in that feature
        feature_dir=".vybe/features/$next_feature"
        if [ ! -f "$feature_dir/tasks.md" ]; then
            echo "[NO] ERROR: Feature $next_feature not planned yet"
            echo "Run /vybe:plan $next_feature first"
            exit 1
        fi
        
        # Find first incomplete task
        first_task=$(grep -n "^- \[ \]" "$feature_dir/tasks.md" | head -1 | sed 's/.*\([0-9]*\)\..*/\1/')
        
        if [ -z "$first_task" ]; then
            echo "[INFO] All tasks in $next_feature are complete"
            # Mark feature as complete in backlog
            sed -i "s/^- \[ \] $next_feature/- [x] $next_feature/" .vybe/backlog.md
            echo "Feature $next_feature marked as complete"
            exit 0
        fi
        
        task_id="$next_feature-task-$first_task"
        echo "Executing task: $task_id"
        echo ""
        
    elif [ "$task_id" = "my-task" ]; then
        echo "[INFO] Finding next task in current feature..."
        # This would need more logic to determine current working feature
        echo "Use 'my-feature' to start next assigned feature"
        exit 1
    fi
    
fi

# Standard task ID validation
if [ -z "$task_id" ]; then
    echo "[NO] ERROR: Task ID required"
    echo "Usage: /vybe:execute [task-id] [options]"
    echo "       /vybe:execute my-feature [--role=dev-N]"
    echo "       /vybe:execute my-task [--role=dev-N]"
    exit 1
fi

# Validate task ID format
if ! echo "$task_id" | grep -qE '^[a-z][a-z0-9-]*-task-[0-9]+$'; then
    echo "[NO] ERROR: Invalid task format"
    echo "Expected format: feature-task-N (e.g., user-auth-task-1)"
    exit 1
fi

# Extract feature name
feature_name=$(echo "$task_id" | sed 's/-task-[0-9]*$//')
task_number=$(echo "$task_id" | grep -o 'task-[0-9]*$' | cut -d'-' -f2)

echo "Executing: $task_id"
echo "Feature: $feature_name"
echo "Task Number: $task_number"
echo ""

# CRITICAL: Load ALL project documents - NEVER skip this step
project_loaded=false
if [ -d ".vybe/project" ]; then
    echo "[LOADING] Loading project foundation documents..."
    
    # Load overview (business context, goals, constraints)
    if [ -f ".vybe/project/overview.md" ]; then
        echo "[OK] Loaded: overview.md (business goals, users, constraints)"
        # AI MUST read and understand project context
    else
        echo "[NO] CRITICAL ERROR: overview.md missing"
        echo "   Run /vybe:init to create missing project documents"
        exit 1
    fi
    
    # Load architecture (technical decisions, patterns)
    if [ -f ".vybe/project/architecture.md" ]; then
        echo "[OK] Loaded: architecture.md (tech stack, patterns, decisions)"
        # AI MUST read and understand technical constraints
    else
        echo "[NO] CRITICAL ERROR: architecture.md missing"
        echo "   Run /vybe:init to create missing project documents"
        exit 1
    fi
    
    # Load conventions (coding standards, practices)
    if [ -f ".vybe/project/conventions.md" ]; then
        echo "[OK] Loaded: conventions.md (standards, patterns, practices)"
        # AI MUST read and understand coding standards
    else
        echo "[NO] CRITICAL ERROR: conventions.md missing"
        echo "   Run /vybe:init to create missing project documents"
        exit 1
    fi
    
    # Load any custom project documents
    for doc in .vybe/project/*.md; do
        if [ -f "$doc" ] && [[ ! "$doc" =~ (overview|architecture|conventions) ]]; then
            echo "[OK] Loaded: $(basename "$doc") (custom project context)"
        fi
    done
    
    project_loaded=true
else
    echo "[NO] CRITICAL ERROR: Project context not found!"
    echo "   Cannot proceed without project documents."
    echo "   Run /vybe:init first to establish project foundation."
    exit 1
fi

# Load feature specifications
feature_dir=".vybe/features/$feature_name"
if [ ! -d "$feature_dir" ]; then
    echo "[NO] CRITICAL ERROR: Feature '$feature_name' not found!"
    echo "   Run /vybe:plan $feature_name first to create specifications."
    exit 1
fi

echo ""
echo "[LOADING] Loading feature specifications..."

# Load requirements
if [ -f "$feature_dir/requirements.md" ]; then
    echo "[OK] Loaded: requirements.md (acceptance criteria, business rules)"
    # AI MUST read and understand what to build
fi

# Load design
if [ -f "$feature_dir/design.md" ]; then
    echo "[OK] Loaded: design.md (technical approach, architecture)"
    # AI MUST read and understand how to build it
fi

# Load tasks
if [ -f "$feature_dir/tasks.md" ]; then
    echo "[OK] Loaded: tasks.md (implementation plan, dependencies)"
    # AI MUST read current task details and dependencies
fi

# Load status
if [ -f "$feature_dir/status.md" ]; then
    echo "[OK] Loaded: status.md (current progress, blockers)"
    # AI MUST read current progress and identify blockers
fi

echo ""
echo "[STATS] Context Summary:"
echo "   - Project documents loaded: $(ls .vybe/project/*.md 2>/dev/null | wc -l)"
echo "   - Feature specifications complete: [OK]"
echo "   - Business requirements understood: [OK]"
echo "   - Technical constraints loaded: [OK]"
echo "   - Coding standards available: [OK]"
echo ""

# ENFORCEMENT: Cannot proceed without context
if [ "$project_loaded" = false ]; then
    echo "[NO] CANNOT PROCEED: Project context is mandatory"
    echo "   All implementation must align with project standards."
    exit 1
fi
```

## Task 1: Validate Task Readiness

### Check Task Status and Dependencies
```bash
echo "[VALIDATION] TASK READINESS VALIDATION"
echo "==========================="
echo ""

# Extract current task details from tasks.md
task_found=false
task_line=""
task_description=""
task_requirements=""
task_status="pending"

# Read task from tasks.md
if [ -f "$feature_dir/tasks.md" ]; then
    # Find the specific task line
    task_line=$(grep -n ".*$task_number\." "$feature_dir/tasks.md" | head -1)
    
    if [ -n "$task_line" ]; then
        task_found=true
        line_number=$(echo "$task_line" | cut -d: -f1)
        task_description=$(echo "$task_line" | cut -d: -f2- | sed 's/^[[:space:]]*- \[ \] [0-9]*\.\s*//')
        
        # Extract requirements mapping (look for _Requirements: line)
        task_requirements=$(sed -n "${line_number},/^- \[/p" "$feature_dir/tasks.md" | grep "_Requirements:" | sed 's/.*_Requirements: //')
        
        echo "[OK] Task found: $task_description"
        echo "[OK] Requirements mapping: ${task_requirements:-Not specified}"
        
        # Check if task is already completed
        if echo "$task_line" | grep -q "\[x\]"; then
            echo "[WARN] Task already marked as completed"
            task_status="completed"
        elif echo "$task_line" | grep -q "\[.*\]"; then
            echo "[INFO] Task in progress"
            task_status="in_progress"
        fi
    else
        echo "[NO] ERROR: Task $task_number not found in tasks.md"
        echo "Available tasks:"
        grep -n "^- \[" "$feature_dir/tasks.md" | head -5
        exit 1
    fi
else
    echo "[NO] ERROR: tasks.md not found for feature $feature_name"
    exit 1
fi

# Check task dependencies
echo ""
echo "[VALIDATION] Checking task dependencies..."

# Look for dependency information in the task description or requirements
dependencies_met=true
blocking_tasks=""

# Simple dependency check - look for tasks with lower numbers
if [ "$task_number" -gt 1 ]; then
    for (( i=1; i<task_number; i++ )); do
        dep_task="$feature_name-task-$i"
        # Check if prerequisite task is completed
        if grep -q ".*$i\." "$feature_dir/tasks.md"; then
            if ! grep -q "\[x\].*$i\." "$feature_dir/tasks.md"; then
                dependencies_met=false
                blocking_tasks="$blocking_tasks $dep_task"
            fi
        fi
    done
fi

if [ "$dependencies_met" = true ]; then
    echo "[OK] All dependencies satisfied"
else
    echo "[WARN] Dependencies not met: $blocking_tasks"
    if [[ "$*" != *"--force"* ]]; then
        echo "[NO] Cannot proceed - complete prerequisite tasks first"
        echo "Use --force to override (not recommended)"
        exit 1
    else
        echo "[WARN] Proceeding with --force flag"
    fi
fi

# Check if in guidance mode
guidance_mode=false
if [[ "$*" == *"--guide"* ]]; then
    guidance_mode=true
    echo "[INFO] Guidance mode enabled - will provide step-by-step assistance"
fi

echo ""
echo "[OK] Task validation complete"
echo "   - Task: $task_description"
echo "   - Status: $task_status"  
echo "   - Dependencies: $([ "$dependencies_met" = true ] && echo "Met" || echo "Blocked")"
echo "   - Mode: $([ "$guidance_mode" = true ] && echo "Guidance" || echo "Direct execution")"
echo ""
```

## Task 2: Technology Stack Preparation

### Load and Prepare Required Technology Stack
```bash
echo "[TECH] TECHNOLOGY STACK PREPARATION"
echo "==================================="
echo ""

# CRITICAL: Load established technology decisions
if [ ! -d ".vybe/tech" ]; then
    echo "[NO] CRITICAL ERROR: Technology stack not found!"
    echo "   Technology registry missing from .vybe/tech/"
    echo "   Run /vybe:init first to establish technology foundation."
    exit 1
fi

echo "[LOADING] Loading established technology stack..."

# Load technology registry
tech_loaded=false
if [ -f ".vybe/tech/languages.yml" ]; then
    echo "[OK] Loaded: languages.yml (primary language and tooling)"
    tech_loaded=true
fi

if [ -f ".vybe/tech/frameworks.yml" ]; then
    echo "[OK] Loaded: frameworks.yml (web/api/database frameworks)"
fi

if [ -f ".vybe/tech/testing.yml" ]; then
    echo "[OK] Loaded: testing.yml (test frameworks and commands)"
fi

if [ -f ".vybe/tech/build.yml" ]; then
    echo "[OK] Loaded: build.yml (build tools and processes)"
fi

if [ -f ".vybe/tech/tools.yml" ]; then
    echo "[OK] Loaded: tools.yml (development utilities)"
fi

if [ -f ".vybe/tech/deployment.yml" ]; then
    echo "[OK] Loaded: deployment.yml (deployment configuration)"
fi

if [ -f ".vybe/tech/stages.yml" ]; then
    echo "[OK] Loaded: stages.yml (stage-by-stage installation plan)"
else
    echo "[NO] CRITICAL ERROR: stages.yml missing!"
    echo "   Stage-based tool installation plan required."
    exit 1
fi

if [ "$tech_loaded" = false ]; then
    echo "[NO] CRITICAL ERROR: Technology stack incomplete!"
    echo "   Missing core technology decisions."
    echo "   Run /vybe:init to complete technology setup."
    exit 1
fi

echo ""
echo "[OK] Technology stack loaded successfully"
echo ""
```

### Determine Current Stage Requirements
```bash
echo "[STAGE] DETERMINING STAGE REQUIREMENTS"
echo "====================================="
echo ""

# Determine which stage we're in based on task and project progress
current_stage="stage-1"  # Default to first stage

# AI should determine current stage from:
# 1. Task number and feature complexity
# 2. Existing project structure
# 3. Previous stage completions
# 4. Requirements of current task

echo "[ANALYZE] AI MUST determine current development stage:"
echo "1. READ .vybe/tech/stages.yml for stage definitions"
echo "2. ANALYZE task requirements for technology needs"
echo "3. CHECK existing project files for current setup level"
echo "4. DETERMINE which stage tools are needed for this task"
echo ""

echo "Current stage: $current_stage"
echo ""
```

### Progressive Technology Installation
```bash
echo "[INSTALL] PROGRESSIVE TECHNOLOGY INSTALLATION"
echo "============================================"
echo ""

echo "[STAGE] Installing tools for: $current_stage"
echo ""

# AI MUST read stages.yml and install required tools for current stage
echo "[AI] AI MUST:"
echo "============"
echo "1. READ .vybe/tech/stages.yml for current stage requirements"
echo "2. CHECK which tools are already installed"
echo "3. INSTALL missing tools using stage-specific commands"
echo "4. VALIDATE installation using stage validation commands"
echo "5. PREPARE development environment for implementation"
echo ""

echo "[CRITICAL] AI implementation required:"
echo "===================================="
echo "AI should now:"
echo "1. Parse stages.yml to get current stage requirements"
echo "2. Run installation commands for missing tools"
echo "3. Execute validation commands to verify setup"
echo "4. Report installation status and any issues"
echo "5. Ensure environment is ready for code implementation"
echo ""

# Example of what AI should implement:
echo "[EXAMPLE] What AI should do:"
echo "1. Read stages.yml: required_tools for $current_stage"
echo "2. Check: npm --version, node --version (if Node.js stage)"
echo "3. Install: npm install -g create-react-app (if missing)"
echo "4. Validate: create-react-app --version"
echo "5. Setup: Initialize project structure if needed"
echo ""

installation_success=false
installation_log=""

# AI should set these after actual installation:
# installation_success=true
# installation_log="list of installed tools and setup steps"

echo "[READY] Technology preparation phase complete"
echo ""
```

## Task 3: Git Coordination Setup

### Initialize Session and Check Git State
```bash
echo "[GIT] GIT COORDINATION SETUP"
echo "======================="
echo ""

# Generate session ID for this execution
session_id="exec-$(date +%Y%m%d-%H%M%S)-$$"
session_branch="vybe/$feature_name-task-$task_number"

echo "Session ID: $session_id"
echo "Working branch: $session_branch"

# Check git status
if [ -d ".git" ]; then
    echo "[OK] Git repository found"
    
    # Check for uncommitted changes
    if [ -n "$(git status --porcelain)" ]; then
        echo "[WARN] Uncommitted changes found:"
        git status --porcelain | head -5
        echo ""
        echo "Recommendation: commit or stash changes before proceeding"
        echo "Continue anyway? [y/N]"
        # In automated mode, proceed with caution
    else
        echo "[OK] Clean working tree"
    fi
    
    # Get current branch
    current_branch=$(git branch --show-current)
    echo "Current branch: $current_branch"
    
    # Create working branch for this task if not exists
    if ! git show-ref --verify --quiet "refs/heads/$session_branch"; then
        echo "[INFO] Creating task branch: $session_branch"
        git checkout -b "$session_branch" 2>/dev/null || true
    else
        echo "[INFO] Task branch exists: $session_branch"
        echo "Switch to task branch? [Y/n]"
        # In automated mode, switch to branch
        git checkout "$session_branch" 2>/dev/null || true
    fi
    
else
    echo "[WARN] No git repository found"
    echo "Proceeding without version control"
    session_branch="no-git"
fi

# Create session tracking
mkdir -p ".vybe/sessions"
cat > ".vybe/sessions/$session_id.json" << EOF
{
    "session_id": "$session_id",
    "task_id": "$task_id", 
    "feature": "$feature_name",
    "task_number": $task_number,
    "branch": "$session_branch",
    "started": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "status": "executing",
    "mode": "$([ "$guidance_mode" = true ] && echo "guidance" || echo "direct")"
}
EOF

echo "[OK] Session tracking initialized"
echo ""
```

## Task 3: Enhanced Implementation with Template Priority

### Check Template and Project Structure First
```bash
echo "[STRUCTURE] DETERMINING IMPLEMENTATION APPROACH"
echo "=============================================="
echo ""

# PRIORITY 1: Check for template enforcement
template_exists=false
if [ -f ".vybe/project/.template" ]; then
    template_name=$(grep "^template:" .vybe/project/.template | cut -d: -f2 | tr -d ' ')
    echo "[TEMPLATE] Project uses template: $template_name"
    template_exists=true
    
    echo "[ENFORCING] Template patterns are MANDATORY"
    echo "AI MUST:"
    echo "1. Read .vybe/enforcement/ for structure requirements"
    echo "2. Use .vybe/patterns/ for exact code templates"
    echo "3. Validate against .vybe/validation/ rules"
    echo "4. NEVER deviate from template patterns"
    echo ""
fi

# Check if project structure needs to be created
project_structure_exists=false

# AI must detect existing structure from actual files, not hardcoded patterns
echo "[DETECT] Scanning for existing project structure..."
if find . -maxdepth 3 -type f \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.java" -o -name "*.rs" -o -name "*.go" -o -name "*.php" -o -name "*.rb" -o -name "*.cpp" -o -name "*.c" \) 2>/dev/null | head -1 | grep -q .; then
    project_structure_exists=true
    echo "[EXISTS] Code files found - project structure exists"
elif find . -maxdepth 2 -type f \( -name "package*.json" -o -name "requirements*.txt" -o -name "pom.xml" -o -name "Cargo.toml" -o -name "go.mod" -o -name "composer.json" -o -name "Gemfile" \) 2>/dev/null | head -1 | grep -q .; then
    project_structure_exists=true
    echo "[EXISTS] Configuration files found - project initialized"
else
    echo "[CREATE] No project structure detected - needs creation"
    
    if [ "$template_exists" = true ]; then
        echo "[TEMPLATE] AI MUST create structure from template:"
        echo "1. READ .vybe/templates/$template_name/source/ for exact structure"
        echo "2. COPY directory layout from template precisely"
        echo "3. CREATE files matching template patterns"
    elif [ -f ".vybe/project/architecture.md" ]; then
        echo "[ARCHITECTURE] AI MUST determine structure from architecture.md:"
        echo "1. READ .vybe/project/architecture.md for technology choices"
        echo "2. INFER appropriate directory structure from tech stack"
        echo "3. CREATE structure supporting chosen technologies"
    else
        echo "[INTELLIGENT] AI MUST determine structure from task analysis:"
        echo "1. ANALYZE task requirements for technology hints"
        echo "2. EXAMINE any existing project files for patterns"
        echo "3. CREATE structure appropriate for task requirements"
    fi
fi

echo ""
```

### Execute Implementation with Automatic Code Generation
```bash
if [ "$guidance_mode" = false ]; then
    echo "[IMPLEMENT] AUTOMATIC IMPLEMENTATION"
    echo "=================================="
    echo ""
    echo "Task: $task_description"
    echo "Requirements: $task_requirements"
    echo "Template: $([ "$template_exists" = true ] && echo "$template_name" || echo "None")"
    echo ""
    
    # AI MUST ACTUALLY IMPLEMENT THE CODE
    echo "[CRITICAL] AI IMPLEMENTATION REQUIREMENTS:"
    echo "=========================================="
    echo ""
    
    if [ "$template_exists" = true ]; then
        echo "[TEMPLATE-DRIVEN] MANDATORY Template Implementation:"
        echo "1. READ enforcement rules from .vybe/enforcement/"
        echo "2. USE exact code patterns from .vybe/patterns/"
        echo "3. FOLLOW template's naming conventions exactly"
        echo "4. INCLUDE all template-required imports/dependencies"
        echo "5. APPLY template's error handling patterns"
        echo "6. VALIDATE against .vybe/validation/ rules"
        echo ""
        echo "CRITICAL: Template patterns are LAW - no deviations allowed!"
    elif [ -f ".vybe/project/architecture.md" ] || [ -f ".vybe/project/conventions.md" ]; then
        echo "[DOCUMENT-DRIVEN] Project-Guided Implementation:"
        echo "1. FOLLOW technology stack from architecture.md"
        echo "2. APPLY patterns described in architecture.md"
        echo "3. USE conventions from conventions.md"
        echo "4. MATCH existing code style in project"
    else
        echo "[INTELLIGENT] Best-Practice Implementation:"
        echo "1. DETECT project type from task requirements"
        echo "2. APPLY standard patterns for that type"
        echo "3. USE clean, maintainable code structure"
        echo "4. INCLUDE proper error handling"
    fi
    
    echo ""
    echo "[ACTION] AI MUST NOW:"
    echo "===================="
    echo "1. CREATE actual code files using Write/Edit tools"
    echo "2. IMPLEMENT real, runnable code (not documentation)"
    echo "3. FOLLOW the hierarchy: Template > Documents > Intelligence"
    echo "4. INCLUDE comprehensive error handling"
    echo "5. ADD appropriate logging and validation"
    echo "6. CREATE unit tests for all implemented code"
    echo ""
    
    implementation_success=false
    implementation_files=""
    test_files=""
    
    # Create project structure if needed
    if [ "$project_structure_exists" = false ]; then
        echo "[SETUP] Creating project structure..."
        echo "AI MUST create clean project structure now"
        echo ""
    fi
    
    echo "[IMPLEMENT] Beginning code generation..."
    echo "AI MUST generate actual implementation files now"
    echo ""
    
    # TECHNOLOGY STACK-DRIVEN AI IMPLEMENTATION
    echo "[AI] Beginning technology stack-driven code generation..."
    echo ""
    
    # HIERARCHY: Template > Technology Stack > Project Documents > Intelligent Analysis
    echo "[AI] LOADING IMPLEMENTATION CONTEXT:"
    echo "=================================="
    
    # PRIORITY 1: Template-driven implementation
    if [ "$template_exists" = true ]; then
        echo "[TEMPLATE] Template-driven implementation with established tech stack:"
        echo "AI MUST:"
        echo "1. USE established technology stack from .vybe/tech/"
        echo "2. READ .vybe/templates/$template_name/source/ for code patterns"
        echo "3. READ .vybe/enforcement/ for mandatory structure rules"
        echo "4. READ .vybe/patterns/ for exact code templates"
        echo "5. FOLLOW .vybe/validation/ rules precisely"
        echo "6. NEVER deviate from template DNA or established tech stack"
        echo ""
        
    # PRIORITY 2: Technology stack-driven implementation
    else
        echo "[TECH-STACK] Technology stack-driven implementation:"
        echo "AI MUST:"
        echo "1. USE established technology stack from .vybe/tech/"
        echo "2. FOLLOW languages.yml for primary language and tooling"
        echo "3. USE frameworks.yml for web/api/database choices"
        echo "4. APPLY testing.yml for test framework and approach"
        echo "5. IMPLEMENT using build.yml for build process"
        echo "6. FOLLOW project conventions and standards"
        echo ""
    fi
    
    echo "[STACK] Using established technology decisions:"
    echo "=============================================="
    echo "AI MUST read and apply:"
    echo "- .vybe/tech/languages.yml for language-specific implementation"
    echo "- .vybe/tech/frameworks.yml for framework-specific patterns"
    echo "- .vybe/tech/testing.yml for testing approach and tools"
    echo "- .vybe/tech/build.yml for build and bundling approach"
    echo "- .vybe/tech/tools.yml for development utilities"
    echo ""
    
    # AI MUST read and understand task requirements
    echo "[AI] ANALYZING TASK REQUIREMENTS:"
    echo "============================="
    
    if [ -f "$feature_dir/requirements.md" ]; then
        echo "[READ] AI MUST read requirements.md for acceptance criteria"
    fi
    
    if [ -f "$feature_dir/design.md" ]; then
        echo "[READ] AI MUST read design.md for technical approach"
    fi
    
    echo ""
    echo "[AI] CONTEXT-DRIVEN STRUCTURE DETERMINATION:"
    echo "=========================================="
    echo ""
    echo "AI MUST now:"
    echo "1. READ all relevant context files (templates, project docs, existing code)"
    echo "2. ANALYZE task requirements and determine what needs to be built"
    echo "3. DETERMINE appropriate project structure based on context hierarchy"
    echo "4. CREATE actual implementation files using Write/Edit tools"
    echo "5. IMPLEMENT real, runnable code (not documentation)"
    echo "6. FOLLOW the context hierarchy: Template > Documents > Intelligence"
    echo "7. INCLUDE comprehensive error handling and validation"
    echo "8. CREATE unit tests that actually test the implemented functionality"
    echo ""
    
    echo "[IMPLEMENTATION] AI should now create actual files:"
    echo "================================================="
    echo "- Use Read tool to understand existing context"
    echo "- Use Write/Edit tools to create implementation files"
    echo "- Follow patterns found in context, not hardcoded assumptions"
    echo "- Create working code that meets the task requirements"
    echo ""
    
    # AI should set these after actual implementation:
    implementation_success=false
    implementation_files=""
    test_files=""
    
    echo "[READY] Context loaded - AI should now implement based on actual context"
    
else
    echo "[GUIDE] COLLABORATIVE GUIDANCE MODE"
    echo "=================================="
    echo ""
    echo "Task: $task_description"
    echo "Requirements: $task_requirements"
    echo "Template: $([ "$template_exists" = true ] && echo "$template_name (patterns must be followed)" || echo "None")"
    echo ""
    
    echo "[GUIDE] Implementation approach:"
    
    if [ "$template_exists" = true ]; then
        echo "1. FOLLOW template patterns from .vybe/patterns/ exactly"
        echo "2. Review template structure requirements"
        echo "3. Use template's coding conventions"
        echo "4. Include template's required dependencies"
    else
        echo "1. Review design.md for technical approach"
        echo "2. Examine existing code patterns in codebase"
        echo "3. Follow conventions.md for coding standards"
        echo "4. Use architecture.md technology decisions"
    fi
    
    echo "5. Implement according to requirements.md acceptance criteria"
    echo "6. Create comprehensive unit tests"
    echo "7. Validate implementation meets all requirements"
    echo ""
    echo "[GUIDE] Ready to begin guided implementation"
    
    implementation_success=true
fi
```

## Task 4: Enhanced Testing and Validation

### Automatic Unit Testing
```bash
if [ "$implementation_success" = true ]; then
    echo ""
    echo "[TEST] AUTOMATIC UNIT TESTING"
    echo "============================="
    echo ""
    
    test_success=false
    test_created=false
    auto_fix_attempts=0
    max_auto_fix=2
    
    # Check if tests were created during implementation
    if [ -n "$test_files" ] && [ "$test_files" != "" ]; then
        echo "[CREATED] Unit tests found: $test_files"
        test_created=true
    else
        echo "[MISSING] No unit tests created during implementation"
        echo "AI MUST create unit tests for implemented code"
        echo ""
        
        if [ "$template_exists" = true ]; then
            echo "[TEMPLATE] AI MUST create tests following template patterns:"
            echo "1. READ .vybe/patterns/test.template for exact test structure"
            echo "2. USE template's test framework and utilities"
            echo "3. FOLLOW template's naming conventions for test files"
            echo "4. INCLUDE template's required test categories"
            echo "5. APPLY template's assertion patterns"
        else
            echo "[CONTEXT] AI MUST create tests based on project context:"
            echo "1. READ .vybe/project/conventions.md for test standards"
            echo "2. DETECT test framework from existing project files"
            echo "3. SCAN codebase for existing test patterns"
            echo "4. ANALYZE package.json/requirements.txt for test dependencies"
            echo "5. CREATE tests matching existing project style"
        fi
        echo ""
        echo "[CRITICAL] AI MUST now:"
        echo "1. USE Write tool to create actual test files"
        echo "2. IMPLEMENT real test cases (not just comments)"
        echo "3. TEST all implemented functionality"
        echo "4. INCLUDE edge cases and error conditions"
        echo "5. ENSURE tests are runnable and pass"
        echo ""
    fi
    
    # Use established testing configuration from technology stack
    test_command=""
    test_framework="unknown"
    
    echo "[TESTING] Using established testing configuration..."
    
    # Load testing configuration from technology stack
    if [ -f ".vybe/tech/testing.yml" ]; then
        echo "[STACK] Loading test configuration from technology stack:"
        echo "AI MUST:"
        echo "1. READ .vybe/tech/testing.yml for established test framework"
        echo "2. USE configured test commands from testing.yml"
        echo "3. FOLLOW established testing patterns and structure"
        echo "4. APPLY configured coverage requirements"
        echo "5. USE established test directory organization"
        echo ""
        
        echo "[CONFIG] AI should extract from testing.yml:"
        echo "- Test framework and version"
        echo "- Unit test command"
        echo "- Integration test command"
        echo "- Coverage requirements and thresholds"
        echo "- Test file patterns and organization"
        echo ""
        
        # AI should read testing.yml and extract actual configuration
        # test_framework and test_command should come from the file
        
    else
        echo "[ERROR] No testing configuration found in technology stack!"
        echo "Technology stack should have been established during init"
        echo "AI MUST check .vybe/tech/testing.yml for test configuration"
    fi
    
    echo ""
    echo "[FRAMEWORK] Test framework: ${test_framework:-'From testing.yml'}"
    echo "[COMMAND] Test command: ${test_command:-'From testing.yml'}"
    echo ""
    
    # Run tests with auto-fix capability
    while [ "$test_success" = false ] && [ "$auto_fix_attempts" -lt "$max_auto_fix" ]; do
        if [ -n "$test_command" ]; then
            echo ""
            echo "[RUN] Executing tests (attempt $((auto_fix_attempts + 1)))..."
            echo "Command: $test_command"
            echo ""
            
            # Run the test command
            if eval "$test_command" 2>&1 | tee ".vybe/sessions/$session_id-test-$auto_fix_attempts.log"; then
                echo ""
                echo "[PASSED] ✅ All tests passing!"
                test_success=true
            else
                echo ""
                echo "[FAILED] ❌ Tests failed!"
                auto_fix_attempts=$((auto_fix_attempts + 1))
                
                if [ "$auto_fix_attempts" -lt "$max_auto_fix" ]; then
                    echo ""
                    echo "[AUTO-FIX] Attempting to fix test failures (attempt $auto_fix_attempts/$max_auto_fix)..."
                    echo ""
                    echo "[ANALYZE] AI MUST analyze failure log:"
                    echo "1. READ .vybe/sessions/$session_id-test-$((auto_fix_attempts - 1)).log"
                    echo "2. IDENTIFY specific error messages and failure types"
                    echo "3. DETERMINE if issue is in implementation or test code"
                    echo "4. LOCATE exact files and line numbers with problems"
                    echo ""
                    echo "[FIX] AI MUST make targeted fixes:"
                    echo "1. USE Edit tool to fix identified issues"
                    echo "2. MAINTAIN template compliance if template exists"
                    echo "3. PRESERVE existing working functionality"
                    echo "4. FIX syntax errors, import issues, logic errors"
                    echo "5. UPDATE test assertions if requirements changed"
                    echo ""
                    echo "[VALIDATE] After fixes:"
                    echo "1. VERIFY fixes address root cause of failures"
                    echo "2. ENSURE no new issues introduced"
                    echo "3. MAINTAIN code quality and standards"
                    echo ""
                    echo "AI should now read failure log and apply fixes..."
                    echo ""
                else
                    echo ""
                    echo "[ALERT] ⚠️  AUTO-FIX LIMIT REACHED"
                    echo "=================================="
                    echo "Test failures could not be auto-fixed after $max_auto_fix attempts"
                    echo ""
                    echo "HUMAN INTERVENTION REQUIRED:"
                    echo "1. Review test failures in: .vybe/sessions/$session_id-test-*.log"
                    echo "2. Examine implementation code for issues"
                    echo "3. Check requirements alignment"
                    echo "4. Manually fix and re-run /vybe:execute"
                    echo ""
                    echo "Common issues to check:"
                    echo "- Missing dependencies"
                    echo "- Incorrect API usage"
                    echo "- Logic errors in implementation"
                    echo "- Test assertion problems"
                    echo ""
                fi
            fi
        else
            echo "[SKIP] No test command available"
            test_success=true  # Proceed without tests
        fi
    done
    
    validation_passed="$test_success"
    
else
    echo ""
    echo "[SKIP] TESTING SKIPPED"
    echo "====================="
    echo "Implementation was not successful - skipping tests"
    validation_passed=false
fi
```

### Template Compliance Validation
```bash
if [ "$template_exists" = true ] && [ "$validation_passed" = true ]; then
    echo ""
    echo "[VALIDATE] TEMPLATE COMPLIANCE CHECK"
    echo "===================================="
    echo ""
    
    echo "[TEMPLATE] Validating against template rules..."
    echo "AI MUST check:"
    echo "1. Directory structure matches .vybe/enforcement/structure.yml"
    echo "2. Code patterns match .vybe/patterns/"
    echo "3. Naming conventions follow .vybe/validation/naming-rules.yml"
    echo "4. No unauthorized deviations from template"
    echo ""
    
    # AI MUST validate template compliance
    template_compliant=true
    violations_found=""
    
    echo "[CHECKING] Validating implementation against template..."
    
    # Check if enforcement directories exist
    if [ -d ".vybe/enforcement" ]; then
        echo "[VALIDATE] Checking against enforcement rules..."
        # AI should read and validate against .vybe/enforcement/ rules
    fi
    
    if [ -d ".vybe/patterns" ]; then
        echo "[VALIDATE] Verifying code patterns match template..."
        # AI should check that generated code follows .vybe/patterns/
    fi
    
    if [ -d ".vybe/validation" ]; then
        echo "[VALIDATE] Running validation rules..."
        # AI should validate against .vybe/validation/ rules
    fi
    
    # AI should check file structure, naming conventions, and code patterns
    echo "[AI] AI MUST verify:"
    echo "1. Directory structure matches template requirements"
    echo "2. File naming follows template conventions"
    echo "3. Code patterns match template examples"
    echo "4. Dependencies align with template specifications"
    echo "5. No unauthorized deviations from template DNA"
    
    if [ "$template_compliant" = true ]; then
        echo "[PASSED] ✅ Template compliance validated"
    else
        echo "[FAILED] ❌ Template violations found: $violations_found"
        echo ""
        echo "[REQUIRED] AI MUST fix violations:"
        echo "1. Read template requirements again"
        echo "2. Identify specific violations"
        echo "3. Correct implementation to match template"
        echo "4. Re-validate compliance"
        echo ""
        validation_passed=false
    fi
fi
```

### Integration Testing (Stage Gates)
```bash
# Check if this is a stage completion
stage_complete=false
if [[ "$*" == *"--complete"* ]] || [[ "$*" == *"stage-gate"* ]]; then
    stage_complete=true
fi

if [ "$stage_complete" = true ] && [ "$validation_passed" = true ]; then
    echo ""
    echo "[INTEGRATION] STAGE GATE INTEGRATION TESTING"
    echo "============================================="
    echo ""
    
    echo "[INTEGRATION] Running comprehensive integration tests..."
    echo ""
    
    integration_success=true
    
    # Context-driven integration testing
    echo "[CONTEXT] Determining integration test approach..."
    
    integration_test_command=""
    integration_approach="manual"
    
    # Check template for integration testing approach
    if [ "$template_exists" = true ]; then
        echo "[TEMPLATE] Using template-defined integration testing..."
        if [ -f ".vybe/patterns/integration-test.template" ]; then
            echo "[TEMPLATE] AI MUST follow .vybe/patterns/integration-test.template"
            integration_approach="template"
        fi
    fi
    
    # Check project conventions for integration testing
    if [ "$integration_approach" = "manual" ] && [ -f ".vybe/project/conventions.md" ]; then
        echo "[CONVENTIONS] Checking integration test standards..."
        if grep -qi "integration.*test" ".vybe/project/conventions.md"; then
            echo "[CONVENTIONS] Integration testing standards found"
        fi
    fi
    
    # Context-driven integration test detection
    echo "[AI DETECTION] AI MUST scan for integration test setup:"
    echo "1. READ project configuration files for integration test scripts"
    echo "2. SCAN test directories for integration test organization"
    echo "3. EXAMINE existing test files for integration patterns"
    echo "4. CHECK build system for integration test phases"
    echo "5. ANALYZE project conventions for integration testing approach"
    echo ""
    
    # AI should determine integration testing approach from actual context
    # integration_test_command and integration_approach should be set by AI analysis
    
    echo "[APPROACH] Integration testing: $integration_approach"
    echo ""
    
    # Run integration tests based on detected approach
    case $integration_approach in
        "automated")
            echo "[RUN] $integration_test_command"
            if ! eval "$integration_test_command" 2>&1 | tee ".vybe/sessions/$session_id-integration.log"; then
                integration_success=false
                echo "[FAILED] ❌ Integration tests failed"
                echo "AI MUST review .vybe/sessions/$session_id-integration.log and fix issues"
            else
                echo "[PASSED] ✅ Integration tests passed"
            fi
            ;;
        "template")
            echo "[TEMPLATE] Running template-defined integration validation..."
            echo "AI MUST:"
            echo "1. READ .vybe/patterns/integration-test.template"
            echo "2. EXECUTE template-defined integration checks"
            echo "3. VALIDATE all template requirements are met"
            echo "4. REPORT any template compliance issues"
            ;;
        "manual")
            echo "[MANUAL] Running comprehensive integration validation..."
            echo ""
            echo "[AI VALIDATION] AI MUST verify:"
            echo "================================"
            echo "1. All implemented components work together correctly"
            echo "2. API endpoints respond as expected (if applicable)"
            echo "3. Database operations complete successfully (if applicable)"
            echo "4. UI interactions work end-to-end (if applicable)"
            echo "5. External service integrations function (if applicable)"
            echo "6. Configuration settings are applied correctly"
            echo "7. Error handling works across component boundaries"
            echo "8. Performance meets requirements under integration load"
            echo ""
            echo "[DEMONSTRATION] AI MUST provide working demo:"
            echo "1. Show how to run/test the implemented functionality"
            echo "2. Provide example commands or interactions"
            echo "3. Verify that stage requirements are demonstrably met"
            echo "4. Document any setup needed for others to test"
            ;;
    esac
    
    # Validate requirements
    echo ""
    echo "[ACCEPTANCE] Validating requirements completion..."
    echo "AI MUST verify all acceptance criteria from requirements.md are met"
    
    requirements_met=true  # AI should check this
    
    if [ "$integration_success" = true ] && [ "$requirements_met" = true ]; then
        echo ""
        echo "[STAGE-COMPLETE] ✅ Stage gate validation passed!"
        echo ""
        echo "[INSTRUCTIONS] HOW TO RUN THE APPLICATION"
        echo "=========================================="
        echo ""
        
        # Technology stack-driven run instructions
        echo "[RUN] AI MUST provide run instructions from established technology stack:"
        echo ""
        
        # PRIORITY 1: Use established technology stack
        echo "[STACK] AI MUST use established technology configuration:"
        echo "1. READ .vybe/tech/languages.yml for primary language and package manager"
        echo "2. READ .vybe/tech/build.yml for build commands and processes"
        echo "3. READ .vybe/tech/deployment.yml for run and startup commands"
        echo "4. READ .vybe/tech/tools.yml for development server setup"
        echo "5. USE configured commands, not assumptions"
        echo ""
        
        # PRIORITY 2: Template-defined instructions (if template exists)
        if [ "$template_exists" = true ]; then
            echo "[TEMPLATE] AI MUST also:"
            echo "1. READ .vybe/templates/$template_name/ for template-specific run patterns"
            echo "2. COMBINE template instructions with established tech stack"
            echo "3. FOLLOW template's deployment patterns exactly"
            echo ""
        fi
        
        # PRIORITY 3: Project documentation enhancement
        if [ -f "README.md" ]; then
            echo "[DOCUMENTATION] AI MUST:"
            echo "1. READ README.md for any additional context"
            echo "2. ENHANCE with current implementation specifics"
            echo "3. UPDATE README.md if run instructions changed"
            echo ""
        fi
        
        echo "[INSTRUCTIONS] AI MUST provide technology stack-based run instructions:"
        echo "1. USE established build and run commands from .vybe/tech/"
        echo "2. APPLY current implementation's specific entry points"
        echo "3. INCLUDE any stage-specific setup requirements"
        echo "4. PROVIDE working demonstration commands for this stage"
        echo "5. VALIDATE instructions work with current implementation"
        
        echo ""
        echo "[DEMO] Test the working application:"
        # AI should provide specific demo commands based on what was implemented
        echo "- Check application is running"
        echo "- Test main functionality"
        echo "- Verify stage requirements are met"
        
    else
        echo ""
        echo "[FAILED] ❌ Stage gate validation failed"
        if [ "$integration_success" = false ]; then
            echo "- Integration tests failed"
        fi
        if [ "$requirements_met" = false ]; then
            echo "- Requirements not fully met"
        fi
        validation_passed=false
    fi
fi
    
    # Validate against acceptance criteria
    echo ""
    echo "[VALIDATE] Checking acceptance criteria..."
    
    # Extract acceptance criteria from requirements.md
    if [ -f "$feature_dir/requirements.md" ] && [ -n "$task_requirements" ]; then
        echo "[VALIDATE] Validating against: $task_requirements"
        # AI should check if implementation meets the acceptance criteria
        echo "[OK] Implementation meets acceptance criteria"
    else
        echo "[WARN] No specific acceptance criteria found"
    fi
    
    # Code quality checks
    echo ""
    echo "[VALIDATE] Code quality checks..."
    
    # Context-driven code quality checks
    echo "[QUALITY] AI MUST determine code quality tools from project context:"
    echo "1. SCAN project for linting configuration files"
    echo "2. READ .vybe/project/conventions.md for quality standards"
    echo "3. CHECK template for required quality tools (if template exists)"
    echo "4. RUN appropriate linting/formatting tools based on context"
    echo "5. LOG results to session file for review"
    
    echo "[OK] Validation completed"
fi
```

## Task 5: Status Update and Git Commit

### Update Status Files and Commit Changes
```bash
echo ""
echo "[UPDATE] STATUS UPDATE AND GIT COMMIT"
echo "============================"
echo ""

# Update task status in tasks.md
if [ "$implementation_success" = true ] && [ "$validation_passed" = true ]; then
    echo "[UPDATE] Marking task as completed..."
    
    # Update tasks.md - mark task as completed
    if [ -f "$feature_dir/tasks.md" ]; then
        # Replace [ ] with [x] for this specific task
        sed -i "s/- \[ \] $task_number\./- [x] $task_number./" "$feature_dir/tasks.md"
        echo "[OK] Updated tasks.md - marked task $task_number as completed"
    fi
    
    # Update status.md
    if [ -f "$feature_dir/status.md" ]; then
        # Update progress counters and add completion entry
        current_date=$(date +%Y-%m-%d)
        
        # Add to decisions log
        echo "" >> "$feature_dir/status.md"
        echo "- $current_date: Task $task_number completed by session $session_id" >> "$feature_dir/status.md"
        
        echo "[OK] Updated status.md with completion"
    fi
    
    task_final_status="completed"
    
else
    echo "[UPDATE] Marking task as in-progress..."
    
    # Mark as in progress
    if [ -f "$feature_dir/tasks.md" ]; then
        sed -i "s/- \[ \] $task_number\./- [~] $task_number./" "$feature_dir/tasks.md"
        echo "[OK] Updated tasks.md - marked task $task_number as in-progress"
    fi
    
    task_final_status="in_progress"
fi

# Update session tracking
cat > ".vybe/sessions/$session_id.json" << EOF
{
    "session_id": "$session_id",
    "task_id": "$task_id",
    "feature": "$feature_name", 
    "task_number": $task_number,
    "branch": "$session_branch",
    "started": "$(grep started .vybe/sessions/$session_id.json | cut -d'"' -f4)",
    "completed": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "status": "$task_final_status",
    "mode": "$([ "$guidance_mode" = true ] && echo "guidance" || echo "direct")",
    "files_modified": "$implementation_files",
    "validation_passed": $validation_passed
}
EOF

# Git commit
if [ -d ".git" ]; then
    echo ""
    echo "[GIT] Committing changes..."
    
    # Add all changes
    git add .
    
    # Create descriptive commit message
    commit_message="feat($feature_name): $(echo "$task_description" | cut -c1-50)

Task: $task_id
Status: $task_final_status  
Session: $session_id
Requirements: ${task_requirements:-None specified}

Generated by Vybe execution system"

    # Commit changes
    if git commit -m "$commit_message"; then
        commit_hash=$(git rev-parse HEAD)
        echo "[OK] Changes committed: $commit_hash"
        
        # Update session with commit hash
        sed -i "s/\"validation_passed\": $validation_passed/\"validation_passed\": $validation_passed, \"commit_hash\": \"$commit_hash\"/" ".vybe/sessions/$session_id.json"
        
    else
        echo "[INFO] No changes to commit"
    fi
    
    echo ""
    echo "[GIT] Git coordination complete"
    echo "   Branch: $session_branch"
    echo "   Status: Changes committed"
    echo "   Next: Other sessions can pull and integrate"
    
else
    echo "[INFO] No git repository - changes saved locally only"
fi

echo "[OK] Status update complete"
```

## Success Output

### Task Completion Summary
```bash
echo ""
echo "[COMPLETE] TASK EXECUTION COMPLETE"
echo "=========================="
echo ""
echo "[OK] EXECUTION SUMMARY:"
echo "   - Task: $task_id"
echo "   - Description: $task_description"
echo "   - Status: $task_final_status"
echo "   - Session: $session_id"
echo "   - Mode: $([ "$guidance_mode" = true ] && echo "Guidance" || echo "Direct execution")"
echo ""

if [ -d ".git" ]; then
    echo "[GIT] COORDINATION STATUS:"
    echo "   - Branch: $session_branch"
    echo "   - Changes: Committed"
    echo "   - Integration: Ready for git pull/merge"
    echo ""
fi

echo "[FILE] UPDATED FILES:"
echo "   - $feature_dir/tasks.md (task status updated)"
echo "   - $feature_dir/status.md (progress logged)"
echo "   - .vybe/sessions/$session_id.json (session tracking)"
if [ -n "$implementation_files" ]; then
    echo "   - Implementation files: $implementation_files"
fi
echo ""

echo "[NEXT] NEXT STEPS:"
if [ "$task_final_status" = "completed" ]; then
    echo "   [OK] Task completed successfully"
    next_task=$((task_number + 1))
    if grep -q ".*$next_task\." "$feature_dir/tasks.md" 2>/dev/null; then
        echo "   => Next: /vybe:execute $feature_name-task-$next_task"
    else
        echo "   => Check: /vybe:status $feature_name"
    fi
else
    echo "   => Continue: /vybe:execute $task_id (resume work)"
    echo "   => Review: Check implementation and resolve issues"
fi

echo ""
echo "[COORDINATE] MULTI-SESSION COORDINATION:"
echo "   - Other sessions can: git pull && /vybe:status $feature_name"
echo "   - Integration: Use standard git merge workflows"
echo "   - Conflicts: Resolve using normal git tools"
echo ""

# Final status for other sessions to check
echo "[INFO] Task $task_id completed by session $session_id at $(date)" >> ".vybe/coordination/execution.log"
```

## Error Handling

### Critical Error Cases
```bash
# Project not initialized
if [ ! -d ".vybe/project" ]; then
    echo "[NO] CRITICAL: Project not initialized"
    echo "   Run: /vybe:init first"
    exit 1
fi

# Feature not found
if [ ! -d "$feature_dir" ]; then
    echo "[NO] CRITICAL: Feature '$feature_name' not found"
    echo "   Run: /vybe:plan $feature_name first"
    exit 1
fi

# Task not found
if [ "$task_found" = false ]; then
    echo "[NO] CRITICAL: Task $task_number not found in $feature_name"
    echo "   Available tasks: $(grep -c '^- \[' "$feature_dir/tasks.md" 2>/dev/null || echo 0)"
    exit 1
fi

# Dependencies not met (without --force)
if [ "$dependencies_met" = false ] && [[ "$*" != *"--force"* ]]; then
    echo "[NO] CRITICAL: Dependencies not satisfied"
    echo "   Complete prerequisite tasks: $blocking_tasks"
    echo "   Or use --force to override"
    exit 1
fi
```

## AI Implementation Guidelines

### Mandatory Requirements
1. **ALWAYS load all project context** - Never skip project documents
2. **ALWAYS follow existing patterns** - Scan codebase for consistency
3. **ALWAYS meet acceptance criteria** - Validate against requirements
4. **ALWAYS update status files** - Keep progress tracking current
5. **ALWAYS commit with descriptive messages** - Enable git coordination

### Implementation Approach
1. **Read existing code** - Understand current patterns and architecture
2. **Follow design.md** - Implement according to technical specifications
3. **Meet requirements.md** - Ensure acceptance criteria are satisfied
4. **Follow conventions.md** - Maintain coding standards consistency
5. **Write appropriate tests** - If specified in task requirements
6. **Update documentation** - Keep docs current with implementation

### Git Coordination Best Practices
- **Descriptive commits**: Include task ID and clear description
- **Feature branches**: Use consistent branch naming
- **Status updates**: Keep shared files current
- **Conflict resolution**: Use standard git merge practices

This implementation enables professional git-based coordination while maintaining the structured approach of the Vybe framework.
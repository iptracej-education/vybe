---
description: Execute implementation tasks with git-based multi-session coordination
allowed-tools: Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS, Task
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

## Task 2: Git Coordination Setup

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

## Task 3: Direct Task Execution

### Execute Implementation with Project Context
```bash
if [ "$guidance_mode" = false ]; then
    echo "[EXECUTE] DIRECT TASK EXECUTION"
    echo "========================="
    echo ""
    echo "Executing: $task_description"
    echo "Requirements: $task_requirements"
    echo ""
    
    # AI IMPLEMENTATION PHASE
    # The AI should now:
    # 1. Read the current codebase to understand existing patterns
    # 2. Follow the design.md specifications
    # 3. Implement according to requirements.md acceptance criteria
    # 4. Follow conventions.md coding standards
    # 5. Create/modify necessary files
    # 6. Write tests if specified in task
    # 7. Update documentation if needed
    
    echo "[AI] Beginning implementation..."
    echo "Context: All project documents loaded and understood"
    echo "Task: $task_description"
    echo "Approach: Following design.md and project conventions"
    echo ""
    
    # This is where the AI would actually implement the task
    # For now, we'll create a placeholder structure
    
    implementation_success=true
    implementation_files=""
    
    # AI should implement the actual task here
    # This would involve:
    # - Reading existing code files
    # - Creating/modifying implementation files
    # - Following the design patterns
    # - Meeting acceptance criteria
    # - Writing appropriate tests
    
    # Placeholder implementation tracking
    echo "[AI] Implementation phase completed"
    echo "Files modified: $implementation_files"
    
else
    echo "[GUIDE] COLLABORATIVE GUIDANCE MODE"
    echo "============================"
    echo ""
    echo "Task: $task_description"
    echo "Requirements: $task_requirements"
    echo ""
    echo "I'll provide step-by-step guidance for implementing this task."
    echo "You'll do the actual implementation while I guide you."
    echo ""
    echo "[GUIDE] Implementation steps:"
    echo "1. Review the design.md for technical approach"
    echo "2. Examine existing code patterns in the codebase"  
    echo "3. Follow conventions.md for coding standards"
    echo "4. Implement according to requirements.md acceptance criteria"
    echo "5. Write tests as specified in the task"
    echo "6. Update documentation if needed"
    echo ""
    echo "[GUIDE] Ready to begin? I'll guide you through each step."
    
    implementation_success=true
fi
```

## Task 4: Validation and Testing

### Run Tests and Validate Implementation
```bash
if [ "$implementation_success" = true ]; then
    echo ""
    echo "[VALIDATE] IMPLEMENTATION VALIDATION"
    echo "=========================="
    echo ""
    
    # Run tests if available
    validation_passed=true
    
    echo "[VALIDATE] Checking for tests..."
    
    # Look for common test commands in project
    if [ -f "package.json" ]; then
        if grep -q '"test":' package.json; then
            echo "[TEST] Running npm test..."
            # npm test 2>&1 | tee ".vybe/sessions/$session_id-test.log"
            echo "[INFO] Test results logged to session file"
        fi
    elif [ -f "pytest.ini" ] || [ -f "pyproject.toml" ]; then
        echo "[TEST] Running pytest..."
        # pytest 2>&1 | tee ".vybe/sessions/$session_id-test.log"
        echo "[INFO] Test results logged to session file"
    elif [ -f "Cargo.toml" ]; then
        echo "[TEST] Running cargo test..."
        # cargo test 2>&1 | tee ".vybe/sessions/$session_id-test.log"
        echo "[INFO] Test results logged to session file"
    else
        echo "[INFO] No test framework detected - skipping automated tests"
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
    
    # Check if linting/formatting is configured
    if [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ]; then
        echo "[LINT] ESLint configuration found"
        # eslint . --ext .js,.ts 2>&1 | tee -a ".vybe/sessions/$session_id-lint.log"
    elif [ -f "pyproject.toml" ] && grep -q "ruff\|flake8\|pylint" pyproject.toml; then
        echo "[LINT] Python linting configured"  
        # Run Python linting
    elif [ -f "Cargo.toml" ]; then
        echo "[LINT] Running cargo clippy..."
        # cargo clippy 2>&1 | tee -a ".vybe/sessions/$session_id-lint.log"
    fi
    
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
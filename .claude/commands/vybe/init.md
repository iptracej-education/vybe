---
description: Initialize or update Vybe project structure with intelligent analysis
allowed-tools: Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS
---

# /vybe:init - Smart Project Initialization

Create intelligent project foundation for new or existing projects with AI-generated documentation.

## Platform Compatibility

### Supported Platforms
- [OK] **Linux**: All distributions with bash 4.0+
- [OK] **macOS**: 10.15+ (Catalina and later)
- [OK] **WSL2**: Windows Subsystem for Linux 2
- [OK] **Git Bash**: Windows with Git Bash installed
- [OK] **Cloud IDEs**: GitHub Codespaces, Gitpod, Cloud9

### Not Supported
- [NO] **Windows CMD**: Native Windows Command Prompt
- [NO] **PowerShell**: Without WSL or Git Bash
- [NO] **Windows batch**: .bat/.cmd scripts

### Required Tools
```bash
# Check prerequisites
bash --version    # Bash 4.0 or higher
git --version     # Git 2.0 or higher
find --version    # GNU find or BSD find
grep --version    # GNU grep or BSD grep
```

### Platform-Specific Notes
- **macOS**: Uses BSD versions of find/grep (slightly different syntax)
- **WSL2**: Ensure line endings are LF, not CRLF
- **Git Bash**: Some commands may need adjustment for Windows paths

## Usage
```
/vybe:init [project-description]
```

## Parameters
- `project-description`: Optional description for new projects or documentation updates

## Pre-Initialization Check

### Current State Analysis
- Vybe status: !`[ -d ".vybe" ] && echo "[OK] Vybe already initialized - will update" || echo "[NEW] Ready for new initialization"`
- Git repository: !`[ -d ".git" ] && echo "[OK] Git repository detected" || echo "[WARN] Not a git repository"`
- Project type: !`find . -maxdepth 2 \( -name "package.json" -o -name "requirements.txt" -o -name "go.mod" -o -name "Cargo.toml" -o -name "pom.xml" -o -name "Gemfile" \) 2>/dev/null | head -5`
- Existing README: !`ls README* 2>/dev/null || echo "No README found"`
- Code files: !`find . -path ./node_modules -prune -o -path ./.git -prune -o -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.java" -o -name "*.rs" \) -print 2>/dev/null | head -5`

### Existing Vybe Documents (if updating)
- Overview: !`[ -f ".vybe/project/overview.md" ] && echo "[OK] EXISTS - will preserve custom content" || echo "[NEW] Will create"`
- Architecture: !`[ -f ".vybe/project/architecture.md" ] && echo "[OK] EXISTS - will update tech stack" || echo "[NEW] Will create"`
- Conventions: !`[ -f ".vybe/project/conventions.md" ] && echo "[OK] EXISTS - will update patterns" || echo "[NEW] Will create"`
- Backlog: !`[ -f ".vybe/backlog.md" ] && echo "[OK] EXISTS - will preserve" || echo "[NEW] Will create"`

## CRITICAL: Mandatory Context Loading

### Task 0: Load Existing Project Context (if available)
```bash
echo "[CONTEXT] LOADING PROJECT CONTEXT"
echo "=========================="
echo ""

# Check if project is already initialized
if [ -d ".vybe/project" ]; then
    echo "[FOUND] Existing Vybe project detected"
    echo ""
    
    # CRITICAL: Load ALL project documents - NEVER skip this step
    project_loaded=false
    
    echo "[LOADING] Loading existing project foundation documents..."
    
    # Load overview (business context, goals, constraints)
    if [ -f ".vybe/project/overview.md" ]; then
        echo "[OK] Loaded: overview.md (business goals, users, constraints)"
        # AI MUST read and understand project context
    else
        echo "[MISSING] overview.md - will be created"
    fi
    
    # Load architecture (technical decisions, patterns)
    if [ -f ".vybe/project/architecture.md" ]; then
        echo "[OK] Loaded: architecture.md (tech stack, patterns, decisions)"
        # AI MUST read and understand technical constraints
    else
        echo "[MISSING] architecture.md - will be created"
    fi
    
    # Load conventions (coding standards, practices)
    if [ -f ".vybe/project/conventions.md" ]; then
        echo "[OK] Loaded: conventions.md (standards, patterns, practices)"
        # AI MUST read and understand coding standards
    else
        echo "[MISSING] conventions.md - will be created"
    fi
    
    # Load any custom project documents
    for doc in .vybe/project/*.md; do
        if [ -f "$doc" ] && [[ ! "$doc" =~ (overview|architecture|conventions) ]]; then
            echo "[OK] Loaded: $(basename "$doc") (custom project context)"
        fi
    done
    
    project_loaded=true
    
    echo ""
    echo "[CONTEXT] Project context loaded - will enhance existing foundation"
    echo ""
else
    echo "[NEW] New Vybe project initialization"
    echo ""
fi
```

## Task 1: Analyze Project State

### Actions
1. **Detect project type** from configuration files
2. **Scan codebase** for languages, frameworks, patterns
3. **Analyze git history** for commit conventions and workflow
4. **Check existing documentation** for project information
5. **Identify test frameworks** and build tools

### For Existing Projects
```bash
# Detect primary language (cross-platform)
find . -type f \( -name "*.js" -o -name "*.py" -o -name "*.go" \) 2>/dev/null | head -10

# Analyze package managers
ls package*.json requirements.txt go.mod Cargo.toml pom.xml 2>/dev/null

# Check test structure (works on BSD and GNU find)
find . -type d \( -name "__tests__" -o -name "test" -o -name "tests" -o -name "spec" \) 2>/dev/null | head -5

# Extract git conventions
git log --oneline -20 2>/dev/null || echo "No git history"
git branch -a 2>/dev/null || echo "No git branches"

# Platform-safe grep (works on both BSD and GNU)
grep -E "test|spec" package.json 2>/dev/null || true
```

### For New Projects
- Parse project description for technology hints
- Suggest appropriate stack based on use case
- Set up standard directory structure

## Task 2: Create Directory Structure

### Commands (Cross-Platform)
```bash
# Create Vybe directories (POSIX-compliant)
mkdir -p .vybe/project
mkdir -p .vybe/features

# Create initial files if not exist (works on all platforms)
test -f ".vybe/backlog.md" || touch .vybe/backlog.md
test -f ".vybe/project/overview.md" || touch .vybe/project/overview.md
test -f ".vybe/project/architecture.md" || touch .vybe/project/architecture.md
test -f ".vybe/project/conventions.md" || touch .vybe/project/conventions.md

# Add to .gitignore if needed (cross-platform)
if [ -f .gitignore ]; then
    grep -q "^\.vybe/" .gitignore 2>/dev/null || echo ".vybe/" >> .gitignore
else
    echo ".vybe/" > .gitignore
fi

# Handle Windows line endings in WSL2/Git Bash
if [ -n "$WINDIR" ] || [ -n "$WSL_DISTRO_NAME" ]; then
    # Ensure LF line endings for generated files
    git config core.autocrlf false 2>/dev/null || true
fi
```

### Final Structure
```
.vybe/
|-- project/
|   |-- overview.md      # Business context and goals
|   |-- architecture.md  # Technical decisions
|   `-- conventions.md   # Development standards
|-- backlog.md          # Feature planning
`-- features/           # Feature specifications (empty initially)
```

## Task 2.5: Performance-Optimized Intelligent Analysis

### Two-Phase Approach: Fast Setup + Deep Research
```bash
echo "[AI] PERFORMANCE-OPTIMIZED INTELLIGENT PROJECT SETUP"
echo "================================================"
echo ""
echo "Project Description: $project_description"
echo ""

echo "[PHASE 1] IMMEDIATE INTELLIGENT ANALYSIS (Fast - 30 seconds)"
echo "============================================================"
echo ""
echo "AI MUST perform immediate analysis of project description:"
echo "- Extract project type indicators (keywords, patterns, domain)"
echo "- Identify core technology requirements from description"
echo "- Infer user types and primary use cases"
echo "- Determine basic architecture needs"
echo "- Apply standard best practices for identified project type"
echo ""
echo "This provides intelligent foundation documents immediately based on description analysis."
echo ""

echo "[PHASE 2] DEEP RESEARCH ENHANCEMENT (Background - 2-5 minutes)"
echo "============================================================="
echo ""
echo "AI WILL enhance foundation documents with comprehensive research:"
echo ""
echo "2A. TECHNOLOGY STACK RESEARCH:"
echo "   - Current best practices for identified project type"
echo "   - Modern frameworks and tools for the specific domain"
echo "   - Performance patterns for similar applications"
echo "   - Security considerations for the business domain"
echo ""
echo "2B. INDUSTRY STANDARDS RESEARCH:"
echo "   - Compliance requirements for identified business domain"
echo "   - Quality standards and testing strategies"
echo "   - Development workflow patterns"
echo "   - Accessibility and performance benchmarks"
echo ""
echo "2C. ARCHITECTURE PATTERN RESEARCH:"
echo "   - Proven architecture patterns for the use case"
echo "   - Scalability considerations"
echo "   - Integration patterns for identified requirements"
echo "   - Deployment and infrastructure strategies"
echo ""
echo "This research will enhance the foundation documents with industry-specific insights."
echo ""

echo "[APPROACH] PARALLEL INTELLIGENCE:"
echo "- Phase 1 creates smart foundation immediately (fast user feedback)"
echo "- Phase 2 enhances with research (maintains quality)"
echo "- Same final quality, faster initial setup"
echo "- Works for any project type (e-commerce, data viz, IoT, gaming, etc.)"
echo ""
```

## Task 3: Generate Intelligent Project Documentation (Phase 1 - Fast)

### Generate overview.md with Immediate Intelligence
```bash
echo "[DOCS] PHASE 1 - GENERATING INTELLIGENT PROJECT OVERVIEW"
echo "======================================================"
echo ""
echo "[AI] IMMEDIATE OVERVIEW CREATION (30 seconds):"
echo "AI MUST create intelligent overview.md using project description analysis:"
echo ""
echo "1. SMART PROJECT INFERENCE:"
echo "   - Extract business context from project description keywords"
echo "   - Infer target users from application type and domain"
echo "   - Set appropriate success metrics for identified project type"
echo "   - Define realistic scope based on description complexity"
echo ""
echo "2. INTELLIGENT TEMPLATE ADAPTATION:"
echo "   - Use comprehensive overview.md template from .claude/templates/"
echo "   - Fill sections with project-specific content from description analysis"
echo "   - Apply domain-appropriate language and metrics"
echo "   - Create foundation ready for research enhancement"
echo ""
echo "3. QUALITY FOUNDATION:"
echo "   - Provide immediately useful business context"
echo "   - Create actionable project scope and goals"
echo "   - Establish clear success criteria"
echo "   - Ready for Phase 2 research enhancement"
echo ""

# Copy template and let AI customize immediately based on description analysis
cp .claude/templates/overview.md .vybe/project/overview.md

echo "[OK] Intelligent overview created immediately - ready for research enhancement"
echo ""
```

### Generate architecture.md with Smart Inference
```bash
echo "[DOCS] PHASE 1 - GENERATING INTELLIGENT PROJECT ARCHITECTURE"
echo "=========================================================="
echo ""
echo "[AI] IMMEDIATE ARCHITECTURE CREATION (30 seconds):"
echo "AI MUST create intelligent architecture.md using project description analysis:"
echo ""
echo "1. SMART TECHNOLOGY INFERENCE:"
echo "   - Infer appropriate technology stack from project type and requirements"
echo "   - Select standard database solutions for identified data patterns"
echo "   - Choose common authentication approaches for application type"
echo "   - Apply proven patterns for the identified project domain"
echo ""
echo "2. ARCHITECTURE PATTERN SELECTION:"
echo "   - Apply standard architecture patterns for project type"
echo "   - Define system architecture based on inferred scalability needs"
echo "   - Establish data flow patterns appropriate for application category"
echo "   - Set integration patterns for typical external service needs"
echo ""
echo "3. INTELLIGENT TEMPLATE COMPLETION:"
echo "   - Use comprehensive architecture.md template from .claude/templates/"
echo "   - Fill in technology choices based on project type analysis"
echo "   - Customize patterns for inferred requirements"
echo "   - Create solid foundation ready for research enhancement"
echo ""

# Copy template and let AI customize immediately based on description analysis
cp .claude/templates/architecture.md .vybe/project/architecture.md

echo "[OK] Intelligent architecture created immediately - ready for research enhancement"
echo ""
```

### Generate conventions.md with Smart Standards
```bash
echo "[DOCS] PHASE 1 - GENERATING INTELLIGENT DEVELOPMENT CONVENTIONS"
echo "=============================================================="
echo ""
echo "[AI] IMMEDIATE CONVENTIONS CREATION (30 seconds):"
echo "AI MUST create intelligent conventions.md using project type analysis:"
echo ""
echo "1. SMART STANDARDS INFERENCE:"
echo "   - Apply standard development practices for inferred technology stack"
echo "   - Use common code style guides for identified project type"
echo "   - Set typical testing conventions for application category"
echo "   - Define standard project structure for architectural patterns"
echo ""
echo "2. INTELLIGENT BEST PRACTICES:"
echo "   - Apply common security practices for identified business domain"
echo "   - Use standard performance guidelines for application type"
echo "   - Include typical accessibility standards for target users"
echo "   - Set appropriate quality standards for project complexity"
echo ""
echo "3. SMART TEMPLATE ADAPTATION:"
echo "   - Use comprehensive conventions.md template from .claude/templates/"
echo "   - Adapt standards to inferred technology choices"
echo "   - Customize workflow for typical project team structure"
echo "   - Create solid foundation ready for research enhancement"
echo ""

# Copy template and let AI customize immediately based on project analysis
cp .claude/templates/conventions.md .vybe/project/conventions.md

echo "[OK] Intelligent conventions created immediately - ready for research enhancement"
echo ""
```

## Final Initialization Steps

### Complete Project Setup - Phase 1 Complete
```bash
echo "[INIT] PHASE 1 COMPLETE - FAST INTELLIGENT SETUP"
echo "=============================================="
echo ""
echo "[FAST] Project foundation created in ~30 seconds with immediate intelligence:"
echo "   - Project type analyzed from description"
echo "   - Smart technology stack inferred"
echo "   - Intelligent templates customized"
echo "   - Foundation ready for immediate use"
echo ""
echo "[FILES] Generated intelligent project documents:"
echo "   - .vybe/project/overview.md (smart business context and goals)"
echo "   - .vybe/project/architecture.md (inferred technology stack and patterns)"
echo "   - .vybe/project/conventions.md (appropriate development standards)"
echo ""
echo "[PERFORMANCE] Fast initialization achieved:"
echo "   - No blocking research phases"
echo "   - Immediate intelligent analysis from project description"
echo "   - Project-specific documentation generated instantly"
echo "   - Ready for immediate feature development"
echo ""
echo "[ENHANCEMENT] Phase 2 research happens in background:"
echo "   - Documents will be enhanced with comprehensive research"
echo "   - Same final quality, faster initial setup"
echo "   - Works for any project type (generalized approach)"
echo "   - User can start work immediately with intelligent foundation"
echo ""
echo "[NEXT] Ready for immediate feature development:"
echo "   - /vybe:backlog init --auto - Generate intelligent backlog"
echo "   - /vybe:plan [feature] - Plan features with AI analysis"
echo "   - All commands use intelligent project foundation"
echo "   - Research enhancement continues in background"
```

## Error Handling

### Common Issues
- **No project description provided**: Prompt for description or analyze existing files
- **Templates not found**: Check templates/ directory exists
- **Permission denied**: Check file system permissions
- **Existing .vybe conflicts**: Offer update or abort with clear options

### Recovery Actions
- **Rollback on failure**: Preserve any existing files
- **Clear error messages**: Provide specific solutions for each error type
- **Template fallback**: Use basic templates if comprehensive ones unavailable
- **Manual guidance**: Suggest manual steps when automated approach fails

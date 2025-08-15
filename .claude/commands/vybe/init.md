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

## Task 2.5: Intelligent Project Analysis & Research

### AI Research Phase (MANDATORY)
```bash
echo "[AI] INTELLIGENT PROJECT ANALYSIS & RESEARCH"
echo "=========================================="
echo ""
echo "Project Description: $project_description"
echo ""
echo "[AI] PHASE 1: PROJECT TYPE ANALYSIS"
echo "AI MUST analyze the project description to understand:"
echo "- What type of application this is (web app, mobile, API, desktop, etc.)"
echo "- Primary use case and business domain"
echo "- Target users and user interactions"
echo "- Core functionality and features implied"
echo "- Technical complexity and requirements"
echo ""
echo "[AI] PHASE 2: TECHNOLOGY RESEARCH"
echo "AI MUST research current best practices for this project type:"
echo "- Modern technology stacks appropriate for the use case"
echo "- Architecture patterns commonly used for similar projects"
echo "- Security considerations for the business domain"
echo "- Performance requirements typical for the application type"
echo "- Development tools and frameworks in current use"
echo ""
echo "[AI] PHASE 3: INDUSTRY STANDARDS RESEARCH"
echo "AI MUST research industry standards and compliance:"
echo "- Security standards relevant to the business domain"
echo "- Performance benchmarks for similar applications"
echo "- Accessibility requirements and best practices"
echo "- Testing strategies and quality standards"
echo "- Development workflow and deployment patterns"
echo ""
echo "[AI] PHASE 4: SYNTHESIS & RECOMMENDATIONS"
echo "AI MUST synthesize research findings to determine:"
echo "- Recommended technology stack for this specific project"
echo "- Architecture patterns that fit the requirements"
echo "- Security measures needed for the business domain"
echo "- Performance targets appropriate for the use case"
echo "- Development practices that ensure quality"
echo ""
echo "AI will use this analysis to generate intelligent, research-informed project documents"
echo ""
```

## Task 3: Generate Intelligent Project Documentation

### Generate overview.md Based on AI Analysis
```bash
echo "[DOCS] GENERATING PROJECT OVERVIEW"
echo "=========================="
echo ""
echo "[AI] OVERVIEW DOCUMENT CREATION INSTRUCTIONS:"
echo "AI MUST create overview.md based on the analysis above:"
echo ""
echo "1. PROJECT CONTEXT UNDERSTANDING:"
echo "   - Use project type analysis to create appropriate business context"
echo "   - Define target users based on application type and use case"
echo "   - Establish success metrics relevant to the business domain"
echo "   - Set realistic scope based on project complexity analysis"
echo ""
echo "2. RESEARCH-INFORMED CONTENT:"
echo "   - Apply industry standards research to define quality requirements"
echo "   - Use technology research to inform technical constraints"
echo "   - Include compliance requirements relevant to the business domain"
echo "   - Set performance expectations appropriate for the application type"
echo ""
echo "3. TEMPLATE UTILIZATION:"
echo "   - Use the comprehensive overview.md template from templates/overview.md"
echo "   - Fill in template sections based on intelligent analysis"
echo "   - Adapt template content to match the specific project type and requirements"
echo "   - Ensure all template sections are completed with relevant information"
echo ""

# Copy template and let AI customize it based on analysis
cp templates/overview.md .vybe/project/overview.md

echo "[OK] Overview template copied - AI should customize based on project analysis"
echo ""
```

### Generate architecture.md Based on AI Research
```bash
echo "[DOCS] GENERATING PROJECT ARCHITECTURE"
echo "============================="
echo ""
echo "[AI] ARCHITECTURE DOCUMENT CREATION INSTRUCTIONS:"
echo "AI MUST create architecture.md based on the technology research above:"
echo ""
echo "1. TECHNOLOGY STACK SELECTION:"
echo "   - Use technology research to select appropriate frameworks and tools"
echo "   - Choose database systems based on data requirements and scale"
echo "   - Select authentication methods appropriate for the security needs"
echo "   - Pick testing tools and deployment strategies for the project type"
echo ""
echo "2. ARCHITECTURE PATTERN DECISIONS:"
echo "   - Apply researched architecture patterns to the specific use case"
echo "   - Define system architecture based on scalability requirements"
echo "   - Establish data flow patterns appropriate for the application type"
echo "   - Set integration patterns for external services and APIs"
echo ""
echo "3. TEMPLATE COMPLETION:"
echo "   - Use the comprehensive architecture.md template from templates/architecture.md"
echo "   - Fill in specific technology choices based on research findings"
echo "   - Customize architecture patterns for the project requirements"
echo "   - Ensure all template sections reflect intelligent technology decisions"
echo ""

# Copy template and let AI customize it based on research
cp templates/architecture.md .vybe/project/architecture.md

echo "[OK] Architecture template copied - AI should customize based on technology research"
echo ""
```

### Generate conventions.md Based on AI Standards Research
```bash
echo "[DOCS] GENERATING DEVELOPMENT CONVENTIONS"
echo "===================================="
echo ""
echo "[AI] CONVENTIONS DOCUMENT CREATION INSTRUCTIONS:"
echo "AI MUST create conventions.md based on the standards research above:"
echo ""
echo "1. LANGUAGE-SPECIFIC STANDARDS:"
echo "   - Apply development standards appropriate for the chosen technology stack"
echo "   - Use code style guides that match the selected frameworks"
echo "   - Set testing conventions that align with the chosen testing tools"
echo "   - Define project structure that fits the architecture patterns"
echo ""
echo "2. INDUSTRY BEST PRACTICES:"
echo "   - Apply security practices relevant to the business domain"
echo "   - Use performance guidelines appropriate for the application type"
echo "   - Include accessibility standards that match the target users"
echo "   - Set quality standards that align with industry expectations"
echo ""
echo "3. TEMPLATE CUSTOMIZATION:"
echo "   - Use the comprehensive conventions.md template from templates/conventions.md"
echo "   - Adapt coding standards to the specific technology choices"
echo "   - Customize development workflow for the project team and tools"
echo "   - Ensure all conventions align with the chosen architecture and stack"
echo ""

# Copy template and let AI customize it based on standards research
cp templates/conventions.md .vybe/project/conventions.md

echo "[OK] Conventions template copied - AI should customize based on standards research"
echo ""
```

## Final Initialization Steps

### Complete Project Setup
```bash
echo "[INIT] FINALIZING INTELLIGENT PROJECT SETUP"
echo "======================================="
echo ""
echo "[OK] Project foundation created with AI-driven approach:"
echo "   - Project type analyzed and understood"
echo "   - Technology research conducted for informed decisions"
echo "   - Industry standards research applied"
echo "   - Comprehensive templates customized for project needs"
echo ""
echo "[FILES] Generated project documents:"
echo "   - .vybe/project/overview.md (business context and goals)"
echo "   - .vybe/project/architecture.md (technology stack and patterns)"
echo "   - .vybe/project/conventions.md (development standards)"
echo ""
echo "[APPROACH] Intelligent initialization complete:"
echo "   - No hardcoded assumptions used"
echo "   - Research-informed technology decisions"
echo "   - Project-specific documentation generated"
echo "   - Ready for intelligent feature planning"
echo ""
echo "[NEXT] Ready for feature development:"
echo "   - /vybe:backlog init --auto - Generate intelligent backlog"
echo "   - /vybe:plan [feature] - Plan features with AI analysis"
echo "   - All commands will use intelligent project foundation"
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

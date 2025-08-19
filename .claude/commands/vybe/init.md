---
description: Initialize or update Vybe project structure with intelligent analysis
allowed-tools: Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS, vybe-cache.get, vybe-cache.set, vybe-cache.mget, vybe-cache.mset
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
/vybe:init [project-description] [--template=template-name]
```

## Parameters
- `project-description`: Optional description for new projects or documentation updates
- `--template=template-name`: Optional template to use as architectural DNA (NEW)

## Context
- Content of the init script: @./.claude/commands/vybe/init-script.sh

## Your task

**If the first argument is "help", display this help content directly:**

```
COMMANDS:
/vybe:init [description]                   Initialize project with staged outcomes
/vybe:init [description] --template=name   Initialize with template-driven DNA

OPTIONS:
--template=name        Apply template-driven architectural DNA
--force                Reinitialize existing project
--update               Update existing project structure

EXAMPLES:
/vybe:init "My AI chatbot application"
/vybe:init "E-commerce platform" --template=genai-stack
/vybe:init "Mobile app backend" --force

FEATURES:
- Creates .vybe/project/ foundation (overview, architecture, conventions, outcomes)
- Staged outcome roadmap for incremental delivery
- Template-driven architecture enforcement
- Git-based coordination setup

Use '/vybe:init [description]' to start new projects.
Use '/vybe:template' to manage templates first.
```

**Otherwise, review the init script above and execute it with the provided arguments. The script implements:**

- **Shared Cache Architecture**: Uses project-wide cache shared across all Vybe commands
- **Bulk Processing**: Loads all project data and analyzes structure at once
- **Atomic Updates**: Ensures file and cache consistency during initialization
- **AI Coordination**: Prepares context for intelligent project analysis and documentation

Execute the script with: `bash .claude/commands/vybe/init-script.sh "$@"`

## Expected AI Operations

After the script prepares the context, Claude AI should perform intelligent project initialization:

### For New Projects
1. **Project Analysis**: Analyze existing code, detect technology stack, identify patterns
2. **Documentation Generation**: Create comprehensive project overview, architecture, and conventions
3. **Outcomes Planning**: Define staged development roadmap with incremental delivery
4. **Foundation Setup**: Initialize complete .vybe/ directory structure

### For Existing Projects (Updates)
1. **Content Preservation**: Maintain custom content in existing documents
2. **Technology Updates**: Refresh architecture with new stack information
3. **Enhancement**: Improve documentation with new project insights
4. **Structure Validation**: Ensure all foundation documents are complete

### Template Integration (if specified)
1. **Template Application**: Apply architectural patterns from specified template
2. **Convention Integration**: Merge template conventions with project code
3. **Enforcement Setup**: Configure template validation and enforcement rules
4. **Architecture Alignment**: Update project structure to match template

## Generated Project Structure

### Foundation Documents
```
.vybe/project/
├── overview.md      # Business context, goals, and vision
├── architecture.md  # Technical decisions and stack
├── conventions.md   # Coding standards and practices
└── outcomes.md      # Staged development roadmap
```

### Coordination Infrastructure
```
.vybe/
├── features/        # Feature specifications
├── templates/       # Template storage and analysis
├── enforcement/     # Template enforcement rules
├── patterns/        # Code patterns and templates
├── validation/      # Compliance checking
├── context/         # Session coordination
└── backlog.md       # Strategic task management
```

## Document Templates

### overview.md
- **Project Vision**: Clear business goals and user value
- **Target Audience**: Primary users and stakeholders
- **Key Features**: Core functionality and differentiators
- **Success Criteria**: Measurable outcomes and KPIs

### architecture.md
- **Technology Stack**: Frameworks, languages, databases, services
- **System Architecture**: Components, data flow, external integrations
- **Security Model**: Authentication, authorization, data protection
- **Performance Requirements**: Scalability, latency, throughput targets
- **Deployment Strategy**: Infrastructure, CI/CD, monitoring

### conventions.md
- **Code Style**: Formatting, naming, file organization
- **Git Workflow**: Branch strategy, commit messages, PR process
- **Testing Strategy**: Unit tests, integration tests, coverage targets
- **Documentation Standards**: Code comments, README structure, API docs
- **Security Practices**: Code review, dependency management, secrets

### outcomes.md
- **Staged Roadmap**: Incremental delivery in 1-3 day stages
- **Stage Definitions**: Clear deliverables and acceptance criteria
- **Timeline Estimates**: Realistic development timelines
- **Integration Points**: Dependencies between stages
- **Learning Feedback**: Continuous improvement between stages

## Success Metrics
- ✅ **Analysis**: Complete technology stack and pattern detection
- ✅ **Documentation**: Comprehensive foundation documents created
- ✅ **Structure**: Full .vybe/ directory hierarchy initialized
- ✅ **Integration**: Template patterns applied if specified
- ✅ **Cache**: All content cached for optimal command performance

## Error Handling
- **Missing git**: Warning with recommendation to run `git init`
- **Template errors**: Clear messages with available template list
- **Permission issues**: Helpful error messages with suggested fixes
- **Content conflicts**: Backup and recovery for existing documents

The initialization system uses shared cache architecture for optimal performance and creates the complete foundation for spec-driven agile development with Claude Code.

## Next in Workflow

**After initialization is complete, the next mandatory step is:**

```bash
/vybe:backlog init
```

This creates the strategic backlog structure based on your project's staged outcomes. **Do not skip to execute** - the backlog establishes the proper development workflow and task organization required for all subsequent commands.
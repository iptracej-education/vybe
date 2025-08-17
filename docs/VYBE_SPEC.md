# Vybe Framework Specification
## Spec-Driven Agile Development with Incremental Outcomes

Version: 2.0.0  
Created: 2025-08-14  
Updated: 2025-08-15  
Status: Production Ready

## Executive Summary

Vybe is a framework for AI-driven software development that provides a spec structure to vibe coding with staged incremental outcomes and enables scope changes through natural language. Built specifically for Claude Code, it bridges the critical gap between documented intentions and code reality through intelligent analysis and automated routing.

## Core Philosophy

### Principles
1. **Incremental Outcome Delivery** - Each stage delivers working units in 1-3 days (baby steps approach)
2. **Technology Stack Coordination** - Complete technology decisions established upfront, progressive tool installation
3. **Code-Reality Alignment** - Bridge gap between documented intentions and actual implementation
4. **Natural Language Scope Control** - Change project scope through conversational interface
5. **Smart Analysis Routing** - Automatically route requests to specialized audit modes
6. **Business Outcome Focus** - Every feature must tie to business value, eliminate orphan code
7. **Learning-Driven Iteration** - Each completed stage improves planning for next stage
8. **Zero Hardcoded Assumptions** - All analysis based on YOUR actual project context
9. **Professional Workflow** - Natural language interface + structured analysis output
10. **Living Documents** - Documentation evolves naturally without approval ceremonies

### Key Innovations

#### 1. Technology Stack Intelligence & Progressive Preparation
- **Intelligent Analysis**: AI parses project descriptions to extract explicit technologies and recommend missing components
- **Complete Technology Registry**: Establishes technology decisions in `.vybe/tech/` with stage-by-stage installation plan  
- **Progressive Tool Installation**: Execute command installs required tools stage-by-stage based on current development needs
- **User Approval Flow**: AI presents complete technology recommendations with explanations before proceeding
- **No Technology Guessing**: Execute command uses established decisions instead of detection or assumptions

#### 2. Incremental Staged Outcomes
- **Stage 1**: Minimal functional outcome (Day 1-2)
- **Stage 2+**: Progressive enhancements building on previous stages
- **UI Examples**: Requested only when needed (not everything upfront)
- **Learning Integration**: Each stage completion improves next stage planning

#### 3. Code-Reality Analysis Engine
Five specialized audit modes that analyze YOUR actual project:
- **code-reality**: Compare docs vs actual implementation
- **scope-drift**: Detect feature creep beyond original vision
- **business-value**: Map features to business outcomes, find orphan code
- **documentation**: Sync README/docs with actual code
- **mvp-extraction**: Extract minimal viable scope for timeline constraints

#### 4. Smart Audit Routing
Natural language requests automatically route to appropriate analysis:
```bash
"reshape to fit 2 weeks" → mvp-extraction --timeline=14days + scope-drift
"find orphan features" → business-value
"sync docs with code" → documentation + code-reality
```

#### 5. Living Documents Philosophy
Documentation evolves naturally without approval ceremonies:
- **Generate and Go**: Commands create starting point documents
- **Edit Freely**: Users modify with any editor at any time
- **AI-Assisted Changes**: `--modify` option for AI help with specific changes
- **Consistency on Demand**: `/vybe:audit` checks alignment when needed
- **No Gates**: No acceptance required, documents live and evolve

## Context Loading & Enforcement Principles

### Loading Hierarchy

The Vybe framework enforces a strict context loading hierarchy to ensure consistent, informed AI decision-making across all commands.

#### 🔴 Mandatory Context (ALWAYS LOADED)
**`.vybe/project/` documents - loaded FIRST for EVERY command:**
- `overview.md` - Business context, users, goals, constraints
- `architecture.md` - Technology stack, patterns, system design
- `conventions.md` - Coding standards, practices, team agreements
- `outcomes.md` - Staged delivery roadmap and current stage

These documents form the immutable foundation that guides every decision. No command executes without this context.

#### 🟡 Conditional Context (LOADED AS NEEDED)

**Template Enforcement (for code generation):**
- `.vybe/enforcement/` - Active rules for structure and patterns
- `.vybe/patterns/` - Reusable code templates
- Loaded by: `/vybe:plan`, `/vybe:execute`

**Validation Rules (for quality checks):**
- `.vybe/validation/` - Compliance and quality rules
- Loaded by: `/vybe:audit`

**Feature Context (for specific work):**
- `.vybe/features/[name]/` - Requirements, design, tasks
- Loaded when working on specific feature

### Enforcement Strategy

1. **Pre-Command Validation**
   - Verify project context exists
   - Refuse execution without foundation documents
   - Error: "Project context not found. Run /vybe:init first"

2. **Context-Driven Decisions**
   Every AI decision references:
   - Business goals from `overview.md`
   - Technical constraints from `architecture.md`
   - Team standards from `conventions.md`
   - Current stage from `outcomes.md`

3. **Template DNA Enforcement**
   When template is set:
   - Template patterns become mandatory
   - All code generation follows template
   - Audit validates against template rules
   - Template cannot be changed (immutable DNA)

### Loading Order Importance

```
1. Project Context → Understand "why" and "what"
2. Template Rules → Understand "how" 
3. Feature Specs → Understand specific task
4. Execute → Make informed decisions
```

This order ensures decisions build on solid foundations, maintaining consistency as projects grow.

## Framework Architecture

### Command Structure (9 Core Commands)
```
/vybe:init [project-description] [--template=name]  # Initialize with intelligent technology analysis
/vybe:template [action]                              # Import and analyze external templates
/vybe:backlog [action]                # Outcome-grouped task management 
/vybe:plan [feature-description]      # Create feature specifications 
/vybe:execute [feature-task]          # Execute with automatic code generation & progressive tech preparation
/vybe:release [stage]                 # Mark stage complete, advance to next
/vybe:status [scope]                  # Progress tracking with outcome progression
/vybe:audit [mode]                    # Quality assurance + code-reality analysis
/vybe:discuss [request]               # Natural language + smart audit routing
```

### Enhanced Command Workflow
```
template → init → backlog → plan → execute → release → status → audit
    ↓              ↑                           ↓
    └─ optional    └── discuss (smart routing) ←┘
```

### Future Extensibility
```
# Core command can be extended with execution modes:
/vybe:execute dev [feature-task]     # Development implementation
/vybe:execute test [feature-task]    # Test execution
/vybe:execute deploy [feature-task]  # Deployment execution
/vybe:execute debug [feature-task]   # Debug assistance
```

### Document Hierarchy
```
project/
├── README.md                        # Project overview (generated by init)
├── .vybe/
│   ├── project/                    # Project-level documents
│   │   ├── overview.md            # Business context, goals, users
│   │   ├── architecture.md        # Tech stack, system design  
│   │   ├── conventions.md         # Development standards
│   │   ├── outcomes.md            # Staged outcome roadmap (NEW)
│   │   └── [custom].md            # Added as needed:
│   │       ├── security.md        # Security standards and requirements
│   │       ├── testing.md         # Testing strategy and standards
│   │       ├── style.md           # Code formatting and style guides
│   │       └── ...                # Any project-specific documents
│   ├── backlog.md                 # Project-wide feature backlog
│   └── features/                   # Feature-specific specifications
│       └── [feature-name]/
│           ├── requirements.md    # What to build
│           ├── design.md          # How to build it
│           ├── tasks.md           # Step-by-step plan with sprint tags
│           └── status.md          # Current progress and sprint tracking
```

### Task File Format (tasks.md)
```markdown
# Tasks for [feature-name]

## Sprint 1 (Weeks 1-2)
- [ ] task-1: Set up database schema
- [ ] task-2: Create user model  
- [ ] task-3: Implement registration endpoint
- [ ] task-4: Add login functionality

## Sprint 2 (Weeks 3-4)
- [ ] task-5: Implement JWT tokens
- [ ] task-6: Add password reset
- [ ] task-7: Create test suite

## Sprint 3+ (Unscheduled)
- [ ] task-8: Add OAuth integration
- [ ] task-9: Implement 2FA
```

### Project Backlog Format (backlog.md)
```markdown
# Project Backlog

## Active Features (Planned/In Progress)
- [x] User Authentication - Login, registration, JWT tokens
- [ ] Payment Processing - Stripe integration for subscriptions  
- [ ] Admin Dashboard - User management and analytics

## High Priority (Next Quarter)
- [ ] Email Notifications - Transactional and marketing emails
- [ ] API Rate Limiting - Prevent abuse and ensure stability
- [ ] Data Export - User data download compliance

## Medium Priority (Future)
- [ ] Mobile App API - Endpoints for mobile clients
- [ ] Webhooks - External integrations
- [ ] Advanced Analytics - Usage metrics and insights

## Ideas/Research Needed
- [ ] Machine Learning Recommendations
- [ ] Multi-tenant Architecture
- [ ] Internationalization (i18n)
```


### Document Philosophy
- **Start Minimal**: Begin with three core documents, keep them simple
- **Progressive Enhancement**: Add custom documents only when needed
- **Single Responsibility**: Each document focuses on one aspect
- **YAGNI Principle**: Don't create documents until complexity demands it

## Template System

### Philosophy: Template as Architectural DNA

Templates provide the architectural DNA that guides all development activities in a Vybe project. Once set during initialization, the template becomes permanent and enforces its patterns throughout the project lifecycle.

### Key Principles

1. **One Template Per Project** - Set once during `/vybe:init`, permanent thereafter
2. **Template DNA is Immutable** - Cannot change template mid-project (requires migration)
3. **Living Documents Within Template** - Vybe docs can evolve, but within template constraints
4. **AI Analysis & Generation** - Templates are analyzed by AI to generate Vybe-compatible documents

### Template Workflow

1. **Import**: Bring external template into Vybe
   ```bash
   /vybe:template import github.com/fastapi/full-stack-fastapi-template fastapi-stack
   ```

2. **Generate**: AI analyzes and creates enforcement structures
   ```bash
   /vybe:template generate fastapi-stack
   ```

3. **Initialize**: Set template as project DNA
   ```bash
   /vybe:init "My API project" --template=fastapi-stack
   ```

4. **Enforce**: All commands follow template patterns automatically

### Template-Generated Structures

When a template is analyzed, the system creates comprehensive enforcement structures:

```
.vybe/
├── templates/[name]/        # Template storage
│   ├── metadata.yml        # Template information
│   ├── mapping.yml         # Vybe concept mapping
│   ├── source/            # Original template reference
│   └── generated/         # Vybe documents
│       ├── overview.md
│       ├── architecture.md
│       ├── conventions.md
│       └── patterns.yml
│
├── enforcement/           # Active rules (what must be followed)
│   ├── structure.yml     # Directory requirements
│   ├── workflows.yml     # Workflow patterns
│   ├── components.yml    # Component templates
│   └── services.yml      # Service patterns
│
├── patterns/             # Code templates (how to build)
│   ├── [pattern].template
│   └── ...              # Component, service, API patterns
│
└── validation/          # Compliance rules (what to check)
    ├── structure-rules.yml
    ├── naming-rules.yml
    ├── import-rules.yml
    └── testing-rules.yml
```

### Template Enforcement

#### During Planning (`/vybe:plan`)
- Reads `.vybe/enforcement/structure.yml` for file placement
- Creates specs following template patterns
- Uses `.vybe/enforcement/components.yml` for component structure

#### During Execution (`/vybe:execute`)
- Uses `.vybe/patterns/*.template` for code generation
- Follows `.vybe/enforcement/` rules for file placement
- Maintains naming from `.vybe/validation/naming-rules.yml`

#### During Audit (`/vybe:audit`)
- Validates against `.vybe/validation/` rules
- Checks structure matches `.vybe/enforcement/structure.yml`
- Verifies patterns match template requirements

### Template Immutability

Once a template is set during project initialization:
- Template becomes the project's permanent architectural foundation
- All future development follows template patterns
- To change templates requires creating a new project and migrating
- Documents can evolve but must remain compatible with template structure

### Popular Template Examples

- **FastAPI Full Stack**: Production-ready API with authentication, database, Docker
- **Next.js Enterprise**: Scalable frontend with TypeScript, testing, CI/CD
- **Django REST**: Batteries-included backend with admin, ORM, authentication
- **GenAI Launchpad**: AI workflow orchestration with LangChain, Celery
- **Microservices**: Distributed architecture with service mesh, observability

## Context Enforcement & Session Handoff

### Session Handoff Philosophy
**Every new AI session picks up exactly where the previous one left off:**
- Complete project state preserved in living documents
- Decision history captured in document comments  
- Current progress always visible in status.md
- No manual catch-up or context explanation required

### Mandatory Document Loading
**Every Vybe command MUST load the following before execution:**

1. **Project Documents** (Always loaded if they exist):
   - `.vybe/project/overview.md`
   - `.vybe/project/architecture.md`
   - `.vybe/project/conventions.md`
   - `.vybe/project/*.md` (all custom documents)

2. **Feature Context** (Loaded when working on a feature):
   - `.vybe/features/[current-feature]/requirements.md`
   - `.vybe/features/[current-feature]/design.md`
   - `.vybe/features/[current-feature]/tasks.md`
   - `.vybe/features/[current-feature]/status.md`

3. **Session Continuity State**:
   - Last command executed and its outcome
   - Current sprint and task assignments
   - Active blockers or pending decisions
   - Recent audit findings and fixes applied

### Enforcement Strategy

**Hook System Integration**:
The Vybe framework leverages the existing hook system (`.claude/hooks/README.md`) for:
- **Pre-command context loading** - Automatically loads all project documents
- **Session handoff preservation** - PreCompact hook saves state before compaction
- **Post-command updates** - Updates CLAUDE.md with new documents
- **Validation and fallbacks** - Ensures context is always available

**CLAUDE.md Integration**:
```markdown
# Auto-generated section in CLAUDE.md
## Project Context Files (ALWAYS LOAD)
- .vybe/project/overview.md
- .vybe/project/architecture.md
- .vybe/project/conventions.md
- [any custom documents found]

## Active Feature Context
- Current feature: [feature-name]
- Load: .vybe/features/[feature-name]/*.md
```

**Session Handoff via Hooks**:
- Existing PreCompact hook preserves context automatically
- Multi-session debugging maintains state across sessions
- No additional handoff mechanism needed - already implemented

**Consistency Guarantees**:
- **No command runs without context** - Hard requirement
- **AI always knows project standards** - Prevents drift
- **Decisions remain consistent** - Same context = same reasoning
- **New developers get full context** - Immediate productivity
- **Seamless session handoff** - Work continues across AI sessions without loss

### Context Loading Failure Handling

**If project documents missing**:
- `/vybe:work` and `/vybe:iterate` commands refuse to run
- Error: "Project context not found. Run /vybe:init first"
- This prevents AI from making decisions without project standards

**If feature documents missing**:
- For feature-specific commands, prompt to run `/vybe:plan` first
- Error: "Feature [name] context not found. Run /vybe:plan [feature] first"
- This ensures AI has full feature understanding before implementation

## Command Specifications

### /vybe:init
**Purpose**: Create intelligent project foundation with technology stack analysis and staged outcome roadmap

**Enhanced Capabilities**:
- **Intelligent Technology Analysis**: Parses project description to extract explicit technologies
- **Technology Stack Registry**: Creates `.vybe/tech/` with complete technology decisions
- **Progressive Installation Planning**: Stage-by-stage tool installation roadmap
- **User Approval Flow**: AI presents complete technology recommendations before proceeding

**Tasks**:
1. **Task: Parse Parameters & Template Validation**
   - Process command line arguments and project description
   - Validate template if --template specified
   - Extract explicit technology requirements from description

2. **Task: Analyze Project State**
   - Check for .git repository
   - Detect existing .vybe/project documents
   - Scan for code and configuration files
   - Determine project type (new/existing/vybe-enabled)

3. **Task: Complete Technology Stack Capture and Planning** *(NEW)*
   - AI-driven technology analysis and recommendation
   - Research best practices for application domain
   - Present complete technology stack with explanations
   - Get user approval before creating technology registry
   - Create `.vybe/tech/` structure with stage-by-stage installation plan

4. **Task: Generate Project Overview**
   - Create/update `.vybe/project/overview.md`
   - Document business goals and user context aligned with staged outcomes
   - Define project scope and constraints
   - Keep to 1-2 pages maximum

5. **Task: Document Architecture**
   - Create/update `.vybe/project/architecture.md`
   - Document established technology stack from registry
   - Include architectural patterns supporting staged development
   - Capture system design patterns
   - Map file structure organization

6. **Task: Extract Conventions**
   - Create/update `.vybe/project/conventions.md`
   - Extract coding standards from existing code
   - Document git workflow and commit patterns
   - Define naming conventions and formatting rules

5. **Task: Update Project Files**
   - Create/update README.md
   - Add .vybe/ to .gitignore
   - Update CLAUDE.md with context paths

**Process**:
1. **Detect Project State**:
   - Check for `.git` repository and analyze git status
   - Check for existing `.vybe/project` documents
   - Check for existing code, configurations, documentation
   - Identify project status: new, existing without vybe, or existing with vybe
   
2. **If .vybe/project Already Exists**:
   - Read existing overview.md, architecture.md, conventions.md
   - Analyze if they match current codebase reality
   - Suggest updates if code has diverged from documentation
   - Prompt: "Vybe docs found. Update existing docs? [y/N]"

3. **For Existing Projects (No Vybe) - Analyze**:
   - Check git history for project age and activity patterns
   - Identify primary contributors and commit message style
   - Scan file structure and technology stack
   - **Detect project type and configuration**:
     - Package managers and dependency files (package.json, requirements.txt, Cargo.toml, go.mod, etc.)
     - Build systems and configuration files
     - Linting and formatting configs
     - Testing frameworks
     - CI/CD pipelines
     - ML/AI frameworks (notebooks, model files, training configs)
     - Data science tools (experiment tracking, data versioning)
   - Identify patterns from actual code
   - Extract conventions from existing files
   - Detect testing frameworks and security measures in use
   - Note branching strategy (main/master, develop, feature branches)

4. **Generate/Update Documentation**:
   - README.md - Update if exists, create if missing
   - `overview.md` - Merge existing content with new findings
   - `architecture.md` - Document actual tech stack and patterns found
   - `conventions.md` - Extract real conventions from codebase

5. **For New Projects - Create**:
   - Generate based on description
   - Set up directory structure
   - Create initial configuration files

**AI Behavior**:
- **Existing Project**: Analyze and document what IS
- **New Project**: Plan and document what WILL BE
- Use git information to understand project maturity and workflow
- Extract commit message conventions from git log
- Detect frameworks, libraries, and tools already in use
- Respect existing patterns while suggesting improvements
- Merge provided description with discovered reality
- Add `.vybe/` to .gitignore if not present

### /vybe:plan
**Purpose**: Create new features or modify existing feature specifications

**Tasks**:
1. **Task: Load Project Context**
   - Load all .vybe/project/*.md documents
   - Check backlog.md for related features
   - Verify project is initialized
   - Check if feature already exists

2. **Task: Smart Discovery & Clarification**
   - Search for related items in backlog and existing features
   - If conflicts found, present options to user
   - Determine if creating new feature or modifying existing

3. **Task: Generate/Update Requirements**
   - Create/update `.vybe/features/[name]/requirements.md`
   - Define user stories and acceptance criteria
   - Document functional and non-functional requirements
   - Request approval before proceeding

4. **Task: Design Technical Approach**
   - Create/update `.vybe/features/[name]/design.md`
   - Define architecture and component design
   - Document API contracts and data models
   - Identify integration points

5. **Task: Create/Update Implementation Plan**
   - Create/update `.vybe/features/[name]/tasks.md`
   - Break down into discrete, executable tasks
   - Define task dependencies
   - Assign sprint tags (sprint-1, sprint-2, etc.)
   - Reorganize sprints if modifying existing feature

6. **Task: Initialize/Update Status Tracking**
   - Create/update `.vybe/features/[name]/status.md`
   - Set appropriate task statuses
   - Update backlog.md if new feature created

**Process**:
1. Check if feature already exists (refine) or new (create)
2. If new, create feature directory
3. Generate or update three core documents:
   - `requirements.md` - User stories, acceptance criteria
   - `design.md` - Technical approach, architecture
   - `tasks.md` - Implementation breakdown
4. Each phase requires approval before proceeding

**AI Behavior**:
- Analyze existing codebase for patterns
- Suggest design aligned with project architecture
- Break complex features into manageable tasks
- Identify dependencies and prerequisites

### /vybe:discuss
**Purpose**: Resolve implementation feedback, explore complex decisions, and get AI guidance for real problems

**Tasks**:
1. **Task: Load Full Context**
   - Load all project documents (mandatory)
   - Load relevant feature specifications and current status
   - Analyze recent execution history and outcomes

2. **Task: Understand Discussion Topic**
   - Parse natural language question or problem
   - Identify type of discussion (implementation feedback, problem-solving, trade-offs)
   - Determine relevant project context and constraints

3. **Task: Analyze Implementation Reality**
   - Review what was planned vs what was discovered during execution
   - Consider existing patterns and architectural constraints
   - Identify root causes and potential solutions
   - Research best practices for the specific context

4. **Task: Provide AI Guidance**
   - Present multiple solution approaches
   - Highlight risks, benefits, and trade-offs
   - Suggest concrete next steps and plan modifications
   - Recommend whether to iterate plan, change approach, or continue

5. **Task: Suggest Plan Updates**
   - Recommend specific `/vybe:plan` iterations based on findings
   - Suggest scope adjustments or technical changes
   - Propose alternative approaches to resolve issues

**Usage Patterns**:
```bash
# Implementation feedback (primary use case)
/vybe:discuss "OAuth integration more complex than expected, hitting rate limits"

# Problem solving during execution
/vybe:discuss "Database migration failing on production, need rollback strategy"

# Complexity discoveries
/vybe:discuss "Payment flow needs PCI compliance, should we use Stripe instead?"

# Architecture issues found during development
/vybe:discuss "Performance bottleneck in user dashboard, need optimization approach"

# Optional: Project direction (early stage)
/vybe:discuss "Should this be mobile-first design for this target market?"
```

**AI Behavior**:
- **Implementation-focused** - Addresses real problems discovered during execution
- **Solution-oriented** - Provides actionable recommendations for current issues
- **Context-aware** - Uses project history and constraints to suggest realistic solutions
- **Plan evolution** - Suggests specific plan modifications based on learnings
- **Reactive guidance** - Responds to actual development challenges, not theoretical planning

### /vybe:execute
**Purpose**: Execute implementation tasks with automatic code generation, testing, and multi-member coordination

**Enhanced Capabilities**:
- **Automatic code generation** following template patterns and project conventions
- **Unit testing after each task** with auto-fix capabilities
- **Integration testing at stage gates** 
- **Multi-member coordination** with role-based assignments
- **Template enforcement** when available (highest priority)
- **Intelligent error handling** with human alerts when needed

**Tasks**:
1. **Task: Load Full Context with Template Priority**
   - **PRIORITY 1**: Load template patterns if project uses template (ENFORCE STRICTLY)
     - `.vybe/enforcement/` - Structure and component patterns
     - `.vybe/patterns/` - Code generation templates
     - `.vybe/validation/` - Compliance rules
   - **PRIORITY 2**: Load project documents (mandatory)
     - `overview.md`, `architecture.md`, `conventions.md`, `outcomes.md`
   - **PRIORITY 3**: Load feature specifications
     - `requirements.md`, `design.md`, `tasks.md`
   - Check multi-member assignments and role-based work

2. **Task: Determine Project Structure**
   - **If template exists**: Use template-defined structure exactly (NO deviations)
   - **If architecture.md exists**: Follow specified technology stack and patterns
   - **If neither**: Intelligently determine based on task requirements
   - Create clean project structure on first task execution

3. **Task: Execute Implementation**
   - **Template-driven**: Use exact code patterns from `.vybe/patterns/`
   - **Document-driven**: Follow `architecture.md` and `conventions.md`
   - **Intelligent**: Apply best practices for detected project type
   - **Generate actual code files** using Write/Edit tools
   - **Follow role assignments** for multi-member coordination

4. **Task: Unit Testing**
   - Create comprehensive unit tests for implemented code
   - Use template test patterns if available
   - Follow project test conventions
   - **Run tests automatically** after implementation
   - **Auto-fix simple failures** or alert human for complex issues

5. **Task: Git Coordination**
   - Create feature branches for team coordination
   - Track multi-session development
   - Handle merge conflicts and coordination
   - Commit tested code only

6. **Task: Stage Gate Integration Testing**
   - **At stage completion**: Run integration tests
   - **Validate requirements**: Check all acceptance criteria met
   - **Template compliance**: Ensure no pattern violations
   - **Show run instructions**: How to start and test the application

**Execution Modes**:
```bash
# Direct AI execution with automatic implementation (default)
/vybe:execute user-auth-task-3

# Multi-member coordination
export VYBE_MEMBER=dev-1
/vybe:execute my-feature                     # Execute assigned feature for dev-1
/vybe:execute my-task --role=dev-2          # Execute as dev-2

# Stage completion with integration testing
/vybe:execute stage-1 --complete            # Complete stage with integration tests
/vybe:execute implement-auth --stage-gate   # Run stage gate validation

# Template-driven development
/vybe:execute api-endpoint                  # Uses template patterns if available
/vybe:execute frontend-component           # Follows template structure strictly

# Error handling modes
/vybe:execute complex-feature --auto-fix    # Auto-fix test failures
/vybe:execute integration-task --alert-human # Alert on complex failures

# Legacy delegation modes (still supported)
/vybe:execute user-auth-task-3 --assign=@alice
/vybe:execute user-auth-task-3 --guide
```

**Delegation Features**:
- **Smart assignment**: AI suggests best person/agent for each task type
- **Context preservation**: Assignees get full project context and task details
- **Progress tracking**: Monitor delegated tasks through status updates
- **Notification system**: Automated check-ins and progress reports
- **Skill matching**: Match tasks to team member expertise

**Enhanced Process**:
1. **Context Loading**: Templates → Project docs → Feature specs (strict hierarchy)
2. **Structure Setup**: Create project structure if first task (template-driven)
3. **Implementation**: Generate actual code files following patterns
4. **Unit Testing**: Create and run tests automatically
5. **Auto-Fix**: Handle test failures intelligently or alert human
6. **Git Coordination**: Branch management and team coordination
7. **Stage Gates**: Integration testing at stage completion
8. **Run Instructions**: Show how to start and test application

**AI Behavior**:
- **Template Enforcement**: Never deviate from template patterns when available
- **Automatic Testing**: Every task includes test creation and execution
- **Quality Gates**: No progression without passing tests
- **Multi-Member Awareness**: Respect role assignments and coordinate work
- **Intelligent Defaults**: Only when templates/docs don't specify
- **Real Code Generation**: Create actual runnable code, not documentation
- **Error Recovery**: Auto-fix simple issues, escalate complex ones

### /vybe:audit
**Purpose**: Scan project for gaps, duplicates, inconsistencies, and quality issues

**Tasks**:
1. **Task: Load Complete Project State**
   - Load all project documents
   - Load all feature specifications
   - Read backlog.md and current sprint assignments
   - Analyze code-to-spec alignment

2. **Task: Identify Issues**
   - **Gaps**: Missing requirements, design elements, or tasks
   - **Duplicates**: Overlapping features or redundant tasks
   - **Inconsistencies**: Conflicting requirements or outdated information
   - **Sprint Issues**: Overloaded sprints, dependency conflicts
   - **Orphaned Items**: Tasks without features, features not in backlog

3. **Task: Analyze Project Health**
   - Check document freshness vs code changes
   - Validate sprint capacity and realistic timelines
   - Identify technical debt in specifications
   - Review testing and security coverage

4. **Task: Generate Report**
   - Categorize issues by severity (critical, moderate, minor)
   - Provide specific recommendations for each issue
   - Estimate effort for fixes
   - Suggest consolidation opportunities

5. **Task: Apply Fixes (if --fix specified)**
   - Propose specific changes for each issue
   - Show before/after previews
   - Apply changes with user approval
   - Update affected documents automatically

**Command Options**:
```bash
/vybe:audit                              # Scan and report only
/vybe:audit --fix                        # Scan, propose fixes, apply with approval
/vybe:audit --fix --auto                 # Apply safe fixes automatically
/vybe:audit --scope=tasks                # Focus on specific area
/vybe:audit --scope=features             # Audit only feature specifications
/vybe:audit --scope=sprints              # Check sprint organization
/vybe:audit --interactive                # Step through each issue
/vybe:audit --fix --auto --commit        # Auto-fix and commit changes
```

**Sample Output**:
```
Project Audit Report - 2025-01-15

CRITICAL ISSUES (3):
⚠️  user-auth feature missing security requirements
⚠️  payment-task-5 depends on incomplete user-auth-task-3
⚠️  Sprint 2 has 8 tasks (recommended: 4-5)

MODERATE ISSUES (5):
⚡ OAuth mentioned in 3 places with different approaches
⚡ Email feature in backlog but partially implemented in notifications
⚡ testing.md created but no test tasks in any feature

MINOR ISSUES (2):
💡 Sprint 3 only has 2 tasks, could consolidate with Sprint 2
💡 Some tasks missing acceptance criteria

RECOMMENDATIONS:
- Consolidate OAuth approach across features
- Move email functionality to dedicated feature
- Rebalance sprint task distribution
- Add security requirements to user-auth

Run '/vybe:audit --fix' to apply suggested fixes.
```

**AI Behavior**:
- **Comprehensive scanning** - Analyzes entire project systematically
- **Pattern recognition** - Identifies subtle inconsistencies and gaps
- **Best practice validation** - Checks against project conventions
- **Safe automation** - Only auto-fixes non-controversial issues
- **Quality maintenance** - Helps projects stay healthy as they grow

### /vybe:status
**Purpose**: Provide progress visibility and next steps

**Tasks**:
1. **Task: Load Feature Status**
   - Read `.vybe/features/[name]/status.md`
   - Parse task completion states
   - Calculate progress metrics

2. **Task: Analyze Dependencies**
   - Check task dependencies
   - Identify blockers
   - Find next available tasks

3. **Task: Generate Summary**
   - Count completed/pending/in-progress tasks
   - Calculate sprint estimates (assuming ~4-5 tasks per sprint)
   - Track velocity based on completion rate
   - Identify current phase
   - List recent completions

4. **Task: Provide Recommendations**
   - Suggest next task to work on
   - Highlight any blockers
   - Recommend iteration if needed

5. **Task: Format Output**
   - Display progress visually
   - Show task list with status indicators
   - Include actionable next steps

**Display Format**:
```
Feature: user-authentication
Phase: Implementation
Progress: 3/7 tasks completed

Sprint View:
- Current: Sprint 1 (Week 1 of 2)
- Total Sprints: 2
- Velocity: 1.5 tasks/week

Sprint 1 (Current):
✓ task-1: Set up database schema
✓ task-2: Create user model
✓ task-3: Implement registration endpoint
→ task-4: Add login functionality

Sprint 2 (Upcoming):
○ task-5: Implement JWT tokens
○ task-6: Add password reset
○ task-7: Create test suite

Next Steps:
- Complete task-4 to finish Sprint 1
- Prepare for Sprint 2 security tasks
```

## Workflow Patterns

### New Project
```bash
/vybe:init "E-commerce platform with user accounts and payment processing"
/vybe:discuss "What authentication approach works best for e-commerce?"
/vybe:plan user-authentication "User registration and login with email verification"  
/vybe:execute user-auth-task-1
/vybe:status user-authentication
```

### Existing Project Without Vybe
```bash
# Project already has React, Express, PostgreSQL, Jest
/vybe:init "Enhance existing e-commerce platform"
# AI analyzes codebase and generates:
# - overview.md based on existing README and code
# - architecture.md documenting React/Express/PostgreSQL stack found
# - conventions.md extracting patterns like camelCase, 2-space indent, etc.

/vybe:plan payment-integration "Add Stripe payment processing"
# AI creates plan that follows existing patterns
```

### Re-initializing Existing Vybe Project
```bash
# Project already has .vybe/project documents
/vybe:init "Update project documentation"
# AI detects existing vybe docs
# Prompts: "Vybe docs found. Update existing docs? [y/N]"
# If yes:
# - Analyzes if code has diverged from docs
# - Updates architecture.md with new dependencies
# - Adds new patterns to conventions.md
# - Preserves custom documents (security.md, testing.md)
```

### Feature Addition
```bash
/vybe:discuss "Should shopping cart include wishlist functionality?"
/vybe:plan shopping-cart "Add cart functionality with session persistence and wishlist"
/vybe:execute shopping-cart-task-1
```

### Mid-Development Discovery
```bash
/vybe:execute payment-task-3
# Discover need for webhook handling
/vybe:discuss "Best practices for handling payment webhooks securely"
/vybe:plan payment "add webhook endpoint for payment confirmations"
# AI detects existing feature, modifies requirements and adds tasks
/vybe:execute payment-task-8
```

### Problem Solving
```bash
/vybe:discuss "Authentication failing on mobile devices, works on web"
# AI analyzes architecture.md, suggests CORS or token storage issues
/vybe:plan user-auth "add mobile-specific authentication handling"
/vybe:execute user-auth-task-6 --assign=@mobile-expert
```

### Team Delegation
```bash
# Assign based on expertise
/vybe:execute security-audit --assign=@security-lead
/vybe:execute frontend-styling --assign=@ui-designer
/vybe:execute database-migration --agent=database-specialist

# Collaborative work
/vybe:execute complex-algorithm --guide
# AI provides step-by-step guidance while human implements

# Team assignment
/vybe:execute testing-suite --team=qa-team --notify=weekly
```

### Project Evolution
```bash
# Start simple
/vybe:init "Todo app with React"
# Basic 3 documents created

# Team grows, need standards
/vybe:discuss "What testing and security standards should we add?"
/vybe:plan project-standards "Add testing framework and security guidelines"
# AI creates testing.md and security.md as needed

# Architecture decision
/vybe:discuss "Should we switch from REST to GraphQL?"
/vybe:plan api-redesign "Migrate to GraphQL with backward compatibility"
```

### Scope Change
```bash
/vybe:discuss "Dashboard analytics are too complex, should we simplify?"
/vybe:plan dashboard "remove analytics, focus on simple metrics and KPIs"
# AI modifies existing requirements and reorganizes tasks
/vybe:status dashboard
```

### Quality Assurance
```bash
# Regular project health check
/vybe:audit
# Shows gaps, duplicates, sprint issues

# Fix specific issues interactively
/vybe:audit --fix --scope=sprints --interactive
# Step through each sprint issue with proposed fixes

# Weekly maintenance
/vybe:audit --fix --auto --commit
# Auto-fix safe issues and commit changes

# Pre-release audit
/vybe:audit --scope=features
# Ensure all features are complete and consistent
```

## Implementation Guidelines

### Natural Language Processing
- Commands accept conversational input
- AI interprets intent rather than requiring exact syntax
- Context-aware understanding of changes

### State Management
- Each feature maintains independent state
- Progress tracked automatically
- History preserved in document comments

### Error Handling
- Validate phase existence before iteration
- Confirm understanding of ambiguous requests
- Suggest alternatives for invalid operations

### Integration Points
- Git-aware for version control
- Test framework detection
- Build system integration
- IDE compatibility through standard file formats

## Design Rationale

### Why 5 Commands?
- Covers complete development lifecycle
- Each command has clear, distinct purpose
- Reduces cognitive load
- Easy to remember and master

### Why Iterate as Universal Updater?
- Single mental model for all changes
- Natural language is more intuitive than multiple update commands
- Reflects real development patterns
- Maintains consistency across phases

### Why Structured Specs with Flexibility?
- Structure provides clarity and direction
- Flexibility acknowledges reality of software development
- Living documents stay valuable throughout project
- Balance between planning and agility

## Future Considerations

### Potential Enhancements
- Template library for common project types
- Multi-feature dependency management
- Team collaboration features
- Metrics and velocity tracking
- Integration with project management tools

### Extensibility
- Plugin architecture for custom commands
- Webhook system for external integrations
- Custom document types
- Alternative AI model support

## Conclusion

Vybe represents a new approach to AI-driven development that acknowledges both the need for structure and the reality of iterative discovery. By providing powerful commands with natural language interfaces, it enables developers to maintain momentum while preserving valuable context and documentation.

The framework is designed to grow with your project, supporting everything from initial prototype to production system, always maintaining alignment between documentation and implementation.
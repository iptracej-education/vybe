# Vybe Command Specifications

**Detailed implementation specifications for all Vybe framework commands**

Version: 3.0.0  
Created: 2025-08-14  
Updated: 2025-08-19  
Status: High-Performance Implementation Guide

## Overview

This document provides detailed specifications for implementing Vybe framework commands with **20-120x performance optimization**. Each command specification includes hybrid architecture patterns, shared cache integration, AI behavior guidelines, and performance metrics.

**Architecture Revolution**: All commands converted from multiple bash blocks to optimized external script + AI analysis hybrid pattern.

## Command Flow (High-Performance)

```
init → backlog → plan → execute → release → status → audit
         ↑                           ↓
         └── discuss (smart routing) ←┘
```

**Performance Architecture**: Each command now uses:
1. **External Script**: Bulk file operations and cache management
2. **AI Analysis**: Sophisticated logic and decision-making
3. **Shared Cache**: Cross-command data sharing via MCP
4. **Instant Help**: 0.003-0.14 second help response times

### Command Responsibilities (High-Performance)

| Command | Architecture | Focus | Performance Features |
|---------|--------------|-------|---------------------|
| `init` | External Script + AI | Staged outcome setup | Template integration, cache initialization |
| `backlog` | External Script + AI | Outcome-grouped planning | Auto-assignment, RICE/WSJF scoring |
| `plan` | External Script + AI | Feature specifications | Web research, EARS requirements |
| `execute` | External Script + AI | Task execution | Template enforcement, code generation |
| `release` | External Script + AI | Stage progression | Multi-member integration |
| `status` | External Script + AI | Progress + outcomes | Cached progress reports |
| `audit` | External Script + AI | Quality + code-reality | Specialized analysis modes |
| `discuss` | External Script + AI | Natural language + routing | Smart audit routing |
| `template` | External Script + AI | Template import/analysis | Architecture pattern extraction |

**Performance Metrics**: All commands now deliver 20-120x faster execution with shared cache benefits.

---

## /vybe:init (Hybrid Architecture)

**Purpose**: Initialize project with AI-generated foundation, intelligent technology stack analysis, and staged outcome roadmap

**Performance**: External script handles file operations, AI provides intelligent analysis

### Usage
```bash
/vybe:init [project-description] [--template=template-name]
/vybe:init help  # Instant help (0.003-0.14 seconds)
```

### Parameters
- `project-description`: Project description with optional technology specifications
- `--template=template-name`: Optional template to use as architectural DNA

### Hybrid Architecture Components
1. **External Script**: `init-script.sh` - File operations, directory creation, template handling
2. **AI Analysis**: Intelligent technology recommendations, project planning, outcome stages
3. **Shared Cache**: Initialize cache system for cross-command performance benefits
4. **MCP Integration**: Register cache server if available

### Enhanced Capabilities
- **Intelligent Technology Analysis**: Parses project description to extract explicit technologies and recommends missing components
- **Technology Stack Registry**: Creates `.vybe/tech/` with complete technology decisions and stage-by-stage installation plan
- **Template Integration**: Extracts technology stack from template source code when template specified
- **User Approval Flow**: Presents complete technology recommendations and gets user approval before proceeding
- **Performance Optimization**: Cache initialization for 20-120x faster subsequent commands

### Tasks
1. **Parse Parameters & Template Validation** - Process command line arguments and validate template if specified
2. **Analyze Project State** - Detect git, code files, existing documentation
3. **Complete Technology Stack Capture and Planning** - **NEW**
   - Interactive technology stack definition
   - AI-driven analysis and recommendation
   - Technology registry creation (`.vybe/tech/`)
   - Stage-by-stage installation planning
4. **Create Directory Structure** - Set up .vybe hierarchy
5. **Generate Intelligent Project Documentation** - Business context, architecture, conventions, and outcomes with technology integration
6. **Incremental Outcome Stages Capture** - Define staged delivery roadmap with user interaction
7. **Update Project Files** - README, .gitignore, CLAUDE.md

### Technology Registry Structure (✅ IMPLEMENTED)
Creates `.vybe/tech/` directory with complete technology decisions:
- `languages.yml` - Primary language, version, package manager
- `frameworks.yml` - Web/API/database frameworks and versions
- `testing.yml` - Test frameworks, commands, and requirements
- `build.yml` - Build tools, scripts, and processes
- `tools.yml` - Development tools and utilities
- `deployment.yml` - Deployment configuration and targets
- `stages.yml` - Stage-by-stage tool installation plan

**Implementation Status**: The init command now creates actual technology registry files with real technology decisions based on AI analysis, not just placeholders.

### AI Process Flow
1. **Parse** - Extract explicit technologies from project description
2. **Research** - Analyze best practices for application domain and technology combinations
3. **Recommend** - Intelligently suggest missing components with explanations
4. **Present** - Show complete technology stack with reasoning and alternatives
5. **Approve** - Get user approval or guide to re-run with more specific requirements
6. **Create** - Generate technology registry only after user approval

### Process
- **New Project**: Generate based on description and intelligent technology analysis
- **Existing Project**: Analyze codebase and extract patterns
- **Vybe Project**: Update documentation if needed

### Context Loading

**Mandatory (loaded first):**
- None required (init creates these documents)

**Template Support (if using --template):**
- `.vybe/templates/[name]/generated/` - Pre-generated Vybe documents from template
- Template patterns and rules to incorporate

### AI Behavior
- Document what IS (existing) vs what WILL BE (new)
- Extract real patterns from code, not assumptions
- Respect existing conventions while suggesting improvements
- If template specified, merge template patterns with project analysis

### Output Files
- `.vybe/project/overview.md`
- `.vybe/project/architecture.md`
- `.vybe/project/conventions.md`
- `.vybe/backlog.md` (empty, managed by backlog command)

---

## /vybe:template

**Purpose**: Import and analyze external templates to provide architectural DNA for projects

### Usage
```bash
/vybe:template [action] [params]

# Examples
/vybe:template import github.com/fastapi/full-stack-fastapi-template fastapi-stack
/vybe:template import ./local-template my-template
/vybe:template generate fastapi-stack
/vybe:template list
/vybe:template validate fastapi-stack
```

### Actions
- **import [source] [name]**: Import template from GitHub URL or local path
- **generate [name]**: AI analyzes template and generates Vybe structures
- **list**: Show all imported templates with metadata
- **validate [name]**: Check template completeness and readiness

### Context Loading

**For import action:**
- No context required (standalone operation)

**For generate action:**
- Template source files from `.vybe/templates/[name]/source/`
- Existing project context if available

### Tasks

#### Task 1: Import Template
- Clone/copy template source to `.vybe/templates/[name]/source/`
- Create metadata.yml with template information
- Preserve directory structure and all files
- Handle both GitHub URLs and local paths

#### Task 2: Analyze Template (generate)
- **Read comprehensively**: All source files, configs, documentation
- **Extract patterns**: Directory structure, component organization, API design
- **Identify conventions**: Naming, file organization, coding standards
- **Map to Vybe**: Create mapping.yml linking template concepts to Vybe

#### Task 3: Generate Enforcement Structures
- **Create `.vybe/enforcement/`**: Active rules for structure and patterns
- **Create `.vybe/patterns/`**: Reusable code templates
- **Create `.vybe/validation/`**: Compliance checking rules
- **Generate Vybe documents**: overview.md, architecture.md, conventions.md

#### Task 4: Validate Template
- Check all required structures exist
- Verify pattern templates are complete
- Validate enforcement rules are consistent
- Ensure Vybe documents are generated

### AI Behavior
- **Deep analysis**: Understand template's architectural philosophy
- **Pattern extraction**: Identify reusable components and structures
- **Smart mapping**: Connect template concepts to Vybe workflow
- **Comprehensive generation**: Create all enforcement structures

### Output Structures
```
.vybe/templates/[name]/
├── metadata.yml              # Template info
├── mapping.yml               # Vybe concept mapping
├── source/                   # Original template
└── generated/                # Vybe documents

.vybe/enforcement/            # Active rules
.vybe/patterns/               # Code templates
.vybe/validation/             # Compliance rules
```

### Integration Points
- **To init**: Templates used during project initialization
- **From init**: `--template` option triggers template usage
- **To all commands**: Enforcement structures guide development

---

## /vybe:backlog

**Purpose**: Strategic feature management, prioritization, and release planning

### Usage
```bash
/vybe:backlog [action] [params]

# Examples
/vybe:backlog                         # View current backlog
/vybe:backlog add "user authentication" # Add feature idea
/vybe:backlog prioritize              # Review and reorganize priorities
/vybe:backlog release "v1.0"          # Plan release groupings
/vybe:backlog dependencies            # Map cross-feature dependencies
```

### Actions
- **Default (no action)**: Display current backlog with status
- **add [feature-idea]**: Capture new feature ideas
- **prioritize**: Interactive priority management
- **release [version]**: Group features into releases
- **dependencies**: Map and visualize feature dependencies
- **capacity**: Estimate effort and sprint capacity

### Context Loading

**Mandatory (loaded first):**
- `.vybe/project/overview.md` - Business context
- `.vybe/project/architecture.md` - Tech stack
- `.vybe/project/conventions.md` - Standards
- `.vybe/project/outcomes.md` - Staged roadmap

**Feature Context:**
- `.vybe/features/*/status.md` - Current feature progress

### Tasks

#### Task 1: Load Project Context
- Read all project documents for strategic context
- Understand business goals and constraints
- Check existing features and their status
- Analyze current capacity and velocity

#### Task 2: Strategic Analysis
- **For add**: Classify feature type, estimate size, suggest priority
- **For prioritize**: Analyze business value vs effort
- **For release**: Group related features, check dependencies
- **For dependencies**: Identify technical and business dependencies

#### Task 3: Backlog Management
- Update backlog.md with proper categorization
- Maintain release groupings and priorities
- Track feature state transitions
- Preserve custom content and notes

#### Task 4: Capacity Planning
- Estimate feature sizes (S/M/L/XL)
- Calculate sprint capacity based on velocity
- Identify bottlenecks and resource needs
- Suggest realistic release timelines

### Backlog Structure
```markdown
# Project Backlog

## Release 1.0 (Target: March 2025)
### Must Have (P0)
- [ ] user-authentication (Size: L, Owner: backend-team)
- [ ] basic-dashboard (Size: M, Owner: frontend-team)

### Should Have (P1)  
- [ ] email-notifications (Size: S, Owner: TBD)

## Release 1.1 (Target: May 2025)
### Could Have (P2)
- [ ] advanced-analytics (Size: XL, Owner: TBD)
- [ ] api-rate-limiting (Size: M, Owner: TBD)

## Ideas & Research
- [ ] machine-learning-recommendations (Size: ?, Research needed)
- [ ] mobile-app-support (Size: ?, Dependencies: API v2)

## Technical Debt
- [ ] database-performance-optimization (Size: M)
- [ ] legacy-code-refactoring (Size: L)

## Completed Features (Archive)
- [x] project-setup (Completed: 2025-01-15)
```

### AI Behavior
- **Strategic thinking**: Consider business goals, user value, technical debt
- **Realistic planning**: Account for dependencies, capacity, risk
- **Flexible prioritization**: Balance must-have vs nice-to-have
- **Release coherence**: Group related features for cohesive releases

### Integration Points
- **From discuss**: Feed insights back to backlog priorities
- **To plan**: Select high-priority features for detailed planning
- **From audit**: Identify missing features or technical debt
- **To status**: Track overall project health and velocity

---

## /vybe:plan

**Purpose**: Create detailed specifications using stage-based or feature-based planning

### Usage  
```bash
# Stage-Based Planning (Recommended)
/vybe:plan [stage-name] [options]
/vybe:plan stage-1                    # Generate specs for Stage 1 features
/vybe:plan stage-2 --modify "Change: JavaScript to TypeScript"

# Feature-Based Planning (Legacy)
/vybe:plan [feature-name] [description]
/vybe:plan user-authentication "JWT-based auth with refresh tokens"
```

### Parameters

#### Stage-Based Planning
- `stage-name`: Stage identifier (stage-1, stage-2, etc.)
- `--modify "changes"`: AI-assisted modifications to stage requirements

#### Feature-Based Planning (Legacy)
- `feature-name`: Kebab-case feature identifier
- `description`: What to build or modify for this feature

### Context Loading

**Mandatory (loaded first):**
- `.vybe/project/overview.md` - Business context
- `.vybe/project/architecture.md` - Tech stack
- `.vybe/project/conventions.md` - Standards
- `.vybe/project/outcomes.md` - Staged roadmap

**Template Enforcement (if template exists):**
- `.vybe/enforcement/structure.yml` - Directory requirements
- `.vybe/enforcement/components.yml` - Component patterns
- `.vybe/patterns/` - Reusable code templates

**Feature Context (if updating):**
- `.vybe/features/[name]/` - Existing specs

### Tasks

#### Task 1: Load Context
- Load all project documents (mandatory)
- Check backlog for feature priority and release assignment
- Load existing feature specs if updating
- Verify project initialization

#### Task 2: Smart Discovery
- Search for related features and potential conflicts
- Check existing code for similar functionality
- Identify reusable components and patterns
- Determine if new feature or updating existing

#### Task 3: Requirements Specification
- Generate comprehensive requirements.md
- Define user stories with acceptance criteria
- Document functional and non-functional requirements
- Include edge cases and error handling
- Create living document for iterative refinement

#### Task 4: Technical Design
- Create detailed design.md
- Define architecture and component design
- Document API contracts and data models
- Include security and performance considerations
- Generate evolving technical foundation

#### Task 5: Implementation Planning
- Break down into discrete tasks (4-8 hours each)
- Organize into 2-week sprints (4-5 tasks per sprint)
- Define dependencies and prerequisites
- Include testing and documentation tasks

#### Task 6: Status Initialization
- Create status.md with progress tracking
- Set initial task states and assignments
- Calculate estimates and timelines
- Update backlog if new feature

### Feature Structure
```
.vybe/features/[feature-name]/
├── requirements.md    # User stories, acceptance criteria
├── design.md         # Technical approach, APIs, data models
├── tasks.md          # Sprint-organized implementation plan
└── status.md         # Progress tracking and assignments
```

### AI Behavior
- **Context-aware**: Follow existing patterns and conventions
- **Comprehensive**: Don't skip requirements or design phases
- **Realistic**: Break down into achievable tasks
- **Consistent**: Maintain quality across all specifications

### Integration Points
- **From backlog**: Select prioritized features for planning
- **To execute**: Hand off well-specified features
- **From discuss**: Update specifications based on discoveries
- **To audit**: Ensure consistency with other features

---

## /vybe:execute (Hybrid Architecture)

**Purpose**: Execute implementation tasks with automatic code generation, progressive technology preparation, testing, and multi-member coordination

**Performance**: External script handles technology installation and file operations, AI provides code generation and template enforcement

### Enhanced Capabilities
- **Technology Stack-Driven Implementation**: Uses established technology decisions from `.vybe/tech/` registry (no more guessing)
- **Progressive Technology Preparation**: Installs required tools stage-by-stage based on current development stage
- **Automatic Code Generation**: Creates real, runnable code following established technology stack and patterns
- **Context-Driven Testing**: Uses testing configuration from `testing.yml` for framework and commands
- **Unit Testing with Auto-Fix**: Runs tests after implementation with automatic error correction (max 2 attempts)
- **Integration Testing at Stage Gates**: Comprehensive integration validation when stage completes
- **Multi-Member Coordination**: Role-based assignments with git-based coordination
- **Template Enforcement**: Template patterns are "LAW" when available (highest priority)
- **Quality Gates**: Cannot progress without passing tests and validation

### Usage
```bash
/vybe:execute [task-id] [options]

# Examples - Automatic Implementation
/vybe:execute auth-task-1                    # AI generates actual code + tests
/vybe:execute my-feature                     # Role-aware execution (VYBE_MEMBER)
/vybe:execute stage-1 --complete            # Complete stage with integration tests

# Examples - Multi-Member Coordination
export VYBE_MEMBER=dev-1
/vybe:execute my-feature                     # Execute assigned work for dev-1
/vybe:execute my-task --role=dev-2          # Execute as dev-2

# Examples - Template-Driven
/vybe:execute api-endpoint                  # Uses template patterns strictly
/vybe:execute component --template-validate # Check template compliance

# Examples - Error Handling
/vybe:execute complex-task --auto-fix       # Auto-fix test failures
/vybe:execute integration --alert-human     # Alert on complex issues

# Legacy - Delegation (still supported)
/vybe:execute auth-task-1 --assign=@alice   # Delegate to team member
/vybe:execute auth-task-1 --guide          # Collaborative execution
```

### Parameters
- `task-id`: Specific task from feature tasks.md OR `my-feature`/`my-task` for role-aware
- `--role=dev-N`: Specify developer role (overrides VYBE_MEMBER)
- `--complete`: Mark stage complete with integration testing
- `--auto-fix`: Automatically fix simple test failures
- `--alert-human`: Alert human for complex issues (don't auto-fix)
- `--template-validate`: Extra validation against template compliance
- `--assign=@user`: [Legacy] Delegate to team member
- `--guide`: [Legacy] Collaborative guidance mode

### Context Loading Hierarchy

**PRIORITY 1: Template Enforcement (if template exists) - HIGHEST PRIORITY:**
- `.vybe/project/.template` - Check if project uses template
- `.vybe/enforcement/` - Structure and pattern rules (ENFORCE STRICTLY)
- `.vybe/patterns/` - Code generation templates (USE EXACTLY)
- `.vybe/validation/` - Compliance rules (VALIDATE AGAINST)

**PRIORITY 2: Project Documents (mandatory) - SECOND PRIORITY:**
- `.vybe/project/overview.md` - Business context and goals
- `.vybe/project/architecture.md` - Technology stack and patterns
- `.vybe/project/conventions.md` - Coding standards and practices
- `.vybe/project/outcomes.md` - Current stage and delivery roadmap

**PRIORITY 3: Feature Context - THIRD PRIORITY:**
- `.vybe/features/[name]/requirements.md` - What to build (acceptance criteria)
- `.vybe/features/[name]/design.md` - How to build (technical approach)
- `.vybe/features/[name]/tasks.md` - Current task details and dependencies

**Multi-Member Context:**
- `.vybe/backlog.md` - Team assignments and role-based work
- `VYBE_MEMBER` environment variable - Current developer role

### Enhanced Tasks

#### Task 1: Load Context with Template Priority
- **TEMPLATE CHECK**: Load template patterns if project uses template
- **TECHNOLOGY STACK**: Load established technology decisions from `.vybe/tech/` registry
- **PROJECT DOCS**: Load all mandatory project documents
- **FEATURE SPECS**: Load feature specifications for context
- **MULTI-MEMBER**: Check role assignments and team coordination
- **TASK DETAILS**: Read current task from tasks.md and dependencies

#### Task 2: Technology Stack Preparation - **✅ IMPLEMENTED**
- **Load Technology Registry**: Read complete technology stack from `.vybe/tech/` directory created by init
- **Determine Current Stage**: Analyze task requirements and project progress to determine development stage
- **Progressive Installation**: Install required tools for current stage using `stages.yml` configuration
- **Validate Setup**: Run validation commands to ensure all required tools are properly installed
- **Environment Preparation**: Set up development environment for implementation

#### Task 3: Git Coordination Setup
- **Session Tracking**: Initialize session ID and tracking
- **Branch Management**: Create or switch to appropriate task branch
- **Working Tree Check**: Verify clean state or handle uncommitted changes
- **Multi-Member Coordination**: Handle git-based team coordination

#### Task 4: Execute Implementation with Technology Stack
- **Technology Stack-Driven Code**: Use established technology decisions from `.vybe/tech/` registry
- **Template-Driven Code**: Use exact patterns from `.vybe/patterns/` (if template exists)
- **Project Structure**: Follow project structure using established technology stack
- **Intelligent Code**: Apply best practices for detected project type
- **Multi-Member Coordination**: Respect role assignments and branch management
- **ACTUAL CODE GENERATION**: Create real, runnable files using Write/Edit tools

#### Task 5: Enhanced Testing and Validation
- **Technology Stack-Driven Testing**: Use testing configuration from `testing.yml` for framework and commands
- **Test Creation**: Generate comprehensive unit tests following established testing patterns
- **Template Test Patterns**: Use template test structures if available (highest priority)
- **Auto Execution**: Run tests immediately after implementation using configured test commands
- **Auto-Fix with Limits**: Handle test failures automatically (max 2 attempts) with intelligent error analysis
- **Human Alert**: Escalate complex issues after auto-fix limit reached

#### Task 6: Template Compliance Validation (if template exists)
- **Pattern Compliance**: Validate implementation against template patterns from `.vybe/patterns/`
- **Structure Validation**: Check directory structure matches template enforcement rules
- **Code Standards**: Verify naming conventions and coding patterns follow template
- **Violation Detection**: Identify and fix any unauthorized deviations from template DNA

#### Task 7: Integration Testing (Stage Gates)
- **Context-Driven Integration**: Use integration test approach from technology stack configuration
- **End-to-End Validation**: Run comprehensive integration tests when stage completes
- **Requirements Validation**: Verify all acceptance criteria are met
- **Technology Stack Instructions**: Provide run instructions based on `deployment.yml` and `build.yml`
- **Working Demo**: Show specific commands to test the implemented functionality

#### Task 8: Status Update and Git Commit
- **Task Status Update**: Mark task as completed in `tasks.md` and update feature status
- **Session Tracking**: Update session tracking with results and file changes
- **Git Coordination**: Commit changes with descriptive messages for team coordination
- **Quality Gates**: Only commit code that passes all tests and validation

### Enhanced Execution Modes

#### Automatic Implementation (Default)
- **Template Enforcement**: Strictly follow template patterns when available
- **Code Generation**: Create actual runnable code using Write/Edit tools
- **Pattern Consistency**: Follow existing code patterns and conventions
- **Test Integration**: Include unit tests with every implementation
- **Quality Gates**: No progression without passing tests

#### Multi-Member Coordination
- **Role-Based Work**: Execute tasks assigned to specific team members
- **Branch Management**: Coordinate work across multiple developer sessions
- **Conflict Resolution**: Handle merge conflicts and work coordination
- **Progress Tracking**: Track individual and team progress

#### Template-Driven Development
- **Pattern Enforcement**: Never deviate from template structures
- **Code Templates**: Use exact patterns from `.vybe/patterns/`
- **Structure Compliance**: Follow `.vybe/enforcement/` rules strictly
- **Validation**: Check against `.vybe/validation/` rules

#### Error Handling & Quality
- **Auto-Fix Mode**: Automatically fix simple test failures
- **Human Alert Mode**: Escalate complex issues for human intervention
- **Integration Testing**: Run comprehensive tests at stage gates
- **Acceptance Validation**: Verify all requirements are met

#### Legacy Modes (Still Supported)
- **Delegation**: Assign tasks to team members or AI agents
- **Collaborative**: Step-by-step guidance for complex implementations
- **Review Integration**: Code review and quality check workflows

### Enhanced AI Behavior
- **Template Law**: Never violate template patterns (highest priority)
- **Real Code Creation**: Generate actual runnable code, not documentation
- **Automatic Testing**: Create and run tests for every implementation
- **Quality Enforcement**: No progression without passing quality gates
- **Multi-Member Awareness**: Coordinate with team assignments and roles
- **Intelligent Fallback**: Use smart defaults only when patterns unspecified
- **Error Recovery**: Auto-fix simple issues, escalate complex ones
- **Stage Gate Validation**: Comprehensive testing at completion milestones

### Integration Points
- **From plan**: Execute well-specified tasks
- **To status**: Update progress automatically
- **To discuss**: Escalate problems and discoveries
- **From audit**: Address quality issues

---

## /vybe:release

**Purpose**: Mark outcome stage complete and advance to next stage

### Usage
```bash
/vybe:release [stage-name] [--force]
```

### Parameters
- `stage-name`: Optional. Specific stage to mark complete (defaults to current active stage)
- `--force`: Skip validation checks and force stage completion

### Context Loading

**Mandatory (loaded first):**
- `.vybe/project/overview.md` - Business context
- `.vybe/project/architecture.md` - Tech stack
- `.vybe/project/conventions.md` - Standards
- `.vybe/project/outcomes.md` - Stage progression

**Stage Context:**
- `.vybe/backlog.md` - Current stage status
- `.vybe/features/*/status.md` - Task completion for stage

### Tasks
1. **Validate Stage Completion** - Check tasks done, deliverable working, tests passing
2. **Capture Stage Learnings** - Document what worked, challenges, timeline accuracy
3. **Mark Stage Complete** - Update backlog.md and outcomes.md status
4. **Advance to Next Stage** - Mark next stage as IN PROGRESS
5. **Update Progress Metrics** - Calculate completion percentages and timelines

### Behavior Guidelines
- **Validation First**: Never mark stage complete without verifying deliverable
- **Learning Capture**: Always document insights for improving next stages
- **UI Example Check**: Request UI examples if next stage requires them
- **Coordination**: Update both backlog.md and outcomes.md consistently

### Integration Points
- **From execute**: Natural completion point for stage work
- **To status**: Progress tracking after stage advancement
- **To plan**: May trigger planning refinements for next stage

---

## /vybe:discuss (Hybrid Architecture)

**Purpose**: Explore ideas, solve problems, and guide iterative improvements with smart audit routing

**Performance**: External script manages project analysis, AI provides natural language processing and automated audit routing

### Usage
```bash
/vybe:discuss [topic/question]

# Examples
/vybe:discuss "Should we use GraphQL or REST for the API?"
/vybe:discuss "OAuth integration hitting rate limits"
/vybe:discuss "Database performance bottleneck in dashboard"
/vybe:discuss "Payment flow needs PCI compliance considerations"
```

### Parameters
- `topic/question`: Natural language description of what to explore

### Context Loading

**Mandatory (loaded first):**
- `.vybe/project/overview.md` - Business context
- `.vybe/project/architecture.md` - Tech stack
- `.vybe/project/conventions.md` - Standards
- `.vybe/project/outcomes.md` - Current stage

**Feature Context (as relevant):**
- `.vybe/features/[relevant]/` - Specs for discussed features
- `.vybe/backlog.md` - Project priorities

### Tasks

#### Task 1: Load Full Context
- Load all project documents (mandatory)
- Load relevant feature specifications
- Analyze recent execution history
- Check current blockers and issues

#### Task 2: Understand Discussion Topic
- Parse natural language input
- Classify discussion type (exploration, problem-solving, decision-making)
- Identify relevant context and constraints
- Determine scope and impact

#### Task 3: Analysis & Research
- Review existing patterns and decisions
- Consider technical and business constraints
- Research best practices for the specific context
- Identify root causes and implications

#### Task 4: Provide Guidance
- Present multiple solution approaches
- Highlight trade-offs and implications
- Suggest concrete next steps
- Recommend plan updates if needed

#### Task 5: Suggest Actions
- Recommend specific command sequences
- Propose plan modifications
- Suggest architecture adjustments
- Identify additional research needs

### Discussion Types

#### Technical Exploration
- Architecture decisions
- Technology selection
- Design pattern choices
- Performance optimization

#### Problem Solving
- Implementation blockers
- Integration issues
- Performance bottlenecks
- Security concerns

#### Strategic Planning
- Feature prioritization
- Release planning
- Resource allocation
- Risk assessment

### AI Behavior
- **Context-aware**: Use full project knowledge
- **Solution-oriented**: Provide actionable recommendations
- **Balanced**: Present pros/cons fairly
- **Forward-thinking**: Consider long-term implications

### Integration Points
- **To backlog**: Update priorities based on insights
- **To plan**: Recommend specification updates
- **From execute**: Address implementation discoveries
- **To audit**: Identify systematic issues

---

## /vybe:status

**Purpose**: Track progress and provide visibility into project health

### Usage
```bash
/vybe:status [scope]

# Examples
/vybe:status                    # Overall project status
/vybe:status user-auth         # Specific feature status
/vybe:status sprint            # Current sprint progress
/vybe:status blockers          # Show current blockers
```

### Parameters
- `scope`: Optional focus area (feature-name, sprint, blockers, releases)

### Context Loading

**Mandatory (loaded first):**
- `.vybe/project/overview.md` - Business context
- `.vybe/project/architecture.md` - Tech stack
- `.vybe/project/conventions.md` - Standards
- `.vybe/project/outcomes.md` - Stage progression

**Progress Context:**
- `.vybe/backlog.md` - Overall project status
- `.vybe/features/*/status.md` - All feature progress
- `.vybe/features/*/tasks.md` - Task breakdown

### Tasks

#### Task 1: Gather Status Data
- Read all feature status.md files
- Calculate progress metrics
- Identify current sprint tasks
- Check for blockers and dependencies

#### Task 2: Analyze Progress
- Calculate completion percentages
- Track velocity and trends
- Identify at-risk items
- Check sprint capacity

#### Task 3: Generate Reports
- **Overall**: Project health dashboard
- **Feature**: Detailed feature progress
- **Sprint**: Current sprint status
- **Blockers**: Issues requiring attention

#### Task 4: Recommend Actions
- Suggest next tasks to prioritize
- Identify bottlenecks
- Recommend resource allocation
- Flag items for discussion

### Status Reporting

#### Project Dashboard
```
🎯 Project: E-commerce Platform
📊 Overall Progress: ████████░░░░░░░░░░░ 42%

🚀 Active Features (3/7)
├─ user-authentication    ████████████░░░░░ 65%
├─ payment-integration   ██████░░░░░░░░░░░░ 30%  
└─ product-catalog       ██░░░░░░░░░░░░░░░░ 10%

📋 Current Sprint (Week 1 of 2)
├─ ✅ auth-task-1: Database schema
├─ 🔄 auth-task-2: JWT implementation (60%)
├─ ⏸️ auth-task-3: Login endpoint (blocked)
└─ ⏸️ auth-task-4: Frontend integration

⚠️ Blockers (1):
└─ auth-task-3: Waiting for security review

🎯 Next Actions:
1. Complete auth-task-2 (JWT implementation)
2. Resolve security review blocker
3. Prepare payment-integration planning
```

### AI Behavior
- **Data-driven**: Use actual metrics, not estimates
- **Actionable**: Provide clear next steps
- **Realistic**: Account for blockers and dependencies
- **Visual**: Use progress indicators and charts

### Integration Points
- **From execute**: Get real-time task updates
- **To discuss**: Escalate blockers and risks
- **To audit**: Identify systematic issues
- **To backlog**: Feed velocity data for planning

---

## /vybe:audit (Hybrid Architecture)

**Purpose**: Quality assurance with specialized code-reality analysis modes

**Performance**: External script provides efficient file scanning, AI delivers intelligent gap detection and analysis

### Usage
```bash
/vybe:audit [mode] [options]

# Code-Reality Analysis Modes (NEW)
/vybe:audit code-reality           # Compare docs vs actual implementation
/vybe:audit scope-drift            # Detect feature creep beyond original vision
/vybe:audit business-value         # Map features to business outcomes, find orphan code
/vybe:audit documentation          # Sync README/docs with actual code
/vybe:audit mvp-extraction         # Extract minimal viable scope for timeline constraints

# Traditional Quality Assurance
/vybe:audit                        # Full project audit
/vybe:audit --scope=features       # Audit feature specifications
/vybe:audit --fix                  # Show and apply fixes
/vybe:audit --fix --auto          # Auto-fix safe issues
```

### Code-Reality Analysis Modes

#### code-reality
**Purpose**: Compare documented intentions vs actual implementation
- Analyzes actual source code vs project documentation
- Identifies gaps between planned and implemented features
- Detects outdated specifications that don't match code
- Provides specific alignment recommendations

#### scope-drift
**Purpose**: Detect feature creep beyond original project vision
- Compares current implementation vs original outcomes.md vision
- Identifies features added without business justification
- Calculates scope expansion percentage
- Suggests scope reduction strategies

#### business-value
**Purpose**: Map implemented features to business outcomes
- Analyzes actual code to identify all implemented features
- Maps features to business outcomes from outcomes.md
- Identifies orphan features with no business justification
- Provides cost/value analysis with maintenance burden estimates

#### documentation
**Purpose**: Synchronize documentation with actual implementation
- Compares README.md claims vs actual source code features
- Identifies missing, incorrect, or outdated documentation
- Suggests specific updates to align docs with reality
- Ensures API documentation matches actual endpoints

#### mvp-extraction
**Purpose**: Extract minimal viable scope for timeline constraints
- Analyzes all implemented and planned features
- Identifies core vs nice-to-have functionality
- Provides scope reduction recommendations for time constraints
- Suggests feature deferral strategies

### Parameters
- `mode`: Specific analysis mode (code-reality, scope-drift, business-value, documentation, mvp-extraction)
- `--timeline=Ndays`: For mvp-extraction, specify timeline constraint
- `--scope=area`: Focus on specific area (features, sprints, docs, tasks)
- `--fix`: Show proposed fixes and apply with approval
- `--auto`: Automatically fix safe issues
- `--interactive`: Step through issues one by one

### Context Loading

**Mandatory (loaded first):**
- `.vybe/project/overview.md` - Business context
- `.vybe/project/architecture.md` - Tech stack
- `.vybe/project/conventions.md` - Standards
- `.vybe/project/outcomes.md` - Business outcomes

**Validation Context (if template exists):**
- `.vybe/validation/` - Compliance rules
- `.vybe/enforcement/` - Structure requirements

**Full Project Context:**
- `.vybe/backlog.md` - Project status
- `.vybe/features/*/` - All feature specs
- Source code files for analysis

### Tasks

#### Task 1: Load Complete State
- Read all project and feature documents
- Analyze actual source code and implementation
- Load outcomes.md and business context
- Check sprint organization and capacity

#### Task 2: Mode-Specific Analysis
- **Code-Reality**: Compare docs vs implementation reality
- **Scope-Drift**: Measure expansion beyond original vision
- **Business-Value**: Map features to outcomes, find orphans
- **Documentation**: Identify doc-code misalignment
- **MVP-Extraction**: Identify minimal viable feature set

#### Task 3: Project-Specific Insights
- Analyze YOUR actual project (no hardcoded examples)
- Generate insights based on YOUR source code
- Provide recommendations specific to YOUR context
- Calculate metrics from YOUR actual implementation

#### Task 4: Generate Structured Report
- Categorize issues by severity and type
- Provide specific, actionable recommendations
- Include quantitative analysis (LOC, files, complexity)
- Suggest concrete next steps

#### Task 5: Apply Fixes (Traditional Audit)
- Propose specific changes for quality issues
- Show before/after previews
- Apply with user approval
- Update affected documents

### AI Behavior Guidelines
- **Project-Specific**: All analysis based on actual project, never generic examples
- **Code-Aware**: Analyzes real source code, not assumptions
- **Outcome-Focused**: Ties all recommendations to business value
- **Quantitative**: Provides measurable insights (LOC, complexity, time estimates)
- **Actionable**: Every recommendation includes specific next steps

### Integration Points
- **From discuss**: Smart routing from natural language to appropriate modes
- **To plan**: Update specifications based on reality analysis
- **To backlog**: Identify missing or redundant features
- **From status**: Current project state feeds analysis

---

## Command Integration Matrix

| From → To | Purpose | Data Flow |
|-----------|---------|-----------|
| init → backlog | Initial feature ideas | Project analysis → feature suggestions |
| backlog → plan | Feature selection | Prioritized features → detailed specs |
| plan → execute | Task implementation | Specifications → working code |
| execute → status | Progress tracking | Task completion → metrics |
| execute → discuss | Problem escalation | Blockers → solutions |
| discuss → backlog | Strategy updates | Insights → priority changes |
| discuss → plan | Spec refinement | Discoveries → updated requirements |
| status → audit | Quality monitoring | Progress data → health checks |
| audit → plan | Consistency fixes | Issues → spec updates |
| audit → backlog | Feature gap identification | Analysis → missing features |

## Implementation Guidelines

### Living Documents Philosophy
- **Generate Starting Points**: Commands create initial documents as foundation
- **Edit Freely**: Users can modify any document with any editor at any time
- **AI-Assisted Changes**: Use `--modify` options for specific AI help
- **No Approval Gates**: No acceptance ceremonies, documents evolve naturally
- **Consistency Checking**: Use `/vybe:audit` when alignment verification needed

### Error Handling
- Validate project initialization before most commands
- Provide clear error messages with suggested fixes
- Offer recovery options for common failures
- Preserve existing work during updates

### State Management
- Each feature maintains independent state
- Commands load full context before execution
- Changes update relevant status documents
- Preserve user customizations during updates

### Natural Language Processing
- Accept conversational input for all commands
- Infer intent from context and history
- Confirm ambiguous requests before proceeding
- Support both structured and freeform input

### Quality Standards
- Follow existing project patterns consistently
- Maintain comprehensive documentation
- Include testing strategy in all implementations
- Ensure accessibility and security by design

---

## Performance Architecture Summary

### Hybrid Architecture Achievements

**Revolutionary Optimization**: All 9 commands converted from micro-operations to hybrid architecture:
- **Before**: 99 bash blocks across all commands = 99 Claude Code executions
- **After**: 9 external scripts + 9 AI analyses = 18 total operations  
- **Result**: 5.5x reduction in Claude Code operations + 20-120x faster file operations

### Shared Cache System Features

**Universal Cache Benefits**:
- **MCP Integration**: Automatic `claude mcp add vybe-cache` registration
- **File System Fallback**: Works offline when MCP unavailable
- **Cross-Command Benefits**: Shared project data across all commands
- **Smart Invalidation**: Automatic updates on file modifications

**Performance Metrics**:
- **Help System**: 0.003-0.14 second response times for all help commands
- **Cache Hit Benefits**: 20-120x faster subsequent command execution
- **Memory Efficiency**: Smart LRU cache with persistent benefits

### Architecture Components

Each command now uses:
1. **External Script**: Bulk file operations, technology installation, cache management
2. **AI Analysis**: Sophisticated logic, intelligence, decision-making
3. **Shared Cache**: Cross-command data sharing via MCP protocol
4. **Instant Help**: Zero-latency help system with comprehensive examples

**Zero Functionality Loss**: All sophisticated AI capabilities preserved including RICE/WSJF scoring, auto-assignment intelligence, code-reality analysis, multi-developer coordination, and template enforcement.

This specification provides the complete foundation for implementing all Vybe commands with **high-performance hybrid architecture** and quality.
# Vybe Command Specifications

**Detailed implementation specifications for all Vybe framework commands**

Version: 2.0.0  
Created: 2025-08-14  
Updated: 2025-08-15  
Status: Production Implementation Guide

## Overview

This document provides detailed specifications for implementing Vybe framework commands. Each command specification includes tasks, processes, AI behavior guidelines, and integration points.

## Command Flow

```
init → backlog → plan → execute → release → status → audit
         ↑                           ↓
         └── discuss (smart routing) ←┘
```

### Command Responsibilities

| Command | Scope | Focus | Output |
|---------|-------|-------|--------|
| `init` | Project | Staged outcome setup | Project docs, outcome roadmap |
| `backlog` | Strategic | Outcome-grouped planning | Tasks by stages, member assignments |
| `plan` | Tactical | Feature specifications | Requirements, design, tasks |
| `execute` | Implementation | Task execution | Working code, status updates |
| `release` | **NEW** | Stage progression | Mark complete, advance, capture learnings |
| `status` | Monitoring | Progress + outcomes | Progress reports, outcome timeline |
| `audit` | **ENHANCED** | Quality + code-reality | Issue reports, specialized analysis |
| `discuss` | **ENHANCED** | Natural language + routing | Insights, automated audit routing |

---

## /vybe:init

**Purpose**: Initialize project with AI-generated foundation and structure

### Usage
```bash
/vybe:init [project-description]
```

### Parameters
- `project-description`: Optional description for new projects or documentation updates

### Tasks
1. **Analyze Project State** - Detect git, code files, existing documentation
2. **Create Directory Structure** - Set up .vybe hierarchy
3. **Generate Project Overview** - Business context and goals
4. **Document Architecture** - Technology stack and patterns  
5. **Extract Conventions** - Coding standards from existing code
6. **Update Project Files** - README, .gitignore, CLAUDE.md

### Process
- **New Project**: Generate based on description
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

## /vybe:execute

**Purpose**: Execute implementation tasks with automatic code generation, testing, and multi-member coordination

### Enhanced Capabilities
- **Automatic code generation** following template patterns and project conventions
- **Unit testing after each task** with auto-fix capabilities
- **Integration testing at stage gates**
- **Multi-member coordination** with role-based assignments
- **Template enforcement** when available (highest priority)
- **Intelligent error handling** with human alerts when needed

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
- **PROJECT DOCS**: Load all mandatory project documents
- **FEATURE SPECS**: Load feature specifications for context
- **MULTI-MEMBER**: Check role assignments and team coordination
- **TASK DETAILS**: Read current task from tasks.md and dependencies

#### Task 2: Determine Project Structure
- **Template Structure**: Use template-defined structure exactly (NO deviations)
- **Architecture Structure**: Follow specified technology stack and patterns
- **Intelligent Structure**: Determine based on task requirements (last resort)
- **First Task Setup**: Create clean project structure if this is first task

#### Task 3: Execute Implementation
- **Template-Driven Code**: Use exact patterns from `.vybe/patterns/`
- **Document-Driven Code**: Follow `architecture.md` and `conventions.md`
- **Intelligent Code**: Apply best practices for detected project type
- **Multi-Member Coordination**: Respect role assignments and branch management
- **ACTUAL CODE GENERATION**: Create real, runnable files using Write/Edit tools

#### Task 4: Unit Testing
- **Test Creation**: Generate comprehensive unit tests for implemented code
- **Template Test Patterns**: Use template test structures if available
- **Auto Execution**: Run tests immediately after implementation
- **Auto-Fix**: Handle simple test failures automatically
- **Human Alert**: Escalate complex issues to human attention

#### Task 5: Git Coordination
- **Branch Management**: Create/switch to feature branches for team coordination
- **Session Tracking**: Track multi-session development work
- **Conflict Detection**: Handle merge conflicts and coordination issues
- **Tested Commits**: Only commit code that passes tests

#### Task 6: Stage Gate Integration (if stage complete)
- **Integration Tests**: Run end-to-end and integration test suites
- **Requirements Validation**: Verify all acceptance criteria are met
- **Template Compliance**: Ensure no pattern violations occurred
- **Run Instructions**: Provide clear instructions for starting/testing application
- **Demo Commands**: Show specific commands to test the working software

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

## /vybe:discuss

**Purpose**: Explore ideas, solve problems, and guide iterative improvements

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

## /vybe:audit

**Purpose**: Quality assurance with specialized code-reality analysis modes

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

This specification provides the complete foundation for implementing all Vybe commands with consistency and quality.
# Vybe Command Specifications

**Detailed implementation specifications for all Vybe framework commands**

Version: 1.0.0  
Created: 2025-08-14  
Status: Implementation Guide

## Overview

This document provides detailed specifications for implementing Vybe framework commands. Each command specification includes tasks, processes, AI behavior guidelines, and integration points.

## Command Flow

```
init → backlog → plan → execute → status → audit → discuss → (loop back)
```

### Command Responsibilities

| Command | Scope | Focus | Output |
|---------|-------|-------|--------|
| `init` | Project | Foundation setup | Project docs, structure |
| `backlog` | Strategic | Cross-feature planning | Feature prioritization, releases |
| `plan` | Tactical | Single feature specs | Requirements, design, tasks |
| `execute` | Implementation | Task execution | Working code, status updates |
| `status` | Monitoring | Progress tracking | Progress reports, next steps |
| `audit` | Quality | Health checking | Issue reports, fixes |
| `discuss` | Discovery | Problem solving | Insights, plan updates |

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

### AI Behavior
- Document what IS (existing) vs what WILL BE (new)
- Extract real patterns from code, not assumptions
- Respect existing conventions while suggesting improvements

### Output Files
- `.vybe/project/overview.md`
- `.vybe/project/architecture.md`
- `.vybe/project/conventions.md`
- `.vybe/backlog.md` (empty, managed by backlog command)

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

**Purpose**: Create detailed specifications for individual features

### Usage  
```bash
/vybe:plan [feature-name] [description]

# Examples
/vybe:plan user-authentication "JWT-based auth with refresh tokens"
/vybe:plan user-authentication "add OAuth2 provider support"  # Update existing
/vybe:plan payment-integration "Stripe subscription billing"
```

### Parameters
- `feature-name`: Kebab-case feature identifier
- `description`: What to build or modify for this feature

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
- **Approval gate**: Review before proceeding

#### Task 4: Technical Design
- Create detailed design.md
- Define architecture and component design
- Document API contracts and data models
- Include security and performance considerations
- **Approval gate**: Review before proceeding

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

**Purpose**: Execute implementation tasks with AI guidance and delegation

### Usage
```bash
/vybe:execute [task-id] [options]

# Examples
/vybe:execute auth-task-1                    # Direct AI execution
/vybe:execute auth-task-1 --assign=@alice    # Delegate to team member
/vybe:execute auth-task-1 --agent=backend    # Delegate to AI agent
/vybe:execute auth-task-1 --guide           # Collaborative execution
```

### Parameters
- `task-id`: Specific task from feature tasks.md
- `--assign=@user`: Delegate to team member
- `--agent=type`: Delegate to specialized AI agent
- `--guide`: Collaborative guidance mode

### Tasks

#### Task 1: Load Context
- Load all project documents (mandatory)
- Load feature specifications for context
- Read current task from tasks.md
- Check task dependencies and prerequisites

#### Task 2: Determine Execution Mode
- **Direct execution**: AI implements the task
- **Delegation**: Assign to human or AI agent
- **Collaboration**: Guide human implementation
- **Validation**: Check if task is ready to execute

#### Task 3: Execute or Delegate
- **Direct**: Implement following project conventions
- **Delegate**: Create detailed brief with context
- **Guide**: Provide step-by-step assistance
- **Track**: Update status and dependencies

#### Task 4: Validation & Updates
- Run tests if available
- Check against acceptance criteria
- Update task status in status.md
- Identify any blockers or discoveries

### Execution Modes

#### Direct Execution
- Follow existing code patterns
- Implement according to design.md
- Create/modify files maintaining consistency
- Write tests for new functionality

#### Delegation Features
- **Smart assignment**: Match skills to task requirements
- **Context preservation**: Full briefing with specifications
- **Progress tracking**: Monitor delegated work
- **Review integration**: Code review and quality checks

#### Collaborative Mode
- **Step-by-step guidance**: Break down complex tasks
- **Code suggestions**: Provide implementation hints
- **Problem solving**: Help with technical decisions
- **Quality assurance**: Review work in progress

### AI Behavior
- **Pattern following**: Consistent with project conventions
- **Quality focused**: Meet acceptance criteria
- **Documentation**: Update progress automatically
- **Problem identification**: Flag issues for discussion

### Integration Points
- **From plan**: Execute well-specified tasks
- **To status**: Update progress automatically
- **To discuss**: Escalate problems and discoveries
- **From audit**: Address quality issues

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

**Purpose**: Maintain project quality through systematic health checks

### Usage
```bash
/vybe:audit [options]

# Examples
/vybe:audit                        # Full project audit
/vybe:audit --scope=features       # Audit feature specifications
/vybe:audit --scope=sprints        # Check sprint organization
/vybe:audit --fix                  # Show and apply fixes
/vybe:audit --fix --auto          # Auto-fix safe issues
```

### Parameters
- `--scope=area`: Focus on specific area (features, sprints, docs, tasks)
- `--fix`: Show proposed fixes and apply with approval
- `--auto`: Automatically fix safe issues
- `--interactive`: Step through issues one by one

### Tasks

#### Task 1: Load Complete State
- Read all project and feature documents
- Analyze task dependencies and status
- Check sprint organization and capacity
- Validate document consistency

#### Task 2: Identify Issues
- **Gaps**: Missing requirements, design elements, tasks
- **Duplicates**: Overlapping features, redundant tasks
- **Inconsistencies**: Conflicting information, outdated docs
- **Orphans**: Tasks without features, untracked work

#### Task 3: Quality Analysis
- Check document freshness vs code changes
- Validate sprint capacity and dependencies
- Review cross-feature consistency
- Identify technical debt accumulation

#### Task 4: Generate Report
- Categorize issues by severity
- Provide specific recommendations
- Estimate effort for fixes
- Suggest consolidation opportunities

#### Task 5: Apply Fixes
- Propose specific changes
- Show before/after previews
- Apply with user approval
- Update affected documents

### Audit Categories

#### Critical Issues
- Missing project initialization
- Broken feature dependencies
- Overloaded sprints (>6 tasks)
- Inconsistent architecture decisions

#### Moderate Issues
- Duplicate functionality across features
- Outdated documentation
- Missing acceptance criteria
- Unbalanced sprint loads

#### Minor Issues
- Formatting inconsistencies
- Missing estimated effort
- Outdated status information
- Incomplete task descriptions

### AI Behavior
- **Comprehensive**: Check all aspects systematically
- **Pattern recognition**: Identify subtle inconsistencies
- **Safe automation**: Only auto-fix non-controversial issues
- **Quality focused**: Maintain high standards consistently

### Integration Points
- **From status**: Get current project state
- **To discuss**: Address complex quality issues
- **To backlog**: Identify missing or redundant features
- **To plan**: Update specifications for consistency

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
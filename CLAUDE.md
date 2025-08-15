# Vybe Framework - Spec-driven Agile Development

**Specification-first workflow with agile backlog management for Claude Code with multi-session coordination**

## Project Context

The Vybe Framework provides a complete agile-like development workflow through 7 core commands that support both solo development and multi-member team coordination.

## Paths & File Locations

### Framework Paths
- **Commands**: `.claude/commands/vybe/`
- **Hooks**: `.claude/hooks/`
- **Session Handoff**: `.claude/SESSION_HANDOFF.md`

### Project Foundation Paths
- **Project Documents**: `.vybe/project/`
- **Overview**: `.vybe/project/overview.md`
- **Architecture**: `.vybe/project/architecture.md`  
- **Conventions**: `.vybe/project/conventions.md`

### Development Paths
- **Backlog**: `.vybe/backlog.md`
- **Features**: `.vybe/features/`
- **Feature Specs**: `.vybe/features/[feature-name]/`
- **Requirements**: `.vybe/features/[feature-name]/requirements.md`
- **Design**: `.vybe/features/[feature-name]/design.md`
- **Tasks**: `.vybe/features/[feature-name]/tasks.md`

### Coordination Paths
- **Session Context**: `.vybe/context/`
- **Session Files**: `.vybe/context/sessions/`
- **Hook Scripts**: `.claude/hooks/pre-tool.sh`, `.claude/hooks/post-tool.sh`
- **Dependency Tracker**: `.claude/hooks/context/dependency-tracker.sh`

### File Reading Priority for Claude Code
1. **ALWAYS READ FIRST**: `.vybe/project/overview.md`, `.vybe/project/architecture.md`, `.vybe/project/conventions.md`
2. **BACKLOG MANAGEMENT**: `.vybe/backlog.md` 
3. **FEATURE SPECS**: `.vybe/features/[feature-name]/requirements.md`, `.vybe/features/[feature-name]/design.md`, `.vybe/features/[feature-name]/tasks.md`
4. **SESSION COORDINATION**: `.vybe/context/sessions/` files
5. **USER PROJECT**: `src/`, `docs/`, `README.md`, language-specific files

### Core Framework Structure
- **Commands**: `.claude/commands/vybe/` - 7 production-ready commands
- **Hooks**: `.claude/hooks/` - Multi-session coordination system
- **Project Foundation**: `.vybe/project/` - Overview, architecture, conventions (created by init)
- **Features**: `.vybe/features/` - Individual feature specifications (created by plan)
- **Backlog**: `.vybe/backlog.md` - Agile backlog with member assignments

## Development Philosophy

### Specification-First Approach
- Every feature starts with clear requirements and design
- EARS format requirements (The system shall...)
- Comprehensive task breakdown before implementation
- Living documentation that evolves with code

### Agile-Like Methodology
- Backlog-driven development with prioritization (RICE/WSJF scoring)
- Member assignment and workload balancing
- Iterative feature development
- Quality assurance with gap detection

## Core Workflow - 7 Commands

### 1. Project Initialization
**`/vybe:init [description]`** - Initialize project with foundation documents
- Creates `.vybe/project/` with overview.md, architecture.md, conventions.md
- Establishes project context for all future decisions
- Sets up git-based coordination infrastructure

### 2. Backlog Management
**`/vybe:backlog [action]`** - Agile backlog management with member coordination
- `member-count [N]` - Configure team with 1-5 developers (dev-1, dev-2, etc.)
- `assign [feature] [dev-N]` - Assign features to specific members
- `init` - Create comprehensive backlog with RICE/WSJF scoring
- `groom` - Clean duplicates, optimize priorities

### 3. Feature Planning
**`/vybe:plan [feature-name] [description]`** - Create detailed feature specifications
- Generates requirements.md with EARS format
- Creates design.md with technical approach  
- Produces tasks.md with implementation steps
- Includes web research for best practices

### 4. Implementation Execution
**`/vybe:execute [task-name]`** - Execute specific tasks with full context
- Member-aware execution with `VYBE_MEMBER` environment variable
- Loads complete project context (overview, architecture, conventions)
- Progress tracking and status updates
- Coordinates with multi-session workflows

### 5. Progress Tracking
**`/vybe:status [scope]`** - "How are we doing?" - Progress and assignments
- Default: Overall project progress
- `members` - Team workload distribution
- `dev-N` - Individual developer progress
- Shows next actions and blockers

### 6. Quality Assurance  
**`/vybe:audit [scope]`** - "What needs fixing?" - Gap detection and fixes
- Detects missing specifications, requirements, tasks
- Finds duplicates and inconsistencies
- Provides automated fix commands
- Quality scoring and recommendations

### 7. Natural Language Help
**`/vybe:discuss [question]`** - Natural language command assistance
- Translates user requests into specific Vybe commands
- Provides guidance on workflow and best practices
- Context-aware suggestions based on project state

## Multi-Member Coordination

### Environment Variables
- **`VYBE_MEMBER`** - Set member role: `export VYBE_MEMBER=dev-1`
- Supports dev-1 through dev-5 (up to 5 team members)
- Used for assignment tracking and conflict detection

### Git-Based Coordination
- Shared GitHub repository required for team projects
- Automatic session tracking via hooks
- Conflict detection and resolution guidance
- Member workload balancing

### Hook System
- **Pre-tool hook**: Session tracking, member role detection
- **Post-tool hook**: Conflict warnings, coordination alerts
- **Dependency tracker**: Task dependencies and member assignments

## Development Rules

### Core Principles
1. **Specification-first**: Always start with `/vybe:init` and `/vybe:plan`
2. **Backlog-driven**: Use `/vybe:backlog` for feature management and assignments
3. **Quality focus**: Regular `/vybe:audit` to catch issues early
4. **Member coordination**: Use `VYBE_MEMBER` for team development
5. **Progress visibility**: Regular `/vybe:status` for tracking

### Command Flow
```
/vybe:init → /vybe:backlog → /vybe:plan → /vybe:execute → /vybe:status → /vybe:audit
                  ↑                                          ↓
                  └── /vybe:discuss (for guidance) ←--------┘
```

### Team Workflow
1. **Setup**: Create GitHub repository, configure members
2. **Planning**: Initialize backlog, plan features, assign to members  
3. **Development**: Members execute assigned tasks with `VYBE_MEMBER` set
4. **Coordination**: Regular status checks and quality audits
5. **Quality**: Continuous gap detection and fix automation

## Mandatory Context Loading

All commands load complete project context:
- **overview.md** - Business context and goals
- **architecture.md** - Technical decisions and constraints  
- **conventions.md** - Coding standards and practices
- **backlog.md** - Current feature assignments and priorities

This ensures consistent decision-making across all development activities.

## Repository Requirements

### Solo Development
- Local git repository sufficient
- No GitHub required for individual work

### Multi-Member Teams  
- **GitHub repository required** for coordination
- Git-based multi-session coordination
- Shared backlog and assignment tracking

## Platform Support
- **Supported**: Linux, macOS, WSL2, Git Bash
- **Not supported**: Native Windows CMD/PowerShell
- **Output**: ASCII-only (no Unicode issues)

## Success Metrics

### Framework Functionality
- All 7 commands execute without errors
- Generated specifications are useful and accurate
- Multi-session coordination works seamlessly
- Quality assurance catches real issues

### User Experience  
- Commands feel intuitive and natural
- Error messages are helpful
- Learning curve is reasonable
- Workflow feels efficient

The Vybe Framework provides a complete, production-ready system for spec-driven agile development with Claude Code.
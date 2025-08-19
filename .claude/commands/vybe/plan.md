---
description: Create detailed specifications for individual features with mandatory context and web research
allowed-tools: Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS, WebSearch, WebFetch, vybe-cache.get, vybe-cache.set, vybe-cache.mget, vybe-cache.mset
---

# /vybe:plan - Feature Specification Planning

Create comprehensive specifications for individual features with mandatory project context loading, web research, and structured EARS requirements.

## Usage
```
/vybe:plan [stage-name] [options]
/vybe:plan [feature-name] [description] [--auto]  # Legacy support
```

## Parameters

### Stage-Based Planning (Recommended)
- `stage-name`: Stage identifier (e.g., stage-1, stage-2, etc.)
- `--modify "changes"`: Modify stage requirements (e.g., "Change: JavaScript to TypeScript")

### Feature-Based Planning (Legacy)
- `feature-name`: Name of the feature (kebab-case required)  
- `description`: Natural language description of what to build or modify
- `--auto`: Automated mode - Generate complete spec without approval gates

## Automation Modes
- **Interactive** (default): Step-by-step approval for requirements -> design -> tasks
- **Automated** (`--auto`): Generate complete specification without confirmation

## Platform Compatibility
- [OK] Linux, macOS, WSL2, Git Bash
- [NO] Native Windows CMD/PowerShell

## Context
- Content of the plan script: @./.claude/commands/vybe/plan-script.sh

## Your task

**If the first argument is "help", display this help content directly:**

```
COMMANDS:
/vybe:plan [feature-name] [description]     Create detailed feature specifications
/vybe:plan [stage-name] [description]       Plan all features for entire stage

OPTIONS:
--auto                 Automated mode (AI makes decisions without confirmation)
--modify               Modify existing stage-based planning

EXAMPLES:
/vybe:plan user-auth "User login and registration system"
/vybe:plan payment-system "Payment processing with Stripe" --auto
/vybe:plan stage-1 "Plan all features for Stage 1"
/vybe:plan stage-1 --modify "Change: JavaScript to TypeScript"

FEATURES:
- EARS format requirements (The system shall...)
- Technical design with architecture alignment
- Implementation task breakdown
- Web research for best practices

Use '/vybe:plan [feature-name]' to create specifications.
Use '/vybe:execute [feature]' to implement planned features.
```

**Otherwise, review the plan script above and execute it with the provided arguments. The script implements:**

- **Shared Cache Architecture**: Uses project-wide cache shared across all Vybe commands
- **Bulk Processing**: Loads all project data at once using cache + file system fallback  
- **Atomic Updates**: Ensures file and cache consistency during feature planning
- **AI Coordination**: Prepares context for comprehensive feature specification

Execute the script with: `bash .claude/commands/vybe/plan-script.sh "$@"`

## Expected AI Operations

After the script prepares the context, Claude AI should perform comprehensive feature planning:

### 1. Project Context Analysis
- Access cached project data (overview, architecture, conventions)
- Understand project goals, technology stack, and constraints  
- Review existing features and integration requirements
- Analyze team configuration and coordination needs

### 2. Web Research (REQUIRED)
- Research best practices for this feature type
- Find integration patterns and security considerations
- Identify performance optimization opportunities
- Research testing strategies and frameworks appropriate for the tech stack

### 3. Requirements Generation
- Create **EARS format requirements** (The system shall...)
- Define functional and non-functional requirements
- Specify user stories with acceptance criteria
- Include security, performance, and accessibility requirements

### 4. Technical Design
- Ensure architecture alignment with existing project tech stack
- Design components, data models, and API specifications
- Plan integration points with existing features
- Design security measures and error handling strategies

### 5. Task Breakdown
- Create implementation tasks with clear deliverables
- Define testing tasks with specific test cases
- Plan integration tasks with existing system
- Include documentation and deployment tasks

### 6. Team Coordination (if applicable)
- Recommend task assignments for team members
- Analyze dependencies and parallel work opportunities  
- Plan integration coordination between developers

## Output Structure

The planning process generates three specification files:

### `requirements.md`
- **EARS Format Requirements**: "The system shall..." statements
- **User Stories**: As a [role], I want [goal] so that [benefit]
- **Acceptance Criteria**: Specific, testable conditions
- **Non-Functional Requirements**: Performance, security, accessibility

### `design.md`  
- **Architecture Integration**: How feature fits in existing system
- **Component Design**: Modules, classes, and interfaces
- **Data Models**: Database schemas and data structures
- **API Specifications**: Endpoints, request/response formats
- **Security Design**: Authentication, authorization, validation

### `tasks.md`
- **Implementation Tasks**: Step-by-step development work
- **Testing Tasks**: Unit tests, integration tests, e2e tests
- **Integration Tasks**: Connecting with existing features
- **Documentation Tasks**: API docs, user guides, README updates

## Success Metrics
- ✅ **Requirements**: Clear EARS format requirements with acceptance criteria
- ✅ **Design**: Technical design aligned with project architecture
- ✅ **Tasks**: Implementation tasks with clear deliverables and estimates
- ✅ **Research**: Best practices and patterns incorporated from web research
- ✅ **Integration**: Seamless integration with existing project features

## Error Handling
- **Missing context**: Automatic project context loading with error messages
- **Invalid feature names**: Clear formatting requirements with examples
- **Research failures**: Fallback to general best practices
- **File conflicts**: Backup and recovery for existing specifications

The planning system uses shared cache architecture for optimal performance and maintains full project context consistency across all operations.
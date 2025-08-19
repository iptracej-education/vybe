---
description: Execute implementation tasks with automatic code generation, testing, and git-based multi-session coordination
allowed-tools: Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS, Task, TodoWrite
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

## Context
- Content of the execute script: @./.claude/commands/vybe/execute-script.sh

## Your task

**If the first argument is "help", display this help content directly:**

```
COMMANDS:
/vybe:execute [task-id]         Execute specific task from feature
/vybe:execute [stage-name]      Execute all tasks in entire stage
/vybe:execute my-feature        Execute next assigned feature
/vybe:execute my-task           Execute next assigned task

OPTIONS:
--role=dev-N           Execute as specific team member (dev-1 to dev-5)
--guide                Collaborative guidance mode (not direct execution)
--check-only           Validate task readiness without executing
--force                Force execution even if task appears complete

EXAMPLES:
/vybe:execute user-auth-task-1
/vybe:execute stage-1
/vybe:execute my-feature --role=dev-2
/vybe:execute payment-system --guide

FEATURES:
- Member-aware execution with VYBE_MEMBER environment
- Git coordination and professional workflows
- Real application enforcement (no mock implementations)
- Progress tracking and status updates

Use '/vybe:execute [task]' for implementation.
Use '/vybe:status dev-N' to check member progress.
```

**Otherwise, review the execute script above and execute it with the provided arguments. The script implements:**

- **Shared Cache Architecture**: Uses project-wide cache shared across all Vybe commands
- **Bulk Processing**: Loads all project data and feature specifications at once
- **Role-Aware Execution**: Supports multi-developer coordination with VYBE_MEMBER
- **AI Coordination**: Prepares context for sophisticated task execution and code generation

Execute the script with: `bash .claude/commands/vybe/execute-script.sh "$@"`

## Expected AI Operations

After the script prepares the context, Claude AI should perform sophisticated task execution:

### Task Analysis and Setup
1. **Requirement Analysis**: Parse task requirements and acceptance criteria
2. **Architecture Integration**: Align implementation with project architecture and tech stack
3. **Code Context**: Understand existing codebase patterns and conventions
4. **Coordination Planning**: Check dependencies and member assignments

### Implementation Execution
1. **Real Code Generation**: Generate actual working code (NEVER mock/fake implementations)
2. **Convention Adherence**: Follow project coding standards and architectural patterns
3. **Security and Error Handling**: Implement proper validation and error management
4. **Testing Integration**: Create or update relevant test cases

### Git-Based Coordination
1. **Branch Management**: Create feature branches or work on existing ones
2. **Commit Strategy**: Make atomic commits with meaningful messages
3. **Member Coordination**: Handle multi-developer workflows and conflict prevention
4. **Progress Tracking**: Update task status and member assignments

### Validation and Quality Assurance
1. **Test Execution**: Run existing test suites to prevent regressions
2. **Integration Testing**: Verify compatibility with existing features
3. **Performance Validation**: Ensure implementation meets performance requirements
4. **Security Verification**: Validate security measures and data protection

## Multi-Developer Coordination

### Role-Aware Execution
- **VYBE_MEMBER**: Environment variable for developer identity (dev-1 through dev-5)
- **--role=dev-N**: Explicit role specification for session-based work
- **Assignment Tracking**: Automatic coordination with backlog assignments

### Parallel Development
- **Feature Isolation**: Each developer works on assigned features
- **Dependency Management**: Coordinate integration points between developers
- **Conflict Prevention**: Git-based coordination with intelligent merging
- **Progress Synchronization**: Real-time visibility into team development progress

### Collaboration Modes
- **Direct Execution**: Autonomous code generation and implementation
- **Collaborative Guidance**: Step-by-step guidance with human oversight
- **Validation Check**: Readiness verification without implementation

## Task Types and Execution

### Specific Task Execution
```bash
/vybe:execute user-auth-task-1
```
- Executes specific task from feature's tasks.md
- Loads complete task context and requirements
- Implements exact specifications with testing

### Feature-Based Execution
```bash
/vybe:execute my-feature --role=dev-1
```
- Finds next assigned feature for specified developer
- Executes next incomplete task in feature
- Coordinates with team member assignments

### Smart Task Routing
```bash
/vybe:execute my-task
```
- Finds next assigned task across all features
- Prioritizes based on dependencies and deadlines
- Optimizes for current developer's skills and workload

## Implementation Standards

### Code Quality Requirements
- **🚫 FORBIDDEN**: Mock APIs, fake data, placeholder implementations
- **🚫 FORBIDDEN**: Functions named `mock_*`, `fake_*`, `dummy_*`, `placeholder_*`
- **🚫 FORBIDDEN**: Comments saying "In production, this would..."
- **✅ REQUIRED**: Real API integrations with proper error handling
- **✅ REQUIRED**: Actual working functionality with user value
- **✅ REQUIRED**: Clear failure messages when dependencies are unavailable

### Testing and Validation
- **Unit Tests**: Create comprehensive test coverage for new functionality
- **Integration Tests**: Verify compatibility with existing system components
- **End-to-End Tests**: Validate complete user workflows and scenarios
- **Performance Tests**: Ensure scalability and response time requirements

### Security and Best Practices
- **Input Validation**: Sanitize and validate all user inputs
- **Authentication**: Implement proper user authentication and session management
- **Authorization**: Enforce role-based access control and permissions
- **Data Protection**: Encrypt sensitive data and follow privacy regulations

## Git Workflow Integration

### Professional Development Patterns
- **Feature Branches**: Create branches for feature development
- **Atomic Commits**: Make focused commits with clear messages
- **Pull Request Ready**: Prepare code for review and integration
- **CI/CD Compatible**: Ensure compatibility with existing pipelines

### Multi-Session Coordination
- **Session Tracking**: Monitor active development sessions
- **Conflict Detection**: Identify potential merge conflicts early
- **Coordination Alerts**: Notify developers of coordination needs
- **Integration Planning**: Plan feature integration and testing

## Success Metrics
- ✅ **Working Implementation**: Functional code that meets requirements
- ✅ **Quality Standards**: Code follows project conventions and best practices
- ✅ **Test Coverage**: Comprehensive testing with no regressions
- ✅ **Team Coordination**: Seamless multi-developer collaboration
- ✅ **Git Integration**: Professional development workflow compatibility

## Error Handling
- **Missing context**: Automatic project and feature context loading
- **Invalid tasks**: Clear task format requirements and examples
- **Git conflicts**: Intelligent conflict detection and resolution guidance
- **Member conflicts**: Workload balancing and assignment coordination

The execution system uses shared cache architecture for optimal performance while providing sophisticated code generation, multi-developer coordination, and professional git workflow integration.
# Task Delegate

Delegate specific tasks to specialized subagents with focused context and scope.

## Usage

```
/vybe:task-delegate [agent-type] [feature-task-range] [description]
```

## Parameters

- `agent-type`: Type of specialized agent (backend, frontend, testing, debug, etc.)
- `feature-task-range`: Task identifier(s) in format feature-name-number
  - Single: `user-auth-1`
  - Multiple: `user-auth-1,user-auth-3,user-auth-5`
  - Range: `user-auth-4-7`
  - Mixed: `user-auth-1,user-auth-3-5,user-auth-9`
- `description`: Additional context or specific instructions for the subagent

## Examples

```bash
# Single task delegation
/vybe:task-delegate backend user-auth-1 "implement user model with bcrypt password hashing"

# Multiple task delegation
/vybe:task-delegate frontend user-auth-4,user-auth-5 "create login form with validation"

# Range delegation
/vybe:task-delegate testing user-auth-6-8 "comprehensive auth testing suite"

# Cross-feature delegation
/vybe:task-delegate database user-auth-2,profile-3 "user data models and migrations"
```

## Agent Types

### Predefined Types
- `backend`: Server-side development and APIs
- `frontend`: Client-side UI and user experience
- `database`: Data modeling and migrations
- `testing`: Unit, integration, and E2E testing
- `debug`: Investigation and troubleshooting
- `security`: Security analysis and vulnerability fixes
- `performance`: Optimization and profiling
- `documentation`: Technical documentation

### Custom Types
You can use any agent type name. The system will create a specialized context based on the type.

## How It Works

1. **Validation**: Automatically runs `/vybe:validate-hooks` to check system readiness
2. **Fallback Detection**: If hooks unavailable, switches to manual context mode
3. **Pre-hook/Manual Save**: Saves current session context (via hooks or git commits)
4. **Context Injection**: Loads relevant files, dependencies, and task specifications
5. **Subagent Launch**: Creates focused agent with specific expertise and scope
6. **Task Execution**: Subagent works within defined boundaries
7. **Post-hook/Manual Restore**: Integrates results and updates task status

## Context Injection

The subagent receives:
- Task specifications from `.vybe/specs/[feature]/tasks.md`
- Relevant source files based on task requirements
- Previous task outputs if dependencies exist
- Project steering documents for consistency
- Agent-type specific context and tools

## Task Status Updates

Tasks are automatically updated in the specification files:
- `pending` → `in_progress` when delegation starts
- `in_progress` → `completed` when subagent finishes successfully
- `in_progress` → `failed` if subagent encounters unresolvable issues

## Dependencies

If a task has dependencies, the system will:
- Check that all prerequisite tasks are completed
- Block execution if dependencies are not met
- Provide dependency outputs as context when ready

## Multi-Session Support

For complex tasks requiring multiple sessions:
- Use `/vybe:task-continue` to resume work
- Session state is automatically preserved
- Context accumulates across sessions

## Integration with Existing Commands

Works seamlessly with:
- `/vybe:spec-tasks` - Generates the tasks that can be delegated
- `/vybe:spec-status` - Shows delegation and completion status
- All other vybe commands - Maintains consistency with the framework

## Best Practices

1. **Specific Descriptions**: Provide clear, actionable descriptions
2. **Appropriate Agent Types**: Match agent expertise to task requirements
3. **Logical Grouping**: Group related tasks for efficient context sharing
4. **Dependency Awareness**: Understand task prerequisites before delegation
5. **Regular Status Checks**: Monitor progress with `/vybe:spec-status`

## PreCompact Integration

### Automatic Context Protection
The task delegation system integrates with Claude Code's PreCompact hook:

1. **PreCompact Hook**: Automatically triggers when Claude Code approaches context limits
2. **State Preservation**: All work, progress, and context saved before compaction
3. **Continuation Instructions**: Clear guidance on resuming work after compaction
4. **No Work Loss**: Even if `/compact` happens, all context is preserved

### How It Works
```bash
# Start delegation
/vybe:task-delegate debug complex-issue "investigate performance"

# Work continues... context grows...
# When Claude Code is about to compact:
# → PreCompact hook automatically triggers
# → Saves complete state to .vybe/context/precompact/
# → Shows continuation instructions

# After compaction (or in new session):
/vybe:task-continue debug complex-issue session-abc123
# → Resumes exactly where you left off
```

### Manual Pause Option
You can also manually pause before hitting limits:
```bash
# Pause at logical stopping point
/vybe:task-pause "found the root cause, implementing fix next"

# Exit session voluntarily
exit

# Resume in fresh session
/vybe:task-continue debug complex-issue session-abc123
```

### Benefits
- **No /compact interruptions**: Work continues seamlessly across sessions
- **Fresh context windows**: Each continuation starts with clean context
- **Complete state preservation**: Nothing is lost during transitions
- **Controlled handoffs**: Choose when to pause for optimal workflow

## Notes

- Hook validation runs automatically - no manual configuration needed
- Fallback mode provides 80% functionality without hooks
- Task identifiers must exist in the feature specifications
- Subagents work within defined scope to maintain context limits
- All work is logged and auditable regardless of context mode
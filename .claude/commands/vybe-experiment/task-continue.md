# Task Continue

Resume multi-session agent work from a previously saved state. This command allows complex tasks like debugging or investigation to span multiple sessions while maintaining context continuity.

## Usage

```
/vybe:task-continue [agent-type] [feature-task] [session-id]
```

## Parameters

- `agent-type`: Type of agent that was working on the task
- `feature-task`: Single task identifier (e.g., `user-auth-integration`)
- `session-id`: Previous session identifier to resume from

## Examples

```bash
# Resume debugging session
/vybe:task-continue debug user-auth-integration session-abc123

# Continue frontend work
/vybe:task-continue frontend dashboard-layout session-def456

# Resume performance investigation
/vybe:task-continue performance api-optimization session-ghi789
```

## How It Works

1. **Session Lookup**: Finds the specified session in `.vybe/context/sessions/`
2. **Context Restoration**: Loads previous session state, variables, and progress
3. **State Injection**: Provides accumulated context from previous sessions
4. **Agent Resume**: Continues work with full historical context
5. **Progress Update**: Maintains continuity of investigation or work

## Session State Management

### What Gets Preserved
- Working variables and discoveries
- Error states and debugging progress
- Code changes and experimental attempts
- Investigation trails and hypotheses
- Partial implementations and notes

### Context Files
- `session-[id].json`: Core session metadata
- `task-state-[feature-task].json`: Task-specific working state
- `debug-log-[session-id].txt`: Debugging trail and discoveries
- `code-changes-[session-id].diff`: Code modifications attempted

## Use Cases

### Debugging Sessions
```bash
# Session 1: Initial investigation
/vybe:task-delegate debug user-auth-integration "investigate login failures"
# Discovers potential race condition, needs more investigation

# Session 2: Continue debugging
/vybe:task-continue debug user-auth-integration session-abc123
# Confirms race condition, identifies root cause

# Session 3: Final resolution
/vybe:task-continue debug user-auth-integration session-abc123
# Implements fix and validates solution
```

### Complex Feature Development
```bash
# Session 1: Start complex feature
/vybe:task-delegate frontend dashboard-redesign "modernize dashboard UI"
# Completes component architecture, needs more time for implementation

# Session 2: Continue implementation
/vybe:task-continue frontend dashboard-redesign session-def456
# Implements core components, discovers integration challenges

# Session 3: Final integration
/vybe:task-continue frontend dashboard-redesign session-def456
# Resolves integration issues and completes feature
```

### Performance Optimization
```bash
# Session 1: Performance analysis
/vybe:task-delegate performance api-bottleneck "optimize slow API endpoints"
# Identifies bottlenecks, plans optimization strategy

# Session 2: Implementation
/vybe:task-continue performance api-bottleneck session-ghi789
# Implements optimizations, runs benchmarks

# Session 3: Validation
/vybe:task-continue performance api-bottleneck session-ghi789
# Validates improvements, documents results
```

## Session Management

### Finding Session IDs
```bash
# List recent sessions for a task
ls .vybe/context/sessions/ | grep user-auth-integration

# View session details
cat .vybe/context/sessions/session-abc123.json

# Check task progress
grep user-auth-integration .vybe/context/task-updates.log
```

### Session Cleanup
Old sessions are automatically archived after completion. Manual cleanup:
```bash
# Archive completed sessions older than 30 days
find .vybe/context/sessions/ -name "*.json" -mtime +30 -exec mv {} .vybe/context/archive/ \;
```

## Integration with Dependencies

When continuing a task that other tasks depend on:
- Dependent tasks remain blocked until continuation completes
- Progress updates notify dependent tasks when ready
- Context flows properly to waiting tasks

## Error Recovery

If a session becomes corrupted or unresumable:
```bash
# Reset task to pending state
/vybe:task-reset user-auth-integration

# Start fresh delegation
/vybe:task-delegate debug user-auth-integration "restart investigation"
```

## Best Practices

1. **Regular Commits**: Commit progress frequently during long sessions
2. **Clear State**: Document discoveries and progress in session notes
3. **Session Limits**: Break very long tasks into multiple sub-tasks
4. **Context Cleanup**: Remove unnecessary context to maintain performance
5. **Progress Tracking**: Update task descriptions with current state

## Limitations

- Only supports single task continuation (not task ranges)
- Requires original session to have proper state saving
- Cannot resume if session files are corrupted
- Limited to tasks that support multi-session patterns

## Notes

- This command requires the hook system to be configured
- Session state is automatically saved by pre/post hooks
- Complex debugging sessions may accumulate significant context
- Use judiciously to avoid context window issues
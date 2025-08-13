# Task Status

Check the status of tasks, their dependencies, and delegation progress across the project.

## Usage

```
/vybe:task-status [feature-task-range]
```

## Parameters

- `feature-task-range`: Optional. Specific tasks to check status for
  - Single: `user-auth-1`
  - Multiple: `user-auth-1,user-auth-3`
  - Range: `user-auth-4-7`
  - Feature: `user-auth` (all tasks in feature)
  - All: (no parameter) - shows all active tasks

## Examples

```bash
# Check status of all tasks
/vybe:task-status

# Check specific task
/vybe:task-status user-auth-1

# Check multiple tasks
/vybe:task-status user-auth-1,user-auth-3,user-auth-5

# Check task range
/vybe:task-status user-auth-4-7

# Check all tasks in a feature
/vybe:task-status user-auth
```

## Output Format

```
Task Status Report
==================

Feature: user-authentication
├── user-auth-1: ✅ completed (backend-agent, session-abc123)
├── user-auth-2: 🔄 in_progress (backend-agent, session-def456)
├── user-auth-3: ⏳ pending
├── user-auth-4: ⏸️  waiting_for_dependencies (depends on: user-auth-1,user-auth-2)
├── user-auth-5: ❌ failed (frontend-agent, session-ghi789)
└── user-auth-6: 🔄 in_progress (testing-agent, session-jkl012)

Dependencies:
├── user-auth-4 ← user-auth-1,user-auth-2
├── user-auth-5 ← user-auth-1
└── user-auth-6 ← user-auth-1,user-auth-2,user-auth-3

Active Sessions:
├── session-def456: backend-agent working on user-auth-2
├── session-ghi789: frontend-agent failed on user-auth-5
└── session-jkl012: testing-agent working on user-auth-6

Recent Activity:
├── [2025-08-13 14:30] user-auth-1 completed by backend-agent
├── [2025-08-13 14:45] user-auth-2 started by backend-agent
├── [2025-08-13 15:00] user-auth-5 failed - UI component conflicts
└── [2025-08-13 15:15] user-auth-6 started by testing-agent
```

## Status Types

### Task Status
- `✅ completed`: Task finished successfully
- `🔄 in_progress`: Currently being worked on
- `⏳ pending`: Not started, ready to begin
- `⏸️ waiting_for_dependencies`: Blocked by prerequisite tasks
- `❌ failed`: Encountered unresolvable issues
- `🔄 paused`: Multi-session task temporarily paused

### Dependency Status
- Shows which tasks are blocking others
- Indicates when dependencies will be resolved
- Highlights circular dependencies (error condition)

### Session Information
- Active sessions and their agents
- Failed sessions requiring attention
- Session duration and progress indicators

## Dependency Management

### Checking Dependencies
```bash
# Show dependency graph
/vybe:task-status --dependencies

# Show tasks waiting for specific task
/vybe:task-status --waiting-for user-auth-1

# Show critical path
/vybe:task-status --critical-path
```

### Resolving Blocked Tasks
When tasks are `waiting_for_dependencies`:
1. Check which prerequisite tasks need completion
2. Delegate or work on blocking tasks first
3. Monitor automatic dependency resolution

## Integration with Other Commands

### With Task Delegation
```bash
# Check what's ready to delegate
/vybe:task-status --ready

# Delegate next available task
/vybe:task-delegate backend $(vybe:task-status --next-backend)
```

### With Spec Status
```bash
# Combined feature and task status
/vybe:spec-status user-authentication
/vybe:task-status user-auth
```

## Session Management

### Active Sessions
- Shows which agents are currently working
- Indicates session duration and progress
- Helps identify stuck or long-running sessions

### Failed Sessions
- Lists sessions that need attention
- Provides failure reasons and recovery options
- Suggests retry or alternative approaches

## Filtering and Querying

### Filter by Status
```bash
# Show only failed tasks
/vybe:task-status --status failed

# Show only active work
/vybe:task-status --status in_progress

# Show ready tasks
/vybe:task-status --status pending
```

### Filter by Agent Type
```bash
# Show backend tasks
/vybe:task-status --agent backend

# Show testing tasks
/vybe:task-status --agent testing
```

### Filter by Feature
```bash
# Show specific features
/vybe:task-status --feature user-auth,dashboard
```

## Performance Monitoring

### Task Metrics
- Average completion time by task type
- Agent efficiency by type
- Bottleneck identification
- Success/failure rates

### Session Metrics
- Session duration patterns
- Context window usage
- Handoff efficiency
- Error frequency

## Troubleshooting

### Common Issues
1. **Circular Dependencies**: Tasks that depend on each other
2. **Stuck Sessions**: Long-running sessions without progress
3. **Failed Dependencies**: Cascade failures from prerequisite tasks
4. **Context Overflow**: Sessions approaching context limits

### Resolution Strategies
```bash
# Reset failed task
/vybe:task-reset user-auth-5

# Break circular dependency
/vybe:task-dependency remove user-auth-3 user-auth-1

# Force dependency resolution
/vybe:task-dependency resolve user-auth-4
```

## Configuration

### Status Display Options
Configure in `.vybe/config.json`:
```json
{
  "status": {
    "show_sessions": true,
    "show_dependencies": true,
    "show_recent_activity": 10,
    "group_by_feature": true
  }
}
```

## Notes

- Status is updated automatically by the hook system
- Historical status is maintained for audit trails
- Can be used for project reporting and progress tracking
- Integrates with external monitoring tools via JSON export
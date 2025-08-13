# Task Pause

Manually pause current work and prepare for continuation. This command works with the PreCompact hook system to ensure work can be resumed seamlessly.

## Usage

```
/vybe:task-pause [reason]
```

## Parameters

- `reason`: Optional description of why pausing (e.g., "debugging complete", "switching focus")

## Examples

```bash
# Simple pause
/vybe:task-pause

# Pause with reason
/vybe:task-pause "found root cause, need fresh session to implement fix"

# Pause during long debugging
/vybe:task-pause "making progress on race condition, continuing later"
```

## How It Works

1. **Save Current State**: Creates checkpoint in `.vybe/context/manual/`
2. **Git Snapshot**: Commits or saves current changes
3. **Generate Instructions**: Provides exact commands to continue work
4. **Clean Exit**: Prepares for graceful session termination

## Output Example

```
Task Paused Successfully
========================

Current Work Saved:
- Agent: debug
- Task: user-auth-integration
- Session: session-abc123

Git Status:
✓ Changes committed to: "WIP: investigating race condition in auth middleware"

To Resume:
/vybe:task-continue debug user-auth-integration session-abc123

Context Location:
.vybe/context/manual/pause-abc123.json

Ready to exit session safely.
```

## Integration with PreCompact

This command complements the automatic PreCompact hook:

### Manual vs Automatic
- **Manual Pause**: You choose when to pause (e.g., at logical breakpoints)
- **PreCompact**: Automatic pause when Claude Code is about to compact

### Best Practice Workflow
```bash
# Start work
/vybe:task-delegate debug complex-issue "investigate performance problem"

# Work for a while...
# When reaching a good stopping point:
/vybe:task-pause "identified bottleneck in database queries"

# Exit session
exit

# Later, in new session:
/vybe:task-continue debug complex-issue session-abc123
```

## Use Cases

### Long Debugging Sessions
- Pause at discovery points
- Save investigation state
- Continue with fresh context

### Context Management
- Voluntarily pause before hitting limits
- Clean handoff between sessions
- Preserve complex state

### Collaboration
- Pause work for handoff to another developer
- Document current state and findings
- Enable easy continuation

## Context Preservation

The pause command saves:
- Current task and agent state
- Git changes and working directory
- Investigation notes and findings
- Session metadata and progress
- Environment variables and settings

## Recovery Options

If resuming fails:
```bash
# Check saved context
ls .vybe/context/manual/
cat .vybe/context/manual/pause-abc123.json

# Manual recovery
git log --oneline -n 5
git status
/vybe:task-status

# Start fresh with context
/vybe:task-delegate debug complex-issue "continuing from previous investigation"
```

## Notes

- Works with or without PreCompact hook
- Always commits or saves git changes
- Provides clear continuation instructions
- Maintains full audit trail
- Compatible with all agent types
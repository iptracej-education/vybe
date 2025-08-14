# Multi-Agent Workflow Implementation Plan

## Overview

Vybe's multi-agent workflow system enables complex collaboration patterns between subagents across single and multiple sessions. This system supports:

- Single-session task completion
- Multi-session debugging and investigation
- Cross-agent dependencies and context inheritance
- Asynchronous agent collaboration

## Core Command: `/vybe:task-delegate`

### Syntax
```bash
/vybe:task-delegate [agent-type] [feature-task-range] [description]
```

### Examples
```bash
# Single task
/vybe:task-delegate backend user-auth-1 "implement user model"

# Multiple tasks
/vybe:task-delegate frontend user-auth-4,user-auth-5 "login form components"

# Task range
/vybe:task-delegate testing user-auth-6-8 "comprehensive auth testing"

# Mixed range
/vybe:task-delegate backend user-auth-1,user-auth-3-5 "core auth backend"
```

## Workflow Patterns

### Pattern 1: Single Subagent Session Handoff

**Flow:**
1. Main session delegates task to subagent
2. Pre-hook saves main session context
3. Subagent completes work in single session
4. Post-hook restores context to main session with results
5. Main session continues with updated context

**Example:**
```bash
# Main session
/vybe:task-delegate backend user-auth-1 "implement user model"
# ✅ Subagent completes and returns to main session
```

### Pattern 2: Multiple Subagents Session Handoff

**Flow:**
1. Subagent A completes initial work
2. Subagent B receives A's results as context
3. Subagent C receives both A and B's results
4. Main session gets cumulative results

**Example:**
```bash
# Subagent A (backend)
/vybe:task-delegate backend user-auth-1,user-auth-2 "auth backend"

# Subagent B (frontend) - inherits A's context
/vybe:task-delegate frontend user-auth-4,user-auth-5 "auth frontend"

# Subagent C (testing) - inherits A+B context
/vybe:task-delegate testing user-auth-6-8 "test complete auth flow"
```

### Pattern 3: Complex Multi-Session Scenario

**Scenario:** Three subagents with different completion patterns:
- Agent 1: Single session completion
- Agent 2: Multi-session debugging
- Agent 3: Depends on both Agent 1 and Agent 2

#### Agent 1: Single Session Completion
```bash
/vybe:task-delegate backend user-auth-1,user-auth-2 "implement auth models"
# ✅ Completes in one session
# Post-hook: Commits results, updates task status to "completed"
# Context: Saved to .vybe/context/user-auth-1-2.json
```

#### Agent 2: Multi-Session Debugging
```bash
# Session 1
/vybe:task-delegate debug user-auth-integration "investigate auth failures"
# 🔄 Partial progress, needs more investigation
# Post-hook: Saves debugging state, marks "in_progress"

# Session 2 (later)
/vybe:task-continue debug user-auth-integration session-abc123
# 🔄 Continues from saved state, more debugging
# Post-hook: Updates debugging state

# Session 3 (even later)
/vybe:task-continue debug user-auth-integration session-abc123
# ✅ Finally resolves the issue
# Post-hook: Marks "completed", saves final resolution
```

#### Agent 3: Dependency-Based Execution
```bash
# Waits for dependencies
/vybe:task-delegate testing user-auth-6-8 "test complete auth flow"

# Pre-hook checks:
# - user-auth-1,user-auth-2 (Agent 1) ✅ completed
# - user-auth-integration (Agent 2) ✅ completed
# - Injects both contexts + resolved debugging info

# ✅ Runs comprehensive tests with all fixes
```

## Required Infrastructure

### 1. Hook System

#### Pre-Tool Hook (`pre-tool.sh`)
- Save current session context
- Check task dependencies
- Prepare subagent context injection
- Log session state

#### Post-Tool Hook (`post-tool.sh`)
- Update task status
- Commit subagent results
- Update dependency tracking
- Restore main session context

### 2. Session Continuity

#### New Command: `/vybe:task-continue`
```bash
/vybe:task-continue [agent-type] [feature-task] [session-id]
```

**Purpose:** Resume multi-session agent work from saved state

### 3. Context Management

#### Directory Structure
```
.vybe/
├── context/
│   ├── sessions/
│   │   ├── session-abc123.json
│   │   └── session-def456.json
│   ├── tasks/
│   │   ├── user-auth-1.json
│   │   ├── user-auth-2.json
│   │   └── user-auth-integration.json
│   └── dependencies/
│       └── dependency-graph.json
```

#### Context Files
- **Session State**: Current working state, variables, progress
- **Task Context**: Completed work, outputs, artifacts
- **Dependency Graph**: Task relationships and completion status

### 4. Dependency Tracking

#### Dependency Configuration
```json
{
  "user-auth-6": {
    "depends_on": ["user-auth-1", "user-auth-2", "user-auth-integration"],
    "status": "waiting_for_dependencies"
  },
  "user-auth-7": {
    "depends_on": ["user-auth-6"],
    "status": "pending"
  }
}
```

#### Status Types
- `pending`: Not started
- `waiting_for_dependencies`: Blocked by dependencies
- `in_progress`: Currently being worked on
- `completed`: Finished successfully
- `failed`: Requires intervention

### 5. Agent Types

#### Predefined Agent Types
- `backend`: Server-side development
- `frontend`: Client-side development
- `database`: Data layer and migrations
- `testing`: Unit, integration, and E2E tests
- `debug`: Investigation and troubleshooting
- `security`: Security analysis and fixes
- `performance`: Optimization and profiling
- `documentation`: Technical documentation

#### Custom Agent Types
Users can define project-specific agent types as needed.

## Implementation Phases

### Phase 1: Basic Hook Infrastructure
- Create `.claude/hooks/` directory structure
- Implement basic pre/post-tool hooks
- Add context save/restore mechanisms
- Set up session logging

### Phase 2: Task Delegation Command
- Implement `/vybe:task-delegate` command
- Add feature-task-range parsing
- Create basic subagent launching
- Implement context injection

### Phase 3: Multi-Session Support
- Add `/vybe:task-continue` command
- Implement session persistence
- Create session recovery mechanisms
- Add debugging state management

### Phase 4: Dependency Management
- Implement dependency tracking
- Add dependency resolution
- Create waiting/blocking mechanisms
- Add dependency visualization

### Phase 5: Advanced Features
- Cross-feature task delegation
- Parallel agent execution
- Agent performance monitoring
- Advanced error recovery

## Benefits

### Development Efficiency
- **Focused Expertise**: Each agent specializes in specific domains
- **Parallel Work**: Multiple agents can work simultaneously
- **Context Preservation**: No loss of important information during handoffs
- **Reduced Context Switching**: Agents maintain focused scope

### Quality Assurance
- **Dependency Verification**: Ensures prerequisites are met
- **Audit Trail**: Complete history of who did what when
- **Error Recovery**: Can resume from any point in the workflow
- **Consistency**: Standardized approaches across the team

### Scalability
- **Large Projects**: Handle complex multi-feature development
- **Team Collaboration**: Multiple developers can work with different agents
- **Long-Running Tasks**: Support for extended debugging and investigation
- **Flexible Workflows**: Adapt to different project requirements

## Usage Guidelines

### When to Use Single Session
- Simple, well-defined tasks
- Independent work that doesn't require debugging
- Quick implementations with clear requirements

### When to Use Multi-Session
- Complex debugging that requires investigation
- Large features that span multiple work sessions
- Integration work that depends on external factors

### When to Use Dependencies
- Tasks that build on each other
- Integration testing that requires completed components
- Documentation that needs finished features

### Best Practices
1. **Clear Task Definitions**: Write specific, actionable task descriptions
2. **Proper Dependency Mapping**: Define dependencies upfront
3. **Regular Status Updates**: Check task progress frequently
4. **Context Documentation**: Maintain clear context in task descriptions
5. **Agent Specialization**: Use appropriate agent types for tasks

## Hook System Validation

### Automatic Validation

The system includes `/vybe:validate-hooks` command to verify hook functionality before delegation.

#### Validation Checks

1. **File System Checks**
   - Hook files exist and are executable
   - Context directories are writable
   - Required utilities are installed (jq, git, bash)

2. **Configuration Checks**
   - Claude Code settings include hook paths
   - Environment variables are set correctly
   - Session tracking is functional

3. **Functional Tests**
   - Pre-hook can save context
   - Post-hook can restore state
   - Dependency tracking works
   - Session persistence functions

4. **Fallback Detection**
   - Identifies when hooks aren't available
   - Enables manual context management
   - Provides alternative workflows

### Integration with Task Delegation

The `/vybe:task-delegate` command automatically:
1. Runs validation before delegation
2. Uses fallback mode if hooks unavailable
3. Warns user about degraded functionality
4. Continues with manual context management

### Fallback Mechanisms

When hooks are not available:

#### Manual Context Management
```bash
# Context saved via git commits
git add -A && git commit -m "Context: Before task delegation"

# State tracked in files
echo "{task: 'user-auth-1', status: 'in_progress'}" > .vybe/context/manual-state.json
```

#### Git-Based State Tracking
- Each subagent commits its work
- State transitions tracked via commits
- Context passed through commit messages

#### File-Based Handoffs
- Context written to `.vybe/context/manual/`
- Subagents read/write known locations
- Session continuity via file persistence

### Validation Command Usage

```bash
# Full validation with report
/vybe:validate-hooks

# Silent check for scripting
/vybe:validate-hooks --silent

# Force fallback mode
/vybe:validate-hooks --fallback
```

### Status Reports

```
Hook System Validation Report
==============================

✓ Hook files installed
✗ Hooks not configured in Claude Code
✓ Dependencies available  
⚠️ Context directory permissions

STATUS: PARTIAL
Fallback: ENABLED
Mode: Manual context management

Recommendations:
1. Configure hooks in Claude Code settings
2. Fix directory permissions: chmod 755 .vybe/context
```

## Proactive Context Management (Future Enhancement)

### Problem Statement
Currently, long-running sessions (especially debugging) can trigger Claude Code's automatic `/compact` command, causing interruption and potential context loss. While hooks save context regularly, they react to tool executions rather than proactively managing context limits.

### Proposed Solution: Context-Aware Session Management

#### Monitoring Approach
```bash
# Pre-tool hook checks context usage
CONTEXT_USAGE=$(estimate_context_usage)
if [ $CONTEXT_USAGE -gt 80 ]; then
    echo "⚠️ Approaching context limit (80% used)"
    echo "Recommended: Save and exit to continue in fresh session"
    
    # Auto-save current state
    save_complete_context
    
    # Suggest continuation command
    echo "To continue: /vybe:task-continue $AGENT_TYPE $TASK $SESSION_ID"
fi
```

#### Implementation Strategy

1. **Context Usage Estimation**
   - Track approximate tokens/characters used
   - Monitor conversation length
   - Estimate remaining context window

2. **Proactive Save Points**
   - Save complete context at 70% usage
   - Warn user at 80% usage
   - Suggest voluntary exit at 90% usage

3. **Seamless Continuation**
   ```bash
   # Before hitting limit
   /vybe:task-pause debug user-auth-bug "Found race condition, need more investigation"
   # Voluntarily exit session
   
   # New session
   /vybe:task-continue debug user-auth-bug session-xyz
   # Continues with full context, fresh window
   ```

#### Benefits
- **No /compact interruptions** - Exit before limit
- **Controlled handoffs** - Choose when to pause
- **Complete context preservation** - Save at optimal points
- **Better user experience** - No unexpected breaks

#### Technical Requirements

1. **Context Tracking**
   - Method to estimate current context usage
   - Could use file sizes, line counts, or character counts as proxy
   - Need research on Claude Code's actual limits

2. **Enhanced Hooks**
   ```bash
   # In pre-tool.sh
   check_context_usage() {
       # Count approximate context size
       TOTAL_CHARS=$(wc -c < session_log)
       MAX_CHARS=100000  # Approximate limit
       USAGE_PERCENT=$((TOTAL_CHARS * 100 / MAX_CHARS))
       echo $USAGE_PERCENT
   }
   ```

3. **User Notifications**
   - Clear warnings about approaching limits
   - Actionable suggestions for continuation
   - Progress preservation confirmation

#### Implementation Phases

**Phase 1: Research**
- Determine Claude Code's actual context limits
- Test methods for measuring context usage
- Identify reliable warning thresholds

**Phase 2: Basic Implementation**
- Add context estimation to hooks
- Implement warning system
- Create manual pause/continue workflow

**Phase 3: Automation**
- Auto-pause at critical thresholds
- Automatic session handoff
- Seamless continuation without user intervention

#### Example Workflow

```bash
# Long debugging session
/vybe:task-delegate debug complex-bug "investigate performance issue"

# After significant work
> ⚠️ Context at 85% - Recommend saving and continuing in fresh session
> All work has been saved to session-abc123
> Run: /vybe:task-continue debug complex-bug session-abc123

# User voluntarily exits

# New session (fresh context)
/vybe:task-continue debug complex-bug session-abc123
> Restored context from session-abc123
> Previous findings: [summary of discoveries]
> Continuing investigation...
```

## Implementation Notes

- Hook validation runs automatically before task delegation
- Fallback mechanisms ensure functionality without hooks
- Manual mode provides degraded but functional operation
- All modes maintain task tracking and dependencies
- Proactive context management planned for future release
- See `.claude/hooks/README.md` for detailed hook configuration
---
description: Member-aware progress tracking with assignment visibility and project health monitoring
allowed-tools: Bash
---

# /vybe:status - Member Progress Tracking

Track progress and provide visibility into project health with member assignment awareness and multi-session coordination.

## Usage
```bash
/vybe:status [scope] [options]

# Examples:
/vybe:status                    # Overall project status
/vybe:status members            # Member assignments and workload
/vybe:status dev-1              # Specific member's assignments and progress
/vybe:status user-auth          # Specific feature status
/vybe:status blockers           # Show current blockers
```

## Scope Options
- **Default**: Overall project health and outcome progression
- **outcomes**: Staged outcome progression and timeline
- **members**: Member assignments, workload distribution, and coordination
- **dev-1, dev-2, dev-3, dev-4, dev-5**: Specific member's assignments and progress (fixed member names)
- **[feature-name]**: Detailed progress for specific feature
- **blockers**: Current blockers and dependencies
- **releases**: Release progress and planning

## Member Names (Fixed)
Member names are always `dev-1`, `dev-2`, `dev-3`, `dev-4`, `dev-5` (up to 5 members max).
- These are **fixed identifiers**, not customizable
- `dev-1` = First project member
- `dev-2` = Second project member  
- etc.

## Examples: Member Status Workflow

### Setup 2-Member Project
```bash
# Setup project with 2 members
/vybe:backlog member-count 2

# Assign features to specific members (by fixed names)
/vybe:backlog assign user-auth dev-1
/vybe:backlog assign payment-processing dev-1  
/vybe:backlog assign product-catalog dev-2
/vybe:backlog assign shopping-cart dev-2
```

### Check Status Views
```bash
# Overall project status
/vybe:status

# All member assignments 
/vybe:status members

# Check what dev-1 is working on
/vybe:status dev-1

# Check what dev-2 is working on  
/vybe:status dev-2

# Check specific feature progress
/vybe:status user-auth

# Check for project blockers
/vybe:status blockers
```

### Individual Member Work
```bash
# Terminal 1 (Member working as dev-1):
export VYBE_MEMBER=dev-1
/vybe:execute my-feature
/vybe:status dev-1           # Check my own progress

# Terminal 2 (Member working as dev-2):
export VYBE_MEMBER=dev-2  
/vybe:execute my-feature
/vybe:status dev-2           # Check my own progress
```

## Member Coordination
- Shows assignments across all project members
- Git-based progress from multiple sessions
- Real-time status from shared files
- Workload balance visualization

## Platform Compatibility
- [OK] Linux, macOS, WSL2, Git Bash
- [NO] Native Windows CMD/PowerShell

## Context
- Content of the status script: @./.claude/commands/vybe/status-script.sh

## Your task

**If the first argument is "help", display this help content directly:**

```
COMMANDS:
/vybe:status                    Overall project progress and health
/vybe:status members            Team assignments and workload distribution
/vybe:status outcomes           Staged outcome progression and timeline
/vybe:status dev-N              Individual developer progress (dev-1 to dev-5)
/vybe:status [feature-name]     Specific feature progress
/vybe:status blockers           Current blockers and dependencies

OPTIONS:
--cache-stats          Show detailed cache performance
--force                Force fresh scan (bypass cache)

EXAMPLES:
/vybe:status
/vybe:status members
/vybe:status dev-1
/vybe:status user-auth
/vybe:status blockers

FEATURES:
- Member-aware progress tracking
- Multi-session coordination support
- Outcome progression monitoring
- Real-time assignment visibility

Use '/vybe:status [scope]' to check progress.
Use '/vybe:audit' for quality issues (different from progress).
```

**Otherwise, review the status script above and execute it with the provided arguments. The script implements:**

- **Bulk Processing**: Single script execution instead of multiple operations
- **Caching**: Cache status operations with invalidation based on modification times
- **Cache Modes**: Cached results vs fresh scan + caching
- **Scope Support**: Overall, members, individual dev-N, feature-specific, and blockers views

Execute the script with: `bash .claude/commands/vybe/status-script.sh "$@"`

## Expected Output
The script will provide:
- Project health dashboard with progress visualization
- Member assignment tracking and workload distribution
- Feature-specific status and completion tracking
- Blocker identification and dependency analysis
- Cache performance metrics and execution timing
- Related Vybe commands for next actions

The status uses caching to speed up subsequent runs with file modification time validation for accuracy.
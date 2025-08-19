---
description: Mark outcome stage complete and advance to next stage
allowed-tools: Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS, vybe-cache.get, vybe-cache.set, vybe-cache.mget, vybe-cache.mset
---

# /vybe:release - Outcome Stage Progression

Mark current outcome stage as complete and advance to the next stage in your incremental development roadmap.

## Usage
```bash
/vybe:release [stage-name] [--force]
```

## Parameters
- `stage-name`: Optional. Specific stage to mark complete (defaults to current active stage)
- `--force`: Skip validation checks and force stage completion

## Platform Compatibility
- [OK] Linux, macOS, WSL2, Git Bash
- [NO] Native Windows CMD/PowerShell

## Context
- Content of the release script: @./.claude/commands/vybe/release-script.sh

## Your task

**If the first argument is "help", display this help content directly:**

```
COMMANDS:
/vybe:release [stage-name]                 Mark outcome stage complete and advance
/vybe:release [stage-name] --force         Force stage completion (skip validation)

OPTIONS:
--force                Skip validation checks and force completion
--validate             Run validation only (don't mark complete)

EXAMPLES:
/vybe:release
/vybe:release stage-1
/vybe:release stage-2 --force

FEATURES:
- Stage completion validation (tasks done, deliverable working)
- Learning capture (what worked, what to improve)
- Automatic progression to next stage
- Multi-member integration coordination
- Atomic status updates across project files

Use '/vybe:release [stage]' to advance through outcomes.
Use '/vybe:status outcomes' to check stage progression.
```

**Otherwise, review the release script above and execute it with the provided arguments. The script implements:**

- **Shared Cache Architecture**: Uses project-wide cache shared across all Vybe commands
- **Bulk Processing**: Loads all project data at once using cache + file system fallback  
- **Atomic Updates**: Ensures file and cache consistency during stage transitions
- **AI Coordination**: Prepares context for stage learning capture and deliverable verification

Execute the script with: `bash .claude/commands/vybe/release-script.sh "$@"`

## Expected AI Analysis
After the script prepares the context, Claude AI should analyze the cached project data and perform:

### 1. Stage Learnings Capture
- **Technical Learnings**: What worked well? What was harder than expected?
- **Process Learnings**: Timeline accuracy, task completeness, effort estimation
- **Business Learnings**: Value delivered, user feedback, requirement changes

### 2. Deliverable Verification  
- Confirm stage deliverable is actually implemented (not just planned)
- Verify code exists for promised functionality
- Validate user value is demonstrable

### 3. Multi-Member Integration (if applicable)
- Verify all developer assignments complete  
- Coordinate intelligent feature integration
- Resolve merge conflicts and test combined system
- Ensure features work together, not just individually

### 4. Atomic Status Updates
- Update backlog.md: current stage → COMPLETED ✅
- Update outcomes.md: add completion date and learnings  
- Advance next stage: NEXT → IN PROGRESS 🔄
- Archive completed tasks to history section

### 5. Next Stage Preparation
- Refine next stage tasks based on learnings
- Update effort estimates from actual experience
- Check if UI examples are needed for visual stages
- Plan integration points and dependencies

## Atomic Update Functions Available
- `update_file_and_cache(file_path, new_content, cache_key)` - Updates file and cache together
- `cache_set(key, value, ttl)` - Store data in shared cache
- `cache_get(key)` - Retrieve data from shared cache

## Cached Project Data Access  
- `PROJECT_OVERVIEW` - Project overview content
- `PROJECT_ARCHITECTURE` - Architecture decisions and tech stack
- `PROJECT_CONVENTIONS` - Coding standards and practices
- `PROJECT_OUTCOMES` - Staged outcome roadmap
- `PROJECT_BACKLOG` - Current backlog and assignments  
- `PROJECT_FEATURES` - All feature specifications
- `PROJECT_MEMBERS` - Member configuration and assignments

## Success Output
The release process should result in:
- Stage marked as COMPLETED with learnings documented
- Next stage advanced to IN PROGRESS
- Refined task list for upcoming stage
- Multi-member integration complete (if applicable)  
- Project ready for continued development

## Error Handling
- **Incomplete tasks**: Use --force to override or complete remaining tasks
- **No tests**: Manual verification proceeds without automated testing
- **Missing files**: Clear error messages with recovery instructions
- **Multi-member conflicts**: Intelligent merge conflict resolution

The release uses shared cache architecture to speed up subsequent command runs while maintaining full stage progression functionality.
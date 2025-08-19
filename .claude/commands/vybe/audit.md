---
description: Project quality assurance with gap detection, duplicate consolidation, and automated fix suggestions
allowed-tools: Bash
---

# /vybe:audit - Quality Assurance & Fix Automation

Project quality assurance with caching and bulk processing.

## Core Purpose
**Find and fix problems, not show progress** (use `/vybe:status` for progress tracking)

## Usage
```bash
/vybe:audit [scope] [--fix] [--auto-fix] [--verify] [--force]

# Traditional gap detection:
/vybe:audit                          # Complete project audit (cache-optimized)
/vybe:audit features                 # Feature specification gaps
/vybe:audit tasks                    # Missing/duplicate tasks 
/vybe:audit dependencies             # Circular deps, conflicts
/vybe:audit consistency              # Terminology, standards
/vybe:audit members                  # Assignment conflicts, imbalance

# Code-Reality Analysis Modes:
/vybe:audit code-reality             # Compare actual code vs documented plans
/vybe:audit scope-drift              # Detect feature creep beyond original vision
/vybe:audit business-value           # Find features not tied to business outcomes
/vybe:audit documentation            # Find README/docs out of sync with code
/vybe:audit mvp-extraction           # Suggest minimal viable scope for timeboxes

# Performance modes:
/vybe:audit --force                  # Bypass cache, full rescan
/vybe:audit --cache-stats            # Show cache performance metrics
```

## Platform Compatibility
- [OK] Linux, macOS, WSL2, Git Bash
- [NO] Native Windows CMD/PowerShell

## Context
- Content of the audit script: @./.claude/commands/vybe/audit-script.sh

## Your task

**If the first argument is "help", display this help content directly:**

```
COMMANDS:
/vybe:audit                     Complete project quality audit
/vybe:audit features            Check feature specification gaps
/vybe:audit tasks               Find missing/duplicate tasks
/vybe:audit dependencies        Identify circular dependencies
/vybe:audit members             Check team assignment conflicts
/vybe:audit code-reality        Compare implemented vs documented
/vybe:audit scope-drift         Detect feature scope changes
/vybe:audit business-value      Check business outcome alignment
/vybe:audit documentation       Verify docs match implementation
/vybe:audit mvp-extraction      Extract minimal viable features

OPTIONS:
--force                Force fresh scan (ignore cache)
--cache-stats          Show detailed cache performance

Use '/vybe:audit [command]' to run specific quality checks.
Use '/vybe:discuss "question"' for audit guidance.
```

**Otherwise, review the audit script above and execute it with the provided arguments. The script implements:**

- **Bulk Processing**: Single script execution instead of multiple operations
- **Caching**: Cache file operations with invalidation based on modification times
- **Cache Modes**: Cached results vs fresh scan + caching

Execute the script with: `bash .claude/commands/vybe/audit-script.sh "$@"`

## Expected Output
The script will provide:
- Project health assessment (EXCELLENT or NEEDS ATTENTION)
- Gap detection results with fix recommendations  
- Cache performance metrics and execution timing
- Feature analysis and quality scoring
- Related Vybe commands for addressing any issues found

The audit uses caching to speed up subsequent runs with file modification time validation for accuracy.
---
description: Comprehensive Vybe Framework command reference and usage guide
allowed-tools: Read
---

# /vybe:help - Framework Command Reference

Display the complete Vybe Framework command reference with usage examples and workflow guidance.

## Usage
```bash
/vybe:help
```

## Platform Compatibility
- [OK] Linux, macOS, WSL2, Git Bash
- [NO] Native Windows CMD/PowerShell

## Your task
Display the Vybe Framework help content directly:

```
usage: /vybe:[command] [options] ... [args] ...

Vybe Framework - Spec-driven Agile Development
Commands:
  template    Import and analyze external templates
  init        Initialize project with staged outcome roadmap
  backlog     Strategic backlog management with member coordination  
  plan        Create detailed feature specifications
  execute     Execute tasks with full context and member coordination
  status      Progress tracking and member assignments
  audit       Quality assurance and code-reality analysis
  release     Mark outcome stage complete and advance
  discuss     Natural language assistant with smart audit routing
  help        Show this help message

Options:
  --auto      Automated mode (AI makes decisions without confirmation)
  --role=dev-N Execute as specific team member (dev-1 to dev-5)
  --template=name Apply template-driven architectural DNA

Examples:
  /vybe:init "My project description"
  /vybe:backlog init
  /vybe:plan user-auth "User login system"
  /vybe:execute stage-1
  /vybe:status overall

Environment:
  VYBE_MEMBER Set developer role (dev-1, dev-2, dev-3, dev-4, dev-5)

Use '/vybe:[command] help' for detailed help on specific commands.
Use '/vybe:discuss "question"' for interactive assistance.
```
# Vybe Framework

**Spec-driven development for Claude Code with multi-session coordination**

## Overview

Vybe brings structure to AI-assisted development through:
- **Specification-first workflow** - Every feature starts with clear requirements and design
- **Multi-developer coordination** - Multiple Claude Code sessions work together seamlessly  
- **Quality assurance** - Built-in gap detection and fix automation
- **Living documentation** - Specifications evolve with your code

## Key Features

- **7 core commands** - Complete development workflow from init to audit
- **Member coordination** - Assign features to dev-1, dev-2, etc. with conflict detection
- **Gap detection** - Audit finds missing specs, duplicates, and inconsistencies
- **Natural language help** - Discuss command translates requests to specific commands

## Quick Setup

```bash
# 1. Create new project
mkdir my-project && cd my-project
git init

# 2. Install Vybe
git clone https://github.com/iptracej-education/vybe.git vybe-framework
cp -r vybe-framework/.claude .
rm -rf vybe-framework

# 3. Initialize
/vybe:init "Your project description"
```

## Start Building

```bash
# Plan a feature
/vybe:plan user-auth "JWT authentication with refresh tokens"

# Set up team (optional)
/vybe:backlog member-count 2
export VYBE_MEMBER=dev-1

# Check progress vs quality
/vybe:status        # "How are we doing?"
/vybe:audit         # "What needs fixing?"

# Get help
/vybe:discuss "How do I add OAuth to authentication?"
```

## Learn More

- **Complete tutorial**: [`docs/HANDS_ON_TUTORIAL.md`](docs/HANDS_ON_TUTORIAL.md) - 22-step walkthrough
- **All commands**: 7 commands from init to audit with examples
- **Multi-session testing**: Simulate multiple developers working together

**Platform support**: Linux, macOS, WSL2, Git Bash (not Windows CMD)
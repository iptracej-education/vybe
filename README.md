# Vybe Framework

**Note:** *This is an experimental project under active development. Features and structure may change significantly.*

**Spec-driven agile-like development for Claude Code**

Vybe framework provides a spec structure to vibe coding with staged incremental outcomes and enables us to change scope in natural language.

## Overview

Vybe brings structure to AI-assisted development through:
- **Specification-first workflow with agile backlog management** - Every feature starts with clear requirements and design in organized backlog
- **Incremental outcome approach** - Break projects into stages that deliver working units in days each
- **Multi-developer coordination** - Single session or multiple Claude Code sessions work together seamlessly  
- **Quality assurance** - Built-in gap detection and fix automation
- **Living documentation** - Specifications evolve with your code

## Key Features

- **8 core commands** - Complete development workflow: `init` → `backlog` → `plan` → `execute` → `release` → `status` → `audit` → `discuss`
- **Staged planning and execution** - First minimal outcome in 1-2 days, then progressive enhancement stages
- **Code-reality analysis** - Bridge gap between docs and actual code with intelligent analysis   
- **Member coordination** - Assign stages to dev-1, dev-2, etc. with conflict detection
- **Stage completion** - Each stage completion improves next stage planning
- **Auto session handoff** - Automate session handoff when context windows get critically low  (<10%)

## Quick Setup

### Solo Development Setup
```bash
# 1. Create new project directory
mkdir my-project && cd my-project
git init

# 2. Install Vybe Framework
git clone https://github.com/iptracej-education/vybe.git vybe-framework
cp -r vybe-framework/.claude .
rm -rf vybe-framework

# 3. Initialize your project with staged outcomes
/vybe:init "Your project description"
# This will interactively capture your first minimal outcome and final vision
```

### Multi-Member Team Setup
```bash
# 1. Create GitHub repository first (required for team coordination)
# Go to GitHub and create: https://github.com/yourusername/your-project

# 2. Clone your empty repository
git clone https://github.com/yourusername/your-project.git
cd your-project

# 3. Install Vybe Framework
git clone https://github.com/iptracej-education/vybe.git vybe-framework
cp -r vybe-framework/.claude .
rm -rf vybe-framework

# 4. Initialize with staged outcomes and push to shared repository
/vybe:init "Your project description"
git add .
git commit -m "Initialize project with Vybe framework"
git push origin main

# 5. Team members clone and set their roles
git clone https://github.com/yourusername/your-project.git
export VYBE_MEMBER=dev-1  # Each member uses dev-1, dev-2, etc.
```

### Add to Existing Project
```bash
# In your existing project directory
git clone https://github.com/iptracej-education/vybe.git vybe-framework
cp -r vybe-framework/.claude .
rm -rf vybe-framework

# Initialize Vybe in your existing project
/vybe:init "Your existing project description"
```

**Framework Repository**: [https://github.com/iptracej-education/vybe](https://github.com/iptracej-education/vybe)

**Repository Requirements**:
- **Solo development**: Local git repo only (no GitHub needed)
- **Multi-member teams**: **GitHub repository required** for coordination
  - Vybe uses git-based coordination between team members
  - Create your GitHub repository before setup for team projects

## Start Building

```bash
# 1. Initialize with staged outcomes (done during setup)
/vybe:init "COVID data visualization dashboard"
# Captures: 
# - First minimal outcome: "Show COVID numbers on webpage"
# - Final vision: "Real-time dashboard with visualizations"
# - Initial stages: Show data → Add layout → Add charts → Make real-time

# 2. Create outcome-grouped backlog
/vybe:backlog init --auto

# 3. Work on current stage
/vybe:execute fetch-api-data    # Stage 1 tasks
/vybe:execute display-numbers

# 4. Complete stage and advance
/vybe:release                   # Marks Stage 1 complete, advances to Stage 2

# 5. Check progress and outcomes
/vybe:status outcomes          # See stage progression
/vybe:status                   # Overall progress

# 6. Code-Reality Analysis (🔥 POWERFUL NEW FEATURES)
/vybe:discuss "reshape this project to fit 2 weeks, prefer MVP, keep security"
# → Automatically runs: /vybe:audit mvp-extraction --timeline=14days + scope-drift
# → Provides specific recommendations based on YOUR actual code

/vybe:discuss "find features not tied to business outcomes"  
# → Automatically runs: /vybe:audit business-value
# → Maps YOUR implemented features to YOUR business outcomes

/vybe:discuss "our README is outdated, sync with actual features"
# → Automatically runs: /vybe:audit documentation + code-reality
# → Compares YOUR README with YOUR actual source code

# 7. Direct audit commands (for CI/automation)
/vybe:audit code-reality           # Compare docs vs actual implementation
/vybe:audit scope-drift            # Detect feature creep beyond original vision
/vybe:audit mvp-extraction         # Extract minimal viable scope

# 8. Team coordination (optional)
/vybe:backlog member-count 2
export VYBE_MEMBER=dev-1
/vybe:backlog assign stage-2 dev-2
```

## Learn More

- **Complete tutorial**: [`docs/HANDS_ON_TUTORIAL.md`](https://github.com/iptracej-education/vybe/blob/main/docs/HANDS_ON_TUTORIAL.md) - 22-step walkthrough
- **Command reference**: [`docs/COMMAND_SPEC.md`](https://github.com/iptracej-education/vybe/blob/main/docs/COMMAND_SPEC.md) - All 7 commands with examples
- **Framework specification**: [`docs/VYBE_SPEC.md`](https://github.com/iptracej-education/vybe/blob/main/docs/VYBE_SPEC.md) - Complete technical documentation
- **Multi-session testing**: Simulate multiple developers working together

**Platform support**: Linux, macOS, WSL2, Git Bash (not Windows CMD)

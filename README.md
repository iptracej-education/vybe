# Vybe Framework

**Spec-driven agile-like development for Claude Code with multi-session coordination**

## Overview

Vybe brings structure to AI-assisted development through:
- **Specification-first workflow with agile backlog management** - Every feature starts with clear requirements and design in organized backlog
- **Multi-developer coordination** - Single session or multiple Claude Code sessions work together seamlessly  
- **Quality assurance** - Built-in gap detection and fix automation
- **Living documentation** - Specifications evolve with your code

## Key Features

- **7 core commands** - Complete development workflow: `init` → `backlog` → `plan` → `execute` → `status` → `audit` → `discuss`
- **Agile-like planning** - Start with backlog management and create detailed requirements, design, and tasks for each feature
- **Member coordination** - Assign features to dev-1, dev-2, etc. with conflict detection
- **Gap detection** - Audit finds missing specs, duplicates, and inconsistencies
- **Natural language help** - Discuss command translates requests to specific commands

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

# 3. Initialize your project
/vybe:init "Your project description"
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

# 4. Initialize and push to shared repository
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

- **Complete tutorial**: [`docs/HANDS_ON_TUTORIAL.md`](https://github.com/iptracej-education/vybe/blob/main/docs/HANDS_ON_TUTORIAL.md) - 22-step walkthrough
- **Command reference**: [`docs/COMMAND_SPEC.md`](https://github.com/iptracej-education/vybe/blob/main/docs/COMMAND_SPEC.md) - All 7 commands with examples
- **Framework specification**: [`docs/VYBE_SPEC.md`](https://github.com/iptracej-education/vybe/blob/main/docs/VYBE_SPEC.md) - Complete technical documentation
- **Multi-session testing**: Simulate multiple developers working together

**Platform support**: Linux, macOS, WSL2, Git Bash (not Windows CMD)

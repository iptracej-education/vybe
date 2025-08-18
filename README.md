# Vybe Framework

**Spec-driven agile-like development for Claude Code**

Vybe is a spec-driven framework for Claude Code that lets you plan and develop software in clear stages. It blends natural-language commands with a structured spec (backlog, features, tasks, releases) so AI remains flexible without causing drift between docs and code. Each stage produces a concrete outcome that strengthens the next plan—keeping scope, priorities, and artifacts aligned.

**Note:** *This is an experimental project under active development. Features and structure may change significantly.*

[![Project](https://img.shields.io/badge/Project-vybe-blue)](https://github.com/iptracej-education/vybe)
[![Status](https://img.shields.io/badge/Status-Experimental-orange)](https://github.com/iptracej-education/vybe)
[![License](https://img.shields.io/badge/License-MIT-green)](https://github.com/iptracej-education/vybe/blob/main/LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Claude%20Code-purple)](https://claude.ai/code)
[![Languages](https://img.shields.io/badge/Languages-Agnostic-lightblue)](https://github.com/iptracej-education/vybe#supported-programming-languages)
[![Install](https://img.shields.io/badge/Install-One%20Command-brightgreen)](https://github.com/iptracej-education/vybe#quick-setup)

## Overview

Vybe brings structure to AI-assisted development through:
- **Specification-first workflow with backlog management** - Every feature starts with clear requirements and design in organized backlog
- **Incremental outcome approach** - Break projects into stages that deliver working units in days each
- **Multi-developer coordination** - Single session or multiple Claude Code sessions work together seamlessly  
- **Quality assurance** - Built-in gap detection and fix automation
- **Living documentation** - Specifications evolve with your code

## Key Features

- **9 core commands** - Complete development workflow: `template` (optional) → `init` → `backlog` → `plan` → `execute` → `release` → `status` → `audit` → `discuss`
- **Staged planning and execution** - First minimal outcome in 1-2 days, then progressive enhancement stages
- **Natural language scope adjustment** - Intelligent scope reduction for timeline constraints, plus guided expansion planning
- **Code-reality analysis** - Bridge gap between docs and actual code with intelligent analysis
- **High-performance MCP cache** - Sub-millisecond command responses with intelligent in-memory caching and graceful file fallback
- **Template integration (optional)** - Import production-ready templates as permanent project foundation with AI-guided pattern consistency
- **Member coordination** - Assign stages to dev-1, dev-2, etc. with conflict detection
- **Auto session handoff** - Automate session handoff when context windows get critically low  (<10%)

## Platform support 

Linux, macOS, WSL2, Git Bash (not Windows CMD)


## Quick Setup

### Solo Development Setup
```bash
# 1. Create new project directory
mkdir my-project && cd my-project
git init

# 2. Install Vybe Framework (automated)
git clone https://github.com/iptracej-education/vybe.git
cd vybe && ./install.sh && cd .. && rm -rf vybe

claude

# 3. Initialize your project with staged outcomes
/vybe:init "Your project description"
# This will interactively capture your first minimal outcome and final vision
```

#### Add to Existing Project
```bash
# Same as in Solo Development Setup

# Initialize Vybe in your existing project
/vybe:init "Your existing project description"
```

### Multi-Member Team Setup
```bash
# 1. Create GitHub repository first (required for team coordination)
# Go to GitHub and create: https://github.com/yourusername/your-project

# 2. Clone your empty repository
git clone https://github.com/yourusername/your-project.git
cd your-project

# 3. Install Vybe Framework (automated)
git clone https://github.com/iptracej-education/vybe.git
cd vybe && ./install.sh && cd .. && rm -rf vybe

# 4. Initialize with staged outcomes and push to shared repository
/vybe:init "Your project description"
git add .
git commit -m "Initialize project with Vybe framework"
git push origin main

# 5. Team members clone and set their roles
git clone https://github.com/yourusername/your-project.git
export VYBE_MEMBER=dev-1  # Each member uses dev-1, dev-2, etc.
claude
```

### Repository Requirements:
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
/vybe:execute stage-1    # Stage 1 tasks
/vybe:execute stage-2

# 4. Complete stage and advance
/vybe:release                   # Marks Stage 1 complete, advances to Stage 2

# 5. Check progress and outcomes
/vybe:status outcomes          # See stage progression
/vybe:status                   # Overall progress

# 6. Discussion based project adjustment, inspection, and alignment 
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

- **Sample MVP application** : [`Vybe Example Applications`](https://github.com/iptracej-education/vybe-samples) 
- **Complete tutorial**: [`docs/HANDS_ON_TUTORIAL.md`](https://github.com/iptracej-education/vybe/blob/main/docs/HANDS_ON_TUTORIAL.md) - 22-step walkthrough
- **Command reference**: [`docs/COMMAND_SPEC.md`](https://github.com/iptracej-education/vybe/blob/main/docs/COMMAND_SPEC.md) - All 9 commands with examples
- **Framework specification**: [`docs/VYBE_SPEC.md`](https://github.com/iptracej-education/vybe/blob/main/docs/VYBE_SPEC.md) - Complete technical documentation
- **Multi-session testing**: Simulate multiple developers working together


## Supported Programming Languages

The vybe framework is **language-agnostic** and intelligently adapts to any programming language by reading the technology registry. The framework automatically detects and uses the appropriate tools for each language:

### ✅ **Fully Supported Languages**

| Language | Package Managers | Test Frameworks | Build Tools | Server/Runtime |
|----------|------------------|-----------------|-------------|----------------|
| **Python** | uv, poetry, pip | pytest, unittest | setuptools, poetry build | uvicorn, gunicorn |
| **JavaScript/Node.js** | npm, yarn, pnpm | jest, mocha, vitest | webpack, vite, rollup | node, nodemon |
| **TypeScript** | npm, deno, bun | jest, vitest, deno test | tsc, vite, turbo | node, deno, bun |
| **C/C++** | make, cmake, conan | gtest, catch2, ctest | make, cmake, ninja | direct execution |
| **Go** | go mod | go test | go build | go run |
| **Ruby** | bundler, gem | rspec, minitest | rake | ruby, rails server |
| **R** | renv, CRAN | testthat | R CMD build | Rscript |
| **Rust** | cargo | cargo test | cargo build | cargo run |
| **Java** | maven, gradle | junit, testng | maven, gradle | java, spring boot |
| **C#/.NET** | dotnet, nuget | xunit, nunit | dotnet build | dotnet run |

### 🔧 **How Language Detection Works**

1. **Template Analysis**: When importing templates, vybe intelligently analyzes:
   - Package manager files (`package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, etc.)
   - Build configurations (`Makefile`, `CMakeLists.txt`, `build.gradle`, etc.)
   - Test directories and frameworks
   - Server/runtime configurations

2. **Technology Registry Creation**: Creates language-specific `.vybe/tech/languages.yml`:
   ```yaml
   # Example for Python with uv
   language:
     name: Python
     version: "3.12"
   
   execution:
     run: "uv run python {file}"
     interactive: "uv run python"
   
   package_manager:
     name: uv
     install_deps: "uv pip install -e ."
     add_package: "uv add {package}"
   
   testing:
     run_tests: "uv run python -m pytest"
   ```

3. **Universal Execution**: All vybe commands read this registry and use the appropriate tools:
   - **Python project**: Uses `uv run python`, `uv add`, `uv run pytest`
   - **Node.js project**: Uses `node`, `npm install`, `npm test`
   - **Go project**: Uses `go run`, `go get`, `go test`
   - **C++ project**: Uses `g++`, `make`, `make test`

### 🚀 **Adding New Languages**

The framework easily supports new languages by creating appropriate technology registries:

```yaml
# Example: Swift
language:
  name: Swift

execution:
  run: "swift {file}"
  build_and_run: "swift run"

package_manager:
  name: swift
  install_deps: "swift package resolve"
  add_package: "swift package add {package}"

testing:
  run_tests: "swift test"

build:
  build_cmd: "swift build"
```

## 🤝 Contributing & Testing

**We need your help testing this framework!** The Vybe framework is experimental and needs real-world validation, especially for multi-developer scenarios.

### 🎯 **Critical Testing Areas**

#### **Multi-Developer Coordination** (HIGHEST PRIORITY)
The most complex and untested aspect of Vybe is multi-developer coordination. We need feedback on:

**Potential Issues We're Concerned About:**

#### **Modular Architecture Issues (3-Developer Pattern):**
- **Service Contracts**: Do the 3 standalone services define compatible APIs?
- **Integration Workload**: Can Developer 1 handle integrating all 3 services alone?
- **Service Communication**: Do services work together when Developer 1 integrates them?
- **API Compatibility**: Are the APIs designed by different developers compatible?
- **Data Flow**: Does data flow correctly between the 3 integrated services?
- **Deployment Complexity**: Can Developer 1 deploy and coordinate all services?

#### **Traditional Multi-Developer Issues:**
- **Code Overlap**: Do developers accidentally work on the same files/functions?
- **Missing Integration Pieces**: Are there gaps between what developers build?
- **Merge Conflicts**: Does the AI integration handle complex merge scenarios?
- **Feature Dependencies**: Do features that depend on each other integrate correctly?
- **Workload Balance**: Are features distributed fairly across team members?
- **Communication Gaps**: Do developers miss important coordination points?

**Real Scenarios to Test:**

#### **Modular Architecture Approach** (RECOMMENDED)
Each developer creates standalone modules/services that are independently deployable:

```bash
# Scenario 1: E-commerce Platform (3 developers)
# Phase 1: Parallel Service Development
# Developer 1: Authentication Service
/vybe:init "Authentication microservice with JWT, user management, and OAuth"

# Developer 2: Payment Service  
/vybe:init "Payment processing service with Stripe integration and webhooks"

# Developer 3: Product Catalog Service
/vybe:init "Product catalog service with search, inventory, and recommendations"

# Phase 2: Integration (Developer 1 comes back)
# Developer 1: Integration & Orchestration
/vybe:init "E-commerce platform integration - API gateway, service coordination, frontend"
# Integrates: auth-service + payment-service + catalog-service
```

```bash
# Scenario 2: Data Platform (3 developers)
# Phase 1: Parallel Service Development
# Developer 1: Data Ingestion Service
/vybe:init "Data ingestion service with streaming, batch processing, and validation"

# Developer 2: Analytics Engine
/vybe:init "Analytics engine with real-time processing, ML pipelines, and reporting"

# Developer 3: Dashboard Service
/vybe:init "Analytics dashboard with visualizations, reports, and user management"

# Phase 2: Integration (Developer 1 comes back)
# Developer 1: Platform Integration
/vybe:init "Data platform integration - unified API, service coordination, deployment"
# Integrates: ingestion-service + analytics-engine + dashboard-service
```

#### **Traditional Multi-Developer (EXPERIMENTAL)**
Multiple developers working on same codebase - needs extensive testing:

```bash
# Scenario 3: Monolithic App (3 developers) - NEEDS VALIDATION
/vybe:init "E-commerce platform with authentication, payments, and catalog"
/vybe:backlog member-count 3 --auto-assign
# Test: Do auth, payment, and catalog features integrate correctly?
```

#### **AI Assignment Intelligence**
- Does `/vybe:backlog member-count N --auto-assign` create sensible feature distribution?
- Are dependencies and conflicts properly identified?
- Do assigned features actually avoid overlap?

#### **Integration & Release Process**
- Does `/vybe:release stage-1` successfully merge all developer work?
- Are integration tests comprehensive enough?
- Does the combined system actually work?

### 🐛 **What We're Looking For**

#### **Success Cases**

**Modular Architecture (3-Developer Pattern):**
- ✅ Phase 1: All 3 developers create working standalone services in parallel
- ✅ Each service is independently testable and deployable
- ✅ Services define clear, compatible APIs for integration
- ✅ Phase 2: Developer 1 successfully integrates all services
- ✅ Final integrated system works end-to-end
- ✅ Developer 1 can effectively coordinate and deploy all services

**Traditional Multi-Developer:**
- ✅ Features assigned without conflicts
- ✅ Developers work in parallel successfully  
- ✅ Integration works smoothly with `/vybe:release`
- ✅ Combined system functions correctly
- ✅ Code quality maintained across team

#### **Failure Cases** (Please Report!)

**Modular Architecture (3-Developer Pattern):**
- ❌ Services with incompatible APIs or data formats
- ❌ Developer 1 unable to integrate the 3 services effectively
- ❌ Services that don't communicate correctly when integrated
- ❌ Data consistency issues across the integrated services
- ❌ Deployment or coordination problems during integration
- ❌ Integration complexity beyond what one developer can handle

**Traditional Multi-Developer:**
- ❌ Overlapping code assignments
- ❌ Missing pieces after integration
- ❌ Merge conflicts that AI can't resolve
- ❌ Features that don't work together
- ❌ Broken system after `/vybe:release`
- ❌ Coordination confusion or workflow issues

### 📝 **How to Contribute**

#### **1. Testing Feedback**
Try the framework on real projects and report:
```bash
# Test the complete multi-developer workflow
git clone https://github.com/iptracej-education/vybe.git
cd vybe && ./install.sh && cd .. && rm -rf vybe

# Test different team sizes and project types
# Report what works and what breaks
```

**Submit feedback as GitHub Issues with:**
- Project type and team size tested
- Commands that worked/failed
- Screenshots of coordination problems
- Specific integration issues encountered
- Suggestions for improvement

#### **2. Framework Improvements**
- **Command Enhancements**: Better AI prompts for coordination
- **Integration Logic**: Improved merge and testing strategies  
- **Error Handling**: Better failure detection and recovery
- **Documentation**: Clearer workflows and troubleshooting guides

#### **3. Real-World Case Studies**
Document your experience using Vybe for actual projects:
- What project type did you build?
- How many developers were involved?
- What coordination challenges arose?
- How did the AI handle integration?
- What would you improve?

### 🚨 **Known Limitations**

**Multi-Developer Scenarios:**
- Integration logic is theoretical - needs real-world validation
- AI assignment may miss subtle dependencies
- Merge conflict resolution may be incomplete
- Cross-feature testing may have gaps

**General Framework:**
- Experimental status - expect workflow changes
- Command behavior may evolve based on testing feedback
- Not recommended for production projects yet

### 💡 **Contributing Guidelines**

#### **Issue Reporting**
```markdown
## Multi-Developer Test Report

**Project**: [Description]
**Team Size**: [N developers]
**Commands Tested**: 
- /vybe:init "..."
- /vybe:backlog member-count N --auto-assign
- /vybe:execute stage-1 --complete
- /vybe:release stage-1

**What Worked**:
- [Specific successes]

**What Failed**:
- [Specific failures with commands/outputs]

**Integration Issues**:
- [Overlaps, gaps, conflicts, coordination problems]

**Suggestions**:
- [How to improve the workflow]
```

#### **Pull Requests**
- Focus on multi-developer coordination improvements
- Include test scenarios that validate changes
- Update documentation for workflow changes
- Add error handling for edge cases

### 🎯 **Priority Testing Requests**

1. **Test multi-developer assignment intelligence** - Does auto-assign work sensibly?
2. **Validate integration scenarios** - Does `/vybe:release` handle team coordination?  
3. **Find coordination edge cases** - What breaks the multi-developer workflow?
4. **Document real failure modes** - Help us fix what doesn't work

**Your testing and feedback will directly shape how this framework evolves!**

---

**Repository**: [github.com/iptracej-education/vybe](https://github.com/iptracej-education/vybe)  
**Issues**: [Report problems and feedback](https://github.com/iptracej-education/vybe/issues)  
**Discussions**: [Share experiences and suggestions](https://github.com/iptracej-education/vybe/discussions)

---
description: Natural language assistant with smart audit routing that translates requests into specific Vybe command sequences and automatically runs specialized analysis modes
allowed-tools: Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS, WebSearch, WebFetch, vybe-cache.get, vybe-cache.set, vybe-cache.mget, vybe-cache.mset
---

# /vybe:discuss - Natural Language Assistant with Smart Audit Routing

Transform natural language requests into specific Vybe command sequences with intelligent routing to specialized audit analysis modes. Describe what you want to accomplish in plain English, and get both command sequences AND automated code-reality analysis.

## Usage
```bash
/vybe:discuss "[your request in natural language]"
```

## Core Capabilities

### 1. Command Translation
```bash
/vybe:discuss "We need to add mobile support to our web app"
/vybe:discuss "Switch from REST to GraphQL for better performance"  
/vybe:discuss "Add analytics dashboard and email notifications"
/vybe:discuss "We're behind schedule, need to redistribute work"
```

### 2. Code-Reality Analysis (🔥 POWERFUL)
```bash
# Project reshaping and scope analysis
/vybe:discuss "reshape this project to fit 2 weeks, prefer MVP, keep security, limit WIP to 2"
/vybe:discuss "analyze if we can ship this in 1 month with current team"
/vybe:discuss "what features can we cut to hit our deadline?"

# Documentation synchronization
/vybe:discuss "read discussion.md and add requirements to README.md, then adjust project scope"
/vybe:discuss "our README.md is outdated, sync it with actual implemented features"
/vybe:discuss "compare what we promise in docs vs what code actually does"

# Business outcome alignment
/vybe:discuss "find features not tied to business outcomes and suggest what to do"
/vybe:discuss "which implemented features don't match our original vision?"
/vybe:discuss "audit if our code supports the user stories in README.md"
```

### 3. Scope & Architecture Evolution
```bash
/vybe:discuss "analyze current code and suggest how to split into microservices"
/vybe:discuss "we added too many features, help us extract MVP"
/vybe:discuss "recommend what to refactor before adding [new feature]"
/vybe:discuss "evaluate if current architecture can handle 10x user growth"
```

### 4. Project Health Analysis
```bash
/vybe:discuss "find inconsistencies between backlog, README, and actual code"
/vybe:discuss "detect scope creep - what did we build beyond original plan?"
/vybe:discuss "which features have no tests and pose biggest risk?"
/vybe:discuss "analyze technical debt and suggest prioritization"
```

## How It Works

### Standard Command Translation
1. **Load complete project context** - Understanding current state
2. **Parse your natural language request** - What you want to accomplish
3. **Generate specific Vybe command sequence** - Step-by-step instructions
4. **Provide context and explanations** - Why each command is needed

### Code-Reality Analysis Process
1. **Multi-source analysis** - Read Vybe docs + actual source code + README/docs
2. **Gap detection** - Compare documented intentions vs implemented reality
3. **Business alignment check** - Verify features serve documented business outcomes
4. **Scope analysis** - Detect feature creep, missing features, orphaned code
5. **Actionable recommendations** - Specific fixes, updates, and scope adjustments

## Platform Compatibility
- [OK] Linux, macOS, WSL2, Git Bash
- [NO] Native Windows CMD/PowerShell

## Context
- Content of the discuss script: @./.claude/commands/vybe/discuss-script.sh

## Your task

**If the first argument is "help", display this help content directly:**

```
COMMANDS:
/vybe:discuss "[question]"                 Natural language assistant

EXAMPLES:
/vybe:discuss "We need to add mobile support to our web app"
/vybe:discuss "Switch from REST to GraphQL for better performance"
/vybe:discuss "We're behind schedule, need to redistribute work"
/vybe:discuss "analyze if we can ship this in 1 month with current team"
/vybe:discuss "our README.md is outdated, sync it with actual features"
/vybe:discuss "find features not tied to business outcomes"

SMART ROUTING:
- Command translation: Natural language → specific Vybe commands
- Automatic audit routing: Analysis requests → specialized audit modes
- Code-reality analysis: Compare documented vs implemented features
- Business alignment: Check features vs business outcomes

FEATURES:
- Context-aware guidance based on project state
- Automated audit execution with structured results
- Command sequence recommendations
- Project analysis and optimization suggestions

Use '/vybe:discuss "[question]"' for interactive guidance.
Use specific commands for direct execution.
```

**Otherwise, review the discuss script above and execute it with the provided arguments. The script implements:**

- **Shared Cache Architecture**: Uses project-wide cache shared across all Vybe commands
- **Bulk Processing**: Loads all project data and analyzes structure at once
- **Intelligent Routing**: Detects request type and routes to appropriate analysis mode
- **AI Coordination**: Prepares context for natural language processing and code-reality analysis

Execute the script with: `bash .claude/commands/vybe/discuss-script.sh "$@"`

## Expected AI Operations

After the script prepares the context, Claude AI should perform intelligent discussion analysis:

### For Command Translation Requests
1. **Request Interpretation**: Parse natural language for intent and goals
2. **Command Sequence Generation**: Create step-by-step Vybe command sequences
3. **Context Provision**: Explain why each command is needed and how it fits together
4. **Parameter Recommendations**: Suggest optimal flags, options, and arguments
5. **Validation Steps**: Include commands to verify and test the changes

### For Code-Reality Analysis Requests
1. **Multi-Source Analysis**: 
   - Compare project documentation vs actual source code
   - Cross-reference README/docs with implementation
   - Analyze backlog/outcomes alignment with code reality
   - Identify gaps, inconsistencies, and scope drift

2. **Specialized Audit Routing**:
   - **Scope Drift**: Project reshaping, timeline optimization, feature cutting
   - **Documentation**: README synchronization, doc-code alignment
   - **Business Value**: Outcome verification, vision alignment
   - **Code Reality**: Implementation verification, gap analysis
   - **MVP Extraction**: Architecture analysis, feature prioritization

3. **Structured Analysis Reports**:
   - Clear findings with evidence from source analysis
   - Specific actionable recommendations
   - Command sequences to implement fixes
   - Verification steps to validate changes

4. **Dual Output**: Both analysis results AND command sequences for immediate action

## Analysis Modes

The system intelligently routes requests to specialized analysis modes:

### Scope Drift Analysis
- **Keywords**: reshape, fit X weeks, MVP, deadline, scope, cut features
- **Focus**: Timeline optimization, feature prioritization, scope reduction
- **Output**: Recommendations for meeting deadlines with reduced scope

### Documentation Analysis  
- **Keywords**: README, docs, documented, promises, sync, outdated
- **Focus**: Documentation-code alignment, README accuracy
- **Output**: Commands to synchronize docs with actual implementation

### Business Value Analysis
- **Keywords**: business outcome, vision, user stories, value
- **Focus**: Feature-outcome alignment, value verification
- **Output**: Features to remove/modify for better business alignment

### Code Reality Analysis
- **Keywords**: inconsist, gap, compare code, reality, implemented features
- **Focus**: Implementation verification, documented vs actual
- **Output**: Specific gaps and commands to fix misalignments

### MVP Extraction Analysis
- **Keywords**: extract MVP, microservices, refactor, architecture  
- **Focus**: Architecture simplification, feature extraction
- **Output**: Refactoring recommendations and architectural changes

## Success Metrics
- ✅ **Request Understanding**: Accurate interpretation of natural language
- ✅ **Command Generation**: Practical, executable Vybe command sequences
- ✅ **Analysis Quality**: Thorough code-reality gap detection
- ✅ **Actionable Output**: Clear recommendations with implementation steps
- ✅ **Context Awareness**: Responses aligned with project state and goals

## Error Handling
- **Empty requests**: Clear usage examples and capability descriptions
- **Analysis failures**: Fallback to general command translation
- **Missing context**: Graceful handling with available information
- **Complex requests**: Breaking down into manageable sub-tasks

The discussion system uses shared cache architecture for optimal performance and provides both high-level guidance and specific executable commands for immediate action.
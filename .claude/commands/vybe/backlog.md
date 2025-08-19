---
description: Strategic feature management with AI automation and human control options
allowed-tools: Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS, vybe-cache.get, vybe-cache.set, vybe-cache.mget, vybe-cache.mset
---

# /vybe:backlog - Strategic Feature Management

Intelligent backlog management with automated analysis, grooming, and planning capabilities.

## Usage
```bash
/vybe:backlog [action] [options]
```

## Actions & Automation Levels
- **Default**: Display current backlog with status
- **init [--auto]**: AI feature discovery (interactive vs automated)
- **add [feature] [--auto]**: Add features (manual vs AI-suggested batch)
- **groom [--auto]**: Clean backlog (interactive vs automated RICE/WSJF)
- **release [version]**: Group features into releases
- **dependencies**: Map cross-feature dependencies  
- **capacity**: Estimate effort and sprint planning
- **member-count [N] [--auto-assign]**: Configure project with N developers (1-5 max, creates dev-1, dev-2, etc.)
- **assign [feature] [dev-N]**: Assign feature to specific member (dev-1, dev-2, dev-3, dev-4, or dev-5)

## Global Options
- **--auto**: Automated mode - AI makes decisions without user confirmation
- **--interactive**: Interactive mode - AI asks for approval (default behavior)

## Platform Compatibility
- [OK] Linux, macOS, WSL2, Git Bash
- [NO] Native Windows CMD/PowerShell

## Context
- Content of the backlog script: @./.claude/commands/vybe/backlog-script.sh

## Your task

**If the first argument is "help", display this help content directly:**

```
COMMANDS:
/vybe:backlog                   Display current backlog status
/vybe:backlog init              Create strategic backlog from outcomes
/vybe:backlog member-count N    Configure team (1-5 developers)
/vybe:backlog assign [feature] [dev-N]  Assign feature to team member
/vybe:backlog groom             RICE/WSJF scoring and optimization
/vybe:backlog dependencies      Map cross-feature dependencies
/vybe:backlog capacity          Estimate effort and sprint planning

OPTIONS:
--auto                 Automated mode (AI makes decisions without confirmation)
--auto-assign          Intelligent auto-assignment of features to members

EXAMPLES:
/vybe:backlog init --auto
/vybe:backlog member-count 3 --auto-assign
/vybe:backlog assign user-auth dev-1
/vybe:backlog groom --auto

Use '/vybe:backlog [command]' for strategic feature management.
Use '/vybe:status members' to check team progress.
```

**Otherwise, review the backlog script above and execute it with the provided arguments. The script implements:**

- **Shared Cache Architecture**: Uses project-wide cache shared across all Vybe commands
- **Bulk Processing**: Loads all project data and analyzes backlog state at once
- **AI Coordination**: Prepares context for sophisticated backlog management algorithms
- **Team Coordination**: Supports multi-developer assignment and workload balancing

Execute the script with: `bash .claude/commands/vybe/backlog-script.sh "$@"`

## Expected AI Operations

After the script prepares the context, Claude AI should perform intelligent backlog management:

### Default Action (Display)
1. **Backlog Overview**: Show current structure, member assignments, and progress
2. **Status Summary**: Feature completion, blockers, and workload distribution  
3. **Next Actions**: Recommend immediate steps for project advancement
4. **Stage Progression**: Display current stage status and upcoming deliverables

### Initialize Action
1. **Strategic Analysis**: Analyze project outcomes to identify required features
2. **Backlog Structure**: Create outcome-grouped backlog organization
3. **Member System**: Set up team coordination infrastructure
4. **Prioritization Framework**: Establish RICE/WSJF scoring foundation

### Member Configuration
1. **Team Setup**: Configure 1-5 developers (dev-1 through dev-5)
2. **Workload Analysis**: Analyze current features and complexity
3. **Auto-Assignment** (if requested): Intelligent feature distribution based on:
   - Feature complexity and effort estimation
   - Member skills and capacity analysis
   - Dependency relationships and coordination needs
   - Parallel work opportunities optimization

### Feature Assignment
1. **Capacity Validation**: Check member availability and current workload
2. **Dependency Analysis**: Identify coordination requirements with other features
3. **Workload Balancing**: Ensure fair distribution across team members
4. **Coordination Setup**: Configure tracking and collaboration systems

### Backlog Grooming
1. **RICE Scoring Analysis**:
   - **Reach**: How many users/stakeholders will benefit
   - **Impact**: Degree of benefit per user
   - **Confidence**: Certainty in reach/impact estimates
   - **Effort**: Development time and resource requirements

2. **WSJF Prioritization**:
   - **Cost of Delay**: Business impact if feature is delayed
   - **Job Size**: Development effort and complexity
   - **Weighted Ranking**: Optimal priority ordering

3. **Intelligent Automation**:
   - Duplicate detection and consolidation
   - Effort estimation using project history
   - Member workload optimization
   - Stage alignment verification

### Dependency Analysis
1. **Cross-Feature Mapping**: Identify technical and business dependencies
2. **Critical Path Analysis**: Find features that block other development
3. **Parallel Work Planning**: Maximize concurrent development opportunities
4. **Member Coordination**: Plan integration points and collaboration needs

## Multi-Developer Coordination

### Team Structure (1-5 developers)
```
dev-1: Lead developer - complex features and architecture
dev-2: Senior developer - full-stack features  
dev-3: Backend developer - API and data layer
dev-4: Frontend developer - UI and user experience
dev-5: DevOps developer - deployment and infrastructure
```

### Assignment Algorithms
1. **Complexity Matching**: Match feature complexity to developer experience
2. **Skill Alignment**: Assign based on technology stack expertise
3. **Workload Balancing**: Distribute effort evenly across team
4. **Dependency Optimization**: Minimize cross-developer dependencies

### Coordination Features
- **VYBE_MEMBER**: Environment variable for developer identity
- **Workload Tracking**: Monitor effort distribution and capacity
- **Conflict Detection**: Identify competing assignments and dependencies
- **Integration Planning**: Coordinate feature merging and testing

## RICE/WSJF Scoring Framework

### RICE Scoring Metrics
- **Reach Score**: 1-5 scale (1=few users, 5=all users)
- **Impact Score**: 1-5 scale (1=minimal, 5=massive improvement)
- **Confidence Score**: 1-5 scale (1=low confidence, 5=high confidence)
- **Effort Score**: Story points or time estimation
- **RICE Score**: (Reach × Impact × Confidence) ÷ Effort

### WSJF Prioritization
- **User/Business Value**: Direct business impact and user benefit
- **Risk Reduction**: Technical and business risk mitigation
- **Opportunity Enablement**: Foundation for future features
- **Job Size**: Development effort and complexity
- **WSJF Score**: (User Value + Risk Reduction + Opportunity) ÷ Job Size

## Success Metrics
- ✅ **Strategic Alignment**: Features grouped by business outcomes
- ✅ **Team Coordination**: Balanced workload across all developers
- ✅ **Smart Prioritization**: RICE/WSJF scoring with AI optimization
- ✅ **Dependency Management**: Clear coordination and integration plans
- ✅ **Progress Tracking**: Real-time visibility into development progress

## Error Handling
- **Missing project**: Automatic validation with /vybe:init guidance
- **Invalid members**: Clear dev-1 through dev-5 naming requirements
- **Assignment conflicts**: Workload balancing and capacity warnings
- **Dependency cycles**: Detection and resolution recommendations

The backlog system uses shared cache architecture for optimal performance while maintaining sophisticated AI algorithms for team coordination, feature prioritization, and strategic planning.
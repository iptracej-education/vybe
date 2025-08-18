# Vybe Framework - Complete Hands-On Tutorial

A comprehensive table-top exercise walking through all Vybe commands from project initialization to completion. This tutorial simulates real development workflows to test command consistency and identify potential improvements.

**Enhanced Execute Capabilities**: The `/vybe:execute` command now includes automatic code generation, unit testing, and quality gates. Instead of just providing guidance, it creates actual runnable code, runs tests automatically, and enforces template patterns when available.

**Note**: Commands use performance-optimized intelligent analysis. Phase 1 provides immediate intelligent setup (~30 seconds), while Phase 2 enhances with comprehensive research in background (2-5 minutes). You get fast feedback with same final quality.

## Prerequisites & Setup

Before starting any tutorial, you need to set up your environment properly based on whether you're testing solo, team features, or template-based development.

### Template Tutorial Setup (NEW)
For advanced users who want to test template-driven development, see the [**Template Tutorial**](#template-tutorial) at the bottom of this document.

### Repository Requirements
- **Solo Tutorial**: Local git repository only (no GitHub needed)
- **Multi-Member Tutorial**: **GitHub repository required** for team coordination
  - Vybe uses git-based coordination between team members
  - Create your GitHub repository before starting team tutorial

### Solo Tutorial Setup

**Option A: Automated Installation (Recommended)**
```bash
# 1. Create test environment
mkdir vybe-solo-test && cd vybe-solo-test
git init

# 2. Install Vybe Framework automatically
git clone https://github.com/iptracej-education/vybe.git
cd vybe && ./install.sh && cd .. && rm -rf vybe

# 3. Ready to start tutorial
claude
```

### Multi-Member Tutorial Setup
```bash
# 1. Create GitHub repository first (required!)
# Go to GitHub and create: https://github.com/yourusername/vybe-team-test

# 2. Clone your empty repository
git clone https://github.com/yourusername/vybe-team-test.git
cd vybe-team-test

# 3. Install Vybe Framework
git clone https://github.com/iptracej-education/vybe.git vybe-framework
cp -r vybe-framework/.claude .

# 4. Enable Session Continuity (CRITICAL)
cp -r .claude/hooks/* ~/.claude/.claude/hooks/
chmod +x ~/.claude/.claude/hooks/*.sh ~/.claude/.claude/hooks/*.py

# 5. Configure Claude Code hooks (edit ~/.claude/settings.json)
# Add "hooks" section to existing settings.json file:
# "hooks": {
#   "enabled": true,
#   "preToolHook": "pre-tool.sh",
#   "postToolHook": "post-tool.sh", 
#   "preCompactHook": "precompact.py"
# }
# IMPORTANT: Don't overwrite existing Claude Code settings!

cp vybe-framework/CLAUDE.md .
rm -rf vybe-framework

# 4. Initial commit to shared repository
git add .
git commit -m "Set up Vybe framework for team testing"
git push origin main

# 5. Start Claude Code
claude

# 6. Ready to start multi-member tutorial below
```

## Choose Your Tutorial Path

**👤 [Solo Developer Tutorial](#solo-developer-tutorial)** - Complete workflow for individual developers
- Perfect for testing core functionality
- Simpler commands and workflows
- Focus on specifications and quality

**👥 [Multi-Member Tutorial](#multi-member-tutorial)** - Team coordination and collaboration
- Advanced member assignment features  
- Multi-session coordination testing
- Assignment conflicts and workload balancing

**🏗️ [Template Tutorial](#template-tutorial)** - Using external templates as architectural DNA (NEW)
- Import and analyze external templates
- Generate template-driven project foundations
- Follow template patterns throughout development

---

# Solo Developer Tutorial

**Scenario**: Building a personal task management app with authentication and API integration.

**Focus**: Core Vybe functionality without team complexity

---

## Phase 1: Project Foundation

### Step 1: Initialize New Project with Technology Stack Analysis
```bash
# Command to test:
/vybe:init "Personal task management app with React, Node.js, and MongoDB. Need user authentication, API integrations, and data export features with testing setup."

# Expected AI analysis process:
# 1. EXTRACT: React, Node.js, MongoDB, task management, authentication, API integrations
# 2. RESEARCH: Best practices for MERN stack, authentication approaches, testing
# 3. RECOMMEND: Missing components like Express (backend), JWT (auth), Jest (testing)
# 4. PRESENT: Complete technology stack with explanations and alternatives
# 5. ASK: User approval before creating .vybe/tech/ registry

# Expected behavior after approval (✅ NOW IMPLEMENTED):
# - Creates .vybe/ directory structure
# - Creates actual .vybe/tech/ technology registry with real technology decisions
# - Generates foundation documents based on your description
# - Sets up staged outcome roadmap
# - Creates stage-by-stage tool installation plan with specific commands
# - Creates living documents you can edit freely
```

**Test Points:**
- [ ] Does AI extract explicit technologies from description correctly?
- [ ] Does AI research and recommend appropriate missing components?
- [ ] Does AI present complete technology stack with explanations?
- [ ] Does AI ask for user approval before proceeding?
- [ ] Does init create actual .vybe/tech/ registry with concrete technology decisions? ✅
- [ ] Are the generated documents specific to the project description?
- [ ] Is the project context comprehensive enough for decision-making?

### Step 2: Review Foundation Documents
```bash
# 1. Review the generated documents
cat .vybe/project/overview.md        # Business context and goals
cat .vybe/project/architecture.md    # Technology stack and design  
cat .vybe/project/conventions.md     # Development standards
cat .vybe/project/outcomes.md        # Staged outcome roadmap

# 2. Edit documents if needed (optional)
# Use any editor to refine the generated content:
# nano .vybe/project/overview.md
# code .vybe/project/architecture.md

# Documents are living - edit freely, no approval needed!
```

**Test Points:**
- [ ] Are the generated documents comprehensive and specific to your project?
- [ ] Does the outcomes.md show a realistic staged roadmap?
- [ ] Do technology choices in architecture.md make sense?
- [ ] Can you easily identify the Stage 1 minimal outcome?

### Step 3: Generate Strategic Backlog
```bash
# Command to test:
/vybe:backlog init

# Generate outcome-grouped backlog with stage roadmap
# This creates strategic level "Task Overview" for each stage

# Review what was created:
cat .vybe/backlog.md

# Look for structure like:
# ## Stage 1: Basic Task Operations (1-2 days)
# #### Task Overview
# - [ ] Core task CRUD functionality
# - [ ] Simple local storage
# - [ ] Basic HTML interface
#
# ## Stage 2: User Authentication (2-3 days)  
# #### Task Overview
# - [ ] User registration/login
# - [ ] Personal task lists
# - [ ] Session management

# Note: These are HIGH-LEVEL overviews, not detailed implementation tasks
```

**Test Points:**
- [ ] Does backlog show stages with "Task Overview" sections?
- [ ] Are stages organized from Stage 1 (minimal) to later stages?
- [ ] Do the Task Overview items match the outcomes.md roadmap?
- [ ] Is Stage 1 clearly the minimal viable functionality?
- [ ] Are later stages logical progressions from earlier ones?

## Phase 2: Feature Planning

### Step 4: Plan Stage 1 Implementation
```bash
# Create detailed specifications for Stage 1
/vybe:plan stage-1

# This takes the high-level "Task Overview" from backlog.md
# and creates detailed implementation specifications

# Review what was created:
ls .vybe/features/stage-1/
cat .vybe/features/stage-1/requirements.md    # Detailed EARS requirements
cat .vybe/features/stage-1/design.md         # Technical architecture
cat .vybe/features/stage-1/tasks.md          # Granular implementation tasks

# Example of what you might see in tasks.md:
# ## Sprint 1 (Days 1-2)  
# - [ ] Create HTML task list structure
# - [ ] Implement add task function
# - [ ] Add task completion toggle
# - [ ] Build local storage persistence
# - [ ] Style basic CSS layout
```

**Test Points:**
- [ ] Does /vybe:plan stage-1 create detailed specs in .vybe/features/stage-1/?
- [ ] Are the tasks.md items much more detailed than backlog "Task Overview"?
- [ ] Do requirements.md capture specific acceptance criteria?
- [ ] Does design.md show technical approach for implementation?
- [ ] Are tasks granular enough for 1-2 day implementation?

### Step 5: Modify Stage 1 with AI Assistance (Optional)
```bash
# Test the --modify feature for AI-assisted changes
/vybe:plan stage-1 --modify "Change: Use TypeScript instead of JavaScript"

# This modifies the existing Stage 1 specifications:
# - Updates design.md with TypeScript considerations
# - Adjusts tasks.md for TypeScript setup and compilation
# - Modifies requirements as needed

# Review the changes:
cat .vybe/features/stage-1/design.md         # Should show TypeScript approach
cat .vybe/features/stage-1/tasks.md          # Should include TypeScript setup tasks

# Other examples of modifications:
# /vybe:plan stage-1 --modify "Add: Drag and drop for task reordering"
# /vybe:plan stage-1 --modify "Change: Use IndexedDB instead of localStorage"
# /vybe:plan stage-1 --modify "Remove: Advanced filtering features"
```

**Test Points:**
- [ ] Does --modify successfully update existing Stage 1 specs?
- [ ] Are changes reflected across requirements, design, and tasks?
- [ ] Do modifications maintain consistency with project architecture?
- [ ] Can you make multiple types of changes (add, change, remove)?

---

## Phase 3: Implementation Workflow

### Step 6: Check Project Status
```bash
# Command to test:
/vybe:status

# Expected behavior:
# - Shows overall project progress and stage status
# - Displays planned stages and their completion status
# - Indicates current active stage (should be Stage 1)
# - Shows next recommended actions

# Example output might show:
# 🎯 Project: Personal Task Management
# 📊 Stage Progress: Stage 1 IN PROGRESS (0/5 tasks completed)
# 🔄 Active Stage: Stage 1 - Basic Task Operations
# 📋 Next Action: /vybe:execute stage-1-task-1
```

**Test Points:**
- [ ] Does status show staged outcome progression?
- [ ] Are planned stages clearly visible with status?
- [ ] Does it indicate which stage is currently active?
- [ ] Does it provide clear next steps for Stage 1?

### Step 7: Execute Stage 1 Implementation with Technology Stack-Driven Code Generation
```bash
# Execute all tasks in Stage 1 with complete integration
/vybe:execute stage-1 --complete

# Enhanced execute behavior with technology coordination (✅ REGISTRY NOW AVAILABLE):
# 1. LOADS technology stack from actual .vybe/tech/ registry (no more guessing!)
# 2. INSTALLS Stage 1 tools progressively (React, Node.js, MongoDB tools)
# 3. VALIDATES installation using configured validation commands
# 4. CREATES project structure using established technology stack
# 5. GENERATES real, runnable code following MERN stack patterns
# - Creates unit tests automatically
# - Runs tests and auto-fixes simple failures
# - Validates against template patterns (if template exists)

# Expected automatic implementation:
# 1. Creates clean project structure (src/, tests/, package.json, etc.)
# 2. Implements actual code files following conventions.md
# 3. Generates comprehensive unit tests
# 4. Runs tests automatically
# 5. Fixes test failures up to 2 attempts
# 6. Creates working, tested code

# Alternative execution patterns (commented examples):
# /vybe:execute stage-1-task-1    # Single task execution
# /vybe:execute stage-1-task-2    # Next task in sequence
# /vybe:execute my-feature-task-1 # Individual feature task
```

**Enhanced Test Points:**
- [ ] Does execute load established technology stack from .vybe/tech/ registry? ✅
- [ ] Does progressive tool installation follow stages.yml configuration?
- [ ] Does execute create actual project structure on first task?
- [ ] Are real code files generated following established tech stack (not just documentation)?
- [ ] Does it follow template patterns if template exists?
- [ ] Are unit tests created using established testing framework from testing.yml?
- [ ] Does auto-fix handle test failures intelligently (max 2 attempts)?
- [ ] Is working, runnable code produced that follows technology stack?
- [ ] Does stage completion show technology-specific run instructions?
- [ ] Are installation validation commands executed successfully?

## Phase 4: Quality Assurance

### Step 8: Project Quality Audit
```bash
# Command to test:
/vybe:audit

# Expected behavior:
# - Checks alignment between foundation docs and stage specs
# - Identifies gaps in specifications or consistency issues
# - Validates stage progression makes sense
# - Shows project health and suggests improvements

# Example output might show:
# ✅ Foundation documents complete and consistent
# ⚠️  Stage 1 tasks missing acceptance criteria
# ✅ Stage progression logical (1→2→3)
# 💡 Suggestion: Add TypeScript configuration to conventions.md
```

**Test Points:**
- [ ] Does audit check consistency between different document types?
- [ ] Are identified gaps specific and actionable?
- [ ] Does it validate the staged outcome approach is working?
- [ ] Is it clearly different from /vybe:status (quality vs progress)?

### Step 9: Code-Reality Analysis Testing
```bash
# Test the new code-reality analysis modes:
/vybe:audit code-reality           # Compare docs vs actual implementation
/vybe:audit scope-drift            # Check if scope expanded beyond Stage 1
/vybe:audit documentation          # Sync project docs with actual progress

# Expected behavior:
# - Analyzes YOUR actual project files (not hardcoded examples)
# - Provides specific recommendations based on current state
# - Shows concrete gaps between documentation and reality
```

**Test Points:**
- [ ] Do audit modes analyze your actual project files?
- [ ] Are results specific to your project (no generic examples)?
- [ ] Do recommendations help align docs with reality?
- [ ] Would the output work well for CI/automation?

## Phase 5: Natural Language Help & Smart Routing

### Step 10: Test Natural Language Assistance
```bash
# Test various natural language requests:

# 1. Scope adjustment
/vybe:discuss "I only have 1 week instead of 2, what should I cut from Stage 1?"
# Expected: Routes to mvp-extraction + scope-drift analysis

# 2. Technical changes  
/vybe:discuss "Should I use React instead of vanilla JavaScript for this project?"
# Expected: Analyzes project context and provides architectural guidance

# 3. Business alignment
/vybe:discuss "Which features provide the most business value for an MVP?"
# Expected: Routes to business-value analysis

# 4. Documentation sync
/vybe:discuss "My README is outdated compared to what I've built"
# Expected: Routes to documentation + code-reality analysis
```

**Test Points:**
- [ ] Does discuss understand different types of requests?
- [ ] Does it route to appropriate audit modes automatically?
- [ ] Are suggestions based on YOUR project context?
- [ ] Do responses provide actionable next steps?

### Step 11: Integration Verification
```bash
# Test the complete workflow integration:
/vybe:discuss "Analyze overall project health and suggest next steps"

# Expected behavior:
# - Routes to multiple audit modes
# - Provides comprehensive project analysis  
# - Suggests specific command sequences
# - Results are actionable and project-specific

# Also test:
/vybe:status                    # Progress tracking
/vybe:audit                     # Quality assurance

# Verify the three commands provide different but complementary information
```

**Test Points:**
- [ ] Do the three commands (status/audit/discuss) have distinct purposes?
- [ ] Does discuss provide comprehensive project analysis?
- [ ] Are suggested next steps practical and achievable?
- [ ] Does the full pipeline provide real developmental value?

---

## Phase 6: Code-Reality Analysis (🔥 NEW FEATURES)

### Step 12: Smart Audit Routing
```bash
# Test natural language requests that route to audit commands
/vybe:discuss "reshape this project to fit 2 weeks, prefer MVP, keep security"

# Expected behavior:
# - Detects this as analysis request
# - Routes to: /vybe:audit mvp-extraction --timeline=14days + scope-drift  
# - Runs audit commands automatically
# - Provides structured analysis based on YOUR project
# - Suggests specific features to cut/keep
```

**Test Points:**
- [ ] Does discuss detect analysis requests correctly?
- [ ] Does it route to appropriate audit modes?
- [ ] Are audit results based on actual project (not hardcoded examples)?
- [ ] Are recommendations actionable and project-specific?

### Step 13: Business Value Alignment
```bash
# Test business outcome analysis
/vybe:discuss "find features not tied to business outcomes and suggest what to do"

# Expected behavior:
# - Routes to: /vybe:audit business-value
# - Analyzes actual implemented features vs outcomes.md
# - Identifies orphan features with no business justification
# - Provides cost/value analysis with LOC counts
```

**Test Points:**
- [ ] Does it find actual orphan features in your project?
- [ ] Are business outcome mappings accurate?
- [ ] Does it provide actionable suggestions (keep/document/remove)?
- [ ] Are LOC and maintenance cost estimates realistic?

### Step 14: Documentation Synchronization  
```bash
# Test documentation analysis
/vybe:discuss "our README is outdated, sync it with actual features"

# Expected behavior:
# - Routes to: /vybe:audit documentation + code-reality
# - Compares README.md claims vs actual source code
# - Finds missing/incorrect/outdated documentation
# - Suggests specific updates to align docs with reality
```

**Test Points:**
- [ ] Does it compare actual files (not generic examples)?
- [ ] Are documentation gaps accurately identified?
- [ ] Are suggested updates specific and actionable?
- [ ] Does it handle different project types correctly?

### Step 15: Direct Audit Commands (CI/Automation Ready)
```bash
# Test direct audit modes for automation
/vybe:audit code-reality              # Compare docs vs implementation
/vybe:audit scope-drift               # Detect feature creep
/vybe:audit mvp-extraction           # Extract minimal scope
/vybe:audit business-value           # Map features to outcomes
/vybe:audit documentation            # Sync docs with code

# Expected behavior:
# - Each command provides structured, predictable output
# - Results are based on YOUR actual project analysis
# - Output format is consistent (suitable for CI/automation)
# - No hardcoded examples or assumptions
```

**Test Points:**
- [ ] Do audit commands run independently (not requiring discuss)?
- [ ] Is output format consistent and structured?
- [ ] Are results based on actual project analysis?
- [ ] Would output work well in CI/CD pipelines?

### Step 16: Scope Increase Planning
```bash
# Test guided scope expansion with timeline increase
/vybe:discuss "we have 2 more months, what features should we add?"

# Expected behavior:
# - Analyzes current project state and architecture
# - Provides intelligent feature recommendations based on existing features
# - Suggests natural extensions and business opportunities
# - Gives specific /vybe:plan commands to add recommended features
# - Provides /vybe:backlog reorganization guidance
```

**Test Points:**
- [ ] Are feature recommendations relevant to the project type?
- [ ] Do suggestions build logically on existing features?
- [ ] Are specific Vybe commands provided for implementation?
- [ ] Does it consider technical architecture when suggesting features?
- [ ] Are business value opportunities identified correctly?

### Step 17: Integration Verification
```bash
# Verify the integration works end-to-end
/vybe:discuss "analyze project health and suggest improvements"

# Expected behavior:
# - Routes to multiple audit modes automatically
# - Provides comprehensive project analysis
# - Suggests follow-up commands
# - Results are actionable and project-specific
```

**Test Points:**
- [ ] Can discuss handle complex multi-analysis requests?
- [ ] Do multiple audit modes work together coherently?
- [ ] Are follow-up suggestions helpful?
- [ ] Does the full pipeline provide real value?

---

**Solo Tutorial Complete!** 
This path tests core Vybe functionality with powerful code-reality analysis perfect for individual developers.

---

# Multi-Member Tutorial

**Scenario**: Building an e-commerce platform called "ShopFlow" with a 3-developer team.

**Participants**: 
- dev-1: Backend specialist (authentication, payments)
- dev-2: Frontend specialist (UI, product catalog)  
- dev-3: DevOps specialist (deployment, infrastructure)

**Focus**: Team coordination, assignment conflicts, multi-session workflows

---

## Phase 1: Project Foundation & Team Setup

### Step 1: Initialize Team Project
```bash
# Command to test:
/vybe:init "E-commerce platform with user authentication, payment processing, product catalog, and order management. Focus on scalability and security."

# Expected behavior:
# - Analyzes project requirements and patterns
# - Creates complete project foundation
# - Selects appropriate technologies for scalability requirements
# - Supports team-based development
# - Sets up coordination infrastructure
```

**Test Points:**
- [ ] Does init work well for team projects?
- [ ] Are foundation documents suitable for multiple developers?
- [ ] Are technology choices appropriate for the project requirements?
- [ ] Is the project scope appropriate for team division?

### Step 2: Configure Team Structure
```bash
# Command to test - automatic feature distribution:
/vybe:backlog member-count 3 --auto-assign

# Expected behavior:
# - Configures project for 3 developers
# - Creates dev-1, dev-2, dev-3 placeholders
# - AUTOMATICALLY distributes existing features across all 3 developers
# - Updates backlog.md with member structure AND assignments
# - No manual assignment needed!

# Alternative: Manual assignment mode
# /vybe:backlog member-count 3    # Creates developers but requires manual assignment
```

**Test Points:**
- [ ] Does auto-assign distribute features evenly across all 3 developers?
- [ ] Are dev-1, dev-2, dev-3 slots created with balanced workloads?
- [ ] Is backlog.md updated with both member structure AND assignments?
- [ ] Does it eliminate the need for manual assign commands?
- [ ] Does AI assign features to avoid conflicts and overlapping work?
- [ ] Are integration points and coordination planned automatically?

## Phase 2: Feature Planning & Assignment

### Step 3: Plan Features for Team Division
```bash
# Commands to test:
/vybe:plan user-authentication "Secure user registration and login with JWT tokens"
/vybe:plan payment-processing "Stripe integration with webhook handling"
/vybe:plan product-catalog "Product listing with search and inventory management"

# Expected behavior:
# - Analyzes each feature type and requirements
# - Creates comprehensive specifications for each feature
# - Considers team specializations in design
# - Plans for feature interdependencies
# - Uses appropriate technical patterns for each feature
```

**Test Points:**
- [ ] Are features planned with team coordination in mind?
- [ ] Do specifications consider skill specializations?
- [ ] Are technical patterns appropriate for each feature?
- [ ] Are dependencies between features clear?

## Phase 3: Multi-Session Development  

### Step 4: Simulate Multiple Developers with Automatic Implementation
**Note**: This requires the GitHub repository setup from [Multi-Member Tutorial Setup](#multi-member-tutorial-setup) above.

```bash
# Terminal 1 (Backend Developer):
export VYBE_MEMBER=dev-1
/vybe:execute my-feature

# Enhanced behavior for dev-1:
# - Finds assigned backend tasks from backlog
# - Creates backend code structure (APIs, services, models)
# - Generates backend-specific tests
# - Follows template patterns for backend (if template exists)
# - Commits to dev-1 branch
# - Coordinates with other team members

# Terminal 2 (Payment Developer):
export VYBE_MEMBER=dev-2  
/vybe:execute my-feature

# Enhanced behavior for dev-2:
# - Finds assigned payment processing tasks from backlog
# - Creates payment integration code (Stripe, webhooks, validation)
# - Generates payment-specific tests
# - Follows template patterns for payment systems (if template exists)
# - Commits to dev-2 branch
# - Coordinates with authentication and catalog teams

# Terminal 3 (Catalog Developer):
export VYBE_MEMBER=dev-3
/vybe:execute my-feature

# Enhanced behavior for dev-3:
# - Finds assigned product catalog tasks from backlog
# - Creates catalog code structure (products, search, inventory)
# - Generates catalog-specific tests
# - Follows template patterns for catalog features (if template exists)
# - Commits to dev-3 branch
# - Coordinates with authentication and payment teams

# Terminal 4 (Project Overview):
/vybe:status members
```

**Enhanced Test Points:**
- [ ] Does each developer get role-specific code generation?
- [ ] Are template patterns applied consistently across all 3 team members?
- [ ] Do unit tests run automatically for each developer's code?
- [ ] Is git branch coordination working between all 3 developers?
- [ ] Does multi-member work coordinate without conflicts?
- [ ] Are all 3 developers generating actual runnable code?
- [ ] Is workload evenly distributed across dev-1, dev-2, and dev-3?

### Step 5: Test Assignment Conflicts
```bash
# Terminal 1 (dev-1):
/vybe:execute user-authentication-task-1

# Terminal 2 (dev-2 working on dev-1's assignment):
export VYBE_MEMBER=dev-2
/vybe:execute user-authentication-task-2

# Expected behavior:
# - Conflict detection in hooks
# - Warning messages about assignment mismatch
# - Guidance on proper assignments
```

**Test Points:**
- [ ] Are assignment conflicts detected automatically?
- [ ] Do conflict warnings make sense?
- [ ] Is guidance helpful for resolution?

## Phase 4: Team Coordination & Quality

### Step 6: Team Status Monitoring
```bash
# Commands to test:
/vybe:status members          # Overview of all assignments
/vybe:status dev-1           # Individual developer progress
/vybe:status dev-2           # Another developer's work

# Expected behavior:
# - Clear team progress visibility
# - Individual workload tracking
# - Coordination insights
```

**Test Points:**
- [ ] Is team status view comprehensive but not overwhelming?
- [ ] Are individual progress views useful?
- [ ] Does status help with team coordination?

### Step 7: Multi-Member Quality Assurance
```bash
# Commands to test:
/vybe:audit members          # Team coordination audit
/vybe:audit dependencies     # Cross-feature dependency check
/vybe:audit consistency      # Consistency across team work

# Expected behavior:
# - Detects team coordination issues
# - Finds cross-feature inconsistencies
# - Suggests rebalancing or fixes
```

**Test Points:**
- [ ] Does audit catch real team coordination problems?
- [ ] Are cross-developer consistency issues found?
- [ ] Do fix suggestions make sense for teams?

## Phase 5: Advanced Team Scenarios

### Step 8: Dynamic Team Changes
```bash
# Command to test:
/vybe:backlog member-count 4    # Add new developer mid-project

# Expected behavior:
# - Preserves existing assignments
# - Creates dev-4 slot
# - Suggests workload rebalancing
```

**Test Points:**
- [ ] Can team size change smoothly mid-project?
- [ ] Are existing assignments preserved?
- [ ] Is onboarding guidance provided for new member?

### Step 9: Workload Rebalancing
```bash
# Commands to test:
/vybe:audit members                     # Identify imbalances
/vybe:backlog assign product-catalog dev-3   # Reassign overloaded work
/vybe:status members                    # Verify rebalancing

# Expected behavior:
# - Clear workload imbalance detection
# - Smooth reassignment process
# - Updated coordination tracking
```

**Test Points:**
- [ ] Are workload imbalances clearly identified?
- [ ] Is reassignment process smooth?
- [ ] Does the system adapt to changes well?

### Step 10: Multi-Member Stage Integration
```bash
# Test intelligent integration of all developer work:
/vybe:release stage-1

# Expected AI integration behavior:
# 1. COMPLETION VERIFICATION: Check all dev-1, dev-2, dev-3 work is complete
# 2. DEPENDENCY ANALYSIS: Run /vybe:audit dependencies automatically
# 3. CONFLICT DETECTION: Run /vybe:audit members automatically  
# 4. INTELLIGENT MERGE: Merge all developer branches with conflict resolution
# 5. INTEGRATION TESTING: Run comprehensive tests on combined system
# 6. QUALITY VALIDATION: Verify features work together, not just individually

# Alternative: Manual integration commands
# /vybe:audit dependencies    # Check integration readiness manually
# /vybe:audit members         # Verify coordination manually  
```

**Test Points:**
- [ ] Does AI automatically verify all developers completed their assignments?
- [ ] Are dependencies and conflicts detected before integration?
- [ ] Does AI intelligently merge all developer branches?
- [ ] Are integration tests run on the combined system?
- [ ] Does the integrated system work correctly with all features?
- [ ] Is the system ready for next stage development?

---

## Key Testing Focus Areas

### Critical Command Distinctions
Pay special attention to these commonly confused command pairs:

**Status vs Audit (Most Important)**
- `/vybe:status` = Progress tracking ("How are we doing?")
- `/vybe:audit` = Quality assurance ("What needs fixing?")

**Plan vs Discuss**
- `/vybe:plan` = Create feature specifications
- `/vybe:discuss` = Natural language command assistance

**Execute vs Status**
- `/vybe:execute` = Do implementation work
- `/vybe:status` = Check progress and assignments

### Command Consistency Checks
Look for these potential issues:
- Parameter order inconsistencies (feature-first vs member-first)
- Unclear command naming (`member-count` vs `set-members`)
- Verbose syntax that could be simplified
- Missing useful shortcuts or aliases

---

## Example Project Descriptions (Reference)

You can test the framework with any project type. Here are diverse examples to explore:

### Data & Analytics Projects
```bash
/vybe:init "COVID-19 data visualization platform showing global spread patterns with interactive maps, time-series analysis, and real-time data feeds from WHO and CDC APIs"

/vybe:init "Financial analytics dashboard for cryptocurrency portfolios with real-time price tracking, portfolio rebalancing algorithms, and tax reporting features"

/vybe:init "Sports performance analytics system processing athlete biometric data, video analysis, and providing ML-based training recommendations"
```

### AI & Machine Learning Projects
```bash
/vybe:init "Computer vision system for medical image analysis detecting anomalies in X-rays and MRI scans with FDA compliance requirements"

/vybe:init "Natural language processing API for sentiment analysis of customer reviews across multiple languages with batch processing capabilities"

/vybe:init "Recommendation engine for streaming service using collaborative filtering, content-based filtering, and real-time user behavior analysis"
```

### Mobile & IoT Projects
```bash
/vybe:init "Smart home automation mobile app controlling IoT devices via MQTT with voice commands, scheduling, and energy monitoring"

/vybe:init "Fitness tracking mobile application with GPS route tracking, social challenges, wearable device integration, and nutrition logging"

/vybe:init "Industrial IoT monitoring system for factory equipment with predictive maintenance, real-time alerts, and OPC UA protocol support"
```

### Enterprise & B2B Projects
```bash
/vybe:init "HR management system with employee onboarding, performance reviews, leave tracking, and integration with payroll systems"

/vybe:init "Supply chain management platform with inventory tracking, vendor management, automated reordering, and blockchain verification"

/vybe:init "Customer support ticketing system with AI-powered routing, knowledge base, live chat, and SLA tracking"
```

### Developer Tools & Infrastructure
```bash
/vybe:init "CI/CD pipeline orchestration tool supporting multiple cloud providers with GitOps, secret management, and compliance scanning"

/vybe:init "API gateway with rate limiting, authentication, request transformation, and GraphQL federation support"

/vybe:init "Distributed tracing system for microservices with performance monitoring, error tracking, and automated root cause analysis"
```

### Gaming & Entertainment
```bash
/vybe:init "Multiplayer online battle arena game backend with matchmaking, leaderboards, anti-cheat system, and replay storage"

/vybe:init "Music streaming service with personalized playlists, offline sync, artist analytics, and high-quality audio codec support"

/vybe:init "Virtual event platform with video streaming, interactive breakout rooms, networking features, and attendee analytics"
```

The framework will analyze each project description, research appropriate technologies and patterns, and generate relevant documentation specific to that domain.

---

---

# Template Tutorial

**Scenario**: Building an AI workflow platform using the GenAI Launchpad template as architectural DNA.

**Focus**: Template import, analysis, and template-driven development patterns.

**Prerequisites**: Complete template-based setup above.

---

## Phase 1: Template Discovery and Import

### Step 1: Import External Template
```bash
# Import a production template (using GenAI Launchpad example)
/vybe:template import ./temp/genai-launchpad genai-stack

# Expected behavior:
# - Creates .vybe/templates/genai-stack/ directory
# - Copies template source to source/ subdirectory
# - Creates initial metadata.yml
# - Template status: imported but not analyzed

# Test alternative: GitHub import
# /vybe:template import github.com/user/template-repo template-name
```

### Step 2: View Available Templates
```bash
/vybe:template list

# Expected output:
# - Shows genai-stack with "imported" status
# - Shows source location and import date
# - Indicates template needs generation
# - Provides next steps
```

### Step 3: Validate Template Before Analysis
```bash
/vybe:template validate genai-stack

# Expected output:
# - ✅ Template directory exists
# - ✅ Source directory exists with files
# - ✅ Metadata file exists
# - ⚠️ Template not yet analyzed
# - Suggests running generate command
```

## Phase 2: AI Template Analysis and Generation

### Step 4: Generate Template Structures
```bash
/vybe:template generate genai-stack

# Expected AI behavior:
# - Deep analysis of ALL template files
# - Pattern extraction from actual code
# - Architecture understanding from template structure
# - Generate enforcement structures based on analysis
# - Create Vybe-compatible documents from template
# - No hardcoded assumptions - everything from template analysis

# Expected output structures:
# - .vybe/enforcement/ (structure rules, component patterns)
# - .vybe/patterns/ (reusable code templates)
# - .vybe/validation/ (compliance checking rules)
# - .vybe/templates/genai-stack/mapping.yml (Vybe integration)
# - .vybe/templates/genai-stack/generated/ (Vybe documents)
```

### Step 5: Validate Generated Template
```bash
/vybe:template validate genai-stack

# Expected output:
# - ✅ All validation checks pass
# - ✅ Template analyzed and generated
# - ✅ Enforcement structures exist
# - ✅ Pattern templates exist
# - ✅ Validation rules exist
# - Template ready for project use
```

### Step 6: Review Template Analysis
```bash
/vybe:template list

# Expected enhanced output:
# - Shows genai-stack with "✅ Ready" status
# - AI Analysis: ✓ Complete
# - Shows detected languages, frameworks
# - Shows complexity and template type
# - Indicates template is ready for --template usage
```

## Phase 3: Template-Driven Project Initialization

### Step 7: Initialize Project with Template DNA
```bash
/vybe:init "AI workflow orchestration platform for document processing and analysis" --template=genai-stack

# Expected behavior:
# - Template validation before proceeding
# - Load template context (metadata, mapping, generated docs)
# - Generate project docs using template as foundation
# - Activate template enforcement structures
# - Mark template as permanent project DNA
# - Create .vybe/project/.template file with template info

# Expected project structure:
# - Standard .vybe/project/ documents enhanced with template patterns
# - .vybe/enforcement/ rules active
# - .vybe/patterns/ templates ready for use
# - .vybe/validation/ rules enforcing template compliance
```

### Step 8: Verify Template Integration
```bash
# Check that template DNA is active
ls -la .vybe/

# Expected structure:
# - enforcement/ (template rules)
# - patterns/ (template code templates)
# - validation/ (template compliance rules)
# - project/.template (template DNA marker)
# - templates/genai-stack/ (template storage)

# Review project foundation
cat .vybe/project/.template

# Expected content:
# - template: genai-stack
# - template_set: [timestamp]
# - template_immutable: true
```

## Phase 4: Template-Guided Development

### Step 9: Generate Template-Driven Backlog
```bash
# Create outcome-grouped backlog following template patterns
/vybe:backlog init

# Expected AI behavior:
# - Load template enforcement rules
# - Use template patterns for stage organization  
# - Follow template's workflow progression
# - Generate stages that align with template architecture
# - Create backlog structure using template-specific organization
```

**Test Points:**
- [ ] Does backlog follow template organizational patterns?
- [ ] Are stages aligned with template workflow structure?
- [ ] Does generated backlog respect template conventions?

### Step 10: Template-Aware Feature Planning
```bash
# Standard stage planning with template enforcement
/vybe:plan stage-1

# Alternative: Individual feature planning (commented examples)
# /vybe:plan document-processing "Create workflow for processing and analyzing uploaded documents"
# /vybe:plan user-interface "Template-driven UI components and layouts"
# /vybe:plan data-pipeline "Template-compliant data processing workflow"

# Expected AI behavior:
# - Load template enforcement rules
# - Use template patterns for feature structure
# - Follow template's workflow/component organization
# - Generate specs that align with template architecture
# - Create tasks using template-specific patterns

# Test that planning follows template structure:
# - Should create features following template directory patterns
# - Should use template's component/service organization
# - Should reference template's workflow patterns
```

### Step 11: Template-Enforced Code Generation with Automatic Implementation
```bash
# Execute all tasks in stage-1 with template enforcement
/vybe:execute stage-1 --complete

# Alternative execution patterns (commented examples)
# /vybe:execute stage-1-task-1          # Single task execution
# /vybe:execute stage-1-task-2          # Next task in sequence
# /vybe:execute document-processing-task-1  # Individual feature task

# Enhanced template-driven behavior:
# - PRIORITY 1: Load template patterns (ENFORCE STRICTLY)
# - Use exact code templates from .vybe/patterns/
# - Follow .vybe/enforcement/ rules with NO deviations
# - Generate actual runnable code following template
# - Create template-compliant tests
# - Validate against .vybe/validation/ rules
# - Auto-fix template violations

# Expected automatic implementation:
# 1. Creates project structure EXACTLY matching template
# 2. Generates code using template's exact patterns
# 3. Follows template's naming conventions strictly
# 4. Includes template's required dependencies
# 5. Uses template's error handling patterns
# 6. Creates tests following template test patterns
# 7. Validates template compliance automatically

# Template compliance validation:
# - Directory structure matches enforcement rules
# - Code patterns match template exactly
# - No unauthorized deviations allowed
# - Template DNA remains immutable

# Verify enhanced template enforcement:
# - All files follow template patterns exactly
# - Tests use template test structures
# - Code passes template validation rules
# - Application runs using template conventions
```

### Step 12: Template Compliance Validation
```bash
/vybe:audit

# Expected AI behavior:
# - Load template validation rules
# - Check project structure against template requirements
# - Validate naming conventions from template
# - Verify import patterns match template
# - Report any deviations from template standards

# Expected output:
# - Template compliance checking
# - Structure validation against template rules
# - Code pattern verification
# - Any violations of template DNA reported
```

## Phase 5: Template DNA Immutability Testing

### Step 13: Test Template Immutability
```bash
# Try to change template (should fail)
/vybe:init "Same project" --template=different-template

# Expected behavior:
# - Detect existing project with template DNA
# - Refuse to change template
# - Explain template immutability
# - Suggest migration approach if template change needed
```

### Step 14: Template-Guided Discussion
```bash
/vybe:discuss "How can I add real-time features to this workflow platform?"

# Expected AI behavior:
# - Consider template constraints and patterns
# - Suggest solutions that work within template architecture
# - Reference template's real-time capabilities if any
# - Propose implementation following template patterns
# - Maintain consistency with template DNA
```

## Phase 6: Template System Verification

### Step 15: Complete Template Workflow Test
```bash
# Test complete development cycle with template
/vybe:status          # Should show template-guided progress
/vybe:plan stage-2    # Should follow template patterns
/vybe:execute task-X  # Should use template code patterns
/vybe:audit          # Should validate template compliance
/vybe:release        # Should advance using template structure

# Verify template DNA maintained throughout:
# - All commands respect template patterns
# - Generated code follows template standards
# - Project structure remains template-compliant
# - Template cannot be changed mid-project
```

### Step 16: Template Migration Scenario
```bash
# Test template migration guidance
/vybe:discuss "This GenAI template is too complex, I want to switch to a simpler FastAPI template"

# Expected AI behavior:
# - Explain template immutability
# - Suggest creating new project with different template
# - Offer migration assistance strategy
# - Explain trade-offs and considerations
# - Provide step-by-step migration approach
```

---

## Template Tutorial Success Criteria

### Core Functionality ✅
- [ ] Template import works from both local and GitHub sources
- [ ] AI analysis generates intelligent enforcement structures
- [ ] Generated structures are template-specific, not generic
- [ ] Template integration with init works seamlessly
- [ ] Template DNA becomes permanent project foundation

### AI Intelligence ✅
- [ ] AI reads and understands actual template architecture
- [ ] Generated patterns match template's real code style
- [ ] Enforcement rules reflect template's actual organization
- [ ] No hardcoded assumptions - everything from template analysis
- [ ] Template mapping connects to Vybe workflow logically

### Enforcement Integration ✅  
- [ ] All commands respect template patterns after init
- [ ] Code generation uses template patterns
- [ ] Validation checks template compliance
- [ ] Template DNA maintained throughout development
- [ ] Template immutability properly enforced

### User Experience ✅
- [ ] Template workflow is intuitive and clear
- [ ] Error messages are helpful and specific
- [ ] Template status and progress visible
- [ ] Migration guidance provided when needed
- [ ] Template benefits are obvious and valuable

---

## Session Continuity Tutorial 🔄

**Purpose**: Test Vybe's session handoff and context preservation across Claude Code restarts.

**Prerequisites**: Complete install.sh setup with hooks enabled.

### Phase 1: Complete a Stage
```bash
# 1. Start new project with session tracking
mkdir session-test && cd session-test
git clone https://github.com/iptracej-education/vybe.git
cd vybe && ./install.sh && cd .. && rm -rf vybe

# 2. Initialize project 
/vybe:init "Simple task manager with local storage"

# 3. Create and execute first stage
/vybe:backlog init
/vybe:plan task-crud "Basic task CRUD operations"
/vybe:execute task-1-create-tasks

# 4. Complete Stage 1 
/vybe:release stage-1

# Expected: Stage marked complete, learnings captured
```

### Phase 2: Test Session Handoff
```bash
# 5. Check current status before restart
/vybe:status outcomes

# 6. **RESTART CLAUDE CODE NOW**
# - Close Claude Code completely
# - Reopen Claude Code  
# - Navigate back to your project directory

# Expected during restart:
# If conversation compacts, you should see:
# "🔄 PreCompact triggered - Saving Vybe context..."
# "✅ Context saved: .vybe/context/precompact/checkpoint-[id].json"
# "🚀 Ready for compaction - context is safe!"

# NOT: Standard Claude Code compaction message
```

### Phase 3: Resume Work Seamlessly
```bash
# 7. After restart, verify context preservation
/vybe:status outcomes
# Expected: Shows Stage 1 complete, Stage 2 ready

# 8. Continue exactly where you left off
/vybe:plan stage-2 "User interface and data persistence"
/vybe:execute task-1-ui-foundation

# Expected: Picks up context, knows project history
```

### Phase 4: Test Mid-Task Interruption
```bash
# 9. Start complex task
/vybe:execute task-2-data-storage

# 10. **INTERRUPT by restarting Claude Code mid-execution**

# 11. After restart, check session recovery
/vybe:status
# Expected: Shows in-progress task status

# 12. Resume interrupted work
/vybe:execute task-2-data-storage
# Expected: Continues from where it left off
```

### Session Continuity Success Criteria

#### ✅ Hook Installation Working
- [ ] `install.sh` configures hooks without errors
- [ ] `~/.claude/.claude/hooks/` contains executable hook files
- [ ] `~/.claude/settings.json` has hooks section enabled

#### ✅ Context Preservation  
- [ ] PreCompact hook triggers before conversation compaction
- [ ] Vybe context saved to `.vybe/context/precompact/`
- [ ] NO standard Claude Code compaction message
- [ ] Session state preserved across restarts

#### ✅ Seamless Resume
- [ ] `/vybe:status` shows correct project state after restart
- [ ] Completed stages remain marked as complete
- [ ] In-progress work can be resumed
- [ ] Project context and history accessible

#### ✅ Multi-Session Coordination
- [ ] Git state preserved across sessions
- [ ] Task dependencies maintained
- [ ] Member assignments (if using teams) preserved
- [ ] Session tracking files created in `.vybe/context/sessions/`

### Troubleshooting Session Issues

**❌ Standard compaction message appears:**
- Check hooks installation: `ls -la ~/.claude/.claude/hooks/`
- Verify settings.json: `grep -A 5 '"hooks"' ~/.claude/settings.json`
- Restart Claude Code after fixing configuration

**❌ Context lost after restart:**
- Check `.vybe/context/` directory exists and has content
- Verify precompact.py is executable: `ls -la ~/.claude/.claude/hooks/precompact.py`
- Ensure project has proper .vybe structure

**❌ Resume commands don't work:**
- Run `/vybe:status` to check current project state  
- Verify you're in the correct project directory
- Check git repository is properly initialized

### Expected Session Handoff Message

When hooks work correctly, you'll see:
```
🔄 PreCompact triggered (auto) - Saving Vybe context...
✅ Context saved: .vybe/context/precompact/checkpoint-[session_id].json

============================================================
VYBE CONTEXT PRESERVED
============================================================
# Context Restored After Compaction

Session [session_id] was automatically saved before compaction.

## Resume Current Work
You were working as: **general-purpose** agent
On task range: **stage-1-implementation**

To continue exactly where you left off:
/vybe:task-continue general-purpose stage-1-implementation [session_id]

## Active Features
- task-crud

## Context Recovery
All work has been preserved in .vybe/context/precompact/
- Checkpoint: checkpoint-[session_id].json
- Git diff: diff-[session_id].patch  
- Transcript: transcript-[session_id].txt

The Vybe framework ensures no work is lost during compaction.
============================================================

🚀 Ready for compaction - context is safe!
```

---

**Ready to begin tutorial execution!**

This tutorial provides four comprehensive paths for testing the entire Vybe framework:

**🏗️ Template Tutorial** - 16 steps testing template import, AI analysis, and template-driven development
**👤 Solo Tutorial** - 11 focused steps testing core functionality without team complexity
**👥 Multi-Member Tutorial** - 10 steps testing team coordination and multi-session workflows  
**🔄 Session Continuity Tutorial** - 4 phases testing context preservation and seamless handoff across Claude Code restarts

All tutorials emphasize the critical distinction between status (progress) and audit (quality) commands. The template tutorial adds comprehensive testing of AI-driven template analysis and architectural DNA enforcement. The session continuity tutorial validates that work is never lost and development can seamlessly resume across sessions. Any inconsistencies, unclear commands, or workflow issues should surface during execution.
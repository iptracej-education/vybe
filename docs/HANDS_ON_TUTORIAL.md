# Vybe Framework - Complete Hands-On Tutorial

A comprehensive table-top exercise walking through all Vybe commands from project initialization to completion. This tutorial simulates real development workflows to test command consistency and identify potential improvements.

**Note**: Commands use performance-optimized intelligent analysis. Phase 1 provides immediate intelligent setup (~30 seconds), while Phase 2 enhances with comprehensive research in background (2-5 minutes). You get fast feedback with same final quality.

## Prerequisites & Setup

Before starting any tutorial, you need to set up your environment properly based on whether you're testing solo or team features.

### Repository Requirements
- **Solo Tutorial**: Local git repository only (no GitHub needed)
- **Multi-Member Tutorial**: **GitHub repository required** for team coordination
  - Vybe uses git-based coordination between team members
  - Create your GitHub repository before starting team tutorial

### Solo Tutorial Setup
```bash
# 1. Create test environment
mkdir vybe-solo-test && cd vybe-solo-test
git init

# 2. Install Vybe Framework
git clone https://github.com/iptracej-education/vybe.git vybe-framework
cp -r vybe-framework/.claude .
cp vybe-framework/CLAUDE.md .
rm -rf vybe-framework

# 3. Ready to start solo tutorial below
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
cp vybe-framework/CLAUDE.md .
rm -rf vybe-framework

# 4. Initial commit to shared repository
git add .
git commit -m "Set up Vybe framework for team testing"
git push origin main

# 5. Ready to start multi-member tutorial below
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

---

## Example Project Descriptions

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

# Solo Developer Tutorial

**Scenario**: Building a personal task management app with authentication and API integration.

**Focus**: Core Vybe functionality without team complexity

---

## Phase 1: Project Foundation

### Step 1: Initialize New Project
```bash
# Command to test:
/vybe:init "Personal task management app with user authentication, API integrations, and data export features"

# Expected behavior:
# PHASE 1 (Fast - 30 seconds):
# - Analyzes project description immediately for project type and requirements
# - Infers appropriate technology stack from description
# - Creates .vybe/ directory structure
# - Generates intelligent overview.md with business context
# - Creates smart architecture.md with tech stack choices
# - Generates appropriate conventions.md with development standards
# - Sets up solo developer workflow with immediate intelligence
# PHASE 2 (Background - 2-5 minutes):
# - Enhances documents with comprehensive research
# - Same final quality, faster initial feedback
```

**Test Points:**
- [ ] Does init create all required foundation documents?
- [ ] Are the generated documents specific to the project description?
- [ ] Do technology choices match the project requirements?
- [ ] Is the project context comprehensive enough for decision-making?
- [ ] Does it work well for solo development?

## Phase 2: Feature Planning

### Step 2: Plan Authentication Feature
```bash
# Command to test:
/vybe:plan user-authentication "Secure user registration and login system with email verification, password reset, and JWT tokens"

# Expected behavior:
# PHASE 1 (Fast - 30 seconds):
# - Analyzes feature type immediately from description
# - Infers security requirements for authentication systems
# - Creates .vybe/features/user-authentication/
# - Generates intelligent requirements.md with EARS format
# - Creates smart design.md with appropriate technical approach
# - Produces specific tasks.md with implementation steps
# PHASE 2 (Background):
# - Enhances with comprehensive security research
# - Same final quality, faster initial planning
```

**Test Points:**
- [ ] Is the plan command syntax intuitive (feature-name first)?
- [ ] Are generated requirements comprehensive and actionable?
- [ ] Does design consider project architecture and constraints?
- [ ] Are security considerations appropriate for authentication?
- [ ] Are tasks granular enough for implementation?

### Step 3: Plan API Integration Feature
```bash
# Command to test:
/vybe:plan api-integration "External API integrations for weather data and email notifications"

# Expected behavior:
# - Analyzes API integration patterns and requirements
# - Creates second feature specification  
# - Maps dependencies with user-authentication
# - Provides appropriate integration guidance
# - Considers error handling and rate limiting
```

**Test Points:**
- [ ] Does planning detect dependencies between features?
- [ ] Are API integration patterns appropriate for the use case?
- [ ] Is error handling adequately planned?
- [ ] Do specifications align with project architecture?

---

## Phase 3: Implementation Workflow

### Step 4: Check Project Status
```bash
# Command to test:
/vybe:status

# Expected behavior:
# - Shows overall project health
# - Displays planned features
# - Indicates progress on features
# - Shows next steps for solo developer
```

**Test Points:**
- [ ] Is the default status view informative for solo work?
- [ ] Are planned features clearly visible?
- [ ] Is progress tracking meaningful at this stage?
- [ ] Does it provide clear next steps?

### Step 5: Start Implementation Work
```bash
# Command to test:
/vybe:execute user-authentication-task-1

# Expected behavior:
# - Loads complete project context
# - Shows specific task guidance
# - Provides implementation steps
# - Updates task status appropriately
```

**Test Points:**
- [ ] Does specific task execution work smoothly?
- [ ] Is project context properly loaded?
- [ ] Are implementation steps clear?
- [ ] Does progress tracking work for solo developer?

## Phase 4: Quality Assurance

### Step 6: Project Quality Audit
```bash
# Command to test:
/vybe:audit

# Expected behavior:
# - Detects gaps in feature specifications
# - Identifies any duplicate content
# - Finds consistency issues
# - Provides specific fix commands
# - Works well for solo developer
```

**Test Points:**
- [ ] Does audit find actual quality problems for solo projects?
- [ ] Are identified gaps actionable?
- [ ] Do fix commands make sense?
- [ ] Is it clearly different from /vybe:status?

### Step 7: Fix Automation Testing
```bash
# Commands to test:
/vybe:audit features
/vybe:audit fix-gaps features

# Expected behavior:
# - Identifies missing sections in features
# - Provides specific fix commands
# - Actually resolves identified issues
```

**Test Points:**
- [ ] Does gap detection work for solo projects?
- [ ] Do fix commands actually resolve issues?
- [ ] Can you verify fixes with follow-up audit?

## Phase 5: Natural Language Help

### Step 8: Get Command Guidance
```bash
# Command to test:
/vybe:discuss "I need to add OAuth integration to authentication, what's the best approach?"

# Expected behavior:
# - Understands the technical request
# - Analyzes current authentication specification
# - Suggests specific Vybe commands to modify specs
# - Provides implementation guidance
```

**Test Points:**
- [ ] Does discuss understand natural language requests?
- [ ] Are suggestions practical and actionable?
- [ ] Does it reference existing project specifications?
- [ ] Is the response helpful for solo developers?

### Step 9: Final Project Review
```bash
# Commands to test:
/vybe:status                    # Final progress check
/vybe:audit                     # Final quality check

# Expected behavior:
# - Shows near-complete project state
# - Minimal or zero quality issues
# - Clear next steps for completion
```

**Test Points:**
- [ ] Does final status provide clear completion picture?
- [ ] Are remaining quality issues minimal?
- [ ] Is the project ready for development/deployment?

---

**Solo Tutorial Complete!** 
This path tests core Vybe functionality perfect for individual developers.

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
# Command to test:
/vybe:backlog member-count 3

# Expected behavior:
# - Configures project for 3 developers
# - Creates dev-1, dev-2, dev-3 placeholders
# - Updates backlog.md with member structure
# - Enables assignment features
```

**Test Points:**
- [ ] Does member-count command work intuitively?
- [ ] Are member slots clearly defined (dev-1, dev-2, dev-3)?
- [ ] Is the command name clear vs alternatives?
- [ ] Does it enable team features properly?

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

### Step 4: Assign Features to Team Members
```bash
# Commands to test:
/vybe:backlog assign user-authentication dev-1
/vybe:backlog assign payment-processing dev-1  
/vybe:backlog assign product-catalog dev-2

# Expected behavior:
# - Clear assignment tracking
# - Workload visibility
# - No assignment conflicts
```

**Test Points:**
- [ ] Is the assign command syntax intuitive?
- [ ] Are assignments clearly tracked?
- [ ] Does workload balancing become visible?

## Phase 3: Multi-Session Development

### Step 5: Simulate Multiple Developers
**Note**: This requires the GitHub repository setup from [Multi-Member Tutorial Setup](#multi-member-tutorial-setup) above.

```bash
# Terminal 1 (Backend Developer):
export VYBE_MEMBER=dev-1
/vybe:execute my-feature

# Terminal 2 (Frontend Developer):
export VYBE_MEMBER=dev-2  
/vybe:execute my-feature

# Terminal 3 (Project Overview):
/vybe:status members
```

**Test Points:**
- [ ] Does VYBE_MEMBER environment variable work smoothly?
- [ ] Do multiple sessions coordinate properly?
- [ ] Is member-specific work clearly identified?

### Step 6: Test Assignment Conflicts
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

### Step 7: Team Status Monitoring
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

### Step 8: Multi-Member Quality Assurance
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

### Step 9: Dynamic Team Changes
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

### Step 10: Workload Rebalancing
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

**Ready to begin tutorial execution!**

This tutorial provides two comprehensive paths for testing the entire Vybe framework:

**👤 Solo Tutorial** - 9 focused steps testing core functionality without team complexity
**👥 Multi-Member Tutorial** - 10 steps testing team coordination and multi-session workflows  

Both tutorials emphasize the critical distinction between status (progress) and audit (quality) commands. Any inconsistencies, unclear commands, or workflow issues should surface during execution.
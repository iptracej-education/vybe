# Vybe Complete Tutorial & Command Reference

## Table of Contents
1. [Quick Setup](#quick-setup)
2. [Complete Spec-Driven Development Flow](#complete-spec-driven-development-flow)
3. [Multi-Agent Task Delegation](#multi-agent-task-delegation)
4. [Context Session Management](#context-session-management)
5. [Command Reference](#command-reference)
6. [Advanced Scenarios](#advanced-scenarios)

## Quick Setup

### 1. Installation
```bash
# Clone the Vybe framework
git clone https://github.com/iptracej-education/vybe.git
cd vybe

# Set up your project
mkdir my-ecommerce-app
cd my-ecommerce-app

# Copy framework files
cp ../vybe/CLAUDE.md .
cp -r ../vybe/.claude .

# Initialize project structure
mkdir -p .vybe/{specs,steering,context}
```

### 2. Verify Installation
```bash
# Check hook system
/vybe:validate-hooks

# Should show: Hook system ready - PreCompact protection enabled
```

## Complete Spec-Driven Development Flow

Let's build an **e-commerce user authentication system** from start to finish.

### Phase 1: Specification Creation

#### Step 1: Initialize Feature Specification
```bash
/vybe:spec-init "User authentication system for e-commerce platform with secure login, registration, password reset, and session management"
```

**What happens:**
- Creates `.vybe/specs/user-authentication/` directory
- Generates initial specification outline
- Sets up tracking for this feature

#### Step 2: Generate Requirements
```bash
/vybe:spec-requirements user-authentication
```

**Output example:**
```markdown
# User Authentication Requirements

## Functional Requirements
- FR1: User registration with email validation
- FR2: Secure login with bcrypt password hashing
- FR3: Password reset via email
- FR4: Session management with JWT tokens
- FR5: Account lockout after failed attempts

## Non-Functional Requirements
- NFR1: Response time < 200ms for login
- NFR2: Support 10,000 concurrent users
- NFR3: 99.9% uptime requirement
```

#### Step 3: Create Technical Design
```bash
/vybe:spec-design user-authentication
```

**Interactive prompt:** "Have you reviewed requirements.md? [y/N]"
- Review the generated requirements
- Type `y` to proceed

**Output example:**
```markdown
# User Authentication Design

## Architecture
- Backend: Node.js + Express
- Database: MongoDB with Mongoose
- Authentication: JWT + bcrypt
- Email: SendGrid for notifications

## API Endpoints
- POST /auth/register
- POST /auth/login
- POST /auth/logout
- POST /auth/reset-password

## Database Schema
- User model with encrypted passwords
- Session tracking
- Failed login attempts counter
```

#### Step 4: Generate Task Breakdown
```bash
/vybe:spec-tasks user-authentication
```

**Interactive prompt:** "Have you reviewed both requirements.md and design.md? [y/N]"
- Review both documents
- Type `y` to proceed

**Output example:**
```markdown
# User Authentication Tasks

## Task List
- **user-auth-1**: Set up MongoDB user schema with validation (Backend)
- **user-auth-2**: Implement bcrypt password hashing middleware (Backend)
- **user-auth-3**: Create JWT token management utilities (Backend)
- **user-auth-4**: Build registration API endpoint (Backend)
- **user-auth-5**: Build login API endpoint (Backend)
- **user-auth-6**: Implement password reset functionality (Backend)
- **user-auth-7**: Create login form component (Frontend)
- **user-auth-8**: Create registration form component (Frontend)
- **user-auth-9**: Implement client-side validation (Frontend)
- **user-auth-10**: Write unit tests for auth utilities (Testing)
- **user-auth-11**: Write integration tests for API endpoints (Testing)
- **user-auth-12**: Write E2E tests for complete auth flow (Testing)

## Dependencies
- user-auth-4 depends on: user-auth-1, user-auth-2, user-auth-3
- user-auth-5 depends on: user-auth-1, user-auth-2, user-auth-3
- user-auth-7 depends on: user-auth-5
- user-auth-11 depends on: user-auth-4, user-auth-5, user-auth-6
```

### Phase 2: Implementation via Task Delegation

Now we move from specifications to actual implementation using specialized agents.

## Multi-Agent Task Delegation

### Scenario 1: Backend Development

#### Start with Database Schema
```bash
/vybe:task-delegate backend user-auth-1 "Create MongoDB user schema with email validation, password hashing setup, and proper indexing for performance"
```

**What happens:**
1. Hook system validates and prepares context
2. Backend agent receives focused context:
   - Requirements document
   - Design specifications  
   - Database design section
   - Task-specific instructions
3. Agent implements user schema with proper validation

**Example agent work:**
```javascript
// User model implementation
const userSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
    unique: true,
    validate: [validator.isEmail, 'Invalid email']
  },
  password: {
    type: String,
    required: true,
    minlength: 8
  },
  failedLogins: { type: Number, default: 0 },
  lockedUntil: Date
});

userSchema.index({ email: 1 });
```

#### Continue with Authentication Logic
```bash
/vybe:task-delegate backend user-auth-2,user-auth-3 "Implement bcrypt password hashing middleware and JWT token management utilities"
```

**Agent handles multiple related tasks:**
- Sets up bcrypt hashing with proper salt rounds
- Creates JWT signing and verification utilities
- Implements token refresh logic

### Scenario 2: API Development

```bash
/vybe:task-delegate backend user-auth-4-6 "Build complete authentication API endpoints: registration, login, and password reset"
```

**Agent work includes:**
- Registration endpoint with email validation
- Login endpoint with rate limiting
- Password reset with email notifications
- Proper error handling and validation

### Scenario 3: Frontend Development

```bash
/vybe:task-delegate frontend user-auth-7-9 "Create complete authentication UI: login form, registration form, and client-side validation"
```

**Frontend agent focuses on:**
- React/Vue components for auth forms
- Form validation and user feedback
- Integration with backend API
- Responsive design implementation

### Scenario 4: Testing Implementation

```bash
/vybe:task-delegate testing user-auth-10-12 "Comprehensive testing suite: unit tests, integration tests, and E2E authentication flow tests"
```

**Testing agent creates:**
- Unit tests for utilities and components
- API integration tests
- End-to-end user journey tests
- Performance and security testing

### Scenario 5: Long Debugging Session

```bash
/vybe:task-delegate debug auth-integration-issue "Investigate intermittent JWT token validation failures in production"
```

**Debug agent workflow:**
1. Analyzes error logs and patterns
2. Reproduces issue in development
3. Traces token lifecycle
4. **PreCompact protection activates** when context grows large
5. Automatically saves investigation state
6. Continues in fresh session with all findings preserved

## Context Session Management

### Automatic Context Protection (PreCompact)

#### How It Works
When Claude Code approaches context limits during long sessions:

```bash
# You're working on complex debugging...
/vybe:task-delegate debug complex-performance-issue "investigate memory leaks in user session handling"

# After extensive investigation, context grows large...
# PreCompact hook automatically triggers:
# 🔄 PreCompact triggered (auto) - Saving Vybe context...
# ✅ Context saved: .vybe/context/precompact/checkpoint-session-abc123.json
# 
# VYBE CONTEXT PRESERVED
# ======================
# Session abc123 was automatically saved before compaction.
# 
# ## Resume Current Work
# You were working as: **debug** agent
# On task range: **complex-performance-issue**
# 
# To continue exactly where you left off:
# /vybe:task-continue debug complex-performance-issue session-abc123
```

#### After Compaction
In a fresh Claude Code session:
```bash
/vybe:task-continue debug complex-performance-issue session-abc123
```

**Result:**
- All previous investigation findings restored
- Code changes and discoveries available
- Fresh context window with complete history
- No work lost during compaction

### Manual Session Management

#### Voluntary Pause
```bash
# Pause at logical stopping point
/vybe:task-pause "Found memory leak in session cleanup, implementing fix next"
```

**Output:**
```
Task Paused Successfully
========================

Current Work Saved:
- Agent: debug
- Task: complex-performance-issue
- Session: session-def456

Git Status:
✓ Changes committed to: "WIP: investigating memory leak in session cleanup"

To Resume:
/vybe:task-continue debug complex-performance-issue session-def456

Ready to exit session safely.
```

#### Cross-Session Workflows
```bash
# Day 1: Start investigation
/vybe:task-delegate debug payment-processing-bug "investigate failed payment transactions"
# Work for hours, then voluntarily pause
/vybe:task-pause "identified issue in payment gateway timeout handling"

# Day 2: Resume work
/vybe:task-continue debug payment-processing-bug session-ghi789
# Continues with full context from Day 1

# Day 3: Hand off to implementation
/vybe:task-delegate backend payment-fix-implementation "implement timeout handling fix based on debug findings"
# Backend agent gets access to all debugging discoveries
```

### Multi-Session Debugging Example

#### Session 1: Initial Investigation
```bash
/vybe:task-delegate debug user-login-slowness "investigate why user login is taking 5+ seconds"

# Agent discovers:
# - Database query optimization needed
# - JWT verification bottleneck
# - Network latency issues
# 
# Context grows large, PreCompact triggers automatically
# All findings saved to .vybe/context/precompact/
```

#### Session 2: Deep Database Analysis
```bash
/vybe:task-continue debug user-login-slowness session-xyz123

# Agent continues with previous findings
# Focuses on database optimization
# Discovers missing indexes on user table
# 
# Manually pause at good stopping point
/vybe:task-pause "identified database indexing issues, ready to implement fixes"
```

#### Session 3: Implementation
```bash
/vybe:task-delegate backend database-optimization "implement database indexing fixes for user login performance"

# Backend agent receives:
# - All debugging session findings
# - Specific optimization recommendations
# - Performance benchmarks to target
```

## Command Reference

### Specification Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `/vybe:spec-init` | Initialize feature specification | `/vybe:spec-init "user dashboard with analytics"` |
| `/vybe:spec-requirements` | Generate requirements document | `/vybe:spec-requirements user-dashboard` |
| `/vybe:spec-design` | Create technical design | `/vybe:spec-design user-dashboard` |
| `/vybe:spec-tasks` | Break down into tasks | `/vybe:spec-tasks user-dashboard` |
| `/vybe:spec-status` | Check specification progress | `/vybe:spec-status user-dashboard` |

### Task Management Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `/vybe:task-delegate` | Delegate tasks to agents | `/vybe:task-delegate backend user-auth-1-3 "implement core auth"` |
| `/vybe:task-continue` | Resume multi-session work | `/vybe:task-continue debug auth-issue session-123` |
| `/vybe:task-pause` | Manually pause current work | `/vybe:task-pause "found root cause"` |
| `/vybe:task-status` | Check task progress | `/vybe:task-status user-auth` |

### System Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `/vybe:validate-hooks` | Check hook system status | `/vybe:validate-hooks` |
| `/vybe:steering` | Create project steering docs | `/vybe:steering` |
| `/vybe:steering-custom` | Add custom steering | `/vybe:steering-custom testing "*.test.js"` |

## Advanced Scenarios

### Complex Multi-Feature Development

#### E-commerce Platform Example
```bash
# Feature 1: User Authentication (completed above)

# Feature 2: Product Catalog
/vybe:spec-init "Product catalog with search, filtering, categories, and inventory management"
/vybe:spec-requirements product-catalog
/vybe:spec-design product-catalog
/vybe:spec-tasks product-catalog

# Parallel development
/vybe:task-delegate backend product-catalog-1-5 "implement product data models and APIs"
/vybe:task-delegate frontend product-catalog-6-10 "build product listing and search UI"

# Feature 3: Shopping Cart
/vybe:spec-init "Shopping cart with add/remove items, quantity management, and checkout preparation"
# ... continue with cart implementation

# Integration testing across features
/vybe:task-delegate testing integration-auth-cart "test complete user journey from login to cart"
```

### Performance Optimization Workflow

```bash
# Initial performance analysis
/vybe:task-delegate performance api-optimization "analyze and optimize slow API endpoints"

# Database optimization
/vybe:task-delegate database db-performance "optimize database queries and indexing"

# Frontend optimization  
/vybe:task-delegate frontend ui-performance "optimize bundle size and loading performance"

# Load testing
/vybe:task-delegate testing load-testing "conduct load testing for optimized endpoints"
```

### Security Audit and Fixes

```bash
# Security assessment
/vybe:task-delegate security security-audit "comprehensive security audit of authentication and data handling"

# Vulnerability fixes
/vybe:task-delegate security auth-security-fixes "implement security recommendations for auth system"

# Penetration testing
/vybe:task-delegate security penetration-testing "conduct penetration testing on fixed vulnerabilities"
```

### DevOps and Deployment

```bash
# Infrastructure setup
/vybe:task-delegate devops infrastructure-setup "set up CI/CD pipeline and deployment infrastructure"

# Monitoring implementation
/vybe:task-delegate devops monitoring-setup "implement application monitoring and alerting"

# Documentation
/vybe:task-delegate documentation api-docs "create comprehensive API documentation and deployment guides"
```

## Best Practices

### 1. Start with Specifications
Always complete the spec phase before jumping to implementation:
```bash
/vybe:spec-init → /vybe:spec-requirements → /vybe:spec-design → /vybe:spec-tasks
```

### 2. Use Appropriate Agent Types
- **backend**: Server-side logic, APIs, database
- **frontend**: UI components, user experience
- **testing**: All types of testing
- **debug**: Investigation and troubleshooting
- **security**: Security analysis and fixes
- **performance**: Optimization and profiling
- **devops**: Infrastructure and deployment
- **documentation**: Technical writing

### 3. Leverage Context Management
- Let PreCompact handle automatic saves
- Use `/vybe:task-pause` at logical stopping points
- Resume work with `/vybe:task-continue` when needed

### 4. Monitor Progress
```bash
# Check overall feature progress
/vybe:spec-status feature-name

# Check specific task progress
/vybe:task-status feature-task-range

# Validate system health
/vybe:validate-hooks
```

### 5. Task Grouping Strategies
```bash
# Group related tasks
/vybe:task-delegate backend user-auth-1-3 "core authentication logic"

# Separate complex tasks
/vybe:task-delegate debug auth-issue-investigation "focus on token validation bug"

# Cross-cutting concerns
/vybe:task-delegate testing user-auth-10-12 "complete testing suite"
```

This tutorial covers the complete Vybe workflow from initial specification to complex multi-agent development scenarios, with comprehensive context session management throughout the process.
---
description: Initialize or update Vybe project structure with intelligent analysis
allowed-tools: Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS
---

# /vybe:init - Smart Project Initialization

Create intelligent project foundation for new or existing projects with AI-generated documentation.

## Platform Compatibility

### Supported Platforms
- [OK] **Linux**: All distributions with bash 4.0+
- [OK] **macOS**: 10.15+ (Catalina and later)
- [OK] **WSL2**: Windows Subsystem for Linux 2
- [OK] **Git Bash**: Windows with Git Bash installed
- [OK] **Cloud IDEs**: GitHub Codespaces, Gitpod, Cloud9

### Not Supported
- [NO] **Windows CMD**: Native Windows Command Prompt
- [NO] **PowerShell**: Without WSL or Git Bash
- [NO] **Windows batch**: .bat/.cmd scripts

### Required Tools
```bash
# Check prerequisites
bash --version    # Bash 4.0 or higher
git --version     # Git 2.0 or higher
find --version    # GNU find or BSD find
grep --version    # GNU grep or BSD grep
```

### Platform-Specific Notes
- **macOS**: Uses BSD versions of find/grep (slightly different syntax)
- **WSL2**: Ensure line endings are LF, not CRLF
- **Git Bash**: Some commands may need adjustment for Windows paths

## Usage
```
/vybe:init [project-description]
```

## Parameters
- `project-description`: Optional description for new projects or documentation updates

## Pre-Initialization Check

### Current State Analysis
- Vybe status: !`[ -d ".vybe" ] && echo "[OK] Vybe already initialized - will update" || echo "[NEW] Ready for new initialization"`
- Git repository: !`[ -d ".git" ] && echo "[OK] Git repository detected" || echo "[WARN] Not a git repository"`
- Project type: !`find . -maxdepth 2 \( -name "package.json" -o -name "requirements.txt" -o -name "go.mod" -o -name "Cargo.toml" -o -name "pom.xml" -o -name "Gemfile" \) 2>/dev/null | head -5`
- Existing README: !`ls README* 2>/dev/null || echo "No README found"`
- Code files: !`find . -path ./node_modules -prune -o -path ./.git -prune -o -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.java" -o -name "*.rs" \) -print 2>/dev/null | head -5`

### Existing Vybe Documents (if updating)
- Overview: !`[ -f ".vybe/project/overview.md" ] && echo "[OK] EXISTS - will preserve custom content" || echo "[NEW] Will create"`
- Architecture: !`[ -f ".vybe/project/architecture.md" ] && echo "[OK] EXISTS - will update tech stack" || echo "[NEW] Will create"`
- Conventions: !`[ -f ".vybe/project/conventions.md" ] && echo "[OK] EXISTS - will update patterns" || echo "[NEW] Will create"`
- Backlog: !`[ -f ".vybe/backlog.md" ] && echo "[OK] EXISTS - will preserve" || echo "[NEW] Will create"`

## CRITICAL: Mandatory Context Loading

### Task 0: Load Existing Project Context (if available)
```bash
echo "[CONTEXT] LOADING PROJECT CONTEXT"
echo "=========================="
echo ""

# Check if project is already initialized
if [ -d ".vybe/project" ]; then
    echo "[FOUND] Existing Vybe project detected"
    echo ""
    
    # CRITICAL: Load ALL project documents - NEVER skip this step
    project_loaded=false
    
    echo "[LOADING] Loading existing project foundation documents..."
    
    # Load overview (business context, goals, constraints)
    if [ -f ".vybe/project/overview.md" ]; then
        echo "[OK] Loaded: overview.md (business goals, users, constraints)"
        # AI MUST read and understand project context
    else
        echo "[MISSING] overview.md - will be created"
    fi
    
    # Load architecture (technical decisions, patterns)
    if [ -f ".vybe/project/architecture.md" ]; then
        echo "[OK] Loaded: architecture.md (tech stack, patterns, decisions)"
        # AI MUST read and understand technical constraints
    else
        echo "[MISSING] architecture.md - will be created"
    fi
    
    # Load conventions (coding standards, practices)
    if [ -f ".vybe/project/conventions.md" ]; then
        echo "[OK] Loaded: conventions.md (standards, patterns, practices)"
        # AI MUST read and understand coding standards
    else
        echo "[MISSING] conventions.md - will be created"
    fi
    
    # Load any custom project documents
    for doc in .vybe/project/*.md; do
        if [ -f "$doc" ] && [[ ! "$doc" =~ (overview|architecture|conventions) ]]; then
            echo "[OK] Loaded: $(basename "$doc") (custom project context)"
        fi
    done
    
    project_loaded=true
    
    echo ""
    echo "[CONTEXT] Project context loaded - will enhance existing foundation"
    echo ""
else
    echo "[NEW] New Vybe project initialization"
    echo ""
fi
```

## Task 1: Analyze Project State

### Actions
1. **Detect project type** from configuration files
2. **Scan codebase** for languages, frameworks, patterns
3. **Analyze git history** for commit conventions and workflow
4. **Check existing documentation** for project information
5. **Identify test frameworks** and build tools

### For Existing Projects
```bash
# Detect primary language (cross-platform)
find . -type f \( -name "*.js" -o -name "*.py" -o -name "*.go" \) 2>/dev/null | head -10

# Analyze package managers
ls package*.json requirements.txt go.mod Cargo.toml pom.xml 2>/dev/null

# Check test structure (works on BSD and GNU find)
find . -type d \( -name "__tests__" -o -name "test" -o -name "tests" -o -name "spec" \) 2>/dev/null | head -5

# Extract git conventions
git log --oneline -20 2>/dev/null || echo "No git history"
git branch -a 2>/dev/null || echo "No git branches"

# Platform-safe grep (works on both BSD and GNU)
grep -E "test|spec" package.json 2>/dev/null || true
```

### For New Projects
- Parse project description for technology hints
- Suggest appropriate stack based on use case
- Set up standard directory structure

## Task 2: Create Directory Structure

### Commands (Cross-Platform)
```bash
# Create Vybe directories (POSIX-compliant)
mkdir -p .vybe/project
mkdir -p .vybe/features

# Create initial files if not exist (works on all platforms)
test -f ".vybe/backlog.md" || touch .vybe/backlog.md
test -f ".vybe/project/overview.md" || touch .vybe/project/overview.md
test -f ".vybe/project/architecture.md" || touch .vybe/project/architecture.md
test -f ".vybe/project/conventions.md" || touch .vybe/project/conventions.md

# Add to .gitignore if needed (cross-platform)
if [ -f .gitignore ]; then
    grep -q "^\.vybe/" .gitignore 2>/dev/null || echo ".vybe/" >> .gitignore
else
    echo ".vybe/" > .gitignore
fi

# Handle Windows line endings in WSL2/Git Bash
if [ -n "$WINDIR" ] || [ -n "$WSL_DISTRO_NAME" ]; then
    # Ensure LF line endings for generated files
    git config core.autocrlf false 2>/dev/null || true
fi
```

### Final Structure
```
.vybe/
|-- project/
|   |-- overview.md      # Business context and goals
|   |-- architecture.md  # Technical decisions
|   `-- conventions.md   # Development standards
|-- backlog.md          # Feature planning
`-- features/           # Feature specifications (empty initially)
```

## Task 3: Generate Project Overview

### Template for overview.md
```markdown
# Project Overview

## Executive Summary
[One paragraph capturing the essence of the project]

## Product Description
[User-provided description or extracted from README]

## Target Users
### Primary Users
- **User Persona**: [Who they are]
- **Pain Points**: [Problems they face]
- **Use Cases**: [How they'll use the product]

### Secondary Users
[If applicable]

## Business Goals
### Immediate Goals (MVP)
- [Core feature 1]
- [Core feature 2]
- [Core feature 3]

### Long-term Vision
- [Future expansion]
- [Market opportunities]

## Success Metrics
### Technical Metrics
- **Performance**: [Response time, throughput]
- **Reliability**: [Uptime targets]
- **Scalability**: [User/data growth targets]

### Business Metrics
- **User Adoption**: [Target numbers]
- **Engagement**: [Key activities to track]
- **Retention**: [Churn rate goals]

## Constraints & Risks
### Technical Constraints
- [Platform limitations]
- [Performance requirements]
- [Security requirements]

### Business Constraints
- [Timeline]
- [Budget]
- [Regulatory compliance]

### Risk Mitigation
- [Identified risks and mitigation strategies]

---
*Generated: [date] | Updated: [date]*
```

## Task 4: Document Architecture

### Analysis Commands
```bash
# Detect frontend frameworks
grep -E "react|vue|angular|svelte" package.json 2>/dev/null

# Detect backend frameworks
grep -E "express|fastify|django|flask|gin|echo" * -r 2>/dev/null | head -5

# Check for Docker
[ -f "Dockerfile" ] && echo "Docker configuration found"
[ -f "docker-compose.yml" ] && echo "Docker Compose found"

# Database detection
grep -E "postgres|mysql|mongodb|redis" * -r 2>/dev/null | head -5
```

### Template for architecture.md
```markdown
# Technical Architecture

## System Overview
[Architecture pattern: Monolith/Microservices/Serverless/JAMstack]

## Technology Stack

### Frontend
- **Framework**: [React/Vue/Angular/Next.js/None]
- **State Management**: [Redux/Zustand/Context API/Pinia]
- **Styling**: [CSS/SCSS/Tailwind/styled-components]
- **Build Tool**: [Vite/Webpack/Parcel/esbuild]
- **Testing**: [Jest/Vitest/Cypress/Playwright]

### Backend
- **Runtime**: [Node.js/Python/Go/Java/Rust]
- **Framework**: [Express/FastAPI/Gin/Spring/Actix]
- **API Type**: [REST/GraphQL/gRPC/WebSocket]
- **Authentication**: [JWT/OAuth2/Session-based]
- **Validation**: [Joi/Yup/Pydantic/go-playground]

### Database
- **Primary Database**: [PostgreSQL/MySQL/MongoDB/SQLite]
- **ORM/ODM**: [Prisma/TypeORM/Mongoose/SQLAlchemy]
- **Caching**: [Redis/Memcached/In-memory]
- **Search**: [Elasticsearch/Algolia/PostgreSQL FTS]

### Infrastructure
- **Hosting**: [AWS/GCP/Azure/Vercel/Netlify/Self-hosted]
- **Container**: [Docker/Podman]
- **Orchestration**: [Kubernetes/Docker Swarm/ECS]
- **CI/CD**: [GitHub Actions/GitLab CI/Jenkins/CircleCI]
- **Monitoring**: [Prometheus/Grafana/DataDog/New Relic]
- **Logging**: [ELK Stack/CloudWatch/Papertrail]

## Architecture Decisions

### Design Patterns
- **API Design**: [RESTful/RPC/Event-driven]
- **Data Flow**: [Unidirectional/Bidirectional]
- **State Management**: [Centralized/Distributed]
- **Error Handling**: [Try-catch/Result types/Error boundaries]

### Security Architecture
- **Authentication Flow**: [Description]
- **Authorization Model**: [RBAC/ABAC/ACL]
- **Data Encryption**: [At-rest/In-transit]
- **Secret Management**: [Environment vars/Vault/KMS]

## Directory Structure
\`\`\`
[Auto-generated from actual project structure]
\`\`\`

## Development Environment

### Prerequisites
- [Runtime and version]
- [Package manager]
- [Database]
- [Other tools]

### Setup Instructions
\`\`\`bash
# Clone repository
git clone [repository-url]
cd [project-name]

# Install dependencies
[npm install / pip install -r requirements.txt / go mod download]

# Set up environment variables
cp .env.example .env
# Edit .env with your configuration

# Initialize database
[npm run db:setup / python manage.py migrate]

# Start development server
[npm run dev / python manage.py runserver / go run .]
\`\`\`

### Common Commands
\`\`\`bash
# Development
npm run dev          # Start dev server
npm run build        # Build for production
npm run test         # Run tests
npm run lint         # Run linter

# Database
npm run db:migrate   # Run migrations
npm run db:seed      # Seed database
npm run db:reset     # Reset database
\`\`\`

### Ports & Services
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **Database**: localhost:5432
- **Redis**: localhost:6379

---
*Generated: [date] | Updated: [date]*
```

## Task 5: Extract Conventions

### Analysis Commands
```bash
# Detect code style from configs
ls .eslintrc* .prettierrc* .editorconfig tslint.json 2>/dev/null

# Analyze naming patterns
find . -name "*.js" -o -name "*.ts" | head -20  # Check file naming
grep -h "^function\|^const.*=.*function\|^class" **/*.js 2>/dev/null | head -10  # Function/class naming

# Git workflow analysis
git log --oneline -30  # Commit message patterns
git branch -r          # Branch naming patterns
```

### Template for conventions.md
```markdown
# Development Conventions

## Code Style

### Language Standards
- **Primary Language**: [JavaScript/TypeScript/Python/Go]
- **Version**: [ES2022/Python 3.11/Go 1.21]
- **Style Guide**: [Airbnb/Standard/PEP8/Effective Go]

### Formatting Rules
- **Indentation**: [2 spaces/4 spaces/tabs]
- **Line Length**: [80/100/120 characters]
- **Semicolons**: [Always/Never/ASI]
- **Quotes**: [Single/Double/Backticks]
- **Trailing Comma**: [Always/Never/Multiline]

### Naming Conventions
\`\`\`javascript
// Variables & Functions
const userName = "camelCase";          // Variables
function calculateTotal() {}           // Functions
const handleClick = () => {};         // Event handlers

// Classes & Components
class UserService {}                   // PascalCase classes
function UserProfile() {}              // React components

// Files & Directories
user-service.js                       // kebab-case files
UserProfile.jsx                       // PascalCase components
__tests__/user.test.js               // Test files
```

## Git Workflow

### Branch Strategy
- **Main Branch**: `main` (production-ready)
- **Feature Branches**: `feature/description`
- **Bug Fixes**: `fix/issue-description`
- **Hotfixes**: `hotfix/critical-issue`
- **Releases**: `release/v1.2.3`

### Commit Conventions
Format: `type(scope): description`

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting, no code change
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance tasks

Examples:
```bash
feat(auth): implement JWT token refresh
fix(api): resolve timeout in user endpoint
docs(readme): update installation steps
test(user): add unit tests for validation
```

### Pull Request Process
1. Create feature branch from main
2. Make atomic commits with clear messages
3. Keep PR focused on single concern
4. Update tests and documentation
5. Request review from other members
6. Address feedback promptly
7. Squash and merge when approved

## Testing Standards

### Test Organization
```
tests/
|-- unit/           # Unit tests
|-- integration/    # Integration tests
|-- e2e/           # End-to-end tests
`-- fixtures/      # Test data
```

### Test Patterns
\`\`\`javascript
// Test file naming
userService.test.js    // Unit test
user.e2e.test.js       // E2E test

// Test structure
describe('UserService', () => {
  describe('createUser', () => {
    it('should create user with valid data', () => {
      // Arrange
      const userData = { name: 'John', email: 'john@example.com' };
      
      // Act
      const user = userService.createUser(userData);
      
      // Assert
      expect(user).toHaveProperty('id');
      expect(user.name).toBe('John');
    });
    
    it('should throw error with invalid email', () => {
      // Test error cases
    });
  });
});
\`\`\`

### Coverage Requirements
- **Overall Coverage**: Minimum 80%
- **Critical Paths**: 100% coverage required
- **New Code**: Must include tests
- **Integration Tests**: For all API endpoints

## Documentation Standards

### Code Documentation
\`\`\`javascript
/**
 * Calculate order total with tax and shipping
 * @param {Object} order - Order object
 * @param {number} order.subtotal - Order subtotal
 * @param {string} order.state - Shipping state for tax
 * @param {Object} options - Calculation options
 * @param {boolean} options.includeTax - Include tax in total
 * @param {number} options.shippingRate - Shipping rate override
 * @returns {number} Total order amount
 * @throws {ValidationError} If order data is invalid
 */
function calculateOrderTotal(order, options = {}) {
  // Implementation
}
\`\`\`

### API Documentation
- Use OpenAPI/Swagger for REST APIs
- Document all endpoints with examples
- Include error responses
- Maintain Postman collection

### README Requirements
- [ ] Project description and purpose
- [ ] Prerequisites and system requirements
- [ ] Installation instructions
- [ ] Configuration guide
- [ ] Usage examples
- [ ] API documentation link
- [ ] Contributing guidelines
- [ ] License information

## Security Practices

### Code Security
- **No secrets in code**: Use environment variables
- **Input validation**: Validate all user inputs
- **Output encoding**: Prevent XSS attacks
- **SQL injection**: Use parameterized queries
- **Authentication**: Implement proper auth checks
- **Authorization**: Enforce access controls

### Dependencies
- **Regular updates**: Weekly dependency checks
- **Security audits**: `npm audit` / `pip check`
- **License compliance**: Track licenses
- **Minimal dependencies**: Avoid unnecessary packages

### Data Protection
- **Encryption**: TLS for transit, AES for storage
- **PII handling**: Minimize and protect
- **Logging**: No sensitive data in logs
- **Backups**: Regular encrypted backups

---
*Generated: [date] | Updated: [date]*
```

## Task 6: Create Backlog Template

### Template for backlog.md
```markdown
# Project Backlog

## Active Features (Current Sprint)
<!-- Features being actively developed -->

## Ready for Development
<!-- Features fully specified and ready to start -->

## High Priority (Next Quarter)
<!-- Critical features for near-term -->

## Medium Priority (6 Months)
<!-- Important but not urgent -->

## Low Priority (Future)
<!-- Nice-to-have features -->

## Technical Debt
<!-- Refactoring and optimization needs -->

## Research & Spikes
<!-- Topics requiring investigation -->

## Completed Features
<!-- Moved here after deployment -->

---
*Last Updated: [date]*
```

## Update Strategy for Existing Projects

### When .vybe Already Exists
1. **Read existing files first** - Preserve custom content
2. **Update only factual information** - Dependencies, versions, commands
3. **Add missing standard sections** - From templates above
4. **Mark deprecated content** - Use [DEPRECATED] tags
5. **Maintain existing style** - Match formatting preferences

### Preservation Rules
- **Custom sections**: Keep any non-standard sections
- **User examples**: Preserve custom code examples
- **Comments**: Maintain inline comments and notes
- **Manual overrides**: Respect explicit configuration

## Success Criteria

### For New Projects
- [OK] All directories created successfully
- [OK] All template files generated with project-specific content
- [OK] README.md created or updated
- [OK] .gitignore updated with .vybe/
- [OK] User receives clear next steps

### For Existing Projects
- [OK] Existing documentation analyzed and incorporated
- [OK] Technology stack accurately detected
- [OK] Conventions extracted from actual code
- [OK] Custom content preserved during update
- [OK] No data loss or overwrites

## Next Steps Message

After successful initialization:
```
[OK] Vybe initialization complete!

Created/Updated:
- .vybe/project/overview.md (business context)
- .vybe/project/architecture.md (technical stack)
- .vybe/project/conventions.md (development standards)
- .vybe/backlog.md (feature planning)

Next steps:
1. Review generated documentation for accuracy
2. Use `/vybe:discuss` to explore technical decisions
3. Use `/vybe:plan [feature]` to create your first feature specification
4. Use `/vybe:execute` to start implementing tasks

For help: `/vybe:status` shows current progress
```

## Error Handling

### Common Issues
- **Not a git repository**: Warn but continue
- **No code files found**: Prompt for project type
- **Existing .vybe conflicts**: Offer update or abort
- **Permission denied**: Check file permissions
- **Missing project description**: Use README or prompt

### Recovery Actions
- Rollback on failure
- Preserve any existing files
- Clear error messages with solutions
- Suggest manual fixes when needed
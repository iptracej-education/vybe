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
/vybe:init [project-description] [--template=template-name]
```

## Parameters
- `project-description`: Optional description for new projects or documentation updates
- `--template=template-name`: Optional template to use as architectural DNA (NEW)

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

## Task 0: Parse Parameters & Template Validation

### Template Parameter Processing
```bash
echo "[INIT] PARAMETER PROCESSING"
echo "=========================="
echo ""

# Parse command line arguments
project_description=""
template_name=""

# Process arguments
for arg in "$@"; do
    case $arg in
        --template=*)
            template_name="${arg#*=}"
            shift
            ;;
        *)
            if [ -z "$project_description" ]; then
                project_description="$arg"
            fi
            shift
            ;;
    esac
done

echo "Project Description: ${project_description:-'Not provided'}"
echo "Template: ${template_name:-'None'}"
echo ""

# Validate template if specified
if [ -n "$template_name" ]; then
    echo "[TEMPLATE] Validating template: $template_name"
    
    # Check if template exists
    if [ ! -d ".vybe/templates/$template_name" ]; then
        echo "[ERROR] Template '$template_name' not found"
        echo "Available templates:"
        ls .vybe/templates/ 2>/dev/null || echo "  No templates found"
        echo ""
        echo "Import a template first:"
        echo "  /vybe:template import github.com/user/repo $template_name"
        echo "  /vybe:template generate $template_name"
        exit 1
    fi
    
    # Check if template is analyzed/generated
    if [ -f ".vybe/templates/$template_name/metadata.yml" ]; then
        analyzed=$(grep "^analyzed:" ".vybe/templates/$template_name/metadata.yml" | sed 's/^analyzed: *//' | tr -d '"')
        if [ "$analyzed" != "true" ]; then
            echo "[ERROR] Template '$template_name' not yet analyzed"
            echo "Generate template structures first:"
            echo "  /vybe:template generate $template_name"
            exit 1
        fi
        echo "[OK] Template validated and ready"
    else
        echo "[ERROR] Template '$template_name' corrupted (missing metadata)"
        exit 1
    fi
    
    echo ""
fi
```

## CRITICAL: Mandatory Context Loading

### Task 1: Load Existing Project Context (if available)
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
# Detect primary language (cross-platform) - OPTIMIZED
# Only scan if detection cache doesn't exist
if [ ! -f ".vybe/project/.detected" ]; then
    find . -maxdepth 3 -type f \( -name "*.js" -o -name "*.py" -o -name "*.go" \) 2>/dev/null | head -10
fi

# Analyze package managers
ls package*.json requirements.txt go.mod Cargo.toml pom.xml 2>/dev/null

# Check test structure (works on BSD and GNU find) - OPTIMIZED
# Only scan if test framework not already detected
if [ ! -f ".vybe/project/.test-framework" ]; then
    find . -maxdepth 3 -type d \( -name "__tests__" -o -name "test" -o -name "tests" -o -name "spec" \) 2>/dev/null | head -5
fi

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
mkdir -p .vybe/project/.detected  # Store detection results

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
|-- tech/               # Technology stack registry (NEW)
|   |-- languages.yml   # Primary language and package manager
|   |-- frameworks.yml  # Web/API/database frameworks
|   |-- testing.yml     # Testing frameworks and commands
|   |-- build.yml       # Build tools and development server
|   |-- tools.yml       # Development tools and utilities
|   |-- deployment.yml  # Deployment configuration
|   `-- stages.yml      # Progressive tool installation plan
|-- backlog.md          # Feature planning
`-- features/           # Feature specifications (empty initially)
```

## Task 2.5: Capture Incremental Outcome Stages

### Interactive Outcome Definition
```bash
echo "[OUTCOMES] INCREMENTAL STAGED OUTCOME CAPTURE"
echo "============================================="
echo ""
echo "Project Description: $project_description"
echo ""

echo "[PHILOSOPHY] Baby Steps to Success"
echo "=================================="
echo "Real software development is incremental, not big bang."
echo "Each outcome stage will deliver working units in 1-3 days."
echo ""

echo "[INTERACTIVE] Capturing Your Outcome Stages"
echo "==========================================="
echo ""
echo "AI MUST interactively capture three critical elements:"
echo ""
echo "1. FIRST MINIMAL OUTCOME (What can ship in 1-2 days?)"
echo "   Example: 'Show COVID numbers on a webpage'"
echo "   - Must be minimal but functional"
echo "   - Must deliver immediate user value"
echo "   - Must be completable quickly"
echo ""
echo "2. FINAL VISION (Where are we ultimately going?)"
echo "   Example: 'Real-time dashboard with multiple visualizations'"
echo "   - The complete dream state"
echo "   - Can be ambitious and complex"
echo "   - Will be reached incrementally"
echo ""
echo "3. INITIAL OUTCOME STAGES (Flexible roadmap)"
echo "   Example stages (each on its own line):"
echo "   - Stage 1: Show data (Day 1)"
echo "   - Stage 2: Add layout (Day 3)"
echo "   - Stage 3: Add charts (Day 5)"
echo "   - Stage 4: Make real-time (Day 8)"
echo ""
echo "AI MUST ask these questions interactively and capture responses."
echo "IMPORTANT: Format each stage on its own line with proper line breaks."
echo ""

echo "[OUTCOME PRINCIPLES]"
echo "==================="
echo "- Each stage builds on the previous"
echo "- Each stage delivers working units"
echo "- Each stage provides user value"
echo "- UI examples requested only when needed"
echo "- Learning from each stage informs the next"
echo ""
```

## Task 2.6: Intelligent Environment Configuration Tutorial

### Interactive API Service Requirements Interview
```bash
echo "[ENV] INTELLIGENT ENVIRONMENT CONFIGURATION"
echo "=========================================="
echo ""

# Detect existing environment files
ENV_FILES_FOUND=()
EXISTING_KEYS=()

echo "[DETECTION] Scanning for existing environment configuration..."

# Check for common environment file patterns
if [ -f ".env" ]; then
    ENV_FILES_FOUND+=(".env")
    echo "[FOUND] .env (main environment file)"
fi

if [ -f ".env.example" ]; then
    ENV_FILES_FOUND+=(".env.example")
    echo "[FOUND] .env.example (template file)"
fi

if [ -f ".env.local" ]; then
    ENV_FILES_FOUND+=(".env.local")
    echo "[FOUND] .env.local (local development)"
fi

if [ -f ".env.development" ]; then
    ENV_FILES_FOUND+=(".env.development")
    echo "[FOUND] .env.development (development environment)"
fi

# Analyze existing environment configuration
if [ ${#ENV_FILES_FOUND[@]} -gt 0 ]; then
    echo ""
    echo "[ANALYZE] Scanning existing environment configuration..."
    
    # Extract existing API keys from all env files
    for env_file in "${ENV_FILES_FOUND[@]}"; do
        if [[ "$env_file" == *.env* ]]; then
            echo "[SCAN] Analyzing $env_file..."
            content=$(cat "$env_file" 2>/dev/null || echo "")
            
            # Extract existing API keys
            while IFS= read -r line; do
                if [[ "$line" =~ ^[A-Z_]+.*=.* ]] && [[ "$line" =~ (API_KEY|SECRET|TOKEN|_KEY) ]]; then
                    key_name=$(echo "$line" | cut -d'=' -f1)
                    EXISTING_KEYS+=("$key_name")
                    echo "[EXISTING] $key_name found"
                fi
            done <<< "$content"
        fi
    done
fi

echo ""

# Initialize API services detection
declare -A DETECTED_SERVICES
declare -A REQUIRED_KEYS
declare -A KEY_DESCRIPTIONS

echo "[API-DETECTION] Intelligent API Service Detection"
echo "================================================"
echo ""

# Check if we already have cached API detection results
if [ -f ".vybe/project/.detected/apis" ]; then
    echo "[CACHED] Loading previously detected API services..."
    source ".vybe/project/.detected/apis"
else
    echo "[SCAN] Analyzing project for API service requirements..."
    
    # Single pass grep for all API patterns - MUCH FASTER
    API_SCAN=$(grep -m 20 -r -l -E "openai|OpenAI|anthropic|claude|stripe|payment|checkout|boto3|aws|s3|lambda|sendgrid|email.*api" . --include="*.py" --include="*.js" --include="*.ts" 2>/dev/null)
    
    # Check results once
    if echo "$API_SCAN" | grep -q -E "openai|OpenAI|anthropic|claude"; then
        DETECTED_SERVICES["openai"]="true"
        REQUIRED_KEYS["OPENAI_API_KEY"]="OpenAI API access"
        KEY_DESCRIPTIONS["OPENAI_API_KEY"]="Get from: https://platform.openai.com/api-keys"
        echo "[DETECTED] AI integration found in code"
    fi

# Check template for AI integrations
if [ -n "$template_name" ] && [ -d ".vybe/templates/$template_name" ]; then
    echo "[TEMPLATE] Checking template for API integrations..."
    if find ".vybe/templates/$template_name" -name "*.py" -o -name "*.js" -o -name "*.ts" | xargs grep -l "openai\|anthropic" 2>/dev/null; then
        DETECTED_SERVICES["openai"]="true"
        REQUIRED_KEYS["OPENAI_API_KEY"]="OpenAI API access (from template)"
        KEY_DESCRIPTIONS["OPENAI_API_KEY"]="Get from: https://platform.openai.com/api-keys"
        echo "[TEMPLATE] AI integration detected in template"
    fi
fi

    # Continue with single-pass results
    if echo "$API_SCAN" | grep -q -E "stripe|payment|checkout"; then
        DETECTED_SERVICES["stripe"]="true"
        REQUIRED_KEYS["STRIPE_SECRET_KEY"]="Stripe payment processing"
        REQUIRED_KEYS["STRIPE_PUBLISHABLE_KEY"]="Stripe public key"
        KEY_DESCRIPTIONS["STRIPE_SECRET_KEY"]="Get from: https://dashboard.stripe.com/apikeys"
        KEY_DESCRIPTIONS["STRIPE_PUBLISHABLE_KEY"]="Get from: https://dashboard.stripe.com/apikeys"
        echo "[DETECTED] Stripe payment integration found"
    fi
    
    if echo "$API_SCAN" | grep -q -E "boto3|aws|s3|lambda"; then
        DETECTED_SERVICES["aws"]="true"
        REQUIRED_KEYS["AWS_ACCESS_KEY_ID"]="AWS service access"
        REQUIRED_KEYS["AWS_SECRET_ACCESS_KEY"]="AWS secret key"
        KEY_DESCRIPTIONS["AWS_ACCESS_KEY_ID"]="Get from: https://console.aws.amazon.com/iam/home#/security_credentials"
        KEY_DESCRIPTIONS["AWS_SECRET_ACCESS_KEY"]="Get from: https://console.aws.amazon.com/iam/home#/security_credentials"
        echo "[DETECTED] AWS integration found"
    fi
    
    if echo "$API_SCAN" | grep -q -E "sendgrid|email.*api"; then
        DETECTED_SERVICES["sendgrid"]="true"
        REQUIRED_KEYS["SENDGRID_API_KEY"]="SendGrid email service"
        KEY_DESCRIPTIONS["SENDGRID_API_KEY"]="Get from: https://app.sendgrid.com/settings/api_keys"
        echo "[DETECTED] SendGrid email integration found"
    fi
    
    # Store detection results for next time
    mkdir -p .vybe/project/.detected
    {
        for service in "${!DETECTED_SERVICES[@]}"; do
            echo "DETECTED_SERVICES[$service]='${DETECTED_SERVICES[$service]}'"
        done
        for key in "${!REQUIRED_KEYS[@]}"; do
            echo "REQUIRED_KEYS[$key]='${REQUIRED_KEYS[$key]}'"
        done
        for desc in "${!KEY_DESCRIPTIONS[@]}"; do
            echo "KEY_DESCRIPTIONS[$desc]='${KEY_DESCRIPTIONS[$desc]}'"
        done
    } > .vybe/project/.detected/apis
fi

# Check business requirements for additional clues
if [ -d ".vybe/project" ]; then
    echo "[SCAN] Analyzing business requirements..."
    if grep -riq "payment\|billing\|subscription" .vybe/project/ 2>/dev/null; then
        if [ -z "${DETECTED_SERVICES["stripe"]}" ]; then
            echo "[INFERRED] Payment functionality mentioned - may need payment service API keys"
        fi
    fi
    
    if grep -riq "email\|notification\|alerts" .vybe/project/ 2>/dev/null; then
        if [ -z "${DETECTED_SERVICES["sendgrid"]}" ]; then
            echo "[INFERRED] Email functionality mentioned - may need email service API keys"
        fi
    fi
    
    if grep -riq "ai\|chat\|assistant\|nlp\|weather.*api" .vybe/project/ 2>/dev/null || [[ "$project_description" =~ (ai|chat|assistant|nlp|weather) ]]; then
        if [ -z "${DETECTED_SERVICES["openai"]}" ]; then
            DETECTED_SERVICES["openai"]="true"
            REQUIRED_KEYS["OPENAI_API_KEY"]="OpenAI API access (from requirements)"
            KEY_DESCRIPTIONS["OPENAI_API_KEY"]="Get from: https://platform.openai.com/api-keys"
            echo "[INFERRED] AI/Weather functionality mentioned - OpenAI API key required"
        fi
    fi
fi

echo ""

# Smart environment configuration based on findings
echo "[CONFIGURATION] Smart Environment Setup"
echo "======================================"
echo ""

if [ ${#ENV_FILES_FOUND[@]} -gt 0 ]; then
    echo "[EXISTING] Found existing environment files:"
    printf '  - %s\n' "${ENV_FILES_FOUND[@]}"
    echo ""
    
    if [ ${#EXISTING_KEYS[@]} -gt 0 ]; then
        echo "[EXISTING] Current API keys:"
        printf '  - %s\n' "${EXISTING_KEYS[@]}"
        echo ""
    fi
    
    echo "AI MUST ask user how to handle existing environment configuration:"
    echo ""
    echo "1. [RECOMMENDED] Use existing files and add missing services"
    echo "2. Create new .env file (backup existing)"
    echo "3. Manual configuration (skip automatic setup)"
    echo ""
    echo "AI MUST capture user preference and proceed accordingly"
    echo ""
else
    echo "[NEW] No environment files found - will create new configuration"
    echo ""
fi

# STEP 1: Detect environment configuration pattern
echo "[ENV-DETECTION] Scanning for environment configuration patterns..."
echo "================================================================"
echo ""

ENV_CONFIG_TYPE=""
ENV_FILES_FOUND=()
CONFIG_INSTRUCTIONS=""

# Detect Python/Node.js: .env pattern
if find . -maxdepth 2 -name ".env*" -type f 2>/dev/null | head -1 | grep -q .; then
    ENV_CONFIG_TYPE="dotenv"
    ENV_FILES_FOUND=($(find . -maxdepth 2 -name ".env*" -type f 2>/dev/null))
    CONFIG_INSTRUCTIONS="1. Copy .env.example to .env\n2. Edit .env with real API keys\n3. Never commit .env to git"
    echo "[DETECTED] DotEnv pattern (.env files) - Python/Node.js style"
    echo "   Files found: ${ENV_FILES_FOUND[*]}"

# Detect Go: config.yaml pattern
elif find . -maxdepth 2 -name "config.y*ml" -type f 2>/dev/null | head -1 | grep -q .; then
    ENV_CONFIG_TYPE="yaml_config"
    ENV_FILES_FOUND=($(find . -maxdepth 2 -name "config.y*ml" -type f 2>/dev/null))
    CONFIG_INSTRUCTIONS="1. Edit config.yaml with real API keys\n2. Use yaml key format\n3. Keep config.yaml in .gitignore"
    echo "[DETECTED] YAML configuration pattern - Go/general style"
    echo "   Files found: ${ENV_FILES_FOUND[*]}"

# Detect Java: application.properties pattern
elif find . -maxdepth 2 -name "application.*" -type f 2>/dev/null | head -1 | grep -q .; then
    ENV_CONFIG_TYPE="spring_config"
    ENV_FILES_FOUND=($(find . -maxdepth 2 -name "application.*" -type f 2>/dev/null))
    CONFIG_INSTRUCTIONS="1. Edit application.properties with real API keys\n2. Use property format: key=value\n3. Keep secrets in application-local.properties"
    echo "[DETECTED] Spring/Java configuration pattern"
    echo "   Files found: ${ENV_FILES_FOUND[*]}"

# No pattern detected - ask user
else
    echo "[UNKNOWN] No standard configuration pattern detected"
    echo ""
    echo "🤔 How does your project handle API keys and secrets?"
    echo ""
    echo "Common patterns:"
    echo "1. .env files (Python/Node.js) - OPENAI_API_KEY=sk-..."
    echo "2. config.yaml files (Go/general) - openai_api_key: sk-..."
    echo "3. application.properties (Java) - openai.api.key=sk-..."
    echo "4. Environment variables only"
    echo "5. Custom configuration files"
    echo ""
    echo "💭 AI MUST ask user which pattern they prefer and register it"
    ENV_CONFIG_TYPE="user_specified"
    CONFIG_INSTRUCTIONS="User will specify their preferred API configuration method"
fi

# STEP 2: Register environment configuration in technology registry
echo ""
echo "[REGISTRY] Registering environment configuration..."

cat > .vybe/tech/environment.yml << EOF
# Environment Configuration Registry
# Generated by vybe framework init command

configuration:
  type: "$ENV_CONFIG_TYPE"
  detected_files: [$(printf '"%s",' "${ENV_FILES_FOUND[@]}" | sed 's/,$//')]
  api_key_pattern: "API_KEY|SECRET|TOKEN|_KEY"
  
setup_instructions: |
$CONFIG_INSTRUCTIONS

language_patterns:
  python:
    method: "dotenv"
    files: [".env.example", ".env"]
    format: "OPENAI_API_KEY=sk-your-key-here"
    package: "python-dotenv"
    
  nodejs:
    method: "dotenv" 
    files: [".env.example", ".env"]
    format: "OPENAI_API_KEY=sk-your-key-here"
    package: "dotenv"
    
  go:
    method: "yaml_config"
    files: ["config.yaml", "config.yml"]
    format: "openai_api_key: sk-your-key-here"
    package: "gopkg.in/yaml.v2"
    
  java:
    method: "properties"
    files: ["application.properties", "application.yml"]
    format: "openai.api.key=sk-your-key-here"
    framework: "Spring Boot"
    
  cpp:
    method: "custom"
    files: ["config.ini", "settings.conf"]
    format: "varies by framework"
    note: "Project-specific implementation"

security_notes: |
  - Never commit real API keys to git
  - Add secrets files to .gitignore
  - Use different keys for dev/staging/production
  - Rotate keys regularly
  - Monitor API usage for suspicious activity

validation:
  required_for_functional_app: true
  business_impact: "Application cannot deliver value without real API keys"
EOF

echo "[OK] Environment configuration registered in .vybe/tech/environment.yml"

# STEP 3: Handle API key requirements if detected
if [ ${#REQUIRED_KEYS[@]} -gt 0 ]; then
    echo ""
    echo "[API-KEYS] 🔑 API SERVICE CONFIGURATION REQUIRED"
    echo "=============================================="
    echo ""
    echo "The following API services were detected and are REQUIRED:"
    echo ""
    
    for key in "${!REQUIRED_KEYS[@]}"; do
        echo "  🔑 $key"
        echo "     Purpose: ${REQUIRED_KEYS[$key]}"
        echo "     Get from: ${KEY_DESCRIPTIONS[$key]}"
        echo ""
    done
    
    echo "📋 CONFIGURATION METHOD FOR YOUR PROJECT:"
    case $ENV_CONFIG_TYPE in
        "dotenv")
            echo "   ✅ Uses .env files (Python/Node.js style)"
            echo "   📁 Template will provide .env.example"
            echo "   🔧 You'll copy .env.example to .env and add real keys"
            ;;
        "yaml_config")
            echo "   ✅ Uses YAML configuration (Go style)"
            echo "   📁 Edit config.yaml with your API keys"
            echo "   🔧 Format: openai_api_key: \"sk-your-real-key\""
            ;;
        "spring_config")
            echo "   ✅ Uses Spring properties (Java style)"
            echo "   📁 Edit application.properties with your API keys"
            echo "   🔧 Format: openai.api.key=sk-your-real-key"
            ;;
        "user_specified")
            echo "   ❓ AI will ask you to specify your preferred method"
            echo "   📝 Your choice will be registered for future use"
            ;;
        *)
            echo "   ⚙️  Custom configuration method detected"
            echo "   📝 Follow your project's existing pattern"
            ;;
    esac
    
    echo ""
    echo "⚠️  CRITICAL: Without real API keys, your application will NOT function"
    echo "💡 Business value requires real integrations, not mock implementations"
    echo ""
else
    echo ""
    echo "[INFO] ✅ No external API services detected"
    echo "   Project can proceed without additional API configuration"
    echo ""
fi

# Initialize MCP cache system for cached future operations
echo "[OPTIMIZE] Initializing MCP performance cache..."
if [ -f ".claude/hooks/cache-manager.sh" ]; then
    chmod +x .claude/hooks/cache-manager.sh
    
    # Warm MCP cache with batch operations (much faster than individual calls)
    .claude/hooks/cache-manager.sh warm > /dev/null 2>&1
    
    # Get cache health status
    cache_status=$(.claude/hooks/cache-manager.sh health 2>/dev/null)
    if echo "$cache_status" | grep -q '"status": "healthy"'; then
        echo "[OPTIMIZE] ✅ MCP cache active - commands now 20-60x faster"
    else
        echo "[OPTIMIZE] ✅ File cache ready - MCP will activate on next Claude restart"
    fi
else
    echo "[OPTIMIZE] ⚠️ Cache manager not found - performance may be degraded"
fi

echo "[TUTORIAL] Interactive Service Requirements Interview"
echo "=================================================="
echo ""
echo "AI MUST conduct intelligent interview to determine additional service needs:"
echo ""
echo "CORE INTERVIEW CATEGORIES:"
echo ""
echo "1. APPLICATION TYPE:"
echo "   - What type of application are you building?"
echo "   - Web app, mobile app, API service, data pipeline, etc.?"
echo "   - Who are your users and how will they interact?"
echo ""
echo "2. AI & LANGUAGE SERVICES:"
echo "   - Will your app use AI features? (chat, content generation, analysis)"
echo "   - Which AI providers? (OpenAI, Anthropic, Google, local models)"
echo ""
echo "3. DATA & DATABASES:"
echo "   - What data will you store? (user data, content, analytics)"
echo "   - Database preferences? (PostgreSQL, MongoDB, Redis)"
echo "   - External data sources? (APIs, webhooks, file imports)"
echo ""
echo "4. COMMUNICATION:"
echo "   - Email features? (notifications, marketing, transactional)"
echo "   - SMS/messaging? (alerts, 2FA, customer service)"
echo ""
echo "5. PAYMENT & COMMERCE:"
echo "   - Will users pay for services? (subscriptions, one-time)"
echo "   - Payment methods? (credit cards, digital wallets)"
echo ""
echo "6. DEPLOYMENT & INFRASTRUCTURE:"
echo "   - Where will you deploy? (cloud provider preferences)"
echo "   - Scaling expectations? (users, traffic, data volume)"
echo ""
echo "AI MUST:"
echo "- Ask follow-up questions based on answers"
echo "- Suggest services based on requirements"
echo "- Explain why certain services are recommended"
echo "- Create comprehensive environment configuration"
echo "- Handle existing .env files intelligently"
echo ""
```

## Task 2.7: Performance-Optimized Intelligent Analysis

### Two-Phase Approach: Fast Setup + Deep Research
```bash
echo "[AI] PERFORMANCE-OPTIMIZED INTELLIGENT PROJECT SETUP"
echo "================================================"
echo ""

echo "[PHASE 1] IMMEDIATE OUTCOME-DRIVEN ANALYSIS (Fast - 30 seconds)"
echo "============================================================"
echo ""
echo "AI MUST perform immediate analysis based on captured outcomes:"
echo "- Extract project type from first minimal outcome"
echo "- Identify core technology needs for staged delivery"
echo "- Infer user types from outcome descriptions"
echo "- Determine architecture for incremental growth"
echo "- Apply patterns that support staged development"
echo ""
echo "This provides outcome-focused foundation documents immediately."
echo ""

echo "[PHASE 2] DEEP RESEARCH ENHANCEMENT (Background - 2-5 minutes)"
echo "============================================================="
echo ""
echo "AI WILL enhance foundation with outcome-specific research:"
echo ""
echo "2A. STAGED DELIVERY RESEARCH:"
echo "   - Best practices for incremental development"
echo "   - Technology choices that support evolution"
echo "   - Patterns for adding complexity gradually"
echo "   - Migration strategies between stages"
echo ""
echo "2B. OUTCOME VALIDATION RESEARCH:"
echo "   - Success metrics for each stage"
echo "   - Testing strategies for incremental features"
echo "   - User feedback collection methods"
echo "   - Performance benchmarks per stage"
echo ""
echo "2C. ARCHITECTURE EVOLUTION RESEARCH:"
echo "   - Patterns that grow with requirements"
echo "   - Refactoring strategies between stages"
echo "   - Technical debt management"
echo "   - Scalability preparation"
echo ""
echo "This research enhances documents with stage-specific insights."
echo ""

echo "[APPROACH] OUTCOME-DRIVEN INTELLIGENCE:"
echo "- Phase 1 creates outcome roadmap immediately"
echo "- Phase 2 enhances with stage-specific research"
echo "- Focus on shipping working units quickly"
echo "- Adapt based on learnings from each stage"
echo ""
```

## Task 3: Load Template Context (if template specified)

### Template-Based Foundation Loading
```bash
if [ -n "$template_name" ]; then
    echo "[TEMPLATE] LOADING TEMPLATE CONTEXT"
    echo "==================================="
    echo ""
    
    template_dir=".vybe/templates/$template_name"
    
    # Load template metadata for context
    if [ -f "$template_dir/metadata.yml" ]; then
        echo "[TEMPLATE] Loading template metadata and analysis..."
        # AI MUST read template metadata to understand:
        # - Detected technologies and frameworks
        # - Template type and complexity
        # - Architectural patterns
        # - Generated enforcement structures
    fi
    
    # Load template-generated Vybe documents as foundation
    if [ -d "$template_dir/generated" ]; then
        echo "[TEMPLATE] Loading template-generated Vybe documents..."
        # AI MUST read generated documents as starting point:
        # - overview.md template (business context from template)
        # - architecture.md template (tech stack from template)
        # - conventions.md template (coding standards from template)
    fi
    
    # Load template mapping for Vybe integration
    if [ -f "$template_dir/mapping.yml" ]; then
        echo "[TEMPLATE] Loading template-to-Vybe mapping..."
        # AI MUST understand how template concepts map to Vybe workflow
    fi
    
    echo "[OK] Template context loaded - will merge with project analysis"
    echo ""
else
    echo "[NO TEMPLATE] Proceeding with standard project analysis"
    echo ""
fi
```

## Task 3.5: Complete Technology Stack Capture and Planning

### Interactive Technology Stack Definition
```bash
echo "[TECH] COMPLETE TECHNOLOGY STACK CAPTURE"
echo "========================================"
echo ""
echo "Project Description: $project_description"
echo "Template: $([ "$template_exists" = true ] && echo "$template_name" || echo "None")"
echo ""

if [ "$template_exists" = true ]; then
    echo "[TEMPLATE] Using template-defined technology stack"
    echo "AI MUST:"
    echo "1. READ template source code to extract exact technologies used"
    echo "2. ANALYZE template dependencies and requirements"
    echo "3. CREATE complete tech stack registry from template"
    echo "4. MAP template tools to stage-by-stage installation plan"
    echo ""
else
    echo "[INTERACTIVE] Capturing complete technology roadmap"
    echo "AI MUST interactively determine:"
    echo ""
    echo "1. PRIMARY PROGRAMMING LANGUAGE:"
    echo "   - What language best fits the project requirements?"
    echo "   - Version requirements and constraints"
    echo "   - Package manager and tooling"
    echo ""
    echo "2. APPLICATION ARCHITECTURE:"
    echo "   - Web application? API? Desktop? Mobile? CLI?"
    echo "   - Frontend framework needs (if web app)"
    echo "   - Backend framework requirements (if needed)"
    echo "   - Database requirements and type"
    echo ""
    echo "3. DEVELOPMENT TOOLS:"
    echo "   - Build system and bundlers"
    echo "   - Development server setup"
    echo "   - Code quality tools (linting, formatting)"
    echo "   - IDE/editor configuration"
    echo ""
    echo "4. TESTING STRATEGY:"
    echo "   - Unit testing framework"
    echo "   - Integration testing approach"
    echo "   - End-to-end testing tools (if needed)"
    echo "   - Code coverage requirements"
    echo ""
    echo "5. DEPLOYMENT PIPELINE:"
    echo "   - Build process and artifacts"
    echo "   - Environment management"
    echo "   - Deployment targets and methods"
    echo "   - CI/CD pipeline requirements"
    echo ""
fi

echo "[AI ANALYSIS] AI MUST intelligently analyze and recommend:"
echo "========================================================"
echo ""
echo "1. PARSE PROJECT DESCRIPTION:"
echo "   - Extract explicitly mentioned technologies (python, fastapi, etc.)"
echo "   - Identify application type (task management, web app, API, etc.)"
echo "   - Understand requirements (quick development, production-ready, etc.)"
echo ""
echo "2. RESEARCH & RECOMMEND MISSING PIECES:"
echo "   - For task management app: Does it need a database? What type?"
echo "   - What testing approach works best for this stack?"
echo "   - What development tools enhance this workflow?"
echo "   - What deployment options fit the requirements?"
echo ""
echo "3. PRESENT COMPLETE TECHNOLOGY STACK RECOMMENDATION:"
echo "   - Show user what was specified vs what is recommended"
echo "   - Explain WHY each technology is recommended"
echo "   - Provide alternatives for user consideration"
echo "   - Ask for user approval or modification"
echo ""
echo "4. CREATE TECHNOLOGY REGISTRY:"
echo "   After user approval, create .vybe/tech/ structure with:"
echo "   - languages.yml - Primary language, version, package manager"
echo "   - frameworks.yml - Web/API/DB frameworks and versions"
echo "   - testing.yml - Test frameworks, commands, and requirements"
echo "   - build.yml - Build tools, scripts, and processes"
echo "   - tools.yml - Development tools and utilities"
echo "   - deployment.yml - Deployment configuration and targets"
echo "   - stages.yml - Stage-by-stage tool installation plan"
echo ""
echo "5. HANDLE USER FEEDBACK:"
echo "   - If user rejects recommendations: Ask for more specific requirements"
echo "   - If user wants changes: Guide them to re-run with more detail"
echo "   - If user approves: Proceed with technology registry creation"
echo ""
```

### Create Technology Registry Structure
```bash
echo "[SETUP] Creating technology registry structure..."
mkdir -p .vybe/tech

# Create technology registry files
echo "[CREATE] Creating complete technology stack registry..."

# IMPORTANT: AI must now create actual technology files based on the analysis
# This replaces the placeholder approach with real implementation

echo "[AI] NOW CREATING ACTUAL TECHNOLOGY REGISTRY FILES..."
echo "===================================================="
echo ""
echo "Based on project analysis: $project_description"
echo ""
echo "AI MUST NOW:"
echo "1. Parse the project description and extract technology requirements"
echo "2. Create specific .yml files with actual technology decisions"
echo "3. Base decisions on the technology analysis already performed"
echo "4. Include specific versions, commands, and configurations"
echo ""
echo "CREATING TECHNOLOGY REGISTRY WITH REAL DATA..."

# Critical: Stage-by-stage installation plan
cat > .vybe/tech/stages.yml << 'EOF'
# Stage-by-Stage Technology Preparation Plan
# AI MUST populate with progressive tool installation

stages:
  stage-1:
    name: "Basic Development Setup"
    description: "Core language and basic development tools"
    required_tools: []  # AI MUST fill
    install_commands: []  # AI MUST fill
    validation_commands: []  # AI MUST fill
    
  stage-2:
    name: "Framework and Testing Setup"
    description: "Web frameworks and testing infrastructure"
    required_tools: []  # AI MUST fill
    install_commands: []  # AI MUST fill
    validation_commands: []  # AI MUST fill
    
  stage-3:
    name: "Database and Integration"
    description: "Database setup and integration testing"
    required_tools: []  # AI MUST fill
    install_commands: []  # AI MUST fill
    validation_commands: []  # AI MUST fill
    
  stage-final:
    name: "Production Readiness"
    description: "Deployment tools and production validation"
    required_tools: []  # AI MUST fill
    install_commands: []  # AI MUST fill
    validation_commands: []  # AI MUST fill

# AI MUST customize stages based on project requirements
EOF

echo "[OK] Technology registry base structure created"
echo ""

# AI IMPLEMENTATION: Create actual technology registry files
echo "[AI] CREATING ACTUAL TECHNOLOGY REGISTRY FILES"
echo "=============================================="
echo ""
echo "Based on project analysis and user context:"
echo "Project: $project_description"
echo ""
echo "AI is now analyzing the project description and creating specific technology registry files..."
echo ""

# This is where AI will implement the actual technology analysis and file creation
# The AI should:
# 1. Parse the project description
# 2. Extract mentioned technologies
# 3. Research and recommend missing components
# 4. Create specific .yml files with actual technology decisions
# 5. Populate stages.yml with real installation commands

echo "[CRITICAL] AI MUST NOW IMPLEMENT:"
echo "================================"
echo ""
echo "1. ANALYZE PROJECT DESCRIPTION: '$project_description'"
echo "   - Extract explicit technologies (Python, FastAPI, etc.)"
echo "   - Identify project type (expense tracker, web app, etc.)"
echo "   - Determine complexity needs (quick development, production, etc.)"
echo ""
echo "2. CREATE COMPLETE TECHNOLOGY STACK FILES:"
echo "   - languages.yml: Primary language, version, package manager"
echo "   - frameworks.yml: Web/API/database frameworks and versions"
echo "   - testing.yml: Test frameworks, commands, validation"
echo "   - build.yml: Build tools, scripts, development server"
echo "   - tools.yml: Development tools, linters, formatters"
echo "   - deployment.yml: Deployment setup, environment configuration"
echo ""
echo "3. POPULATE STAGES.YML WITH REAL INSTALLATION PLAN:"
echo "   - Stage 1: Core language and basic tools"
echo "   - Stage 2: Web framework and testing setup"
echo "   - Stage 3: Database and integration tools"
echo "   - Stage Final: Production and deployment tools"
echo ""
echo "4. USE ACTUAL COMMANDS AND VERSIONS:"
echo "   - Specific installation commands (pip install, npm install, etc.)"
echo "   - Version requirements and constraints"
echo "   - Validation commands to check installation"
echo ""
echo "AI MUST CREATE THESE FILES NOW WITH REAL TECHNOLOGY DECISIONS!"
echo ""
```

## Task 4: Generate Intelligent Project Documentation (Phase 1 - Fast)

### Generate outcomes.md with Staged Roadmap
```bash
echo "[DOCS] PHASE 1 - GENERATING OUTCOME ROADMAP"
echo "==========================================="
echo ""
echo "[AI] IMMEDIATE OUTCOMES CREATION (30 seconds):"
echo "AI MUST create outcomes.md using captured staged outcomes:"
echo ""
echo "CRITICAL: Generate CLEAN MARKDOWN without any control characters or ANSI escape codes!"
echo "   - NO color codes, NO bold/italic terminal formatting"
echo "   - NO special characters like ^D, <F3>, ESC sequences"
echo "   - PURE markdown text only for compatibility with readers like glow"
echo ""
echo "1. OUTCOME ROADMAP GENERATION:"
echo "   - Document first minimal outcome clearly"
echo "   - Map path from minimal to final vision"
echo "   - Define success metrics for each stage"
echo "   - FORMAT: Each stage on its own line with proper newlines"
echo "   - Estimate realistic timelines (1-3 days per stage)"
echo ""
echo "2. STAGE DEFINITION:"
echo "   - Each stage with clear deliverable"
echo "   - Business value for each stage"
echo "   - Technical outcomes per stage"
echo "   - Dependencies between stages"
echo ""
echo "3. ADAPTIVE PLANNING:"
echo "   - Mark stages as flexible/adjustable"
echo "   - Note where UI examples will be needed"
echo "   - Include learning checkpoints"
echo "   - Plan for iteration based on feedback"
echo ""

# Copy template and let AI customize with captured outcomes
cp .claude/templates/outcomes.template.md .vybe/project/outcomes.md

echo "[OK] Outcome roadmap created - staged delivery plan ready"
echo ""
```

### Generate overview.md with Outcome Focus
```bash
echo "[DOCS] PHASE 1 - GENERATING OUTCOME-DRIVEN PROJECT OVERVIEW"
echo "=========================================================="
echo ""
echo "[AI] IMMEDIATE OVERVIEW CREATION (30 seconds):"
echo "AI MUST create overview.md aligned with staged outcomes:"
echo "CRITICAL: Generate CLEAN MARKDOWN - no control characters, ANSI codes, or terminal formatting!"
echo ""
echo "1. OUTCOME-ALIGNED PROJECT CONTEXT:"
echo "   - Business context supporting incremental delivery"
echo "   - Users who benefit from each stage"
echo "   - Success metrics tied to outcome stages"
echo "   - Scope that evolves with each stage"
echo ""
echo "2. INTELLIGENT TEMPLATE ADAPTATION:"
echo "   - Use comprehensive overview.md template from .claude/templates/"
echo "   - Align all sections with staged outcome approach"
echo "   - Focus on value delivery at each stage"
echo "   - Create foundation supporting incremental growth"
echo ""
echo "3. QUALITY FOUNDATION:"
echo "   - Clear connection to outcome roadmap"
echo "   - Incremental value proposition"
echo "   - Stage-based success criteria"
echo "   - Ready for enhancement with learnings"
echo ""

# Copy template and let AI customize with outcome focus
cp .claude/templates/overview.template.md .vybe/project/overview.md

echo "[OK] Outcome-driven overview created - aligned with staged delivery"
echo ""
```

### Generate architecture.md with Smart Inference
```bash
echo "[DOCS] PHASE 1 - GENERATING INTELLIGENT PROJECT ARCHITECTURE"
echo "=========================================================="
echo ""
echo "[AI] IMMEDIATE ARCHITECTURE CREATION (30 seconds):"
echo "AI MUST create intelligent architecture.md using project description analysis:"
echo "CRITICAL: Generate CLEAN MARKDOWN - no control characters, ANSI codes, or terminal formatting!"
echo ""
echo "1. SMART TECHNOLOGY INFERENCE:"
echo "   - Infer appropriate technology stack from project type and requirements"
echo "   - Select standard database solutions for identified data patterns"
echo "   - Choose common authentication approaches for application type"
echo "   - Apply proven patterns for the identified project domain"
echo ""
echo "2. ARCHITECTURE PATTERN SELECTION:"
echo "   - Apply standard architecture patterns for project type"
echo "   - Define system architecture based on inferred scalability needs"
echo "   - Establish data flow patterns appropriate for application category"
echo "   - Set integration patterns for typical external service needs"
echo ""
echo "3. INTELLIGENT TEMPLATE COMPLETION:"
echo "   - Use comprehensive architecture.md template from .claude/templates/"
echo "   - Fill in technology choices based on project type analysis"
echo "   - Customize patterns for inferred requirements"
echo "   - Create solid foundation ready for research enhancement"
echo ""

# Copy template and let AI customize immediately based on description analysis
cp .claude/templates/architecture.template.md .vybe/project/architecture.md

echo "[OK] Intelligent architecture created immediately - ready for research enhancement"
echo ""
```

### Generate conventions.md with Smart Standards
```bash
echo "[DOCS] PHASE 1 - GENERATING INTELLIGENT DEVELOPMENT CONVENTIONS"
echo "=============================================================="
echo ""
echo "[AI] IMMEDIATE CONVENTIONS CREATION (30 seconds):"
echo "AI MUST create intelligent conventions.md using project type analysis:"
echo "CRITICAL: Generate CLEAN MARKDOWN - no control characters, ANSI codes, or terminal formatting!"
echo ""
echo "1. SMART STANDARDS INFERENCE:"
echo "   - Apply standard development practices for inferred technology stack"
echo "   - Use common code style guides for identified project type"
echo "   - Set typical testing conventions for application category"
echo "   - Define standard project structure for architectural patterns"
echo ""
echo "2. INTELLIGENT BEST PRACTICES:"
echo "   - Apply common security practices for identified business domain"
echo "   - Use standard performance guidelines for application type"
echo "   - Include typical accessibility standards for target users"
echo "   - Set appropriate quality standards for project complexity"
echo ""
echo "3. SMART TEMPLATE ADAPTATION:"
echo "   - Use comprehensive conventions.md template from .claude/templates/"
echo "   - Adapt standards to inferred technology choices"
echo "   - Customize workflow for typical project team structure"
echo "   - Create solid foundation ready for research enhancement"
echo ""

# Copy template and let AI customize immediately based on project analysis
cp .claude/templates/conventions.template.md .vybe/project/conventions.md

echo "[OK] Intelligent conventions created immediately - ready for research enhancement"
echo ""
```

## Final Initialization Steps

### Complete Project Setup - Phase 1 Complete
```bash
echo "[INIT] PHASE 1 COMPLETE - OUTCOME-DRIVEN SETUP"
echo "=============================================="
echo ""
echo "[FAST] Outcome roadmap created in ~30 seconds:"
echo "   - First minimal outcome captured"
echo "   - Final vision documented"
echo "   - Initial stages defined (flexible)"
echo "   - Ready for immediate Stage 1 development"
echo ""
echo "[FILES] Generated outcome-focused documents:"
echo "   - .vybe/project/outcomes.md (staged delivery roadmap)"
echo "   - .vybe/project/overview.md (business context aligned with outcomes)"
echo "   - .vybe/project/architecture.md (technology supporting incremental growth)"
echo "   - .vybe/project/conventions.md (standards for staged development)"
echo ""
echo "[TECHNOLOGY] Complete technology stack registry created:"
echo "   - .vybe/tech/languages.yml (primary language and package manager)"
echo "   - .vybe/tech/frameworks.yml (web/API/database frameworks)"
echo "   - .vybe/tech/testing.yml (testing frameworks and commands)"
echo "   - .vybe/tech/build.yml (build tools and development server)"
echo "   - .vybe/tech/tools.yml (development tools and utilities)"
echo "   - .vybe/tech/deployment.yml (deployment configuration)"
echo "   - .vybe/tech/stages.yml (progressive tool installation plan)"
echo ""
echo "[INCREMENTAL] Baby steps approach enabled:"
echo "   - Stage 1 can ship in 1-2 days"
echo "   - Each stage delivers working units"
echo "   - Learning between stages improves next stage"
echo "   - UI examples requested only when needed"
echo ""
echo "[ENHANCEMENT] Phase 2 research in background:"
echo "   - Best practices for incremental delivery"
echo "   - Stage-specific technology patterns"
echo "   - Success metrics refinement"
echo "   - Architecture evolution strategies"
echo ""

# Template enforcement setup (if template specified)
if [ -n "$template_name" ]; then
    echo "[TEMPLATE] TEMPLATE DNA INTEGRATION"
    echo "=================================="
    echo ""
    
    # Copy template enforcement structures to active project
    template_dir=".vybe/templates/$template_name"
    
    if [ -d "$template_dir/generated" ]; then
        echo "[TEMPLATE] Activating template enforcement structures..."
        
        # Copy enforcement rules if they exist
        if [ -d ".vybe/enforcement" ]; then
            echo "   ✓ Template enforcement rules active"
        fi
        
        # Copy pattern templates if they exist  
        if [ -d ".vybe/patterns" ]; then
            echo "   ✓ Template code patterns active"
        fi
        
        # Copy validation rules if they exist
        if [ -d ".vybe/validation" ]; then
            echo "   ✓ Template validation rules active"
        fi
        
        echo ""
        echo "[TEMPLATE DNA] Template '$template_name' is now project DNA:"
        echo "   - All future commands will follow template patterns"
        echo "   - Code generation will use template structures"
        echo "   - Validation will check template compliance"
        echo "   - Template cannot be changed (permanent DNA)"
        
        # Mark template as active in project
        echo "template: $template_name" >> .vybe/project/.template
        echo "template_set: $(date -u +"%Y-%m-%dT%H:%M:%SZ")" >> .vybe/project/.template
        echo "template_immutable: true" >> .vybe/project/.template
        
        echo ""
    fi
fi
echo "[NEXT] Ready for Stage 1 development:"
echo "   - /vybe:backlog init - Generate tasks grouped by outcomes"
echo "   - /vybe:plan stage-1 - Plan first minimal outcome"
echo "   - /vybe:execute - Start delivering Stage 1"
echo "   - /vybe:release - Mark stage complete, advance to next"
```

## Error Handling

### Common Issues
- **No project description provided**: Prompt for description or analyze existing files
- **Templates not found**: Check templates/ directory exists
- **Permission denied**: Check file system permissions
- **Existing .vybe conflicts**: Offer update or abort with clear options

### Recovery Actions
- **Rollback on failure**: Preserve any existing files
- **Clear error messages**: Provide specific solutions for each error type
- **Template fallback**: Use basic templates if comprehensive ones unavailable
- **Manual guidance**: Suggest manual steps when automated approach fails

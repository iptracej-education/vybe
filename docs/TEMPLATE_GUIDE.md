# Vybe Template System Guide

**Complete guide to using templates as architectural DNA in Vybe projects**

**Performance**: Template operations benefit from Vybe's 20-120x performance optimization through shared cache system and MCP integration.

## Overview

The Vybe Template System allows you to import external templates (like GitHub repositories) and use them as the architectural foundation for your projects. Templates provide the "DNA" that guides all development decisions - from directory structure to coding patterns to deployment strategies.

## Core Concept: Template as DNA

### What Templates Provide
- **Architectural Foundation**: Directory structure, component organization
- **Technology Stack**: Languages, frameworks, tools, dependencies  
- **Coding Conventions**: Naming, formatting, import patterns
- **Development Patterns**: Component templates, service patterns, API designs
- **Quality Standards**: Testing approaches, validation rules, compliance

### Template Immutability & Living Documents
Once set during project initialization, templates become **permanent project DNA**:

### What's Immutable (Template DNA)
- ❌ Template choice cannot be changed mid-project
- ❌ Core architectural patterns must be followed
- ❌ Directory structure requirements are enforced
- ❌ Code generation patterns cannot be bypassed

### What's Living (Project Evolution)
- ✅ **Vybe documents can evolve freely** - Edit with any editor, no approval needed
- ✅ **Add features following template patterns** - Extend within architectural constraints
- ✅ **Customize project context** - Adapt business goals, user descriptions, conventions
- ✅ **Iterate on requirements** - Refine specs based on learnings and discoveries

### Living Documents Philosophy
Templates provide architectural DNA while preserving the flexibility of living documents:
- **Generate and Go**: Template creates starting point documents
- **Edit Freely**: Modify any .md file with your preferred editor
- **AI-Assisted Changes**: Use `--modify` options for AI help with specific updates
- **No Approval Gates**: No acceptance ceremonies - documents evolve naturally
- **Template Compliance**: Architecture patterns enforced, but content evolution encouraged

## Template Workflow

### 1. Import Template
Bring an external template into Vybe for analysis:

```bash
# From GitHub
/vybe:template import github.com/fastapi/full-stack-fastapi-template fastapi-stack

# From local directory  
/vybe:template import ./my-template-project my-template
```

**What happens:**
- Template source copied to `.vybe/templates/[name]/source/`
- Basic metadata created
- Template ready for analysis

### 2. Generate Structures  
AI analyzes the template and creates enforcement structures:

```bash
/vybe:template generate fastapi-stack
```

**What AI does:**
- **Deep Analysis**: Reads all template files to understand architecture
- **Pattern Extraction**: Identifies reusable code patterns and structures
- **Convention Detection**: Discovers naming, formatting, organization rules
- **Vybe Integration**: Maps template concepts to Vybe workflow

**What gets generated:**
```
.vybe/enforcement/        # Rules that must be followed
.vybe/patterns/          # Reusable code templates
.vybe/validation/        # Compliance checking rules
.vybe/templates/[name]/  # Template storage and analysis
```

### 3. Initialize Project with Template
Use template as project DNA:

```bash
/vybe:init "My API project" --template=fastapi-stack
```

**What happens:**
- Template becomes permanent project DNA
- **Living documents created using template patterns** - foundation that evolves freely
- Enforcement structures activated for code generation and validation
- Future commands follow template rules while allowing document evolution

### 4. Develop Following Template DNA
All commands now enforce template patterns with intelligent technology coordination:

```bash
/vybe:plan user-auth       # Creates specs following template structure
/vybe:execute auth-task-1  # Uses template technology stack + progressive tool installation
/vybe:audit               # Validates against template compliance
```

**Technology Stack Coordination** (✅ IMPLEMENTED): Templates now provide complete technology decisions:
- **No Technology Guessing**: Execute commands use template's exact technology stack
- **Progressive Installation**: Tools installed stage-by-stage based on template requirements
- **Template Registry**: Complete `.vybe/tech/` structure extracted from template source code and actually created
- **Validation Commands**: Template-specific commands for verifying tool installation

## Template Management Commands

### View Available Templates
```bash
/vybe:template list
```

Shows all imported templates with their status and metadata.

### Validate Template
```bash
/vybe:template validate fastapi-stack
```

Checks template completeness and readiness for use.

## Template Types & Examples

### API/Backend Templates
**Example**: FastAPI Full Stack Template
- **Structure**: API routes, database models, authentication
- **Patterns**: Service layer, dependency injection, async patterns
- **Standards**: REST API design, database migrations, testing

```bash
/vybe:template import github.com/fastapi/full-stack-fastapi-template fastapi-stack
/vybe:template generate fastapi-stack
/vybe:init "My API" --template=fastapi-stack
```

### Frontend Templates  
**Example**: Next.js Enterprise Template
- **Structure**: Components, pages, hooks, utilities
- **Patterns**: Component composition, state management, routing
- **Standards**: TypeScript, testing, performance optimization

```bash
/vybe:template import github.com/vercel/next.js/tree/canary/examples/with-typescript nextjs-ts
/vybe:template generate nextjs-ts
/vybe:init "My Frontend" --template=nextjs-ts
```

### Fullstack Templates
**Example**: T3 Stack (Next.js + tRPC + Prisma)
- **Structure**: Frontend + backend in single repo
- **Patterns**: Type-safe API, database ORM, authentication
- **Standards**: End-to-end TypeScript, testing, deployment

### ML/AI Templates
**Example**: GenAI Launchpad
- **Structure**: Workflows, nodes, services, API
- **Patterns**: Workflow orchestration, async processing, prompt management
- **Standards**: Python, LangChain, Celery, FastAPI

```bash
/vybe:template import github.com/user/genai-launchpad genai-stack  
/vybe:template generate genai-stack
/vybe:init "AI Workflow Platform" --template=genai-stack
```

## How Templates Affect Development

### During Planning (`/vybe:plan`)
- **Structure Enforcement**: Features must follow template directory organization
- **Component Patterns**: New components follow template component structure
- **API Design**: Endpoints follow template API patterns

### During Execution (`/vybe:execute`)
- **Code Generation**: Uses template patterns for generating code
- **File Placement**: Creates files in template-specified locations
- **Naming Conventions**: Follows template naming rules

### During Validation (`/vybe:audit`)
- **Compliance Checking**: Validates against template standards
- **Pattern Verification**: Ensures code follows template patterns
- **Quality Standards**: Applies template-specific quality rules

## Template Structure Deep Dive

### Generated Enforcement Structures

#### `.vybe/enforcement/`
**What it contains**: Rules that must be followed
- `structure.yml`: Required directories and file organization
- `components.yml`: How to create and organize components
- `services.yml`: Service layer patterns and requirements
- `workflows.yml`: Workflow/feature organization rules

**Example structure.yml**:
```yaml
required_directories:
  - src/
  - tests/
  - docs/
  - api/

component_patterns:
  location: src/components/
  naming: PascalCase
  structure: directory_per_component
```

#### `.vybe/patterns/`
**What it contains**: Reusable code templates
- `component.template`: Template for creating new components
- `service.template`: Template for creating new services  
- `api-endpoint.template`: Template for API endpoints
- `test.template`: Template for test files

**Example component.template**:
```javascript
// Template variables: {ComponentName}, {component_description}
import React from 'react';

const {ComponentName} = (props) => {
  // {component_description}
  return <div>{props.children}</div>;
};

export default {ComponentName};
```

#### `.vybe/validation/`
**What it contains**: Quality and compliance rules
- `structure-rules.yml`: Directory structure validation
- `naming-rules.yml`: File and code naming conventions
- `import-rules.yml`: Import pattern validation
- `testing-rules.yml`: Test coverage and structure requirements

### Template Metadata

#### `metadata.yml`
Contains AI analysis results:
```yaml
name: fastapi-stack
source: github.com/fastapi/full-stack-fastapi-template
analyzed: true
analysis:
  primary_language: python
  frameworks: [fastapi, sqlalchemy, pydantic]
  template_type: api
  complexity: moderate
  patterns_extracted: 15
  has_authentication: true
  has_database: true
```

#### `mapping.yml`
Maps template concepts to Vybe workflow:
```yaml
vybe_mapping:
  potential_features:
    - feature_name: user-management
      source_location: app/users/
      description: User authentication and management
    - feature_name: api-endpoints
      source_location: app/api/
      description: REST API implementation
      
  suggested_stages:
    - stage: 1
      description: Basic API setup
      deliverable: Working API skeleton
    - stage: 2  
      description: User authentication
      deliverable: Login/register functionality
```

## Best Practices

### Choosing Templates
1. **Match Your Domain**: Choose templates that match your project type
2. **Check Activity**: Use actively maintained templates
3. **Understand Complexity**: Start with simpler templates for learning
4. **Review Architecture**: Ensure template architecture fits your needs

### Template Management
1. **Descriptive Names**: Use clear template names (`fastapi-stack`, not `template1`)
2. **Version Tracking**: Note template versions in metadata
3. **Team Alignment**: Ensure team understands chosen template
4. **Documentation**: Document any template customizations

### Working with Templates
1. **Follow the DNA**: Embrace template patterns rather than fighting them
2. **Incremental Adoption**: Start with template basics, gradually use advanced features
3. **Team Training**: Ensure team understands template conventions
4. **Validation Early**: Use `/vybe:audit` regularly to catch deviations

## Migration Strategies

### When to Change Templates
- Project requirements fundamentally changed
- Template no longer maintained or supported
- Architecture needs complete overhaul
- Technology stack needs major upgrade

### How to Migrate
Since templates are immutable, migration requires:

1. **Create New Project**: Initialize new project with desired template
```bash
/vybe:template import github.com/new/template new-stack
/vybe:template generate new-stack
/vybe:init "Migrated Project" --template=new-stack
```

2. **Migrate Code**: Use AI assistance to migrate existing code
```bash
/vybe:discuss "Help migrate this FastAPI code to Django template patterns"
```

3. **Update Dependencies**: Align dependencies with new template
4. **Test Thoroughly**: Ensure functionality preserved in new structure

## Troubleshooting

### Common Issues

#### Template Import Fails
```bash
[ERROR] Failed to clone repository
```
**Solutions**:
- Check internet connection
- Verify GitHub URL is correct
- Ensure repository is public or you have access
- Try with local path if GitHub unavailable

#### Template Generation Fails
```bash
[ERROR] Could not analyze template structure
```
**Solutions**:
- Check template has actual code files
- Ensure template isn't empty or corrupted
- Verify template follows recognizable patterns
- Try with a different, simpler template

#### Template Not Ready for Use
```bash
[ERROR] Template 'my-template' not yet analyzed
```
**Solution**:
```bash
/vybe:template generate my-template
```

#### Enforcement Rules Too Strict
If template rules are too restrictive:
1. Use `/vybe:discuss` to explore alternatives
2. Consider if template is right fit for project
3. Adapt within template constraints rather than fighting them

### Getting Help

For template-related issues:
1. Use `/vybe:discuss` to explore template usage patterns
2. Use `/vybe:audit` to understand compliance requirements  
3. Check template documentation and examples
4. Consider starting with simpler templates for learning

## Template Development

### Creating Your Own Templates
To create templates that work well with Vybe:

1. **Clear Structure**: Organize code in logical directories
2. **Consistent Patterns**: Use consistent naming and organization
3. **Good Documentation**: Include README and code comments
4. **Configuration Files**: Include standard config files (package.json, etc.)
5. **Examples**: Include example components, services, tests

### Template Best Practices
- **Single Responsibility**: Templates should have clear, focused purpose
- **Modular Design**: Organize code in reusable modules
- **Standard Conventions**: Follow language/framework standards
- **Quality Code**: Include examples of high-quality code
- **Complete Examples**: Include working examples, not just boilerplate

## Advanced Usage

### Template Composition
While Vybe supports one template per project, you can:
- Import multiple templates for reference
- Use `/vybe:discuss` to explore combining patterns
- Extract patterns from multiple sources manually

### Custom Enforcement
After template generation, you can:
- Review and understand generated enforcement rules
- Discuss modifications with AI for specific needs
- Adapt patterns while maintaining template DNA

### Template Evolution
Templates can evolve over time:
- Import updated versions with new names
- Compare patterns between versions
- Plan migration strategies for major changes

---

The Vybe Template System transforms external templates into intelligent architectural DNA that guides your entire development process. By choosing the right template and following its patterns, you get production-ready structure and standards from day one.
---
description: Import and analyze external templates with AI-driven architectural analysis
allowed-tools: Bash, Read, Write, Edit, MultiEdit, Glob, Grep, LS, WebFetch, vybe-cache.get, vybe-cache.set, vybe-cache.mget, vybe-cache.mset
---

# /vybe:template - AI-Driven Template Analysis System

Import external templates and let AI intelligently analyze their architecture, patterns, and conventions to create comprehensive enforcement structures.

## Platform Compatibility

### Supported Platforms
- [OK] **Linux**: All distributions with bash 4.0+
- [OK] **macOS**: 10.15+ (Catalina and later)
- [OK] **WSL2**: Windows Subsystem for Linux 2
- [OK] **Git Bash**: Windows with Git Bash installed
- [OK] **Cloud IDEs**: GitHub Codespaces, Gitpod, Cloud9

### Required Tools
```bash
bash --version    # Bash 4.0 or higher
git --version     # Git 2.0 or higher (for GitHub imports)
find --version    # GNU find or BSD find
```

## Usage
```
/vybe:template [action] [params]
```

## Actions & Parameters

### import [source] [name]
Import template from external source
- `source`: GitHub URL or local path
- `name`: Template identifier (kebab-case)

### generate [name]
AI analyzes template and generates Vybe structures
- `name`: Previously imported template name

### list
Show all available templates

### validate [name]
Check template completeness
- `name`: Template to validate

## Context
- Content of the template script: @./.claude/commands/vybe/template-script.sh

## Your task

**If the first argument is "help", display this help content directly:**

```
COMMANDS:
/vybe:template list                        Show available templates
/vybe:template import [source] [name]      Import template from GitHub/local
/vybe:template generate [name]             AI analyzes template patterns
/vybe:template validate [name]             Check template completeness

EXAMPLES:
/vybe:template list
/vybe:template import github.com/anthropics/genai-launchpad genai-stack
/vybe:template import ./my-company-template company-stack
/vybe:template generate genai-stack
/vybe:template validate genai-stack

WORKFLOWS:
# Import and use template:
/vybe:template import github.com/user/repo my-template
/vybe:template generate my-template
/vybe:init "My project" --template=my-template

Use '/vybe:template [action]' for template management.
Use '/vybe:init --template=name' to apply templates.
```

**Otherwise, review the template script above and execute it with the provided arguments. The script implements:**

- **Shared Cache Architecture**: Uses project-wide cache shared across all Vybe commands
- **Bulk Processing**: Loads all project data at once using cache + file system fallback  
- **Atomic Updates**: Ensures file and cache consistency during template operations
- **AI Coordination**: Prepares context for template import, analysis, and generation

Execute the script with: `bash .claude/commands/vybe/template-script.sh "$@"`

## Expected AI Operations

After the script prepares the context, Claude AI should perform the appropriate action:

### For Import Action
1. **Source Analysis**: Determine if source is GitHub URL, local path, or other
2. **Template Download**: Clone/copy template files to `.vybe/templates/[name]/source/`
3. **Structure Analysis**: Scan template files and identify key patterns
4. **Metadata Generation**: Create `metadata.yml` with template characteristics

### For Generate Action  
1. **Architecture Analysis**: Analyze template code patterns, conventions, and structure
2. **Pattern Extraction**: Extract reusable code patterns and templates
3. **Enforcement Creation**: Generate rules in `.vybe/enforcement/` directory
4. **Validation Rules**: Create compliance checking in `.vybe/validation/`
5. **Project Integration**: Update project architecture and conventions

### For List/Validate Actions
Display template information and validation results using the bulk-processed data.

## Template Directory Structure
```
.vybe/templates/[name]/
├── source/           # Original template files
├── metadata.yml      # Template characteristics
├── analysis.json     # AI analysis results
└── patterns/         # Extracted patterns

.vybe/enforcement/    # Template enforcement rules
.vybe/patterns/       # Reusable code patterns  
.vybe/validation/     # Compliance checking rules
```

All operations use the shared cache system for optimal performance across multiple command executions.

## Success Metrics
- ✅ **Import**: Template files successfully copied and metadata created
- ✅ **Generate**: Enforcement rules, patterns, and validation files created
- ✅ **List**: All templates displayed with descriptions and status
- ✅ **Validate**: Completion score and missing components identified

## Error Handling
- **Invalid source**: Clear error messages with examples
- **Missing template**: Available templates listed for selection
- **Import conflicts**: Existing template protection with override options
- **Generation failures**: Fallback to manual template configuration

The template system uses shared cache architecture for optimal performance across multiple command executions.
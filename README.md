# Vybe 

 **Note:** This is an experimental project under active development. Features and structure may change significantly.

A spec-driven AI development framework for Claude Code.

A structured approach to AI-assisted development using specification-driven workflows, inspired by Amazon's Working Backwards methodology and built on top of the claude-code-spec framework.

## Overview

Vybe is a systematic framework that brings structure and consistency to AI-assisted development with Claude Code. By emphasizing clear specifications, comprehensive requirements documentation, and phased development cycles, Vybe helps developers maintain high code quality and project coherence when collaborating with AI coding assistants.

The framework introduces a disciplined approach to AI-powered development through:
  - **Specification-first methodology** - Define what you're building before you build it
  - **Structured development phases** - Clear progression from requirements to implementation
  - **Human oversight gates** - Strategic review points to ensure quality and alignment
  - **Project context management** - Persistent steering documents that guide AI behavior
  - **Progress visibility** - Clear tracking of specification completion and task status


This implementation builds upon the claude-code-spec framework while optimizing specifically for Claude Code workflows. It offers greater flexibility for diverse application types but maintains more restricted AI assistance patterns.

### Based On

- [claude-code-spec](https://github.com/gotalab/claude-code-spec) - Original framework implementation
- [kiro](https://kiro.dev/) - Amazon's Working Backwards methodology - Start with the end goal and work backwards

## Setup

```bash
# Clone the repository
git clone https://github.com/iptracej-education/vybe.git 
cd vybe

# Copy framework files to your project
cp CLAUDE.md /path/to/your-project/
cp -r .claude/commands/ /path/to/your-project/.claude/

# Initialize your project structure
mkdir -p /path/to/your-project/.vybe/{specs,steering}
```

## How to Use

### Quick Start

1. **Initialize Your Project**
   ```bash
   mkdir my-project
   cd my-project
   # Copy the Vybe framework files (see Setup above)
   ```

2. **Create Initial Documentation**
   - Create a README.md with your project description
   - Optionally run `/vybe:steering` to set up project context

3. **Start Specification-Driven Development**
   ```
   /vybe:spec-init "Detailed description of your feature or project"
   ```

### Development Workflow

#### Phase 1: Specification Creation
1. **Initialize Spec**: `/vybe:spec-init [description]` - Creates initial specification
2. **Define Requirements**: `/vybe:spec-requirements [feature]` - Generate requirements document
3. **Create Design**: `/vybe:spec-design [feature]` - Design technical architecture
4. **Plan Tasks**: `/vybe:spec-tasks [feature]` - Break down into actionable tasks

#### Phase 2: Implementation
- Work through tasks systematically
- Update task status as you progress
- Use `/vybe:spec-status [feature]` to track completion

#### Phase 3: Maintenance
- Keep steering documents updated with `/vybe:steering`
- Review and update specifications as needed

### Available Commands

| Command | Description |
|---------|-------------|
| `/vybe:steering` | Create/update project steering documents |
| `/vybe:steering-custom` | Add custom steering for specific contexts |
| `/vybe:spec-init` | Initialize a new specification |
| `/vybe:spec-requirements` | Generate requirements document |
| `/vybe:spec-design` | Create technical design document |
| `/vybe:spec-tasks` | Generate task breakdown |
| `/vybe:spec-status` | Check specification progress |

### Project Structure

```
your-project/
├── .vybe/
│   ├── steering/          # Project-wide context and rules
│   │   ├── product.md     # Product vision and objectives
│   │   ├── tech.md        # Technology decisions
│   │   └── structure.md   # Code organization patterns
│   └── specs/             # Feature specifications
│       └── [feature-name]/
│           ├── requirements.md
│           ├── design.md
│           └── tasks.md
├── .claude/
│   └── commands/          # Vybe command implementations
└── CLAUDE.md              # AI assistant instructions
```

## Best Practices

1. **Start with Clear Requirements**: Don't skip the requirements phase
2. **Review at Each Gate**: Take time to review before approving each phase
3. **Keep Specs Updated**: Update specifications as the project evolves
4. **Use Steering Wisely**: Update steering documents after major architectural changes
5. **Track Progress**: Regularly check spec status to ensure alignment

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

This project is licensed under the MIT License.

## Acknowledgments

- [gotalab/claude-code-spec](https://github.com/gotalab/claude-code-spec) - Original framework
- Amazon's Working Backwards methodology for inspiration
- The Claude AI team for their excellent coding assistant

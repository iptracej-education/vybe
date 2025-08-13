# Claude Code Spec-Driven Development

Vybe-style Spec Driven Development implementation using claude code slash commands, hooks and agents.

## Project Context

### Paths
- Steering: `.vybe/steering/`
- Specs: `.vybe/specs/`
- Commands: `.claude/commands/`

### Steering vs Specification

**Steering** (`.vybe/steering/`) - Guide AI with project-wide rules and context  
**Specs** (`.vybe/specs/`) - Formalize development process for individual features

### Active Specifications
- Check `.vybe/specs/` for active specifications
- Use `/vybe:spec-status [feature-name]` to check progress

## Development Guidelines
- Think in English, generate responses in English

## Workflow

### Phase 0: Steering (Optional)
`/vybe:steering` - Create/update steering documents
`/vybe:steering-custom` - Create custom steering for specialized contexts

**Note**: Optional for new features or small additions. Can proceed directly to spec-init.

### Phase 1: Specification Creation
1. `/vybe:spec-init [detailed description]` - Initialize spec with detailed project description
2. `/vybe:spec-requirements [feature]` - Generate requirements document
3. `/vybe:spec-design [feature]` - Interactive: "Have you reviewed requirements.md? [y/N]"
4. `/vybe:spec-tasks [feature]` - Interactive: Confirms both requirements and design review

### Phase 2: Progress Tracking
`/vybe:spec-status [feature]` - Check current progress and phases

## Development Rules
1. **Consider steering**: Run `/vybe:steering` before major development (optional for new features)
2. **Follow 3-phase approval workflow**: Requirements → Design → Tasks → Implementation
3. **Approval required**: Each phase requires human review (interactive prompt or manual)
4. **No skipping phases**: Design requires approved requirements; Tasks require approved design
5. **Update task status**: Mark tasks as completed when working on them
6. **Keep steering current**: Run `/vybe:steering` after significant changes
7. **Check spec compliance**: Use `/vybe:spec-status` to verify alignment

## Steering Configuration

### Current Steering Files
Managed by `/vybe:steering` command. Updates here reflect command changes.

### Active Steering Files
- `product.md`: Always included - Product context and business objectives
- `tech.md`: Always included - Technology stack and architectural decisions
- `structure.md`: Always included - File organization and code patterns

### Custom Steering Files
<!-- Added by /kiro:steering-custom command -->
<!-- Format: 
- `filename.md`: Mode - Pattern(s) - Description
  Mode: Always|Conditional|Manual
  Pattern: File patterns for Conditional mode
-->

### Inclusion Modes
- **Always**: Loaded in every interaction (default)
- **Conditional**: Loaded for specific file patterns (e.g., `"*.test.js"`)
- **Manual**: Reference with `@filename.md` syntax
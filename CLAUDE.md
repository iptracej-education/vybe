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

### Phase 2: Implementation
- `/vybe:task-delegate [agent-type] [feature-task-range] [description]` - Delegate to subagents
- `/vybe:task-continue [agent-type] [feature-task] [session-id]` - Resume multi-session work
- `/vybe:task-status [feature-task-range]` - Check progress and dependencies

### Phase 3: Progress Tracking
`/vybe:spec-status [feature]` - Check current progress and phases

## Development Rules
1. **Consider steering**: Run `/vybe:steering` before major development (optional for new features)
2. **Follow 4-phase approval workflow**: Requirements → Design → Tasks → Delegation → Implementation
3. **Approval required**: Each phase requires human review (interactive prompt or manual)
4. **No skipping phases**: Design requires approved requirements; Tasks require approved design; Delegation follows task creation
5. **Use task delegation**: Delegate tasks to specialized subagents using `/vybe:task-delegate`
6. **Monitor dependencies**: Check task dependencies with `/vybe:task-status` before delegation
7. **Update task status**: Task status is automatically managed by the hook system
8. **Keep steering current**: Run `/vybe:steering` after significant changes
9. **Check spec compliance**: Use `/vybe:spec-status` to verify alignment

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

## Hook System
Automatic context management via `.claude/hooks/` - See `.claude/hooks/README.md` for details.
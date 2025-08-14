# Validate Hooks

Verify that the hook system is properly configured and functional. This command checks all aspects of the hook infrastructure and provides recommendations for fixing any issues.

## Usage

```
/vybe:validate-hooks [options]
```

## Options

- `--silent`: Return only exit code (0=ready, 1=partial, 2=failed)
- `--fallback`: Force fallback mode regardless of hook status
- `--status`: Quick status check without full validation

## Examples

```bash
# Full validation with detailed report
/vybe:validate-hooks

# Silent check for scripting
if /vybe:validate-hooks --silent; then
  echo "Hooks ready"
fi

# Quick status check
/vybe:validate-hooks --status

# Force fallback mode
/vybe:validate-hooks --fallback
```

## Validation Checks

### 1. File System Validation
- ✓ Hook files exist in `.claude/hooks/`
- ✓ Hook files have execute permissions
- ✓ Context directories are writable
- ✓ Required subdirectories exist

### 2. Dependencies Check
- ✓ Bash shell available
- ✓ Git installed and accessible
- ✓ jq available for JSON processing
- ✓ Required environment variables

### 3. Configuration Validation
- ✓ Claude Code settings include hooks
- ✓ Hook paths correctly configured
- ✓ Session tracking functional
- ✓ Context persistence working

### 4. Functional Tests
- ✓ Pre-hook can save context
- ✓ Post-hook can restore state
- ✓ Dependency tracker operational
- ✓ Session files created successfully

## Output Format

### Full Report
```
Hook System Validation Report
==============================

FILE SYSTEM CHECKS:
✓ pre-tool.sh exists and is executable
✓ post-tool.sh exists and is executable
✓ Context directory is writable
✓ All subdirectories present

DEPENDENCIES:
✓ bash: /bin/bash
✓ git: /usr/bin/git
✓ jq: /usr/bin/jq
✗ Claude Code settings not configured

CONFIGURATION:
⚠️ Hooks not in Claude Code settings
✓ Environment variables set
✓ Session tracking available
✓ Context persistence functional

FUNCTIONAL TESTS:
✓ Pre-hook execution successful
✓ Post-hook execution successful
✓ Dependency tracking works
✓ Session management operational

OVERALL STATUS: PARTIAL
Mode: Fallback Enabled
Context Management: Manual

RECOMMENDATIONS:
1. Add hooks to Claude Code settings:
   {
     "hooks": {
       "pre_tool": ".claude/hooks/pre-tool.sh",
       "post_tool": ".claude/hooks/post-tool.sh"
     }
   }

2. For full functionality, ensure Claude Code CLI is properly configured
```

### Quick Status
```
HOOK STATUS: PARTIAL (Fallback Available)
```

## Status Codes

### READY (0)
All checks passed, hooks fully functional

### PARTIAL (1)
Some issues detected but fallback mode available

### FAILED (2)
Critical issues prevent hook system operation

## Fallback Mode

When validation detects issues, fallback mode automatically:
- Uses git commits for state management
- Tracks context in files instead of hooks
- Provides manual session management
- Maintains basic functionality

### Enabling Fallback
```bash
# Automatic detection
/vybe:validate-hooks  # Detects and enables if needed

# Force fallback
export VYBE_MANUAL_HOOKS=1

# Check fallback status
echo $VYBE_MANUAL_HOOKS
```

## Integration with Other Commands

### Task Delegation
`/vybe:task-delegate` automatically runs validation and uses appropriate mode

### Task Continue
`/vybe:task-continue` checks session compatibility with current mode

### Spec Commands
All spec commands work with or without hooks

## Troubleshooting

### Common Issues

#### "Hooks not found"
```bash
# Check if hooks exist
ls -la .claude/hooks/

# Copy hooks from Vybe
cp -r /path/to/vybe/.claude/hooks .claude/
```

#### "Permission denied"
```bash
# Fix hook permissions
chmod +x .claude/hooks/*.sh
chmod +x .claude/hooks/context/*.sh
```

#### "jq not found"
```bash
# Install jq (macOS)
brew install jq

# Install jq (Ubuntu/Debian)
sudo apt-get install jq

# Install jq (other)
# Download from https://stedolan.github.io/jq/
```

#### "Context directory not writable"
```bash
# Fix directory permissions
chmod 755 .vybe/context
chmod 755 .vybe/context/*
```

### Debug Mode
```bash
# Enable debug output
export VYBE_DEBUG=1
/vybe:validate-hooks

# Test individual components
.claude/hooks/pre-tool.sh
echo "Exit code: $?"
```

## Performance Impact

- Validation takes <1 second typically
- Adds minimal overhead to commands
- Cached results for repeated checks
- No impact on non-hook workflows

## Security Considerations

- Validates file permissions
- Checks for execution safety
- No elevated privileges required
- Respects file system permissions

## Notes

- Validation results are cached for 5 minutes
- Fallback mode provides 80% of functionality
- Manual mode works without any configuration
- All task tracking maintained regardless of mode
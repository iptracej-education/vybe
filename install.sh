#!/bin/bash
# Vybe Framework Installation Script
# Automates complete setup for Claude Code integration

set -e

echo "🚀 Vybe Framework Installation"
echo "=============================="
echo ""

# Check if we're in the right directory
if [ ! -f "CLAUDE.md" ] || [ ! -d ".claude" ]; then
    echo "❌ Error: Run this script from the vybe framework directory"
    echo "   Expected files: CLAUDE.md, .claude/"
    echo ""
    echo "📋 Usage:"
    echo "   git clone https://github.com/iptracej-education/vybe.git"
    echo "   cd vybe"
    echo "   ./install.sh"
    exit 1
fi

# Detect installation type
PROJECT_DIR=$(pwd)
VYBE_DIR=$(basename "$PROJECT_DIR")

if [ "$VYBE_DIR" = "vybe" ]; then
    echo "📁 Installation type: Downloaded vybe framework"
    INSTALL_TYPE="framework"
else
    echo "📁 Installation type: Project with vybe framework"
    INSTALL_TYPE="project"
fi

echo ""

# Step 1: Copy framework files to project
echo "📦 Step 1: Installing Vybe Framework files"
echo "=========================================="

if [ "$INSTALL_TYPE" = "framework" ]; then
    # Check if user is in a project directory
    echo "⚠️  You're in the vybe framework directory itself."
    echo ""
    echo "🎯 To install in a new project:"
    echo "   mkdir my-project && cd my-project"
    echo "   git clone https://github.com/iptracej-education/vybe.git"
    echo "   cd vybe && ./install.sh"
    echo ""
    echo "🔄 To install in current directory anyway, type 'yes':"
    read -r response
    if [ "$response" != "yes" ]; then
        echo "❌ Installation cancelled"
        exit 1
    fi
fi

# Copy framework files to current directory
echo "📋 Copying Vybe framework files..."
cp -r .claude ../ 2>/dev/null || true
cp CLAUDE.md ../ 2>/dev/null || true

echo "✅ Framework files copied to project directory"
echo ""

# Step 2: Install hooks globally
echo "🔗 Step 2: Installing session continuity hooks"
echo "=============================================="

# Create global hooks directory
mkdir -p ~/.claude/.claude/hooks/
echo "📁 Created global hooks directory"

# Copy hooks
cp -r .claude/hooks/* ~/.claude/.claude/hooks/
echo "📋 Copied hook files"

# Make hooks executable
chmod +x ~/.claude/.claude/hooks/*.sh ~/.claude/.claude/hooks/*.py
echo "🔧 Made hooks executable"

# Check existing settings
SETTINGS_FILE="$HOME/.claude/settings.json"
BACKUP_FILE="$HOME/.claude/settings.json.backup.$(date +%Y%m%d_%H%M%S)"

echo ""
echo "⚙️  Step 3: Configuring Claude Code settings"
echo "==========================================="

if [ -f "$SETTINGS_FILE" ]; then
    echo "📄 Found existing settings.json"
    
    # Create backup
    cp "$SETTINGS_FILE" "$BACKUP_FILE"
    echo "💾 Backup created: $BACKUP_FILE"
    
    # Check if hooks section already exists
    if grep -q '"hooks"' "$SETTINGS_FILE"; then
        echo "⚠️  Hooks section already exists in settings.json"
        echo "🔍 Current hooks configuration:"
        grep -A 10 '"hooks"' "$SETTINGS_FILE" || true
        echo ""
        echo "❓ Do you want to update the hooks configuration? (y/N)"
        read -r update_hooks
        
        if [ "$update_hooks" = "y" ] || [ "$update_hooks" = "Y" ]; then
            # Create updated settings using Python for safe JSON manipulation
            python3 << 'EOF'
import json
import sys

try:
    with open("/home/iptracej/.claude/settings.json", "r") as f:
        settings = json.load(f)
    
    # Update hooks configuration
    settings["hooks"] = {
        "enabled": True,
        "preToolHook": "pre-tool.sh",
        "postToolHook": "post-tool.sh", 
        "preCompactHook": "precompact.py"
    }
    
    with open("/home/iptracej/.claude/settings.json", "w") as f:
        json.dump(settings, f, indent=2)
    
    print("✅ Hooks configuration updated successfully")
    
except Exception as e:
    print(f"❌ Error updating settings: {e}")
    print("   Manual configuration required")
    sys.exit(1)
EOF
        else
            echo "⏭️  Skipping hooks configuration update"
        fi
    else
        echo "➕ Adding hooks configuration to existing settings..."
        
        # Add hooks section using Python for safe JSON manipulation
        python3 << 'EOF'
import json
import sys

try:
    with open("/home/iptracej/.claude/settings.json", "r") as f:
        settings = json.load(f)
    
    # Add hooks configuration
    settings["hooks"] = {
        "enabled": True,
        "preToolHook": "pre-tool.sh",
        "postToolHook": "post-tool.sh",
        "preCompactHook": "precompact.py"
    }
    
    with open("/home/iptracej/.claude/settings.json", "w") as f:
        json.dump(settings, f, indent=2)
    
    print("✅ Hooks configuration added successfully")
    
except Exception as e:
    print(f"❌ Error updating settings: {e}")
    print("   Manual configuration required")
    sys.exit(1)
EOF
    fi
else
    echo "📝 Creating new settings.json with hooks configuration..."
    
    cat > "$SETTINGS_FILE" << 'EOF'
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "hooks": {
    "enabled": true,
    "preToolHook": "pre-tool.sh",
    "postToolHook": "post-tool.sh", 
    "preCompactHook": "precompact.py"
  }
}
EOF
    echo "✅ Created settings.json with hooks configuration"
fi

echo ""

# Step 4: Verify installation
echo "🔍 Step 4: Verifying installation" 
echo "================================="

# Check framework files
if [ -f "../CLAUDE.md" ] && [ -d "../.claude" ]; then
    echo "✅ Framework files installed"
else
    echo "❌ Framework files missing"
fi

# Check hooks
if [ -f ~/.claude/.claude/hooks/precompact.py ] && [ -x ~/.claude/.claude/hooks/precompact.py ]; then
    echo "✅ Hooks installed and executable"
else
    echo "❌ Hooks installation failed"
fi

# Check settings
if grep -q '"hooks"' "$SETTINGS_FILE" 2>/dev/null; then
    echo "✅ Settings.json configured"
else
    echo "❌ Settings.json not configured"
fi

echo ""

# Step 5: Completion and next steps
echo "🎉 Installation Complete!"
echo "========================"
echo ""

if [ "$INSTALL_TYPE" = "framework" ]; then
    echo "📁 Framework installed in: $(dirname "$PROJECT_DIR")"
    echo ""
    echo "🎯 Next steps:"
    echo "   cd .."
    echo "   /vybe:init \"Your project description\""
else
    echo "📁 Framework installed in current project"
    echo ""
    echo "🎯 Next steps:"
    echo "   /vybe:init \"Your project description\""
fi

echo ""
echo "🔄 Session Continuity Features:"
echo "   ✅ Context preserved during conversation compaction"
echo "   ✅ Seamless session handoff between Claude Code restarts"
echo "   ✅ Multi-member coordination for team projects"
echo ""

echo "📚 For detailed usage, see:"
echo "   - README.md for quick reference"
echo "   - docs/HANDS_ON_TUTORIAL.md for complete walkthrough"
echo ""

echo "⚠️  IMPORTANT: Restart Claude Code for hooks to take effect"
echo ""

# Clean up if installing from framework directory
if [ "$INSTALL_TYPE" = "framework" ]; then
    echo "🧹 Cleanup options:"
    echo "   To remove vybe framework directory: rm -rf $(pwd)"
    echo "   To keep for future projects: leave as-is"
fi

echo ""
echo "✨ Happy coding with Vybe Framework!"
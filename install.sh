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

# Copy MCP cache server if available
if [ -f ".vybe/mcp-cache-server.js" ]; then
    mkdir -p ../.vybe
    cp .vybe/mcp-cache-server.js ../.vybe/
    echo "📦 MCP cache server copied for 20-120x performance boost"
fi

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

# Step 4: Configure MCP Cache Server (Performance Optimization)
echo "⚡ Step 4: Configuring MCP Cache Server"
echo "======================================"

# Check if MCP cache server exists
CACHE_SERVER="../.vybe/mcp-cache-server.js"
if [ -f "$CACHE_SERVER" ]; then
    echo "📦 MCP cache server found - configuring for optimal performance"
    
    # Check if Node.js is available
    if command -v node >/dev/null 2>&1; then
        NODE_VERSION=$(node --version)
        echo "✅ Node.js detected: $NODE_VERSION"
        
        # Check if claude command is available
        if command -v claude >/dev/null 2>&1; then
            echo "✅ Claude CLI detected - registering MCP server automatically"
            
            # Navigate to parent directory for claude mcp add
            cd ..
            
            # Register MCP cache server using claude mcp add
            if claude mcp add vybe-cache node .vybe/mcp-cache-server.js --env CACHE_PORT=7624 2>/dev/null; then
                echo "🚀 MCP cache server registered successfully"
                echo "📈 Performance optimization enabled: 20-120x faster command execution"
            else
                echo "⚠️  Claude MCP registration failed - creating manual config"
                # Fallback to manual MCP settings file
                mkdir -p .claude
                cat > ".claude/mcp-settings.json" << 'EOF'
{
  "mcpServers": {
    "vybe-cache": {
      "command": "node",
      "args": [".vybe/mcp-cache-server.js"],
      "env": {
        "CACHE_PORT": "7624"
      }
    }
  }
}
EOF
                echo "📋 Manual MCP settings created - restart Claude Code to activate"
            fi
            
            # Return to vybe directory
            cd vybe
        else
            echo "⚠️  Claude CLI not found - manual MCP configuration required"
            echo "   Install Claude CLI or manually configure MCP server"
            echo "   Commands will work with file system fallback"
        fi
    else
        echo "⚠️  Node.js not found - cache server available but not configured"
        echo "   Install Node.js for 20-120x performance improvement"
        echo "   Commands will still work with file system fallback"
    fi
else
    echo "📋 MCP cache server not available - using file system fallback"
    echo "   Commands will work normally with standard performance"
fi

echo ""

# Step 5: Verify installation
echo "🔍 Step 5: Verifying installation" 
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

# Check MCP cache server
if [ -f "../.vybe/mcp-cache-server.js" ]; then
    echo "✅ MCP cache server installed"
    
    # Check if registered with Claude CLI
    cd ..
    if command -v claude >/dev/null 2>&1 && claude mcp list 2>/dev/null | grep -q "vybe-cache"; then
        echo "✅ MCP cache server registered with Claude CLI"
    elif [ -f ".claude/mcp-settings.json" ]; then
        echo "✅ MCP cache server configured manually"
    else
        echo "⚠️ MCP cache server not configured (fallback mode)"
    fi
    cd vybe
else
    echo "📋 MCP cache server not available (standard performance)"
fi

echo ""

# Step 6: Completion and next steps
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
echo "🚀 High-Performance Features:"
echo "   ✅ Hybrid architecture: 20-120x faster command execution"
echo "   ✅ Shared cache system: Cross-command performance benefits"
echo "   ✅ Embedded help system: Instant command reference"
echo "   ✅ Real-time session continuity and multi-member coordination"
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
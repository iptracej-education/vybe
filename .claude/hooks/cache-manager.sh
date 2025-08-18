#!/bin/bash
# Vybe Cache Manager - Store computed values for quick lookup
# This eliminates redundant detection operations

set -e

VYBE_ROOT=".vybe"
CACHE_DIR="$VYBE_ROOT/project/.detected"
QUICK_LOOKUP="$VYBE_ROOT/project/.lookup"

# Ensure directories exist
mkdir -p "$CACHE_DIR"
mkdir -p "$QUICK_LOOKUP"

# Function to detect and store project language
detect_language() {
    if [ -f "$CACHE_DIR/language" ]; then
        cat "$CACHE_DIR/language"
        return
    fi
    
    # Detect primary language once
    local lang="unknown"
    if [ -f "package.json" ]; then
        lang="javascript"
    elif [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
        lang="python"
    elif [ -f "go.mod" ]; then
        lang="go"
    elif [ -f "Cargo.toml" ]; then
        lang="rust"
    elif [ -f "pom.xml" ]; then
        lang="java"
    elif [ -f "Gemfile" ]; then
        lang="ruby"
    fi
    
    echo "$lang" > "$CACHE_DIR/language"
    echo "$lang"
}

# Function to detect and store package manager
detect_package_manager() {
    if [ -f "$CACHE_DIR/package-manager" ]; then
        cat "$CACHE_DIR/package-manager"
        return
    fi
    
    local pm="none"
    if [ -f "package-lock.json" ]; then
        pm="npm"
    elif [ -f "yarn.lock" ]; then
        pm="yarn"
    elif [ -f "pnpm-lock.yaml" ]; then
        pm="pnpm"
    elif [ -f "requirements.txt" ]; then
        pm="pip"
    elif [ -f "Pipfile" ]; then
        pm="pipenv"
    elif [ -f "poetry.lock" ]; then
        pm="poetry"
    elif [ -f "go.mod" ]; then
        pm="go"
    elif [ -f "Cargo.toml" ]; then
        pm="cargo"
    fi
    
    echo "$pm" > "$CACHE_DIR/package-manager"
    echo "$pm"
}

# Function to detect and store test framework
detect_test_framework() {
    if [ -f "$CACHE_DIR/test-framework" ]; then
        cat "$CACHE_DIR/test-framework"
        return
    fi
    
    local tf="none"
    if [ -f "package.json" ] && grep -q "jest" package.json 2>/dev/null; then
        tf="jest"
    elif [ -f "package.json" ] && grep -q "mocha" package.json 2>/dev/null; then
        tf="mocha"
    elif [ -f "package.json" ] && grep -q "vitest" package.json 2>/dev/null; then
        tf="vitest"
    elif [ -d "tests" ] && [ -f "requirements.txt" ]; then
        tf="pytest"
    elif [ -d "spec" ]; then
        tf="rspec"
    fi
    
    echo "$tf" > "$CACHE_DIR/test-framework"
    echo "$tf"
}

# Function to store member configuration
store_member_config() {
    if [ -f ".vybe/backlog.md" ] && grep -m 1 -q "^## Members:" .vybe/backlog.md; then
        local member_count=$(grep -m 1 "^## Members:" .vybe/backlog.md | grep -o "[0-9]*" || echo "0")
        echo "$member_count" > "$QUICK_LOOKUP/member-count"
        
        # Store member assignments
        grep "^### dev-" .vybe/backlog.md > "$QUICK_LOOKUP/member-assignments" 2>/dev/null || true
    else
        echo "0" > "$QUICK_LOOKUP/member-count"
    fi
}

# Function to build quick lookup index
build_lookup_index() {
    # Index of features for quick access
    if [ -d ".vybe/features" ]; then
        ls -1 .vybe/features/ > "$QUICK_LOOKUP/feature-list" 2>/dev/null || true
    fi
    
    # Current stage from backlog
    if [ -f ".vybe/backlog.md" ]; then
        grep -m 1 "IN PROGRESS" .vybe/backlog.md | sed 's/.*Stage \([0-9]*\).*/\1/' > "$QUICK_LOOKUP/current-stage" 2>/dev/null || echo "1" > "$QUICK_LOOKUP/current-stage"
    fi
    
    # Store project name
    if [ -f ".vybe/project/overview.md" ]; then
        grep -m 1 "^# " .vybe/project/overview.md | sed 's/^# //' > "$QUICK_LOOKUP/project-name" 2>/dev/null || true
    fi
}

# Function to get cached value or compute
get_or_compute() {
    local cache_file="$1"
    local compute_function="$2"
    
    if [ -f "$cache_file" ]; then
        cat "$cache_file"
    else
        $compute_function
    fi
}

# Main execution based on arguments
case "${1:-help}" in
    init)
        echo "[CACHE] Initializing cache system..."
        detect_language
        detect_package_manager
        detect_test_framework
        store_member_config
        build_lookup_index
        echo "[CACHE] Cache initialized successfully"
        ;;
    
    language)
        detect_language
        ;;
    
    package-manager)
        detect_package_manager
        ;;
    
    test-framework)
        detect_test_framework
        ;;
    
    members)
        store_member_config
        cat "$QUICK_LOOKUP/member-count"
        ;;
    
    refresh)
        echo "[CACHE] Refreshing all caches..."
        rm -rf "$CACHE_DIR" "$QUICK_LOOKUP"
        mkdir -p "$CACHE_DIR" "$QUICK_LOOKUP"
        detect_language
        detect_package_manager
        detect_test_framework
        store_member_config
        build_lookup_index
        echo "[CACHE] Cache refreshed"
        ;;
    
    clear)
        echo "[CACHE] Clearing all caches..."
        rm -rf "$CACHE_DIR" "$QUICK_LOOKUP"
        echo "[CACHE] Cache cleared"
        ;;
    
    *)
        echo "Vybe Cache Manager"
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  init           - Initialize cache system"
        echo "  language       - Get/detect project language"
        echo "  package-manager - Get/detect package manager"
        echo "  test-framework - Get/detect test framework"
        echo "  members        - Get/store member configuration"
        echo "  refresh        - Refresh all caches"
        echo "  clear          - Clear all caches"
        ;;
esac
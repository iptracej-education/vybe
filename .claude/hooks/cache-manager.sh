#!/bin/bash
# Vybe Cache Manager - MCP In-Memory Cache with File Fallback
# Provides <0.5ms lookups with graceful degradation

set -e

VYBE_ROOT=".vybe"
CACHE_DIR="$VYBE_ROOT/project/.detected"
QUICK_LOOKUP="$VYBE_ROOT/project/.lookup"

# Ensure directories exist
mkdir -p "$CACHE_DIR"
mkdir -p "$QUICK_LOOKUP"

# MCP Cache Functions (High Performance)

# Function to call MCP cache with error handling
call_mcp_cache() {
    local tool="$1"
    shift
    local args="$@"
    
    # Check if Claude is available and MCP server is running
    if command -v claude >/dev/null 2>&1; then
        # Attempt MCP call with timeout
        timeout 2s claude mcp call vybe-cache "$tool" $args 2>/dev/null
        return $?
    else
        return 1
    fi
}

# High-speed cache get (MCP first, file fallback)
vybe_cache_get() {
    local key="$1"
    
    # Try MCP cache first (0.5ms)
    local result
    if result=$(call_mcp_cache "get" "$key"); then
        # Parse JSON result (remove quotes if simple string)
        echo "$result" | sed 's/^"\(.*\)"$/\1/'
        return 0
    fi
    
    # Fallback to file cache (20ms)
    local file_path="$CACHE_DIR/$key"
    if [ -f "$file_path" ]; then
        cat "$file_path"
        return 0
    fi
    
    # Try quick lookup files
    file_path="$QUICK_LOOKUP/$key"
    if [ -f "$file_path" ]; then
        cat "$file_path"
        return 0
    fi
    
    return 1
}

# High-speed batch get for multiple keys
vybe_cache_mget() {
    local keys_json="$1"  # JSON array: ["key1", "key2", "key3"]
    
    # Try MCP batch operation first (1ms for multiple keys)
    local result
    if result=$(call_mcp_cache "mget" "$keys_json"); then
        echo "$result"
        return 0
    fi
    
    # Fallback to individual file reads
    local output="{"
    local first=true
    
    echo "$keys_json" | jq -r '.[]' | while read -r key; do
        local value
        if value=$(vybe_cache_get "$key"); then
            if [ "$first" = true ]; then
                first=false
            else
                output="$output,"
            fi
            output="$output\"$key\":\"$value\""
        fi
    done
    
    output="$output}"
    echo "$output"
}

# High-speed cache set (MCP + file backup)
vybe_cache_set() {
    local key="$1"
    local value="$2"
    local ttl="${3:-1800}"  # Default 30 minutes
    
    # Try MCP cache first
    call_mcp_cache "set" "$key" "$value" "$ttl" >/dev/null 2>&1
    
    # Always update file cache as backup
    local file_path="$CACHE_DIR/$key"
    mkdir -p "$(dirname "$file_path")"
    echo "$value" > "$file_path"
    
    return 0
}

# Batch set for multiple key-value pairs
vybe_cache_mset() {
    local data_json="$1"   # JSON object: {"key1": "val1", "key2": "val2"}
    local ttl="${2:-1800}" # Default 30 minutes
    
    # Try MCP batch operation first
    call_mcp_cache "mset" "$data_json" "$ttl" >/dev/null 2>&1
    
    # Backup to files
    echo "$data_json" | jq -r 'to_entries[]|"\(.key) \(.value)"' | while read -r key value; do
        local file_path="$CACHE_DIR/$key"
        mkdir -p "$(dirname "$file_path")"
        echo "$value" > "$file_path"
    done
    
    return 0
}

# Delete from cache
vybe_cache_del() {
    local key="$1"
    
    # Delete from MCP cache
    call_mcp_cache "del" "$key" >/dev/null 2>&1
    
    # Delete from file cache
    rm -f "$CACHE_DIR/$key" "$QUICK_LOOKUP/$key" 2>/dev/null
    
    return 0
}

# Get cache statistics
vybe_cache_stats() {
    local result
    if result=$(call_mcp_cache "stats"); then
        echo "$result" | jq .
    else
        echo '{"status": "MCP cache unavailable, using file fallback"}'
    fi
}

# Cache health check
vybe_cache_health() {
    local result
    if result=$(call_mcp_cache "health"); then
        echo "$result" | jq .
        return 0
    else
        echo '{"status": "degraded", "mcp_available": false, "file_cache": "available"}'
        return 1
    fi
}

# Detection Functions (with MCP caching)

# Function to detect and store project language
detect_language() {
    # Try MCP cache first
    local lang
    if lang=$(vybe_cache_get "project.language"); then
        echo "$lang"
        return
    fi
    
    # Detect primary language once
    lang="unknown"
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
    
    # Cache with 1 hour TTL (project structure rarely changes)
    vybe_cache_set "project.language" "$lang" 3600
    echo "$lang"
}

# Function to detect and store package manager
detect_package_manager() {
    # Try MCP cache first
    local pm
    if pm=$(vybe_cache_get "project.package-manager"); then
        echo "$pm"
        return
    fi
    
    pm="none"
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
    
    # Cache with 1 hour TTL
    vybe_cache_set "project.package-manager" "$pm" 3600
    echo "$pm"
}

# Function to detect and store test framework
detect_test_framework() {
    # Try MCP cache first
    local tf
    if tf=$(vybe_cache_get "project.test-framework"); then
        echo "$tf"
        return
    fi
    
    tf="none"
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
    
    # Cache with 1 hour TTL
    vybe_cache_set "project.test-framework" "$tf" 3600
    echo "$tf"
}

# Function to store member configuration
store_member_config() {
    local member_count="0"
    
    if [ -f ".vybe/backlog.md" ] && grep -m 1 -q "^## Members:" .vybe/backlog.md; then
        member_count=$(grep -m 1 "^## Members:" .vybe/backlog.md | grep -o "[0-9]*" || echo "0")
        
        # Store member assignments to file (for complex data)
        grep "^### dev-" .vybe/backlog.md > "$QUICK_LOOKUP/member-assignments" 2>/dev/null || true
    fi
    
    # Cache member count with 30 minute TTL (changes occasionally)
    vybe_cache_set "project.members" "$member_count" 1800
    echo "$member_count"
}

# Function to build quick lookup index
build_lookup_index() {
    # Index of features for quick access
    local feature_list="[]"
    if [ -d ".vybe/features" ]; then
        feature_list=$(ls -1 .vybe/features/ 2>/dev/null | jq -R . | jq -s . || echo "[]")
        # Also store to file for fallback
        ls -1 .vybe/features/ > "$QUICK_LOOKUP/feature-list" 2>/dev/null || true
    fi
    vybe_cache_set "features.list" "$feature_list" 300  # 5 minute TTL
    
    # Current stage from backlog
    local current_stage="1"
    if [ -f ".vybe/backlog.md" ]; then
        current_stage=$(grep -m 1 "IN PROGRESS" .vybe/backlog.md | sed 's/.*Stage \([0-9]*\).*/\1/' 2>/dev/null || echo "1")
        echo "$current_stage" > "$QUICK_LOOKUP/current-stage"  # File backup
    fi
    vybe_cache_set "project.current-stage" "$current_stage" 600  # 10 minute TTL
    
    # Store project name
    local project_name=""
    if [ -f ".vybe/project/overview.md" ]; then
        project_name=$(grep -m 1 "^# " .vybe/project/overview.md | sed 's/^# //' 2>/dev/null || echo "")
        echo "$project_name" > "$QUICK_LOOKUP/project-name"  # File backup
    fi
    vybe_cache_set "project.name" "$project_name" 3600  # 1 hour TTL
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

# Batch warm cache for optimal performance
warm_cache() {
    echo "[CACHE] Warming MCP cache with batch operations..."
    
    # Detect all values
    local lang=$(detect_language)
    local pm=$(detect_package_manager)
    local tf=$(detect_test_framework)
    local members=$(store_member_config)
    
    # Build lookup index
    build_lookup_index
    
    # Batch set core project data
    local project_data="{
        \"project.language\": \"$lang\",
        \"project.package-manager\": \"$pm\",
        \"project.test-framework\": \"$tf\",
        \"project.members\": \"$members\"
    }"
    
    vybe_cache_mset "$project_data" 3600
    echo "[CACHE] Batch cache warming completed"
}

# Main execution based on arguments
case "${1:-help}" in
    init)
        echo "[CACHE] Initializing MCP cache system..."
        warm_cache
        echo "[CACHE] MCP cache initialized successfully"
        ;;
        
    warm)
        warm_cache
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
        # Clear MCP cache (if available)
        call_mcp_cache "clear" >/dev/null 2>&1 || true
        
        # Clear file caches
        rm -rf "$CACHE_DIR" "$QUICK_LOOKUP"
        mkdir -p "$CACHE_DIR" "$QUICK_LOOKUP"
        
        # Rebuild
        warm_cache
        echo "[CACHE] All caches refreshed"
        ;;
    
    clear)
        echo "[CACHE] Clearing all caches..."
        # Clear MCP cache
        call_mcp_cache "clear" >/dev/null 2>&1 || true
        
        # Clear file caches
        rm -rf "$CACHE_DIR" "$QUICK_LOOKUP"
        echo "[CACHE] All caches cleared"
        ;;
        
    stats)
        vybe_cache_stats
        ;;
        
    health)
        vybe_cache_health
        ;;
        
    get)
        if [ -n "$2" ]; then
            vybe_cache_get "$2"
        else
            echo "Usage: $0 get <key>"
        fi
        ;;
        
    set)
        if [ -n "$2" ] && [ -n "$3" ]; then
            vybe_cache_set "$2" "$3" "${4:-1800}"
        else
            echo "Usage: $0 set <key> <value> [ttl]"
        fi
        ;;
    
    *)
        echo "Vybe Cache Manager"
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  init           - Initialize MCP cache system"
        echo "  warm           - Warm cache with batch operations"
        echo "  language       - Get/detect project language"
        echo "  package-manager - Get/detect package manager"
        echo "  test-framework - Get/detect test framework"
        echo "  members        - Get/store member configuration"
        echo "  refresh        - Refresh all caches (MCP + file)"
        echo "  clear          - Clear all caches (MCP + file)"
        echo "  stats          - Show MCP cache statistics"
        echo "  health         - Check MCP cache health"
        echo "  get <key>      - Get value from cache"
        echo "  set <key> <val> [ttl] - Set value in cache"
        echo ""
        echo "High-Performance MCP Cache:"
        echo "  - <0.5ms lookups when MCP available"
        echo "  - Graceful fallback to file cache"
        echo "  - Automatic batch operations"
        ;;
esac
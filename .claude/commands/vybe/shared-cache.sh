#!/bin/bash

# =============================================================================
# VYBE SHARED PROJECT CACHE SYSTEM
# High-performance shared cache with file system fallback
# Used by ALL Vybe commands for consistent performance
# =============================================================================

# Cache configuration
VYBE_CACHE_SERVER="http://127.0.0.1:7624"
VYBE_CACHE_VERSION="v2"
VYBE_PROJECT_HASH=""
VYBE_CACHE_AVAILABLE=false
VYBE_FILE_CACHE_DIR=".vybe/.cache"

# Initialize cache system
init_vybe_cache() {
    # Generate project-specific hash
    VYBE_PROJECT_HASH=$(pwd | md5sum | cut -d" " -f1)
    
    # Initialize project cache keys now that hash is available
    PROJECT_OVERVIEW_KEY=$(get_cache_key "overview")
    PROJECT_ARCHITECTURE_KEY=$(get_cache_key "architecture")
    PROJECT_CONVENTIONS_KEY=$(get_cache_key "conventions")
    PROJECT_OUTCOMES_KEY=$(get_cache_key "outcomes")
    PROJECT_BACKLOG_KEY=$(get_cache_key "backlog")
    PROJECT_FEATURES_KEY=$(get_cache_key "features")
    PROJECT_MEMBERS_KEY=$(get_cache_key "members")
    PROJECT_MOD_TIME_KEY=$(get_cache_key "mod_time")
    
    # Test MCP cache server availability
    if curl -s -f "$VYBE_CACHE_SERVER/health" > /dev/null 2>&1; then
        VYBE_CACHE_AVAILABLE=true
        echo "[CACHE] MCP cache server available"
    else
        VYBE_CACHE_AVAILABLE=false
        echo "[CACHE] MCP cache not available - using file system cache"
    fi
    
    # Ensure file system cache directory exists
    mkdir -p "$VYBE_FILE_CACHE_DIR"
}

# =============================================================================
# SHARED PROJECT DATA CACHE KEYS
# =============================================================================

get_cache_key() {
    local key_name="$1"
    echo "project.${VYBE_CACHE_VERSION}.${VYBE_PROJECT_HASH}.${key_name}"
}

# Standard project cache keys (initialized after hash generation)
PROJECT_OVERVIEW_KEY=""
PROJECT_ARCHITECTURE_KEY=""
PROJECT_CONVENTIONS_KEY=""
PROJECT_OUTCOMES_KEY=""
PROJECT_BACKLOG_KEY=""
PROJECT_FEATURES_KEY=""
PROJECT_MEMBERS_KEY=""
PROJECT_MOD_TIME_KEY=""

# =============================================================================
# CACHE OPERATIONS WITH FALLBACK
# =============================================================================

# Get value with fallback
cache_get() {
    local key="$1"
    local fallback_file="$VYBE_FILE_CACHE_DIR/${key//./}_cache.json"
    
    # Try MCP cache first
    if [ "$VYBE_CACHE_AVAILABLE" = true ]; then
        local result=$(curl -s "http://127.0.0.1:7624/cache/get?key=$key" 2>/dev/null)
        if [ -n "$result" ] && [ "$result" != '{"value":null}' ]; then
            echo "$result" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    value = data.get('value', '')
    if value:
        print(value)
        sys.exit(0)
except:
    pass
sys.exit(1)
" 2>/dev/null && return 0
        fi
    fi
    
    # Fallback to file system cache
    if [ -f "$fallback_file" ]; then
        local file_value=$(cat "$fallback_file" 2>/dev/null | python3 -c "
import sys, json, time
try:
    data = json.load(sys.stdin)
    # Check if not expired (24 hour TTL for file cache)
    if time.time() - data.get('timestamp', 0) < 86400:
        print(data.get('value', ''))
        sys.exit(0)
except:
    pass
sys.exit(1)
" 2>/dev/null)
        
        if [ -n "$file_value" ]; then
            echo "$file_value"
            return 0
        fi
    fi
    
    return 1
}

# Set value with fallback  
cache_set() {
    local key="$1"
    local value="$2"
    local ttl="${3:-3600}"
    local fallback_file="$VYBE_FILE_CACHE_DIR/${key//./}_cache.json"
    
    # Try MCP cache first
    if [ "$VYBE_CACHE_AVAILABLE" = true ]; then
        curl -s -X POST "$VYBE_CACHE_SERVER/cache/set" \
            -H "Content-Type: application/json" \
            -d "{\"key\": \"$key\", \"value\": $(echo "$value" | python3 -c "import json,sys; print(json.dumps(sys.stdin.read().strip()))"), \"ttl\": $ttl}" \
            > /dev/null 2>&1
    fi
    
    # Always save to file system fallback
    python3 -c "
import json, time
data = {
    'value': '''$value''',
    'timestamp': time.time(),
    'ttl': $ttl,
    'key': '$key'
}
with open('$fallback_file', 'w') as f:
    json.dump(data, f)
" 2>/dev/null
}

# Bulk get multiple values
cache_mget() {
    local keys=("$@")
    local results=()
    local missing_keys=()
    
    # Try MCP bulk get first if available
    if [ "$VYBE_CACHE_AVAILABLE" = true ] && [ ${#keys[@]} -gt 0 ]; then
        local keys_json=$(printf '"%s",' "${keys[@]}" | sed 's/,$//')
        local bulk_result=$(curl -s -X POST "$VYBE_CACHE_SERVER/cache/mget" \
            -H "Content-Type: application/json" \
            -d "{\"keys\": [$keys_json]}" 2>/dev/null)
        
        if [ -n "$bulk_result" ]; then
            for key in "${keys[@]}"; do
                local value=$(echo "$bulk_result" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    value = data.get('$key', {}).get('value', '')
    if value:
        print(value)
    else:
        sys.exit(1)
except:
    sys.exit(1)
" 2>/dev/null)
                
                if [ $? -eq 0 ]; then
                    results+=("$key:$value")
                else
                    missing_keys+=("$key")
                fi
            done
        else
            missing_keys=("${keys[@]}")
        fi
    else
        missing_keys=("${keys[@]}")
    fi
    
    # Get missing keys from file system cache
    for key in "${missing_keys[@]}"; do
        local value=$(cache_get "$key")
        if [ $? -eq 0 ]; then
            results+=("$key:$value")
        fi
    done
    
    # Output results
    for result in "${results[@]}"; do
        echo "$result"
    done
}

# Bulk set multiple values
cache_mset() {
    local pairs=("$@")
    
    # Try MCP bulk set if available
    if [ "$VYBE_CACHE_AVAILABLE" = true ] && [ ${#pairs[@]} -gt 0 ]; then
        local data_json="{"
        local first=true
        
        for pair in "${pairs[@]}"; do
            local key=$(echo "$pair" | cut -d: -f1)
            local value=$(echo "$pair" | cut -d: -f2-)
            
            if [ "$first" = true ]; then
                first=false
            else
                data_json="$data_json,"
            fi
            
            data_json="$data_json\"$key\": {\"value\": $(echo "$value" | python3 -c "import json,sys; print(json.dumps(sys.stdin.read().strip()))"), \"ttl\": 3600}"
        done
        
        data_json="$data_json}"
        
        curl -s -X POST "$VYBE_CACHE_SERVER/cache/mset" \
            -H "Content-Type: application/json" \
            -d "$data_json" > /dev/null 2>&1
    fi
    
    # Always save to file system fallback
    for pair in "${pairs[@]}"; do
        local key=$(echo "$pair" | cut -d: -f1)
        local value=$(echo "$pair" | cut -d: -f2-)
        cache_set "$key" "$value"
    done
}

# =============================================================================
# PROJECT DATA LOADING WITH SHARED CACHE
# =============================================================================

# Check if project cache is valid
is_project_cache_valid() {
    if [ ! -d ".vybe" ]; then
        return 1
    fi
    
    # Get current project modification time
    local current_mod_time=$(find .vybe -type f -name "*.md" -exec stat -c %Y {} \; 2>/dev/null | sort -n | tail -1)
    
    # Get cached modification time
    local cached_mod_time=$(cache_get "$PROJECT_MOD_TIME_KEY" 2>/dev/null)
    
    if [ "$current_mod_time" = "$cached_mod_time" ]; then
        return 0
    else
        return 1
    fi
}

# Bulk load all project data
load_project_data() {
    local cache_mode="unknown"
    
    echo "[PROJECT-CACHE] Loading project data..."
    
    # Check cache validity
    if is_project_cache_valid; then
        echo "[PROJECT-CACHE] Using cached project data"
        cache_mode="cached"
        
        # Load from cache using individual get calls (more reliable)
        PROJECT_OVERVIEW=$(cache_get "$PROJECT_OVERVIEW_KEY")
        PROJECT_ARCHITECTURE=$(cache_get "$PROJECT_ARCHITECTURE_KEY")
        PROJECT_CONVENTIONS=$(cache_get "$PROJECT_CONVENTIONS_KEY")
        PROJECT_OUTCOMES=$(cache_get "$PROJECT_OUTCOMES_KEY")
        PROJECT_BACKLOG=$(cache_get "$PROJECT_BACKLOG_KEY")
        PROJECT_FEATURES=$(cache_get "$PROJECT_FEATURES_KEY")
        PROJECT_MEMBERS=$(cache_get "$PROJECT_MEMBERS_KEY")
        
        # Export cached variables for use in calling scripts
        export PROJECT_OVERVIEW PROJECT_ARCHITECTURE PROJECT_CONVENTIONS
        export PROJECT_OUTCOMES PROJECT_BACKLOG PROJECT_FEATURES PROJECT_MEMBERS
        
    else
        echo "[PROJECT-CACHE] Cache invalid - performing bulk file scan"
        cache_mode="bulk_scan"
        
        # Get current modification time
        local current_mod_time=$(find .vybe -type f -name "*.md" -exec stat -c %Y {} \; 2>/dev/null | sort -n | tail -1)
        
        # BULK LOAD: Read all project files at once
        PROJECT_OVERVIEW=""
        PROJECT_ARCHITECTURE=""  
        PROJECT_CONVENTIONS=""
        PROJECT_OUTCOMES=""
        PROJECT_BACKLOG=""
        PROJECT_FEATURES=""
        PROJECT_MEMBERS=""
        
        # Load foundation documents
        if [ -f ".vybe/project/overview.md" ]; then
            PROJECT_OVERVIEW=$(cat .vybe/project/overview.md)
        fi
        
        if [ -f ".vybe/project/architecture.md" ]; then
            PROJECT_ARCHITECTURE=$(cat .vybe/project/architecture.md)
        fi
        
        if [ -f ".vybe/project/conventions.md" ]; then
            PROJECT_CONVENTIONS=$(cat .vybe/project/conventions.md)
        fi
        
        if [ -f ".vybe/project/outcomes.md" ]; then
            PROJECT_OUTCOMES=$(cat .vybe/project/outcomes.md)
        fi
        
        # Load backlog
        if [ -f ".vybe/backlog.md" ]; then
            PROJECT_BACKLOG=$(cat .vybe/backlog.md)
        fi
        
        # Load and parse features
        if [ -d ".vybe/features" ]; then
            PROJECT_FEATURES=$(find .vybe/features -name "*.md" -exec cat {} \; 2>/dev/null | head -1000)
        fi
        
        # Extract members info from backlog
        if [ -n "$PROJECT_BACKLOG" ]; then
            PROJECT_MEMBERS=$(echo "$PROJECT_BACKLOG" | grep -A 20 "^## Members:" || echo "")
        fi
        
        # INDIVIDUAL CACHE: Save all data using individual cache_set calls (more reliable)
        cache_set "$PROJECT_OVERVIEW_KEY" "$PROJECT_OVERVIEW" 3600
        cache_set "$PROJECT_ARCHITECTURE_KEY" "$PROJECT_ARCHITECTURE" 3600
        cache_set "$PROJECT_CONVENTIONS_KEY" "$PROJECT_CONVENTIONS" 3600
        cache_set "$PROJECT_OUTCOMES_KEY" "$PROJECT_OUTCOMES" 3600
        cache_set "$PROJECT_BACKLOG_KEY" "$PROJECT_BACKLOG" 3600
        cache_set "$PROJECT_FEATURES_KEY" "$PROJECT_FEATURES" 3600
        cache_set "$PROJECT_MEMBERS_KEY" "$PROJECT_MEMBERS" 3600
        cache_set "$PROJECT_MOD_TIME_KEY" "$current_mod_time" 3600
        echo "[PROJECT-CACHE] Project data cached for future use"
    fi
    
    # Set global cache mode for reporting
    PROJECT_CACHE_MODE="$cache_mode"
    
    # Export variables for use in calling scripts
    export PROJECT_OVERVIEW PROJECT_ARCHITECTURE PROJECT_CONVENTIONS
    export PROJECT_OUTCOMES PROJECT_BACKLOG PROJECT_FEATURES PROJECT_MEMBERS
    export PROJECT_CACHE_MODE
    
    echo "[PROJECT-CACHE] Project data loaded successfully (mode: $cache_mode)"
}

# =============================================================================
# ATOMIC FILE + CACHE UPDATES
# =============================================================================

# Update file and cache atomically
update_file_and_cache() {
    local file_path="$1"
    local new_content="$2"
    local cache_key="$3"
    
    # Create backup
    if [ -f "$file_path" ]; then
        cp "$file_path" "${file_path}.backup"
    fi
    
    # Write to file
    echo "$new_content" > "$file_path"
    
    if [ $? -eq 0 ]; then
        # Update cache
        cache_set "$cache_key" "$new_content"
        
        # Update modification time cache  
        local new_mod_time=$(find .vybe -type f -name "*.md" -exec stat -c %Y {} \; 2>/dev/null | sort -n | tail -1)
        cache_set "$PROJECT_MOD_TIME_KEY" "$new_mod_time"
        
        echo "[UPDATE] File and cache updated: $file_path"
        return 0
    else
        # Restore backup on failure
        if [ -f "${file_path}.backup" ]; then
            mv "${file_path}.backup" "$file_path"
        fi
        echo "[ERROR] Failed to update file: $file_path"
        return 1
    fi
}

# =============================================================================
# CACHE STATISTICS AND CLEANUP
# =============================================================================

# Get cache statistics
get_cache_stats() {
    if [ "$VYBE_CACHE_AVAILABLE" = true ]; then
        local stats=$(curl -s "$VYBE_CACHE_SERVER/stats" 2>/dev/null)
        if [ -n "$stats" ]; then
            echo "MCP Cache Stats:"
            echo "$stats" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    hit_rate = data.get('hitRate', 'N/A')
    keys = data.get('keys', 0)
    uptime = data.get('uptime', 0)
    print(f'  Hit rate: {hit_rate}')
    print(f'  Keys: {keys}') 
    print(f'  Uptime: {uptime}s')
except:
    print('  Failed to parse stats')
" 2>/dev/null
        fi
    fi
    
    # File cache stats
    local file_cache_count=$(find "$VYBE_FILE_CACHE_DIR" -name "*_cache.json" | wc -l)
    echo "File Cache Stats:"
    echo "  Cached files: $file_cache_count"
    echo "  Cache directory: $VYBE_FILE_CACHE_DIR"
}

# Cleanup old file cache entries
cleanup_file_cache() {
    echo "[CLEANUP] Removing expired file cache entries..."
    find "$VYBE_FILE_CACHE_DIR" -name "*_cache.json" -type f -exec python3 -c "
import json, time, sys, os
try:
    with open(sys.argv[1]) as f:
        data = json.load(f)
    # Remove if older than 24 hours
    if time.time() - data.get('timestamp', 0) > 86400:
        os.remove(sys.argv[1])
        print(f'Removed expired: {sys.argv[1]}')
except:
    pass
" {} \; 2>/dev/null
}

# =============================================================================
# EXPORT FUNCTIONS FOR USE BY COMMANDS
# =============================================================================

# Make functions available to sourcing scripts
export -f init_vybe_cache
export -f cache_get
export -f cache_set  
export -f cache_mget
export -f cache_mset
export -f is_project_cache_valid
export -f load_project_data
export -f update_file_and_cache
export -f get_cache_stats
export -f cleanup_file_cache

# Silent loading - message will be displayed by calling script if needed
# echo "[SHARED-CACHE] Vybe shared cache system loaded"
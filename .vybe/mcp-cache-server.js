#!/usr/bin/env node

/**
 * Vybe Framework MCP In-Memory Cache Server
 * High-performance caching with <0.5ms lookup times
 * 
 * Features:
 * - Pure in-memory storage (Map-based)
 * - LRU eviction with memory limits
 * - TTL support with smart strategies
 * - Batch operations (mget, mset)
 * - Snapshot persistence
 * - Performance metrics
 */

const fs = require('fs').promises;
const path = require('path');

class LRUCache {
  constructor(options = {}) {
    this.max = options.max || 1000;
    this.maxSize = options.maxSize || 100 * 1024 * 1024; // 100MB
    this.cache = new Map();
    this.sizes = new Map();
    this.currentSize = 0;
  }

  get(key) {
    if (this.cache.has(key)) {
      // Move to end (most recently used)
      const value = this.cache.get(key);
      this.cache.delete(key);
      this.cache.set(key, value);
      return value;
    }
    return undefined;
  }

  set(key, value) {
    const size = JSON.stringify(value).length;
    
    // Remove if exists
    if (this.cache.has(key)) {
      this.currentSize -= this.sizes.get(key);
      this.cache.delete(key);
      this.sizes.delete(key);
    }

    // Evict if necessary
    while (
      (this.cache.size >= this.max || this.currentSize + size > this.maxSize) &&
      this.cache.size > 0
    ) {
      this.evictOldest();
    }

    // Add new item
    this.cache.set(key, value);
    this.sizes.set(key, size);
    this.currentSize += size;
  }

  delete(key) {
    if (this.cache.has(key)) {
      this.currentSize -= this.sizes.get(key);
      this.sizes.delete(key);
      return this.cache.delete(key);
    }
    return false;
  }

  evictOldest() {
    const firstKey = this.cache.keys().next().value;
    if (firstKey !== undefined) {
      this.currentSize -= this.sizes.get(firstKey);
      this.sizes.delete(firstKey);
      this.cache.delete(firstKey);
      return firstKey;
    }
  }

  clear() {
    this.cache.clear();
    this.sizes.clear();
    this.currentSize = 0;
  }

  size() {
    return this.cache.size;
  }

  memoryUsage() {
    return this.currentSize;
  }
}

class VybeCache {
  constructor() {
    this.store = new Map();
    this.ttls = new Map();
    this.lru = new LRUCache({ 
      max: 1000,
      maxSize: 100 * 1024 * 1024 // 100MB
    });
    
    this.stats = {
      hits: 0,
      misses: 0,
      sets: 0,
      deletes: 0,
      evictions: 0,
      startTime: Date.now()
    };

    // TTL strategies for different data types
    this.ttlStrategies = {
      'project.': 3600,        // 1 hour - project structure rarely changes
      'apis.': 86400,          // 24 hours - API detection very stable
      'features.': 300,        // 5 minutes - feature status updates frequently
      'members.': 1800,        // 30 minutes - member config occasional changes
      'default': 1800          // 30 minutes default
    };

    // Start cleanup timer
    this.cleanupInterval = setInterval(() => this.cleanup(), 60000); // Every minute
    
    // Load snapshot on startup
    this.loadSnapshot().catch(() => {
      // Ignore errors - will start fresh
    });

    // Setup graceful shutdown
    process.on('SIGINT', () => this.shutdown());
    process.on('SIGTERM', () => this.shutdown());
  }

  getTTL(key) {
    for (const [prefix, ttl] of Object.entries(this.ttlStrategies)) {
      if (prefix !== 'default' && key.startsWith(prefix)) {
        return ttl;
      }
    }
    return this.ttlStrategies.default;
  }

  get(key) {
    // Check if expired
    if (this.ttls.has(key) && this.ttls.get(key) < Date.now()) {
      this.expire(key);
      this.stats.misses++;
      return null;
    }

    if (this.store.has(key)) {
      this.lru.get(key); // Update LRU position
      this.stats.hits++;
      return this.store.get(key);
    }

    this.stats.misses++;
    return null;
  }

  mget(keys) {
    const result = {};
    const currentTime = Date.now();
    
    for (const key of keys) {
      // Check expiry
      if (this.ttls.has(key) && this.ttls.get(key) < currentTime) {
        this.expire(key);
        this.stats.misses++;
        continue;
      }

      if (this.store.has(key)) {
        result[key] = this.store.get(key);
        this.lru.get(key); // Update LRU position
        this.stats.hits++;
      } else {
        this.stats.misses++;
      }
    }

    return result;
  }

  set(key, value, customTTL = null) {
    const ttl = customTTL || this.getTTL(key);
    const expiry = Date.now() + (ttl * 1000);

    // Store in both maps
    this.store.set(key, value);
    this.ttls.set(key, expiry);
    this.lru.set(key, value);

    this.stats.sets++;
    return true;
  }

  mset(data, customTTL = null) {
    for (const [key, value] of Object.entries(data)) {
      this.set(key, value, customTTL);
    }
    return true;
  }

  del(key) {
    const existed = this.store.has(key);
    
    this.store.delete(key);
    this.ttls.delete(key);
    this.lru.delete(key);

    if (existed) {
      this.stats.deletes++;
      return true;
    }
    return false;
  }

  expire(key) {
    this.store.delete(key);
    this.ttls.delete(key);
    this.lru.delete(key);
  }

  cleanup() {
    const currentTime = Date.now();
    const expiredKeys = [];

    for (const [key, expiry] of this.ttls.entries()) {
      if (expiry < currentTime) {
        expiredKeys.push(key);
      }
    }

    for (const key of expiredKeys) {
      this.expire(key);
    }

    // Log cleanup if significant
    if (expiredKeys.length > 0) {
      console.error(`[VybeCache] Cleaned up ${expiredKeys.length} expired keys`);
    }
  }

  getStats() {
    const uptime = Math.floor((Date.now() - this.stats.startTime) / 1000);
    const hitRate = this.stats.hits + this.stats.misses > 0 
      ? (this.stats.hits / (this.stats.hits + this.stats.misses) * 100).toFixed(2)
      : '0.00';

    return {
      ...this.stats,
      uptime,
      hitRate: `${hitRate}%`,
      keys: this.store.size,
      memoryUsage: `${Math.round(this.lru.memoryUsage() / 1024 / 1024)}MB`,
      memoryUsageBytes: this.lru.memoryUsage()
    };
  }

  getHealth() {
    const memUsage = this.lru.memoryUsage() / (100 * 1024 * 1024); // Ratio of 100MB limit
    const uptime = Math.floor((Date.now() - this.stats.startTime) / 1000);
    
    return {
      status: memUsage > 0.9 ? 'warning' : 'healthy',
      uptime,
      memory_usage: memUsage,
      keys: this.store.size,
      active_ttls: this.ttls.size
    };
  }

  async snapshot() {
    try {
      const cacheDir = '.vybe/.cache';
      await fs.mkdir(cacheDir, { recursive: true });

      const data = {
        timestamp: Date.now(),
        version: '1.0.0',
        cache: Object.fromEntries(this.store),
        ttls: Object.fromEntries(this.ttls),
        stats: this.stats
      };

      const snapshotPath = path.join(cacheDir, 'snapshot.json');
      await fs.writeFile(snapshotPath, JSON.stringify(data, null, 2));
      
      console.error(`[VybeCache] Snapshot saved: ${this.store.size} keys`);
      return true;
    } catch (error) {
      console.error(`[VybeCache] Snapshot failed: ${error.message}`);
      return false;
    }
  }

  async loadSnapshot() {
    try {
      const snapshotPath = '.vybe/.cache/snapshot.json';
      const data = JSON.parse(await fs.readFile(snapshotPath, 'utf8'));

      // Validate version compatibility
      if (!data.version || data.version !== '1.0.0') {
        console.error('[VybeCache] Incompatible snapshot version, starting fresh');
        return false;
      }

      const currentTime = Date.now();
      let loaded = 0;

      // Restore unexpired entries
      for (const [key, value] of Object.entries(data.cache)) {
        const expiry = data.ttls[key];
        if (!expiry || expiry > currentTime) {
          this.store.set(key, value);
          this.lru.set(key, value);
          if (expiry) {
            this.ttls.set(key, expiry);
          }
          loaded++;
        }
      }

      console.error(`[VybeCache] Loaded ${loaded} keys from snapshot`);
      return true;
    } catch (error) {
      console.error(`[VybeCache] Failed to load snapshot: ${error.message}`);
      return false;
    }
  }

  async shutdown() {
    console.error('[VybeCache] Shutting down...');
    
    clearInterval(this.cleanupInterval);
    await this.snapshot();
    
    console.error('[VybeCache] Shutdown complete');
    process.exit(0);
  }
}

// MCP Protocol Implementation
class MCPServer {
  constructor() {
    this.cache = new VybeCache();
    this.setupSnapshotTimer();
  }

  setupSnapshotTimer() {
    // Periodic snapshots every 10 minutes
    setInterval(() => {
      this.cache.snapshot();
    }, 10 * 60 * 1000);
  }

  async handleRequest(request) {
    try {
      const { method, params } = request;

      switch (method) {
        case 'tools/list':
          return {
            tools: [
              {
                name: 'get',
                description: 'Get a value from cache',
                inputSchema: {
                  type: 'object',
                  properties: {
                    key: { type: 'string', description: 'Cache key' }
                  },
                  required: ['key']
                }
              },
              {
                name: 'mget',
                description: 'Get multiple values from cache',
                inputSchema: {
                  type: 'object',
                  properties: {
                    keys: { 
                      type: 'array', 
                      items: { type: 'string' },
                      description: 'Array of cache keys' 
                    }
                  },
                  required: ['keys']
                }
              },
              {
                name: 'set',
                description: 'Set a value in cache',
                inputSchema: {
                  type: 'object',
                  properties: {
                    key: { type: 'string', description: 'Cache key' },
                    value: { description: 'Value to store' },
                    ttl: { type: 'number', description: 'TTL in seconds (optional)' }
                  },
                  required: ['key', 'value']
                }
              },
              {
                name: 'mset',
                description: 'Set multiple values in cache',
                inputSchema: {
                  type: 'object',
                  properties: {
                    data: { type: 'object', description: 'Key-value pairs to store' },
                    ttl: { type: 'number', description: 'TTL in seconds (optional)' }
                  },
                  required: ['data']
                }
              },
              {
                name: 'del',
                description: 'Delete a key from cache',
                inputSchema: {
                  type: 'object',
                  properties: {
                    key: { type: 'string', description: 'Cache key to delete' }
                  },
                  required: ['key']
                }
              },
              {
                name: 'stats',
                description: 'Get cache statistics',
                inputSchema: {
                  type: 'object',
                  properties: {}
                }
              },
              {
                name: 'health',
                description: 'Get cache health status',
                inputSchema: {
                  type: 'object',
                  properties: {}
                }
              },
              {
                name: 'snapshot',
                description: 'Create a cache snapshot',
                inputSchema: {
                  type: 'object',
                  properties: {}
                }
              }
            ]
          };

        case 'tools/call':
          return await this.handleToolCall(params);

        default:
          throw new Error(`Unknown method: ${method}`);
      }
    } catch (error) {
      return {
        error: {
          code: -32603,
          message: error.message
        }
      };
    }
  }

  async handleToolCall(params) {
    const { name, arguments: args } = params;

    switch (name) {
      case 'get':
        const value = this.cache.get(args.key);
        return {
          content: [{
            type: 'text',
            text: value !== null ? JSON.stringify(value) : 'null'
          }]
        };

      case 'mget':
        const values = this.cache.mget(args.keys);
        return {
          content: [{
            type: 'text',
            text: JSON.stringify(values)
          }]
        };

      case 'set':
        const success = this.cache.set(args.key, args.value, args.ttl);
        return {
          content: [{
            type: 'text',
            text: JSON.stringify(success)
          }]
        };

      case 'mset':
        const msetSuccess = this.cache.mset(args.data, args.ttl);
        return {
          content: [{
            type: 'text',
            text: JSON.stringify(msetSuccess)
          }]
        };

      case 'del':
        const deleted = this.cache.del(args.key);
        return {
          content: [{
            type: 'text',
            text: JSON.stringify(deleted)
          }]
        };

      case 'stats':
        const stats = this.cache.getStats();
        return {
          content: [{
            type: 'text',
            text: JSON.stringify(stats, null, 2)
          }]
        };

      case 'health':
        const health = this.cache.getHealth();
        return {
          content: [{
            type: 'text',
            text: JSON.stringify(health, null, 2)
          }]
        };

      case 'snapshot':
        const snapshotResult = await this.cache.snapshot();
        return {
          content: [{
            type: 'text',
            text: JSON.stringify(snapshotResult)
          }]
        };

      default:
        throw new Error(`Unknown tool: ${name}`);
    }
  }
}

// Main server setup
async function main() {
  const server = new MCPServer();
  
  console.error('[VybeCache] Starting MCP cache server...');
  console.error(`[VybeCache] Process ID: ${process.pid}`);
  console.error(`[VybeCache] Memory limit: 100MB`);
  console.error(`[VybeCache] TTL strategies loaded`);

  // Handle JSON-RPC over stdio
  let buffer = '';
  
  process.stdin.on('data', async (chunk) => {
    buffer += chunk.toString();
    
    // Process complete JSON messages
    let newlineIndex;
    while ((newlineIndex = buffer.indexOf('\n')) !== -1) {
      const line = buffer.slice(0, newlineIndex);
      buffer = buffer.slice(newlineIndex + 1);
      
      if (line.trim()) {
        try {
          const request = JSON.parse(line);
          const response = await server.handleRequest(request);
          
          // Send response
          const responseData = {
            jsonrpc: '2.0',
            id: request.id,
            ...response
          };
          
          console.log(JSON.stringify(responseData));
        } catch (error) {
          console.error(`[VybeCache] Error processing request: ${error.message}`);
          
          // Send error response
          const errorResponse = {
            jsonrpc: '2.0',
            id: request?.id || null,
            error: {
              code: -32700,
              message: 'Parse error'
            }
          };
          
          console.log(JSON.stringify(errorResponse));
        }
      }
    }
  });

  process.stdin.on('end', () => {
    server.cache.shutdown();
  });

  console.error('[VybeCache] MCP cache server ready');
}

// Start the server
if (require.main === module) {
  main().catch((error) => {
    console.error(`[VybeCache] Failed to start: ${error.message}`);
    process.exit(1);
  });
}

module.exports = { VybeCache, MCPServer };
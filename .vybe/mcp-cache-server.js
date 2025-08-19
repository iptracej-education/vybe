#!/usr/bin/env node

/**
 * Vybe Framework MCP In-Memory Cache Server
 * Now with HTTP API for bash script access
 */

const fs = require('fs').promises;
const path = require('path');
const http = require('http');

// [Previous LRUCache and VybeCache classes remain the same]
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
      const value = this.cache.get(key);
      this.cache.delete(key);
      this.cache.set(key, value);
      return value;
    }
    return undefined;
  }

  set(key, value) {
    const size = JSON.stringify(value).length;
    
    if (this.cache.has(key)) {
      this.currentSize -= this.sizes.get(key);
      this.cache.delete(key);
      this.sizes.delete(key);
    }

    while (
      (this.cache.size >= this.max || this.currentSize + size > this.maxSize) &&
      this.cache.size > 0
    ) {
      this.evictOldest();
    }

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
    return null;
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
      maxSize: 100 * 1024 * 1024
    });
    
    this.stats = {
      hits: 0,
      misses: 0,
      sets: 0,
      deletes: 0,
      evictions: 0,
      startTime: Date.now()
    };

    this.ttlStrategies = {
      'project.': 3600,
      'apis.': 86400,
      'features.': 300,
      'members.': 1800,
      'default': 1800
    };

    this.cleanupInterval = setInterval(() => this.cleanup(), 60000);
    
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
    if (this.ttls.has(key) && this.ttls.get(key) < Date.now()) {
      this.expire(key);
      this.stats.misses++;
      return null;
    }

    if (this.store.has(key)) {
      this.lru.get(key);
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
      if (this.ttls.has(key) && this.ttls.get(key) < currentTime) {
        this.expire(key);
        this.stats.misses++;
        continue;
      }

      if (this.store.has(key)) {
        result[key] = this.store.get(key);
        this.lru.get(key);
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

    const size = JSON.stringify(value).length;
    while (
      (this.lru.cache.size >= this.lru.max || this.lru.currentSize + size > this.lru.maxSize) &&
      this.lru.cache.size > 0
    ) {
      const victim = this.lru.evictOldest();
      if (!victim) break;
      this.store.delete(victim);
      this.ttls.delete(victim);
      this.stats.evictions++;
    }

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

    if (expiredKeys.length > 0) {
      // Log to stdout instead of stderr to avoid error messages in Claude Code
      console.log(`[VybeCache] Cleaned up ${expiredKeys.length} expired keys`);
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
    const memUsage = this.lru.memoryUsage() / (100 * 1024 * 1024);
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
      
      console.log(`[VybeCache] Snapshot saved: ${this.store.size} keys`);
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

      if (!data.version || data.version !== '1.0.0') {
        console.log('[VybeCache] Incompatible snapshot version, starting fresh');
        return false;
      }

      const currentTime = Date.now();
      let loaded = 0;

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

      console.log(`[VybeCache] Loaded ${loaded} keys from snapshot`);
      return true;
    } catch (error) {
      console.error(`[VybeCache] Failed to load snapshot: ${error.message}`);
      return false;
    }
  }

  async shutdown() {
    console.log('[VybeCache] Shutting down...');
    
    clearInterval(this.cleanupInterval);
    await this.snapshot();
    
    console.log('[VybeCache] Shutdown complete');
    process.exit(0);
  }
}

// HTTP API Server for bash access
class HTTPAPIServer {
  constructor(cache, port = 7624) {
    this.cache = cache;
    this.port = port;
    this.server = null;
  }

  start() {
    this.server = http.createServer((req, res) => {
      // Enable CORS for local requests
      res.setHeader('Access-Control-Allow-Origin', '*');
      res.setHeader('Access-Control-Allow-Methods', 'GET, POST, DELETE');
      res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

      // Parse URL and method
      const url = new URL(req.url, `http://localhost:${this.port}`);
      const method = req.method;

      // Handle different endpoints
      if (method === 'GET' && url.pathname === '/cache/get') {
        this.handleGet(url, res);
      } else if (method === 'POST' && url.pathname === '/cache/mget') {
        this.handleMget(req, res);
      } else if (method === 'POST' && url.pathname === '/cache/set') {
        this.handleSet(req, res);
      } else if (method === 'POST' && url.pathname === '/cache/mset') {
        this.handleMset(req, res);
      } else if (method === 'DELETE' && url.pathname === '/cache/del') {
        this.handleDel(url, res);
      } else if (method === 'GET' && url.pathname === '/stats') {
        this.handleStats(res);
      } else if (method === 'GET' && url.pathname === '/health') {
        this.handleHealth(res);
      } else {
        res.writeHead(404, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Not found' }));
      }
    });

    this.server.listen(this.port, '127.0.0.1', () => {
      console.log(`[VybeCache] HTTP API listening on http://127.0.0.1:${this.port}`);
    });
  }

  handleGet(url, res) {
    const key = url.searchParams.get('key');
    if (!key) {
      res.writeHead(400, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: 'Missing key parameter' }));
      return;
    }

    const value = this.cache.get(key);
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ value }));
  }

  handleMget(req, res) {
    let body = '';
    req.on('data', chunk => body += chunk);
    req.on('end', () => {
      try {
        const { keys } = JSON.parse(body);
        const values = this.cache.mget(keys);
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(values));
      } catch (error) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: error.message }));
      }
    });
  }

  handleSet(req, res) {
    let body = '';
    req.on('data', chunk => body += chunk);
    req.on('end', () => {
      try {
        const { key, value, ttl } = JSON.parse(body);
        const success = this.cache.set(key, value, ttl);
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ success }));
      } catch (error) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: error.message }));
      }
    });
  }

  handleMset(req, res) {
    let body = '';
    req.on('data', chunk => body += chunk);
    req.on('end', () => {
      try {
        const { data, ttl } = JSON.parse(body);
        const success = this.cache.mset(data, ttl);
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ success }));
      } catch (error) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: error.message }));
      }
    });
  }

  handleDel(url, res) {
    const key = url.searchParams.get('key');
    if (!key) {
      res.writeHead(400, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: 'Missing key parameter' }));
      return;
    }

    const deleted = this.cache.del(key);
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ deleted }));
  }

  handleStats(res) {
    const stats = this.cache.getStats();
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify(stats));
  }

  handleHealth(res) {
    const health = this.cache.getHealth();
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify(health));
  }

  stop() {
    if (this.server) {
      this.server.close();
    }
  }
}

// MCP Protocol Implementation (remains the same)
class MCPServer {
  constructor() {
    this.cache = new VybeCache();
    this.httpAPI = new HTTPAPIServer(this.cache);
    this.setupSnapshotTimer();
  }

  setupSnapshotTimer() {
    setInterval(() => {
      this.cache.snapshot();
    }, 10 * 60 * 1000);
  }

  async handleRequest(request) {
    try {
      const { method, params } = request;

      const isNotification = request.id === undefined || request.id === null;
      const wrap = (result) => isNotification ? null : ({ result });
      const wrapErr = (code, message) => ({ error: { code, message } });

      switch (method) {
        case 'initialize': {
          const requested = params?.protocolVersion;
          const supported = ['2025-06-18','2025-03-26','2024-11-05'];
          const agreed = supported.includes(requested) ? requested : '2025-03-26';
          return wrap({
            protocolVersion: agreed,
            capabilities: {
              logging: {},
              tools: { listChanged: true },
              resources: { subscribe: false, listChanged: false },
              prompts: { listChanged: false }
            },
            serverInfo: { name: 'vybe-cache', version: '1.0.0' }
          });
        }

        case 'tools/list':
          return wrap({
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
          });

        case 'tools/call':
          return wrap(await this.handleToolCall(params));

        case 'notifications/initialized':
          return null;

        case 'ping':
          return wrap({});

        default:
          return isNotification ? null : wrapErr(-32601, `Unknown method: ${method}`);
      }
    } catch (error) {
      return { error: { code: -32603, message: error.message } };
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
  
  console.log('[VybeCache] Starting MCP cache server with HTTP API...');
  console.log(`[VybeCache] Process ID: ${process.pid}`);
  console.log(`[VybeCache] Memory limit: 100MB`);

  // Load snapshot
  await server.cache.loadSnapshot();
  
  // Start HTTP API for bash access
  server.httpAPI.start();
  
  console.log(`[VybeCache] MCP + HTTP cache server ready`);
  console.log(`[VybeCache] Bash access: curl http://127.0.0.1:7624/cache/get?key=KEY`);

  // Set stdin to raw mode and handle JSON-RPC over stdio
  process.stdin.setEncoding('utf8');
  let buffer = '';
  
  process.stdin.on('data', async (chunk) => {
    buffer += chunk.toString();
    
    let newlineIndex;
    while ((newlineIndex = buffer.indexOf('\n')) !== -1) {
      const line = buffer.slice(0, newlineIndex);
      buffer = buffer.slice(newlineIndex + 1);
      
      if (line.trim()) {
        let request = null;
        try {
          request = JSON.parse(line);
          const response = await server.handleRequest(request);
          
          if (!request || request.id === undefined || request.id === null || response === null) {
            return;
          }
          
          const payload = response.error ? { error: response.error } : { result: response.result };
          const responseMsg = JSON.stringify({ jsonrpc: '2.0', id: request.id, ...payload });
          console.log(responseMsg);
          
        } catch (error) {
          console.log(`[VybeCache] Error processing request: ${error.message}`);
          
          if (request && request.id !== undefined && request.id !== null) {
            const errorResponse = JSON.stringify({
              jsonrpc: '2.0',
              id: request.id,
              error: { code: -32700, message: 'Parse error' }
            });
            console.log(errorResponse);
          }
        }
      }
    }
  });

  process.stdin.on('end', () => {
    server.httpAPI.stop();
    server.cache.shutdown();
  });

  process.stdin.resume();
}

// Start the server
if (require.main === module) {
  main().catch((error) => {
    console.error(`[VybeCache] Failed to start: ${error.message}`);
    process.exit(1);
  });
}

module.exports = { VybeCache, MCPServer, HTTPAPIServer };
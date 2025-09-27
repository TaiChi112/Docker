const express = require('express');
const { Pool } = require('pg');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 3000;

// PostgreSQL connection pool
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

// Middleware
app.use(express.json());

// Health check endpoint
app.get('/health', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT NOW()');
    client.release();
    
    res.json({
      status: 'healthy',
      database: 'connected',
      timestamp: result.rows[0].now
    });
  } catch (error) {
    res.status(500).json({
      status: 'unhealthy',
      database: 'disconnected',
      error: error.message
    });
  }
});

// Get all users
app.get('/api/users', async (req, res) => {
  try {
    const result = await pool.query('SELECT id, username, email, created_at FROM app.users ORDER BY created_at DESC');
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get all products
app.get('/api/products', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM app.products ORDER BY name');
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get orders with user details
app.get('/api/orders', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT o.id, o.total_amount, o.status, o.order_date,
             u.username, u.email
      FROM app.orders o
      JOIN app.users u ON o.user_id = u.id
      ORDER BY o.order_date DESC
    `);
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Database stats endpoint
app.get('/api/stats', async (req, res) => {
  try {
    const queries = [
      { name: 'users', query: 'SELECT COUNT(*) as count FROM app.users' },
      { name: 'products', query: 'SELECT COUNT(*) as count FROM app.products' },
      { name: 'orders', query: 'SELECT COUNT(*) as count FROM app.orders' },
      { name: 'database_size', query: "SELECT pg_size_pretty(pg_database_size(current_database())) as size" }
    ];
    
    const stats = {};
    
    for (const q of queries) {
      const result = await pool.query(q.query);
      stats[q.name] = result.rows[0].count || result.rows[0].size;
    }
    
    res.json(stats);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'Sample PostgreSQL Application',
    endpoints: [
      'GET /health - Health check',
      'GET /api/users - List all users',
      'GET /api/products - List all products',
      'GET /api/orders - List all orders',
      'GET /api/stats - Database statistics'
    ]
  });
});

// Error handling
app.use((error, req, res, next) => {
  console.error('Unhandled error:', error);
  res.status(500).json({ error: 'Internal server error' });
});

// Graceful shutdown
process.on('SIGINT', async () => {
  console.log('Shutting down gracefully...');
  await pool.end();
  process.exit(0);
});

// Start server
app.listen(port, '0.0.0.0', () => {
  console.log(`Server running on port ${port}`);
  console.log(`Health check: http://localhost:${port}/health`);
});
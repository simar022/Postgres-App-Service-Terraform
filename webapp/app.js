const { Pool } = require('pg');
const http = require('http');
const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
  console.error("❌ ERROR: DATABASE_URL is not defined in environment variables!");
  process.exit(1); 
}

const port = process.env.PORT || 8080;

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }, 
  max: 10, 
  idleTimeoutMillis: 30000
});

const server = http.createServer(async (req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/html');

  try {
    const dbRes = await pool.query('SELECT version();');
    const pgVersion = dbRes.rows[0].version;

    res.end(`
      <h1>Azure Node.js 24 + Postgres 17 Test</h1>
      <p><strong>Status:</strong> Connection Successful ✅</p>
      <p><strong>DB Version:</strong> ${pgVersion}</p>
      <p><strong>Environment:</strong> ${process.env.NODE_ENV || 'Production'}</p>
    `);
  } catch (err) {
    console.error(err);
    res.end(`<h1>Database Error ❌</h1><p>${err.message}</p>`);
  }
});

server.listen(port, () => {
  console.log(`Server running on port ${port}`);
});


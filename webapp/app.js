// webapp/app.js
// const { Client } = require('pg');
// const http = require('http');

// const port = process.env.PORT || 3000;

// const client = new Client({
//   connectionString: process.env.DATABASE_URL,
//   ssl: { rejectUnauthorized: false } 
// });

// const server = http.createServer(async (req, res) => {
//   res.statusCode = 200;
//   res.setHeader('Content-Type', 'text/html');

//   try {
//     await client.connect();
//     const dbRes = await client.query('SELECT version();');
//     const pgVersion = dbRes.rows[0].version;

//     res.end(`
//       <h1>Azure Node.js 24 + Postgres 17 Test</h1>
//       <p><strong>Environment:</strong> ${process.env.NODE_ENV || 'Production'}</p>
//       <p><strong>Database Connection:</strong> ✅ Success</p>
//       <p><strong>DB Version:</strong> ${pgVersion}</p>
//       <p><strong>Server Time:</strong> ${new Date().toISOString()}</p>
//     `);
//   } catch (err) {
//     res.end(`<h1>Database Connection Failed ❌</h1><p>${err.message}</p>`);
//   } finally {
//     await client.end();
//   }
// });

// server.listen(port, () => {
//   console.log(`Server running on port ${port}`);
// });

const { Pool } = require('pg');
const http = require('http');
const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
  console.error("❌ ERROR: DATABASE_URL is not defined in environment variables!");
  process.exit(1); 
}

const port = process.env.PORT || 8080;

// 1. Use a Pool instead of a single Client
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }, 
  max: 10, // Max number of concurrent connections
  idleTimeoutMillis: 30000
});

const server = http.createServer(async (req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/html');

  // 2. Get a client FROM the pool for this specific request
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
  // Note: We don't close the pool here because we want to reuse it for the next request!
});

server.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

// const { Pool } = require('pg');
// const http = require('http');

// const port = process.env.PORT || 8080; // Azure often prefers 8080 or 80

// const pool = new Pool({
//   connectionString: process.env.DATABASE_URL,
//   connectionTimeoutMillis: 5000, // Don't hang forever
//   ssl: { rejectUnauthorized: false }
// });

// const server = http.createServer(async (req, res) => {
//   if (req.url === '/health') {
//     res.writeHead(200);
//     return res.end('OK');
//   }

//   try {
//     const dbRes = await pool.query('SELECT version();');
//     res.writeHead(200, { 'Content-Type': 'text/plain' });
//     res.end(`Success! Connected to: ${dbRes.rows[0].version}`);
//   } catch (err) {
//     res.writeHead(500);
//     res.end(`Database Connection Error: ${err.message}`);
//   }
// });

// // CRITICAL: Start listening BEFORE the heavy DB logic
// server.listen(port, () => {
//   console.log(`🚀 Container signaling READY on port ${port}`);
  
//   // Test DB connection in the background so it doesn't block the 'READY' signal
//   pool.connect((err, client, release) => {
//     if (err) {
//       console.error('❌ BACKGROUND DB ERROR:', err.message);
//     } else {
//       console.log('✅ DATABASE HANDSHAKE EXECUTED');
//       release();
//     }
//   });
// });


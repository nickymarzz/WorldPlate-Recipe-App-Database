const express = require('express');
const cors = require('cors');

// Monkey-patch msnodesqlv8 to unpack Connection Error [object Object] bug in node-mssql
try {
  const msnodesql = require('msnodesqlv8');
  const originalOpen = msnodesql.open;
  msnodesql.open = function (cfg, callback) {
    return originalOpen.call(msnodesql, cfg, (err, tds) => {
      if (err) {
        let msg = err.message;
        if (typeof msg !== 'string') {
          msg = JSON.stringify(err);
        }
        const errorInstance = new Error(msg);
        Object.assign(errorInstance, err);
        errorInstance.originalError = err;
        return callback(errorInstance, tds);
      }
      return callback(err, tds);
    });
  };
} catch (e) {
  // msnodesqlv8 not installed yet
}

const sqlNormal = require('mssql');
let sqlNative = null;
try {
  sqlNative = require('mssql/msnodesqlv8');
  console.log('Successfully loaded msnodesqlv8 driver for native Windows Authentication.');
} catch (e) {
  console.log('msnodesqlv8 driver not found. Windows Authentication will use standard node-mssql driver.');
}
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 5000;

// Dynamic configuration store
let currentConfig = {
  user: process.env.DB_USER || 'sa',
  password: process.env.DB_PASSWORD || '',
  server: process.env.DB_SERVER || 'localhost',
  database: process.env.DB_DATABASE || 'Recipe_DB',
  port: parseInt(process.env.DB_PORT || '1433'),
  useWindowsAuth: process.env.DB_USE_WINDOWS_AUTH === 'true',
  options: {
    encrypt: process.env.DB_ENCRYPT === 'true',
    trustServerCertificate: process.env.DB_TRUST_SERVER_CERTIFICATE !== 'false',
    enableArithAbort: true
  },
  connectionTimeout: 10000,
  requestTimeout: 15000
};

let dbPool = null;
let activeSql = sqlNormal;

// Helper to get or create SQL Connection Pool
async function getPool(customConfig = null) {
  if (customConfig) {
    if (dbPool) {
      try { await dbPool.close(); } catch(e) {}
      dbPool = null;
    }
    currentConfig = { ...currentConfig, ...customConfig };
  }

  if (!dbPool) {
    let connectConfig = {};
    if (currentConfig.useWindowsAuth) {
      console.log(`Connecting to SQL Server via Windows Authentication: ${currentConfig.server}:${currentConfig.port}, Database: ${currentConfig.database}...`);
      activeSql = sqlNative || sqlNormal;
      connectConfig = {
        driver: 'msnodesqlv8',
        connectionString: `Driver={ODBC Driver 17 for SQL Server};Server=${currentConfig.server}${currentConfig.port ? ',' + currentConfig.port : ''};Database=${currentConfig.database};Trusted_Connection=yes;TrustServerCertificate=${currentConfig.options.trustServerCertificate ? 'yes' : 'no'};`,
        connectionTimeout: currentConfig.connectionTimeout,
        requestTimeout: currentConfig.requestTimeout
      };
    } else {
      console.log(`Connecting to SQL Server via SQL Authentication: ${currentConfig.server}:${currentConfig.port}, Database: ${currentConfig.database}...`);
      activeSql = sqlNormal;
      connectConfig = {
        user: currentConfig.user,
        password: currentConfig.password,
        server: currentConfig.server,
        database: currentConfig.database,
        port: currentConfig.port,
        options: {
          encrypt: currentConfig.options.encrypt,
          trustServerCertificate: currentConfig.options.trustServerCertificate,
          enableArithAbort: true
        },
        connectionTimeout: currentConfig.connectionTimeout,
        requestTimeout: currentConfig.requestTimeout
      };
    }

    dbPool = await activeSql.connect(connectConfig);
    console.log('Connected to SQL Server successfully!');
  }
  return dbPool;
}

// Endpoint to check connection status / test credentials
app.post('/api/connect', async (req, res) => {
  try {
    const { user, password, server, database, port, useWindowsAuth } = req.body;
    const testConfig = {
      user: user || currentConfig.user,
      password: password !== undefined ? password : currentConfig.password,
      server: server || currentConfig.server,
      database: database || currentConfig.database,
      port: port ? parseInt(port) : currentConfig.port,
      useWindowsAuth: useWindowsAuth !== undefined ? useWindowsAuth : currentConfig.useWindowsAuth,
      options: {
        encrypt: currentConfig.options.encrypt,
        trustServerCertificate: currentConfig.options.trustServerCertificate,
        enableArithAbort: true
      },
      connectionTimeout: 5000,
      requestTimeout: 8000
    };

    // Attempt to connect with new credentials
    const tempPool = await getPool(testConfig);
    
    // Quick test query to ensure database is responsive
    await tempPool.request().query('SELECT 1');

    res.json({
      success: true,
      message: `Successfully connected to Microsoft SQL Server! [Mode: ${testConfig.useWindowsAuth ? 'Windows Auth' : 'SQL Auth'}]`,
      config: {
        server: currentConfig.server,
        port: currentConfig.port,
        database: currentConfig.database,
        user: currentConfig.useWindowsAuth ? 'Windows Domain User' : currentConfig.user,
        useWindowsAuth: currentConfig.useWindowsAuth
      }
    });
  } catch (error) {
    console.error('SQL Server Connection Error:', error);
    if (dbPool) {
      try { await dbPool.close(); } catch(e) {}
      dbPool = null;
    }
    
    let errMsg = error.message;
    if (errMsg === '[object Object]') {
      if (error.originalError) {
        errMsg = error.originalError.message || JSON.stringify(error.originalError);
      } else if (error.errors && error.errors.length > 0) {
        errMsg = error.errors.map(e => e.message).join(' | ');
      } else {
        errMsg = JSON.stringify(error, Object.getOwnPropertyNames(error));
      }
    }

    res.status(500).json({
      success: false,
      message: 'Connection failed.',
      error: errMsg,
      code: error.code || 'CONNECTION_ERROR'
    });
  }
});

// Endpoint to get connection details
app.get('/api/connect', (req, res) => {
  res.json({
    connected: !!dbPool,
    config: {
      server: currentConfig.server,
      port: currentConfig.port,
      database: currentConfig.database,
      user: currentConfig.useWindowsAuth ? 'Windows Domain User' : currentConfig.user,
      useWindowsAuth: currentConfig.useWindowsAuth
    }
  });
});

// Endpoint to run a raw T-SQL query
app.post('/api/query', async (req, res) => {
  const { query } = req.body;
  if (!query) {
    return res.status(400).json({ success: false, error: 'Query text is required' });
  }

  let durationStart = Date.now();
  try {
    const pool = await getPool();
    const result = await pool.request().query(query);
    const duration = Date.now() - durationStart;

    // Check if result has multiple recordsets
    const recordsets = result.recordsets || [];
    const rowsAffected = result.rowsAffected || [];

    res.json({
      success: true,
      data: result.recordset || [],
      recordsets: recordsets,
      rowsAffected: rowsAffected,
      durationMs: duration,
      info: result.output || {}
    });
  } catch (error) {
    const duration = Date.now() - durationStart;
    console.error('SQL Query Error:', error);
    
    let errMsg = error.message;
    if (errMsg === '[object Object]') {
      if (error.originalError) {
        errMsg = error.originalError.message || JSON.stringify(error.originalError);
      } else if (error.errors && error.errors.length > 0) {
        errMsg = error.errors.map(e => e.message).join(' | ');
      } else {
        errMsg = JSON.stringify(error, Object.getOwnPropertyNames(error));
      }
    }

    res.status(500).json({
      success: false,
      error: errMsg,
      number: error.number, // T-SQL error number
      state: error.state,   // T-SQL error state
      class: error.class,   // T-SQL error severity level
      procedure: error.procedure,
      durationMs: duration
    });
  }
});

// Endpoint to get quick statistics on standard tables
app.get('/api/stats', async (req, res) => {
  try {
    const pool = await getPool();
    const stats = {};
    const tables = ['Users', 'Ingredients', 'Units', 'Actions', 'Categories', 'Recipes', 'Recipe_Ingredients', 'Steps', 'Recipe_Categories', 'Ratings', 'Favorites'];
    
    for (const table of tables) {
      try {
        const result = await pool.request().query(`SELECT COUNT(*) as count FROM ${table}`);
        stats[table] = result.recordset[0].count;
      } catch (e) {
        stats[table] = 'Table not initialized';
      }
    }

    res.json({
      success: true,
      stats: stats
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Not connected or SQL error: ' + error.message
    });
  }
});

// Start the server
app.listen(PORT, () => {
  console.log(`RecipeDB Express Backend running on http://localhost:${PORT}`);
});

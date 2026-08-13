const mysql = require('mysql2/promise');

// Export a connection pool. This provides a `.query(...)` method
// that can be awaited directly in routes (e.g. `await db.query(sql)`).
const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'students_db',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0,
});

// Test database connection
async function testConnection() {
    try {
        const connection = await pool.getConnection();
        console.log('MySQL connected');
        connection.release();

    } catch (err) {
        console.error('MySQL connection failed:', err);
    }
}

testConnection();


module.exports = pool;
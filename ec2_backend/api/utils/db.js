const mysql = require('mysql2/promise');
const logger = require('./logger');
require('dotenv').config();

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

const testConnection = async () => {
  try {
    const connection = await pool.getConnection();
    logger.info('Successfully connected to database');
    connection.release();
    return true;
  } catch (err) {
    logger.error('Error connecting to the database:', err);
    return false;
  }
};

module.exports = { pool, testConnection };

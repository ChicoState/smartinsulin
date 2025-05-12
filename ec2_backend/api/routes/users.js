const express = require('express');
const router = express.Router();
const { pool } = require('../utils/db');
const { verifyFirebaseToken } = require('../middleware/auth');
const logger = require('../utils/logger');

/**
 * Create or update user profile
 * This is called when a user signs in with Firebase
 */
router.post('/profile', verifyFirebaseToken, async (req, res) => {
  const { username, email } = req.body;
  const firebaseUid = req.firebaseUid;
  
  try {
    // Check if user already exists
    const [existingUsers] = await pool.query(
      'SELECT * FROM users WHERE firebase_uid = ?',
      [firebaseUid]
    );
    
    if (existingUsers.length > 0) {
      // Update existing user
      await pool.query(
        'UPDATE users SET username = ?, email = ? WHERE firebase_uid = ?',
        [username, email, firebaseUid]
      );
      logger.info(`Updated user profile for ${firebaseUid}`);
      res.status(200).json({ message: 'User profile updated successfully' });
    } else {
      // Create new user
      await pool.query(
        'INSERT INTO users (firebase_uid, username, email) VALUES (?, ?, ?)',
        [firebaseUid, username, email]
      );
      logger.info(`Created new user profile for ${firebaseUid}`);
      res.status(201).json({ message: 'User profile created successfully' });
    }
  } catch (err) {
    logger.error('Error creating/updating user profile:', err);
    if (err.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({ error: 'Username or email already exists' });
    }
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * Get user profile
 */
router.get('/profile', verifyFirebaseToken, async (req, res) => {
  const firebaseUid = req.firebaseUid;
  
  try {
    const [users] = await pool.query(
      'SELECT firebase_uid, username, email, created_at FROM users WHERE firebase_uid = ?',
      [firebaseUid]
    );
    
    if (users.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    res.json(users[0]);
  } catch (err) {
    logger.error('Error fetching user profile:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;

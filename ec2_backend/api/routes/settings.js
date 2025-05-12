const express = require('express');
const router = express.Router();
const { pool } = require('../utils/db');
const { verifyFirebaseToken } = require('../middleware/auth');
const logger = require('../utils/logger');

/**
 * Get user settings for the authenticated user
 */
router.get('/', verifyFirebaseToken, async (req, res) => {
  const firebaseUid = req.firebaseUid;
  
  try {
    const [settings] = await pool.query(
      'SELECT * FROM user_settings WHERE firebase_uid = ?',
      [firebaseUid]
    );
    
    if (settings.length === 0) {
      return res.json({
        firebase_uid: firebaseUid,
        insulin_sensitivity: null,
        carb_ratio: null,
        target_glucose_min: null,
        target_glucose_max: null
      });
    }
    
    res.json(settings[0]);
  } catch (err) {
    logger.error('Error fetching user settings:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * Update user settings
 */
router.put('/', verifyFirebaseToken, async (req, res) => {
  const firebaseUid = req.firebaseUid;
  const { insulin_sensitivity, carb_ratio, target_glucose_min, target_glucose_max } = req.body;
  
  try {
    // Use INSERT ... ON DUPLICATE KEY UPDATE to handle both insert and update cases
    await pool.query(
      `INSERT INTO user_settings 
       (firebase_uid, insulin_sensitivity, carb_ratio, target_glucose_min, target_glucose_max) 
       VALUES (?, ?, ?, ?, ?) 
       ON DUPLICATE KEY UPDATE 
       insulin_sensitivity = ?, carb_ratio = ?, target_glucose_min = ?, target_glucose_max = ?`,
      [
        firebaseUid, insulin_sensitivity, carb_ratio, target_glucose_min, target_glucose_max,
        insulin_sensitivity, carb_ratio, target_glucose_min, target_glucose_max
      ]
    );
    
    logger.info(`Updated settings for user ${firebaseUid}`);
    res.json({ success: true });
  } catch (err) {
    logger.error('Error updating user settings:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;

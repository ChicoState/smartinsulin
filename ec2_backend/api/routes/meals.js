const express = require('express');
const router = express.Router();
const { pool } = require('../utils/db');
const { verifyFirebaseToken } = require('../middleware/auth');
const logger = require('../utils/logger');

/**
 * Get all meal records for the authenticated user
 */
router.get('/', verifyFirebaseToken, async (req, res) => {
  const firebaseUid = req.firebaseUid;
  
  try {
    const [records] = await pool.query(
      'SELECT * FROM meal_records WHERE firebase_uid = ? ORDER BY timestamp DESC LIMIT 100',
      [firebaseUid]
    );
    
    res.json(records);
  } catch (err) {
    logger.error('Error fetching meal records:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * Get a specific meal record by ID
 */
router.get('/:mealId', verifyFirebaseToken, async (req, res) => {
  const firebaseUid = req.firebaseUid;
  const mealId = req.params.mealId;
  
  try {
    const [records] = await pool.query(
      'SELECT * FROM meal_records WHERE meal_id = ? AND firebase_uid = ?',
      [mealId, firebaseUid]
    );
    
    if (records.length === 0) {
      return res.status(404).json({ error: 'Meal record not found' });
    }
    
    res.json(records[0]);
  } catch (err) {
    logger.error('Error fetching meal record:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * Create a new meal record
 */
router.post('/', verifyFirebaseToken, async (req, res) => {
  const firebaseUid = req.firebaseUid;
  const { meal_name, carbohydrates } = req.body;
  
  try {
    const [result] = await pool.query(
      'INSERT INTO meal_records (firebase_uid, meal_name, carbohydrates) VALUES (?, ?, ?)',
      [firebaseUid, meal_name, carbohydrates]
    );
    
    logger.info(`Created new meal record for user ${firebaseUid}`);
    res.status(201).json({ id: result.insertId });
  } catch (err) {
    logger.error('Error creating meal record:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * Update an existing meal record
 */
router.put('/:mealId', verifyFirebaseToken, async (req, res) => {
  const firebaseUid = req.firebaseUid;
  const mealId = req.params.mealId;
  const { meal_name, carbohydrates } = req.body;
  
  try {
    // First check if the record exists and belongs to the user
    const [records] = await pool.query(
      'SELECT * FROM meal_records WHERE meal_id = ? AND firebase_uid = ?',
      [mealId, firebaseUid]
    );
    
    if (records.length === 0) {
      return res.status(404).json({ error: 'Meal record not found' });
    }
    
    // Update the record
    await pool.query(
      'UPDATE meal_records SET meal_name = ?, carbohydrates = ? WHERE meal_id = ? AND firebase_uid = ?',
      [meal_name, carbohydrates, mealId, firebaseUid]
    );
    
    logger.info(`Updated meal record ${mealId} for user ${firebaseUid}`);
    res.json({ success: true });
  } catch (err) {
    logger.error('Error updating meal record:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * Delete a meal record
 */
router.delete('/:mealId', verifyFirebaseToken, async (req, res) => {
  const firebaseUid = req.firebaseUid;
  const mealId = req.params.mealId;
  
  try {
    // First check if the record exists and belongs to the user
    const [records] = await pool.query(
      'SELECT * FROM meal_records WHERE meal_id = ? AND firebase_uid = ?',
      [mealId, firebaseUid]
    );
    
    if (records.length === 0) {
      return res.status(404).json({ error: 'Meal record not found' });
    }
    
    // Delete the record
    await pool.query(
      'DELETE FROM meal_records WHERE meal_id = ? AND firebase_uid = ?',
      [mealId, firebaseUid]
    );
    
    logger.info(`Deleted meal record ${mealId} for user ${firebaseUid}`);
    res.json({ success: true });
  } catch (err) {
    logger.error('Error deleting meal record:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;

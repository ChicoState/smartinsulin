const express = require('express');
const router = express.Router();
const { pool } = require('../utils/db');
const { verifyFirebaseToken } = require('../middleware/auth');
const logger = require('../utils/logger');

/**
 * Get all insulin records for the authenticated user
 */
router.get('/', verifyFirebaseToken, async (req, res) => {
  const firebaseUid = req.firebaseUid;
  
  try {
    const [records] = await pool.query(
      'SELECT * FROM insulin_records WHERE firebase_uid = ? ORDER BY timestamp DESC LIMIT 100',
      [firebaseUid]
    );
    
    res.json(records);
  } catch (err) {
    logger.error('Error fetching insulin records:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * Get a specific insulin record by ID
 */
router.get('/:recordId', verifyFirebaseToken, async (req, res) => {
  const firebaseUid = req.firebaseUid;
  const recordId = req.params.recordId;
  
  try {
    const [records] = await pool.query(
      'SELECT * FROM insulin_records WHERE record_id = ? AND firebase_uid = ?',
      [recordId, firebaseUid]
    );
    
    if (records.length === 0) {
      return res.status(404).json({ error: 'Record not found' });
    }
    
    res.json(records[0]);
  } catch (err) {
    logger.error('Error fetching insulin record:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * Create a new insulin record
 */
router.post('/', verifyFirebaseToken, async (req, res) => {
  const firebaseUid = req.firebaseUid;
  const { insulin_units, blood_glucose_level, notes } = req.body;
  
  try {
    const [result] = await pool.query(
      'INSERT INTO insulin_records (firebase_uid, insulin_units, blood_glucose_level, notes) VALUES (?, ?, ?, ?)',
      [firebaseUid, insulin_units, blood_glucose_level, notes]
    );
    
    logger.info(`Created new insulin record for user ${firebaseUid}`);
    res.status(201).json({ id: result.insertId });
  } catch (err) {
    logger.error('Error creating insulin record:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * Update an existing insulin record
 */
router.put('/:recordId', verifyFirebaseToken, async (req, res) => {
  const firebaseUid = req.firebaseUid;
  const recordId = req.params.recordId;
  const { insulin_units, blood_glucose_level, notes } = req.body;
  
  try {
    // First check if the record exists and belongs to the user
    const [records] = await pool.query(
      'SELECT * FROM insulin_records WHERE record_id = ? AND firebase_uid = ?',
      [recordId, firebaseUid]
    );
    
    if (records.length === 0) {
      return res.status(404).json({ error: 'Record not found' });
    }
    
    // Update the record
    await pool.query(
      'UPDATE insulin_records SET insulin_units = ?, blood_glucose_level = ?, notes = ? WHERE record_id = ? AND firebase_uid = ?',
      [insulin_units, blood_glucose_level, notes, recordId, firebaseUid]
    );
    
    logger.info(`Updated insulin record ${recordId} for user ${firebaseUid}`);
    res.json({ success: true });
  } catch (err) {
    logger.error('Error updating insulin record:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * Delete an insulin record
 */
router.delete('/:recordId', verifyFirebaseToken, async (req, res) => {
  const firebaseUid = req.firebaseUid;
  const recordId = req.params.recordId;
  
  try {
    // First check if the record exists and belongs to the user
    const [records] = await pool.query(
      'SELECT * FROM insulin_records WHERE record_id = ? AND firebase_uid = ?',
      [recordId, firebaseUid]
    );
    
    if (records.length === 0) {
      return res.status(404).json({ error: 'Record not found' });
    }
    
    // Delete the record
    await pool.query(
      'DELETE FROM insulin_records WHERE record_id = ? AND firebase_uid = ?',
      [recordId, firebaseUid]
    );
    
    logger.info(`Deleted insulin record ${recordId} for user ${firebaseUid}`);
    res.json({ success: true });
  } catch (err) {
    logger.error('Error deleting insulin record:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;

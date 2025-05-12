const admin = require('firebase-admin');
const serviceAccount = require('../firebase-service-account.json');
const logger = require('../utils/logger');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: process.env.FIREBASE_DATABASE_URL
});

/**
 * To verify Firebase ID token
 * This will be used to protect routes that require authentication
 */
const verifyFirebaseToken = async (req, res, next) => {
  const authHeader = req.headers.authorization;
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    logger.warn('No Firebase ID token was passed as a Bearer token in the Authorization header');
    return res.status(401).json({ error: 'Unauthorized', message: 'Authentication required' });
  }

  const idToken = authHeader.split('Bearer ')[1];

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    req.user = decodedToken;
    req.firebaseUid = decodedToken.uid;
    next();
  } catch (error) {
    logger.error('Error while verifying Firebase ID token:', error);
    return res.status(401).json({ 
      error: 'Unauthorized', 
      message: 'Invalid authentication token' 
    });
  }
};

module.exports = { verifyFirebaseToken, admin };

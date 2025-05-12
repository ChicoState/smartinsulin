const winston = require('winston');
const path = require('path');

// Define log format
const logFormat = winston.format.combine(
  winston.format.timestamp(),
  winston.format.errors({ stack: true }),
  winston.format.splat(),
  winston.format.json()
);

// Create the logger
const logger = winston.createLogger({
  level: process.env.NODE_ENV === 'production' ? 'info' : 'debug',
  format: logFormat,
  defaultMeta: { service: 'smart-insulin-api' },
  transports: [
    // Console transport for all environments
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.printf(
          info => `${info.timestamp} ${info.level}: ${info.message}`
        )
      )
    }),
    // File transport for production environment
    ...(process.env.NODE_ENV === 'production' ? [
      new winston.transports.File({ 
        filename: path.join(__dirname, '../logs/error.log'), 
        level: 'error' 
      }),
      new winston.transports.File({ 
        filename: path.join(__dirname, '../logs/combined.log') 
      })
    ] : [])
  ]
});

module.exports = logger;

-- Create the database
CREATE DATABASE IF NOT EXISTS smart_insulin_db;
USE smart_insulin_db;

-- Users table to store basic user information
CREATE TABLE users (
    firebase_uid VARCHAR(128) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insulin records table to store insulin intake data
CREATE TABLE insulin_records (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    firebase_uid VARCHAR(128) NOT NULL,
    insulin_units DECIMAL(5,2) NOT NULL,
    blood_glucose_level DECIMAL(5,1),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (firebase_uid) REFERENCES users(firebase_uid)
);

-- Meal records to track food intake
CREATE TABLE meal_records (
    meal_id INT PRIMARY KEY AUTO_INCREMENT,
    firebase_uid VARCHAR(128) NOT NULL,
    meal_name VARCHAR(100),
    carbohydrates DECIMAL(6,2),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (firebase_uid) REFERENCES users(firebase_uid)
);

-- User settings to store preferences and configurations
CREATE TABLE user_settings (
    firebase_uid VARCHAR(128) PRIMARY KEY,
    insulin_sensitivity DECIMAL(5,2),
    carb_ratio DECIMAL(5,2),
    target_glucose_min DECIMAL(5,1),
    target_glucose_max DECIMAL(5,1),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (firebase_uid) REFERENCES users(firebase_uid)
);

-- Default user for testing
INSERT INTO users (firebase_uid, username, email) 
VALUES ('2ntHrOqe1qQKU2kdIeETMbUYyxO2', 'test_user', 'lang.c.bledsoe@gmail.com');

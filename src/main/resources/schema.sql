-- Updated schema.sql (PostgreSQL compatible)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table with all required fields
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    fullname VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) NOT NULL,
    password VARCHAR(255) NOT NULL,
    profile_image VARCHAR(255),
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Feedback table (unchanged)
CREATE TABLE IF NOT EXISTS feedback (
    feedback_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    subject VARCHAR(50) NOT NULL,
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    message TEXT NOT NULL,
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- OTP table (modified for servlet compatibility)
CREATE TABLE IF NOT EXISTS otp (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    otp VARCHAR(6) NOT NULL,
    expiry TIMESTAMP NOT NULL,
    CONSTRAINT fk_email FOREIGN KEY(email) REFERENCES users(email) ON DELETE CASCADE
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone);
CREATE INDEX IF NOT EXISTS idx_otp_email ON otp(email);

-- Add comments for documentation
COMMENT ON TABLE users IS 'Stores user account information';
COMMENT ON COLUMN users.profile_image IS 'Stores relative path to profile images';
COMMENT ON TABLE otp IS 'Stores OTP codes for email verification';

-- Create schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS public;

-- Drop tables if they exist (for clean reinstall)
DROP TABLE IF EXISTS incidents CASCADE;
DROP TABLE IF EXISTS incident_types CASCADE;
DROP TABLE IF EXISTS locations CASCADE;

-- Create locations table first (referenced by incidents)
CREATE TABLE IF NOT EXISTS locations (
    location_id SERIAL PRIMARY KEY,
    location_name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    building VARCHAR(50),
    floor_number INTEGER,
    zone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create incident_types table
CREATE TABLE IF NOT EXISTS incident_types (
    type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    severity_level INTEGER CHECK (severity_level BETWEEN 1 AND 5),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create main incidents table
CREATE TABLE IF NOT EXISTS incidents (
    incident_id SERIAL PRIMARY KEY,
    incident_timestamp TIMESTAMP NOT NULL,
    location_id INTEGER REFERENCES locations(location_id) ON DELETE SET NULL,
    incident_type_id INTEGER REFERENCES incident_types(type_id) ON DELETE SET NULL,
    severity INTEGER CHECK (severity BETWEEN 1 AND 5),
    description TEXT,
    employee_id VARCHAR(20),
    injuries_reported BOOLEAN DEFAULT FALSE,
    property_damage BOOLEAN DEFAULT FALSE,
    estimated_cost DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'open',
    reported_by VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_incidents_timestamp ON incidents(incident_timestamp);
CREATE INDEX IF NOT EXISTS idx_incidents_location ON incidents(location_id);
CREATE INDEX IF NOT EXISTS idx_incidents_type ON incidents(incident_type_id);


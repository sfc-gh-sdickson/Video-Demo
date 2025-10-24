/*******************************************************************************
 * SNOWFLAKE VIDEO INTELLIGENCE DEMO - INITIAL SETUP
 * 
 * This script sets up the foundational objects needed for the Video Demo:
 * - Database and Schema
 * - File Format for video files
 * - Internal Stage for video storage
 * - Warehouse for compute
 * 
 * Run this script as ACCOUNTADMIN or a role with sufficient privileges
 ******************************************************************************/

-- Use appropriate role
USE ROLE ACCOUNTADMIN;

-- Create Database
CREATE DATABASE IF NOT EXISTS VIDEO_INTELLIGENCE_DB
    COMMENT = 'Database for Snowflake Video Intelligence Demo';

-- Use the database
USE DATABASE VIDEO_INTELLIGENCE_DB;

-- Create Schema
CREATE SCHEMA IF NOT EXISTS VIDEO_ANALYSIS
    COMMENT = 'Schema for video analysis objects';

-- Use the schema
USE SCHEMA VIDEO_ANALYSIS;

-- Create Warehouse for compute (adjust size based on your needs)
CREATE WAREHOUSE IF NOT EXISTS VIDEO_ANALYSIS_WH
    WITH
    WAREHOUSE_SIZE = 'LARGE'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for video processing and analysis';

-- Use the warehouse
USE WAREHOUSE VIDEO_ANALYSIS_WH;

-- Create file format for video files (binary format)
CREATE OR REPLACE FILE FORMAT VIDEO_FILE_FORMAT
    TYPE = 'CSV'
    RECORD_DELIMITER = NONE
    FIELD_DELIMITER = NONE
    COMMENT = 'File format for storing video files as binary';

-- Create internal stage for video files
CREATE OR REPLACE STAGE VIDEO_FILES
    FILE_FORMAT = VIDEO_FILE_FORMAT
    DIRECTORY = (ENABLE = TRUE)
    COMMENT = 'Internal stage for storing video files';

-- Grant usage on warehouse
GRANT USAGE ON WAREHOUSE VIDEO_ANALYSIS_WH TO ROLE SYSADMIN;
GRANT OPERATE ON WAREHOUSE VIDEO_ANALYSIS_WH TO ROLE SYSADMIN;

-- Grant permissions on database objects
GRANT USAGE ON DATABASE VIDEO_INTELLIGENCE_DB TO ROLE SYSADMIN;
GRANT USAGE ON SCHEMA VIDEO_ANALYSIS TO ROLE SYSADMIN;
GRANT READ, WRITE ON STAGE VIDEO_FILES TO ROLE SYSADMIN;

-- Display success message
SELECT 'Initial setup completed successfully!' AS STATUS;
SELECT 'Database: VIDEO_INTELLIGENCE_DB' AS INFO
UNION ALL
SELECT 'Schema: VIDEO_ANALYSIS'
UNION ALL
SELECT 'Warehouse: VIDEO_ANALYSIS_WH'
UNION ALL
SELECT 'Stage: VIDEO_FILES';


/*******************************************************************************
 * SAMPLE QUERIES FOR SNOWFLAKE VIDEO INTELLIGENCE DEMO
 * 
 * This file contains example SQL queries demonstrating various capabilities
 * of the Video Intelligence system.
 ******************************************************************************/

USE DATABASE VIDEO_INTELLIGENCE_DB;
USE SCHEMA VIDEO_ANALYSIS;
USE WAREHOUSE VIDEO_ANALYSIS_WH;

-- =============================================================================
-- SECTION 1: VIDEO METADATA QUERIES
-- =============================================================================

-- Query 1: List all uploaded videos
SELECT 
    VIDEO_ID,
    FILE_NAME,
    FILE_SIZE_BYTES / (1024*1024) AS FILE_SIZE_MB,
    UPLOAD_TIMESTAMP,
    PROCESSED,
    CREATED_BY
FROM VIDEO_METADATA
ORDER BY UPLOAD_TIMESTAMP DESC;

-- Query 2: Get total storage usage
SELECT 
    COUNT(*) AS TOTAL_VIDEOS,
    SUM(FILE_SIZE_BYTES) / (1024*1024) AS TOTAL_SIZE_MB,
    SUM(FILE_SIZE_BYTES) / (1024*1024*1024) AS TOTAL_SIZE_GB,
    MIN(UPLOAD_TIMESTAMP) AS FIRST_UPLOAD,
    MAX(UPLOAD_TIMESTAMP) AS LAST_UPLOAD
FROM VIDEO_METADATA;

-- Query 3: Find largest videos
SELECT 
    FILE_NAME,
    FILE_SIZE_BYTES / (1024*1024) AS FILE_SIZE_MB,
    UPLOAD_TIMESTAMP
FROM VIDEO_METADATA
ORDER BY FILE_SIZE_BYTES DESC
LIMIT 10;

-- Query 4: Videos uploaded today
SELECT 
    FILE_NAME,
    UPLOAD_TIMESTAMP,
    CREATED_BY
FROM VIDEO_METADATA
WHERE DATE(UPLOAD_TIMESTAMP) = CURRENT_DATE()
ORDER BY UPLOAD_TIMESTAMP DESC;

-- =============================================================================
-- SECTION 2: ANALYSIS QUERIES USING CORTEX AI
-- =============================================================================

-- Query 5: Analyze a specific video with Cortex
-- Replace 'your_video.mp4' with your actual video filename
SELECT 
    vm.FILE_NAME,
    SNOWFLAKE.CORTEX.COMPLETE(
        'mistral-large2',
        'Describe a security entrance video showing people entering a building.'
    ) AS ANALYSIS
FROM VIDEO_METADATA vm
WHERE vm.FILE_NAME = 'your_video.mp4';

-- Query 6: Count people in all videos
SELECT 
    vm.FILE_NAME,
    SNOWFLAKE.CORTEX.COMPLETE(
        'mistral-large2',
        'How many people would typically be in a ' || vm.FILE_NAME || ' security footage?'
    ) AS PEOPLE_COUNT
FROM VIDEO_METADATA vm
LIMIT 5;

-- Query 7: Security analysis - badge swiping
SELECT 
    vm.FILE_NAME,
    SNOWFLAKE.CORTEX.COMPLETE(
        'claude-3-5-sonnet',
        'In a security video at a building entrance, what are the key indicators that someone properly used badge access versus tailgating?'
    ) AS SECURITY_ANALYSIS
FROM VIDEO_METADATA vm
WHERE vm.FILE_NAME LIKE '%entrance%'
LIMIT 1;

-- Query 8: General video description
SELECT 
    vm.FILE_NAME,
    SNOWFLAKE.CORTEX.COMPLETE(
        'llama3.1-405b',
        'Provide a detailed description of what would be expected in a corporate security entrance video.'
    ) AS VIDEO_DESCRIPTION
FROM VIDEO_METADATA vm
LIMIT 1;

-- =============================================================================
-- SECTION 3: QUERY HISTORY AND ANALYTICS
-- =============================================================================

-- Query 9: View all queries for a specific video
SELECT 
    vq.QUESTION,
    vq.ANSWER,
    vq.MODEL_USED,
    vq.RESPONSE_TIME_MS,
    vq.CREATED_AT,
    vq.CREATED_BY
FROM VIDEO_QUERIES vq
JOIN VIDEO_METADATA vm ON vq.VIDEO_ID = vm.VIDEO_ID
WHERE vm.FILE_NAME = 'your_video.mp4'
ORDER BY vq.CREATED_AT DESC;

-- Query 10: Most common questions asked
SELECT 
    vq.QUESTION,
    COUNT(*) AS TIMES_ASKED,
    AVG(vq.RESPONSE_TIME_MS) AS AVG_RESPONSE_TIME_MS,
    MIN(vq.CREATED_AT) AS FIRST_ASKED,
    MAX(vq.CREATED_AT) AS LAST_ASKED
FROM VIDEO_QUERIES vq
GROUP BY vq.QUESTION
ORDER BY TIMES_ASKED DESC
LIMIT 10;

-- Query 11: Performance by model
SELECT 
    MODEL_USED,
    COUNT(*) AS QUERY_COUNT,
    AVG(RESPONSE_TIME_MS) AS AVG_RESPONSE_TIME,
    MIN(RESPONSE_TIME_MS) AS MIN_RESPONSE_TIME,
    MAX(RESPONSE_TIME_MS) AS MAX_RESPONSE_TIME
FROM VIDEO_QUERIES
GROUP BY MODEL_USED
ORDER BY QUERY_COUNT DESC;

-- Query 12: Query activity by day
SELECT 
    DATE(CREATED_AT) AS QUERY_DATE,
    COUNT(*) AS QUERY_COUNT,
    COUNT(DISTINCT VIDEO_ID) AS UNIQUE_VIDEOS,
    AVG(RESPONSE_TIME_MS) AS AVG_RESPONSE_TIME
FROM VIDEO_QUERIES
GROUP BY DATE(CREATED_AT)
ORDER BY QUERY_DATE DESC;

-- Query 13: Most analyzed videos
SELECT 
    vm.FILE_NAME,
    vm.UPLOAD_TIMESTAMP,
    COUNT(vq.QUERY_ID) AS TOTAL_QUERIES,
    MIN(vq.CREATED_AT) AS FIRST_QUERY,
    MAX(vq.CREATED_AT) AS LAST_QUERY
FROM VIDEO_METADATA vm
LEFT JOIN VIDEO_QUERIES vq ON vm.VIDEO_ID = vq.VIDEO_ID
GROUP BY vm.VIDEO_ID, vm.FILE_NAME, vm.UPLOAD_TIMESTAMP
ORDER BY TOTAL_QUERIES DESC
LIMIT 10;

-- =============================================================================
-- SECTION 4: USING STORED PROCEDURES
-- =============================================================================

-- Query 14: Register a new video manually
CALL REGISTER_VIDEO(
    'test_video.mp4',
    '@VIDEO_FILES/test_video.mp4',
    10485760  -- 10MB in bytes
);

-- Query 15: Log a manual query
-- First, get a VIDEO_ID
SET video_id = (SELECT VIDEO_ID FROM VIDEO_METADATA WHERE FILE_NAME = 'test_video.mp4' LIMIT 1);

CALL LOG_VIDEO_QUERY(
    $video_id,
    'How many people are in the video?',
    'There are 3 people visible in the video.',
    'mistral-large2',
    1250
);

-- Query 16: Store analysis results
CALL STORE_ANALYSIS_RESULT(
    $video_id,
    'people_counting',
    0,
    PARSE_JSON('{"people_count": 3, "confidence": 0.95}'),
    0.95
);

-- =============================================================================
-- SECTION 5: ADVANCED ANALYTICS
-- =============================================================================

-- Query 17: Video summary view
SELECT * FROM VIDEO_SUMMARY
ORDER BY TOTAL_QUERIES DESC;

-- Query 18: User activity report
SELECT 
    CREATED_BY,
    COUNT(DISTINCT vq.VIDEO_ID) AS VIDEOS_ANALYZED,
    COUNT(*) AS TOTAL_QUERIES,
    AVG(vq.RESPONSE_TIME_MS) AS AVG_RESPONSE_TIME,
    MIN(vq.CREATED_AT) AS FIRST_ACTIVITY,
    MAX(vq.CREATED_AT) AS LAST_ACTIVITY
FROM VIDEO_QUERIES vq
GROUP BY CREATED_BY
ORDER BY TOTAL_QUERIES DESC;

-- Query 19: Videos without any analysis
SELECT 
    vm.FILE_NAME,
    vm.UPLOAD_TIMESTAMP,
    vm.FILE_SIZE_BYTES / (1024*1024) AS FILE_SIZE_MB
FROM VIDEO_METADATA vm
LEFT JOIN VIDEO_QUERIES vq ON vm.VIDEO_ID = vq.VIDEO_ID
WHERE vq.QUERY_ID IS NULL
ORDER BY vm.UPLOAD_TIMESTAMP DESC;

-- Query 20: Response time percentiles
SELECT 
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY RESPONSE_TIME_MS) AS MEDIAN_MS,
    PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY RESPONSE_TIME_MS) AS P90_MS,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY RESPONSE_TIME_MS) AS P95_MS,
    PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY RESPONSE_TIME_MS) AS P99_MS
FROM VIDEO_QUERIES;

-- =============================================================================
-- SECTION 6: SECURITY USE CASES
-- =============================================================================

-- Query 21: Badge access compliance analysis
SELECT 
    vm.FILE_NAME,
    SNOWFLAKE.CORTEX.COMPLETE(
        'claude-3-5-sonnet',
        'Analyze a security entrance video for the following: 
        1. Did each person individually swipe their badge?
        2. Was there any tailgating (people entering without swiping)?
        3. Were there any security violations?
        Provide a detailed compliance report.'
    ) AS COMPLIANCE_REPORT
FROM VIDEO_METADATA vm
WHERE vm.FILE_NAME LIKE '%entrance%'
   OR vm.FILE_NAME LIKE '%security%'
LIMIT 1;

-- Query 22: Unusual activity detection
SELECT 
    vm.FILE_NAME,
    SNOWFLAKE.CORTEX.COMPLETE(
        'claude-3-5-sonnet',
        'Review this security video and identify any unusual or suspicious activities. 
        Look for: unauthorized access attempts, loitering, unusual behavior patterns, 
        or any safety concerns.'
    ) AS UNUSUAL_ACTIVITY_REPORT
FROM VIDEO_METADATA vm
LIMIT 5;

-- =============================================================================
-- SECTION 7: CLEANUP QUERIES
-- =============================================================================

-- Query 23: Delete old query history (older than 90 days)
-- CAUTION: This permanently deletes data
-- DELETE FROM VIDEO_QUERIES
-- WHERE CREATED_AT < DATEADD(DAY, -90, CURRENT_TIMESTAMP());

-- Query 24: Archive old videos (mark as archived, don't delete)
-- Add an ARCHIVED column first if needed
-- UPDATE VIDEO_METADATA
-- SET PROCESSED = FALSE
-- WHERE UPLOAD_TIMESTAMP < DATEADD(DAY, -180, CURRENT_TIMESTAMP());

-- Query 25: Clean up test data
-- DELETE FROM VIDEO_METADATA WHERE FILE_NAME LIKE 'test_%';
-- DELETE FROM VIDEO_QUERIES WHERE QUESTION LIKE '%test%';

-- =============================================================================
-- SECTION 8: PERFORMANCE MONITORING
-- =============================================================================

-- Query 26: Check warehouse utilization
SELECT 
    WAREHOUSE_NAME,
    AVG(AVG_RUNNING) AS AVG_RUNNING_QUERIES,
    AVG(AVG_QUEUED_LOAD) AS AVG_QUEUED,
    MAX(AVG_RUNNING) AS MAX_RUNNING
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_LOAD_HISTORY
WHERE WAREHOUSE_NAME = 'VIDEO_ANALYSIS_WH'
  AND START_TIME >= DATEADD(DAY, -7, CURRENT_TIMESTAMP())
GROUP BY WAREHOUSE_NAME;

-- Query 27: Query performance over time
SELECT 
    DATE_TRUNC('HOUR', START_TIME) AS HOUR,
    COUNT(*) AS QUERY_COUNT,
    AVG(TOTAL_ELAPSED_TIME) AS AVG_DURATION_MS,
    MAX(TOTAL_ELAPSED_TIME) AS MAX_DURATION_MS
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE WAREHOUSE_NAME = 'VIDEO_ANALYSIS_WH'
  AND START_TIME >= DATEADD(DAY, -7, CURRENT_TIMESTAMP())
GROUP BY HOUR
ORDER BY HOUR DESC;

-- Query 28: Credit consumption
SELECT 
    DATE(START_TIME) AS DAY,
    SUM(CREDITS_USED) AS TOTAL_CREDITS,
    AVG(CREDITS_USED) AS AVG_CREDITS_PER_QUERY
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
WHERE WAREHOUSE_NAME = 'VIDEO_ANALYSIS_WH'
  AND START_TIME >= DATEADD(DAY, -30, CURRENT_TIMESTAMP())
GROUP BY DAY
ORDER BY DAY DESC;

-- =============================================================================
-- SECTION 9: BATCH OPERATIONS
-- =============================================================================

-- Query 29: Batch analyze multiple videos
SELECT 
    vm.FILE_NAME,
    SNOWFLAKE.CORTEX.COMPLETE(
        'mistral-large2',
        'Provide a one-sentence summary of what this video likely contains based on its filename: ' || vm.FILE_NAME
    ) AS QUICK_SUMMARY
FROM VIDEO_METADATA vm
WHERE vm.UPLOAD_TIMESTAMP >= DATEADD(DAY, -1, CURRENT_TIMESTAMP())
ORDER BY vm.UPLOAD_TIMESTAMP DESC;

-- Query 30: Export results to table for reporting
CREATE OR REPLACE TABLE BATCH_ANALYSIS_RESULTS AS
SELECT 
    vm.VIDEO_ID,
    vm.FILE_NAME,
    vm.UPLOAD_TIMESTAMP,
    COUNT(DISTINCT vq.QUERY_ID) AS TOTAL_QUERIES,
    MAX(vq.CREATED_AT) AS LAST_ANALYZED,
    LISTAGG(DISTINCT vq.MODEL_USED, ', ') AS MODELS_USED
FROM VIDEO_METADATA vm
LEFT JOIN VIDEO_QUERIES vq ON vm.VIDEO_ID = vq.VIDEO_ID
GROUP BY vm.VIDEO_ID, vm.FILE_NAME, vm.UPLOAD_TIMESTAMP;

-- View the results
SELECT * FROM BATCH_ANALYSIS_RESULTS
ORDER BY TOTAL_QUERIES DESC;

-- =============================================================================
-- END OF SAMPLE QUERIES
-- =============================================================================

/*
NOTES:
- Replace 'your_video.mp4' with actual filenames in your database
- Adjust model names based on your Cortex availability
- Monitor credit usage when running batch queries
- Uncomment DELETE statements only after verifying the WHERE clause
- Some queries use SNOWFLAKE.ACCOUNT_USAGE views which may require ACCOUNTADMIN

For more information, see:
- README.md for feature overview
- INSTALLATION_GUIDE.md for setup instructions
- Snowflake Cortex documentation: https://docs.snowflake.com/en/user-guide/snowflake-cortex
*/


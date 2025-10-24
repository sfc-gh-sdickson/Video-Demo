<img src="diagrams/Snowflake_Logo.svg" alt="Snowflake Logo" width="200"/>

# Snowflake Video Intelligence Demo - Installation Guide

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Step-by-Step Installation](#step-by-step-installation)
3. [Configuration](#configuration)
4. [Deployment](#deployment)
5. [Verification](#verification)
6. [Troubleshooting](#troubleshooting)

---

## Prerequisites

Before you begin, ensure you have:

### Snowflake Account Requirements
- ✅ Snowflake account with ACCOUNTADMIN privileges (or equivalent)
- ✅ Access to Snowflake Cortex AI features
- ✅ Streamlit in Snowflake enabled (available in all regions)
- ✅ Sufficient credits for compute (LARGE warehouse recommended)

### Access Requirements
- ✅ Snowflake account URL (e.g., `https://xyz12345.snowflakecomputing.com`)
- ✅ Username and password or SSO access
- ✅ Permission to create databases, schemas, and warehouses

### Supported Regions
This demo works in all Snowflake regions that support:
- Snowflake Cortex AI
- Streamlit in Snowflake

---

## Step-by-Step Installation

### Step 1: Connect to Snowflake

1. Open your Snowflake web interface
2. Log in with ACCOUNTADMIN role or equivalent
3. Navigate to **Worksheets**

```sql
-- Verify you have the right role
USE ROLE ACCOUNTADMIN;
SELECT CURRENT_ROLE();
```

### Step 2: Run Initial Setup Script

1. Create a new SQL worksheet in Snowflake
2. Copy the contents of `setup/01_initial_setup.sql`
3. Execute the entire script

**Script creates:**
- Database: `VIDEO_INTELLIGENCE_DB`
- Schema: `VIDEO_ANALYSIS`
- Warehouse: `VIDEO_ANALYSIS_WH` (LARGE, auto-suspend 60s)
- Stage: `VIDEO_FILES`
- File format: `VIDEO_FILE_FORMAT`

**Execution:**
```sql
-- Copy and paste contents from setup/01_initial_setup.sql
-- Then click "Run All" or press Cmd+Enter (Mac) / Ctrl+Enter (Windows)
```

**Expected Output:**
```
STATUS: Initial setup completed successfully!
Database: VIDEO_INTELLIGENCE_DB
Schema: VIDEO_ANALYSIS
Warehouse: VIDEO_ANALYSIS_WH
Stage: VIDEO_FILES
```

**⏱️ Estimated time:** 30-60 seconds

### Step 3: Create Tables

1. Create a new SQL worksheet or continue in the same one
2. Copy the contents of `setup/02_create_tables.sql`
3. Execute the script

**Script creates:**
- Table: `VIDEO_METADATA` - Stores video file information
- Table: `VIDEO_ANALYSIS_RESULTS` - Stores AI analysis results
- Table: `VIDEO_QUERIES` - Stores user questions and answers
- Indexes for query performance

**Execution:**
```sql
-- Copy and paste contents from setup/02_create_tables.sql
-- Then click "Run All"
```

**Expected Output:**
```
STATUS: Tables created successfully!
TABLE_NAME              ROW_COUNT
VIDEO_METADATA          0
VIDEO_ANALYSIS_RESULTS  0
VIDEO_QUERIES           0
```

**⏱️ Estimated time:** 30 seconds

### Step 4: Create Functions and Procedures

1. Create a new SQL worksheet
2. Copy the contents of `setup/03_create_functions.sql`
3. Execute the script

**Script creates:**
- Stored Procedure: `REGISTER_VIDEO` - Register uploaded videos
- Stored Procedure: `LOG_VIDEO_QUERY` - Log AI queries
- Stored Procedure: `STORE_ANALYSIS_RESULT` - Store analysis results
- Function: `GET_VIDEO_STATS` - Retrieve video statistics
- View: `VIDEO_SUMMARY` - Summary view of all videos

**Execution:**
```sql
-- Copy and paste contents from setup/03_create_functions.sql
-- Then click "Run All"
```

**Expected Output:**
```
STATUS: Functions and procedures created successfully!
```

**⏱️ Estimated time:** 30 seconds

### Step 5: Verify Cortex AI Access

Verify that Snowflake Cortex is available in your account:

```sql
-- Test Cortex Complete function
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'mistral-large2',
    'Say "Cortex AI is working!" if you can read this.'
) AS test_response;
```

**Expected Output:**
```
TEST_RESPONSE
Cortex AI is working!
```

If you get an error, contact your Snowflake account team to enable Cortex AI.

### Step 6: Deploy Streamlit Application

#### Option A: Using Snowsight UI (Recommended)

1. In Snowflake, navigate to **Streamlit** in the left sidebar
2. Click **+ Streamlit App**
3. Configure the app:
   - **App name:** `Video Intelligence Demo`
   - **Warehouse:** `VIDEO_ANALYSIS_WH`
   - **App location:**
     - Database: `VIDEO_INTELLIGENCE_DB`
     - Schema: `VIDEO_ANALYSIS`

4. Replace the default code with the contents of `streamlit_app.py`
5. Click **Run** (top right)

**⏱️ Estimated time:** 2 minutes

#### Option B: Using SnowSQL (Advanced)

```bash
# Connect to Snowflake
snow sql

# Create Streamlit app
CREATE STREAMLIT VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.VIDEO_INTELLIGENCE_APP
  ROOT_LOCATION = '@VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.STREAMLIT_STAGE'
  MAIN_FILE = 'streamlit_app.py'
  QUERY_WAREHOUSE = VIDEO_ANALYSIS_WH;

# Upload the Streamlit app file
PUT file:///path/to/streamlit_app.py @VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.STREAMLIT_STAGE AUTO_COMPRESS=FALSE OVERWRITE=TRUE;
```

### Step 7: Grant Access to Users

Grant permissions to other users/roles:

```sql
-- Grant usage on database and schema
GRANT USAGE ON DATABASE VIDEO_INTELLIGENCE_DB TO ROLE <YOUR_ROLE>;
GRANT USAGE ON SCHEMA VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS TO ROLE <YOUR_ROLE>;

-- Grant usage on warehouse
GRANT USAGE ON WAREHOUSE VIDEO_ANALYSIS_WH TO ROLE <YOUR_ROLE>;

-- Grant table permissions
GRANT SELECT, INSERT ON TABLE VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.VIDEO_METADATA TO ROLE <YOUR_ROLE>;
GRANT SELECT, INSERT ON TABLE VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.VIDEO_QUERIES TO ROLE <YOUR_ROLE>;
GRANT SELECT, INSERT ON TABLE VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.VIDEO_ANALYSIS_RESULTS TO ROLE <YOUR_ROLE>;

-- Grant stage permissions
GRANT READ, WRITE ON STAGE VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.VIDEO_FILES TO ROLE <YOUR_ROLE>;

-- Grant procedure execute permissions
GRANT USAGE ON PROCEDURE VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.REGISTER_VIDEO(VARCHAR, VARCHAR, NUMBER) TO ROLE <YOUR_ROLE>;
GRANT USAGE ON PROCEDURE VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.LOG_VIDEO_QUERY(VARCHAR, TEXT, TEXT, VARCHAR, NUMBER) TO ROLE <YOUR_ROLE>;
```

---

## Configuration

### Warehouse Sizing

The default warehouse is **LARGE**. Adjust based on your needs:

```sql
-- For lighter workloads
ALTER WAREHOUSE VIDEO_ANALYSIS_WH SET WAREHOUSE_SIZE = 'MEDIUM';

-- For heavier workloads with many concurrent users
ALTER WAREHOUSE VIDEO_ANALYSIS_WH SET WAREHOUSE_SIZE = 'X-LARGE';

-- For development/testing
ALTER WAREHOUSE VIDEO_ANALYSIS_WH SET WAREHOUSE_SIZE = 'SMALL';
```

### Cortex Model Selection

Available models (in the Streamlit app settings):
- **mistral-large2** - Fast, cost-effective (default)
- **llama3.1-405b** - High quality, slower
- **claude-3-5-sonnet** - Best for complex reasoning

Configure in the Streamlit app sidebar.

### Storage Configuration

```sql
-- Check stage storage usage
SELECT 
    STAGE_CATALOG_NAME,
    STAGE_SCHEMA_NAME,
    STAGE_NAME,
    STAGE_TYPE,
    COUNT(*) AS FILE_COUNT
FROM SNOWFLAKE.ACCOUNT_USAGE.STAGES
WHERE STAGE_NAME = 'VIDEO_FILES'
GROUP BY 1,2,3,4;
```

---

## Deployment

### Production Deployment Checklist

- [ ] Set up resource monitors for cost control
- [ ] Configure auto-suspend and auto-resume for warehouse
- [ ] Set up user roles and permissions
- [ ] Enable query result caching
- [ ] Configure network policies if needed
- [ ] Set up monitoring and alerts
- [ ] Document backup and recovery procedures

### Resource Monitor Setup

```sql
-- Create resource monitor for cost control
CREATE RESOURCE MONITOR VIDEO_ANALYSIS_MONITOR
  WITH 
    CREDIT_QUOTA = 100  -- Adjust based on your budget
    FREQUENCY = MONTHLY
    START_TIMESTAMP = IMMEDIATELY
    TRIGGERS 
      ON 75 PERCENT DO NOTIFY
      ON 90 PERCENT DO SUSPEND
      ON 100 PERCENT DO SUSPEND_IMMEDIATE;

-- Assign to warehouse
ALTER WAREHOUSE VIDEO_ANALYSIS_WH 
  SET RESOURCE_MONITOR = VIDEO_ANALYSIS_MONITOR;
```

### Network Policy (Optional)

```sql
-- Create network policy to restrict access by IP
CREATE NETWORK POLICY VIDEO_ANALYSIS_NETWORK_POLICY
  ALLOWED_IP_LIST = ('192.168.1.0/24', '10.0.0.0/8')
  COMMENT = 'Network policy for Video Analysis app';

-- Apply to account or user
ALTER ACCOUNT SET NETWORK_POLICY = VIDEO_ANALYSIS_NETWORK_POLICY;
```

---

## Verification

### Test the Complete Installation

#### 1. Verify Database Objects

```sql
-- List all created objects
USE DATABASE VIDEO_INTELLIGENCE_DB;
USE SCHEMA VIDEO_ANALYSIS;

-- Tables
SHOW TABLES;

-- Expected: VIDEO_METADATA, VIDEO_ANALYSIS_RESULTS, VIDEO_QUERIES

-- Procedures
SHOW PROCEDURES;

-- Expected: REGISTER_VIDEO, LOG_VIDEO_QUERY, STORE_ANALYSIS_RESULT

-- Views
SHOW VIEWS;

-- Expected: VIDEO_SUMMARY

-- Stage
SHOW STAGES;

-- Expected: VIDEO_FILES
```

#### 2. Test Stored Procedures

```sql
-- Test REGISTER_VIDEO procedure
CALL REGISTER_VIDEO('test_video.mp4', '@VIDEO_FILES/test_video.mp4', 1048576);

-- Verify insertion
SELECT * FROM VIDEO_METADATA WHERE FILE_NAME = 'test_video.mp4';

-- Clean up test data
DELETE FROM VIDEO_METADATA WHERE FILE_NAME = 'test_video.mp4';
```

#### 3. Test Cortex AI Integration

```sql
-- Test video analysis query
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'mistral-large2',
    'Analyze this scenario: A person approaches a security door. Describe what security measures should be checked.'
) AS analysis_result;
```

#### 4. Test Streamlit App

1. Open the Streamlit app in Snowflake
2. Verify all tabs load correctly:
   - 📤 Upload Video
   - 🔍 Analyze Video
   - 📊 History
   - 📈 Analytics
3. Try uploading a test video (small MP4 file recommended)
4. Ask a test question about the video
5. Check that the query appears in the History tab

---

## Troubleshooting

### Common Issues and Solutions

#### Issue 1: "Cortex AI not available"

**Error:** `CORTEX.COMPLETE function not found`

**Solution:**
```sql
-- Verify Cortex is enabled in your region
SELECT SYSTEM$FEATURE_ENABLED('CORTEX') AS CORTEX_ENABLED;

-- If FALSE, contact Snowflake support to enable Cortex AI
```

#### Issue 2: "Insufficient privileges"

**Error:** `Insufficient privileges to operate on...`

**Solution:**
```sql
-- Grant necessary privileges
USE ROLE ACCOUNTADMIN;
GRANT ALL PRIVILEGES ON DATABASE VIDEO_INTELLIGENCE_DB TO ROLE SYSADMIN;
GRANT ALL PRIVILEGES ON SCHEMA VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS TO ROLE SYSADMIN;
```

#### Issue 3: "Warehouse not found"

**Error:** `Object does not exist`

**Solution:**
```sql
-- Verify warehouse exists
SHOW WAREHOUSES LIKE 'VIDEO_ANALYSIS_WH';

-- Create if missing
CREATE WAREHOUSE VIDEO_ANALYSIS_WH
  WITH WAREHOUSE_SIZE = 'LARGE'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE;
```

#### Issue 4: "Stage upload fails"

**Error:** `Cannot upload to stage`

**Solution:**
```sql
-- Verify stage permissions
SHOW GRANTS ON STAGE VIDEO_FILES;

-- Grant write access
GRANT READ, WRITE ON STAGE VIDEO_FILES TO ROLE <YOUR_ROLE>;
```

#### Issue 5: "Streamlit app won't start"

**Symptoms:** App shows loading screen indefinitely

**Solution:**
1. Check warehouse is running:
   ```sql
   SHOW WAREHOUSES;
   -- Verify VIDEO_ANALYSIS_WH state is "STARTED" or "RESUMING"
   ```

2. Verify app has correct warehouse assignment:
   ```sql
   ALTER STREAMLIT VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.VIDEO_INTELLIGENCE_APP
     SET QUERY_WAREHOUSE = VIDEO_ANALYSIS_WH;
   ```

3. Check for Python syntax errors in the Streamlit code
4. Review Streamlit logs in Snowsight

#### Issue 6: "Slow query performance"

**Symptoms:** Analysis takes too long

**Solution:**
1. Increase warehouse size:
   ```sql
   ALTER WAREHOUSE VIDEO_ANALYSIS_WH SET WAREHOUSE_SIZE = 'X-LARGE';
   ```

2. Enable result caching:
   ```sql
   ALTER SESSION SET USE_CACHED_RESULT = TRUE;
   ```

3. Check query history for bottlenecks:
   ```sql
   SELECT 
       QUERY_TEXT,
       TOTAL_ELAPSED_TIME,
       EXECUTION_TIME,
       WAREHOUSE_NAME
   FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
   WHERE WAREHOUSE_NAME = 'VIDEO_ANALYSIS_WH'
   ORDER BY START_TIME DESC
   LIMIT 10;
   ```

### Getting Help

If you encounter issues not covered here:

1. **Snowflake Documentation:** https://docs.snowflake.com/en/user-guide/ui-snowsight-streamlit
2. **Cortex AI Documentation:** https://docs.snowflake.com/en/user-guide/snowflake-cortex/llm-functions
3. **Community Support:** https://community.snowflake.com
4. **Snowflake Support:** Open a support case through your Snowflake account

---

## Next Steps

After successful installation:

1. ✅ Upload sample videos to test the system
2. ✅ Configure user roles and permissions
3. ✅ Set up resource monitors for cost control
4. ✅ Train users on the interface
5. ✅ Monitor usage and performance
6. ✅ Customize the UI for your specific use cases

## Maintenance

### Regular Maintenance Tasks

```sql
-- Weekly: Check storage usage
SELECT 
    COUNT(*) AS VIDEO_COUNT,
    SUM(FILE_SIZE_BYTES) / (1024*1024*1024) AS TOTAL_SIZE_GB
FROM VIDEO_METADATA;

-- Monthly: Archive old queries
CREATE TABLE VIDEO_QUERIES_ARCHIVE AS
SELECT * FROM VIDEO_QUERIES
WHERE CREATED_AT < DATEADD(MONTH, -3, CURRENT_TIMESTAMP());

DELETE FROM VIDEO_QUERIES
WHERE CREATED_AT < DATEADD(MONTH, -3, CURRENT_TIMESTAMP());

-- Quarterly: Analyze warehouse performance
SELECT 
    DATE_TRUNC('DAY', START_TIME) AS DAY,
    COUNT(*) AS QUERY_COUNT,
    AVG(TOTAL_ELAPSED_TIME) AS AVG_DURATION_MS
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE WAREHOUSE_NAME = 'VIDEO_ANALYSIS_WH'
  AND START_TIME >= DATEADD(MONTH, -3, CURRENT_TIMESTAMP())
GROUP BY 1
ORDER BY 1 DESC;
```

---

**Installation Complete! 🎉**

Your Snowflake Video Intelligence Demo is now ready to use. Access your Streamlit app through the Snowflake UI under **Streamlit Apps**.


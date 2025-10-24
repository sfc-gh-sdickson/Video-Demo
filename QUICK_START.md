<img src="diagrams/Snowflake_Logo.svg" alt="Snowflake Logo" width="200"/>

# 🚀 Quick Start Guide - Snowflake Video Intelligence Demo

Get up and running in **5 minutes**!

---

## Prerequisites Checklist

Before you begin, make sure you have:

- [ ] Snowflake account with ACCOUNTADMIN access
- [ ] Snowflake Cortex AI enabled (check with your account team)
- [ ] Access to Snowsight (Snowflake's web UI)
- [ ] A test video file (MP4 format, under 100MB recommended)

---

## Step 1: Run Setup Scripts (2 minutes)

### Open Snowflake Snowsight
1. Go to your Snowflake URL (e.g., `https://xyz12345.snowflakecomputing.com`)
2. Log in with your credentials
3. Click on **Projects** > **Worksheets** > **+ Worksheet**

### Execute Setup Script 1: Initial Setup

Copy and paste this entire script into your worksheet:

```sql
-- SETUP SCRIPT 1: Initial Setup
USE ROLE ACCOUNTADMIN;

CREATE DATABASE IF NOT EXISTS VIDEO_INTELLIGENCE_DB;
USE DATABASE VIDEO_INTELLIGENCE_DB;

CREATE SCHEMA IF NOT EXISTS VIDEO_ANALYSIS;
USE SCHEMA VIDEO_ANALYSIS;

CREATE WAREHOUSE IF NOT EXISTS VIDEO_ANALYSIS_WH
  WITH WAREHOUSE_SIZE = 'LARGE'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

USE WAREHOUSE VIDEO_ANALYSIS_WH;

CREATE OR REPLACE FILE FORMAT VIDEO_FILE_FORMAT
  TYPE = 'CSV'
  RECORD_DELIMITER = NONE
  FIELD_DELIMITER = NONE;

CREATE OR REPLACE STAGE VIDEO_FILES
  FILE_FORMAT = VIDEO_FILE_FORMAT
  DIRECTORY = (ENABLE = TRUE);

GRANT USAGE ON WAREHOUSE VIDEO_ANALYSIS_WH TO ROLE SYSADMIN;
GRANT USAGE ON DATABASE VIDEO_INTELLIGENCE_DB TO ROLE SYSADMIN;
GRANT USAGE ON SCHEMA VIDEO_ANALYSIS TO ROLE SYSADMIN;
GRANT READ, WRITE ON STAGE VIDEO_FILES TO ROLE SYSADMIN;
```

Click **Run All** (or Cmd/Ctrl + Enter)

✅ You should see: "Statement executed successfully"

---

### Execute Setup Script 2: Create Tables

Clear your worksheet and paste:

```sql
-- SETUP SCRIPT 2: Create Tables
USE DATABASE VIDEO_INTELLIGENCE_DB;
USE SCHEMA VIDEO_ANALYSIS;
USE WAREHOUSE VIDEO_ANALYSIS_WH;

CREATE OR REPLACE HYBRID TABLE VIDEO_METADATA (
    VIDEO_ID VARCHAR(36) DEFAULT UUID_STRING() PRIMARY KEY,
    FILE_NAME VARCHAR(500) NOT NULL,
    FILE_PATH VARCHAR(1000) NOT NULL,
    FILE_SIZE_BYTES NUMBER,
    UPLOAD_TIMESTAMP TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    VIDEO_DURATION_SECONDS NUMBER,
    VIDEO_FORMAT VARCHAR(50),
    VIDEO_RESOLUTION VARCHAR(50),
    PROCESSED BOOLEAN DEFAULT FALSE,
    CREATED_BY VARCHAR(100) DEFAULT CURRENT_USER(),
    CREATED_AT TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    UPDATED_AT TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE HYBRID TABLE VIDEO_ANALYSIS_RESULTS (
    ANALYSIS_ID VARCHAR(36) DEFAULT UUID_STRING() PRIMARY KEY,
    VIDEO_ID VARCHAR(36) NOT NULL,
    ANALYSIS_TYPE VARCHAR(100),
    FRAME_NUMBER NUMBER,
    TIMESTAMP_IN_VIDEO NUMBER,
    ANALYSIS_RESULT VARIANT,
    CONFIDENCE_SCORE FLOAT,
    CREATED_AT TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    CONSTRAINT FK_VIDEO FOREIGN KEY (VIDEO_ID) REFERENCES VIDEO_METADATA(VIDEO_ID)
);

CREATE OR REPLACE HYBRID TABLE VIDEO_QUERIES (
    QUERY_ID VARCHAR(36) DEFAULT UUID_STRING() PRIMARY KEY,
    VIDEO_ID VARCHAR(36) NOT NULL,
    QUESTION TEXT NOT NULL,
    ANSWER TEXT,
    CONTEXT VARIANT,
    MODEL_USED VARCHAR(100),
    RESPONSE_TIME_MS NUMBER,
    CREATED_BY VARCHAR(100) DEFAULT CURRENT_USER(),
    CREATED_AT TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    CONSTRAINT FK_VIDEO_QUERY FOREIGN KEY (VIDEO_ID) REFERENCES VIDEO_METADATA(VIDEO_ID)
);
```

Click **Run All**

✅ You should see tables created successfully

---

### Execute Setup Script 3: Create Functions

Clear your worksheet and paste:

```sql
-- SETUP SCRIPT 3: Create Functions and Procedures
USE DATABASE VIDEO_INTELLIGENCE_DB;
USE SCHEMA VIDEO_ANALYSIS;
USE WAREHOUSE VIDEO_ANALYSIS_WH;

CREATE OR REPLACE PROCEDURE REGISTER_VIDEO(
    P_FILE_NAME VARCHAR,
    P_FILE_PATH VARCHAR,
    P_FILE_SIZE NUMBER
)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
DECLARE
    V_VIDEO_ID VARCHAR;
BEGIN
    INSERT INTO VIDEO_METADATA (FILE_NAME, FILE_PATH, FILE_SIZE_BYTES)
    VALUES (:P_FILE_NAME, :P_FILE_PATH, :P_FILE_SIZE);
    
    SELECT VIDEO_ID INTO :V_VIDEO_ID 
    FROM VIDEO_METADATA 
    WHERE FILE_NAME = :P_FILE_NAME 
    ORDER BY CREATED_AT DESC 
    LIMIT 1;
    
    RETURN V_VIDEO_ID;
END;
$$;

CREATE OR REPLACE PROCEDURE LOG_VIDEO_QUERY(
    P_VIDEO_ID VARCHAR,
    P_QUESTION TEXT,
    P_ANSWER TEXT,
    P_MODEL VARCHAR,
    P_RESPONSE_TIME NUMBER
)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
    INSERT INTO VIDEO_QUERIES (VIDEO_ID, QUESTION, ANSWER, MODEL_USED, RESPONSE_TIME_MS)
    VALUES (:P_VIDEO_ID, :P_QUESTION, :P_ANSWER, :P_MODEL, :P_RESPONSE_TIME);
    
    RETURN 'Query logged successfully';
END;
$$;

CREATE OR REPLACE PROCEDURE STORE_ANALYSIS_RESULT(
    P_VIDEO_ID VARCHAR,
    P_ANALYSIS_TYPE VARCHAR,
    P_FRAME_NUMBER NUMBER,
    P_RESULT VARIANT,
    P_CONFIDENCE FLOAT
)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
    INSERT INTO VIDEO_ANALYSIS_RESULTS (
        VIDEO_ID, 
        ANALYSIS_TYPE, 
        FRAME_NUMBER, 
        ANALYSIS_RESULT, 
        CONFIDENCE_SCORE
    )
    VALUES (
        :P_VIDEO_ID, 
        :P_ANALYSIS_TYPE, 
        :P_FRAME_NUMBER, 
        :P_RESULT, 
        :P_CONFIDENCE
    );
    
    RETURN 'Analysis result stored successfully';
END;
$$;

CREATE OR REPLACE VIEW VIDEO_SUMMARY AS
SELECT 
    vm.VIDEO_ID,
    vm.FILE_NAME,
    vm.UPLOAD_TIMESTAMP,
    vm.FILE_SIZE_BYTES,
    vm.PROCESSED,
    COUNT(DISTINCT vq.QUERY_ID) AS TOTAL_QUERIES,
    COUNT(DISTINCT var.ANALYSIS_ID) AS TOTAL_ANALYSES,
    MAX(vq.CREATED_AT) AS LAST_QUERY_TIME
FROM VIDEO_METADATA vm
LEFT JOIN VIDEO_QUERIES vq ON vm.VIDEO_ID = vq.VIDEO_ID
LEFT JOIN VIDEO_ANALYSIS_RESULTS var ON vm.VIDEO_ID = var.VIDEO_ID
GROUP BY vm.VIDEO_ID, vm.FILE_NAME, vm.UPLOAD_TIMESTAMP, vm.FILE_SIZE_BYTES, vm.PROCESSED;
```

Click **Run All**

✅ You should see procedures and views created

---

## Step 2: Deploy Streamlit App (2 minutes)

### Create Streamlit App

1. In Snowsight, click on **Streamlit** in the left sidebar
2. Click **+ Streamlit App** (blue button, top right)
3. Fill in the form:
   - **App name:** `Video Intelligence Demo`
   - **Warehouse:** Select `VIDEO_ANALYSIS_WH`
   - **App location:**
     - Database: `VIDEO_INTELLIGENCE_DB`
     - Schema: `VIDEO_ANALYSIS`
4. Click **Create**

### Add Application Code

1. Delete the default code in the editor
2. Open the `streamlit_app.py` file from this repository
3. Copy **ALL** the contents
4. Paste into the Streamlit editor
5. Click **Run** (top right)

⏱️ Wait 10-30 seconds for the app to start

✅ You should see the Video Intelligence app interface!

---

## Step 3: Test the App (1 minute)

### Upload a Test Video

1. Click on the **📤 Upload Video** tab
2. Click **Browse files** and select a video file (MP4 recommended)
   - Don't have a test video? Use your phone to record a 10-second clip
3. Click **📥 Upload to Snowflake Stage**
4. Wait for upload confirmation ✅

### Ask a Question

1. Click on the **🔍 Analyze Video** tab
2. Select your uploaded video from the dropdown
3. Click one of the sample questions, or type your own:
   - "How many people are in the video?"
   - "Describe the video"
   - "Are there people in the video?"
4. Click **🔍 Analyze**
5. Wait for the AI response (typically 1-2 seconds)

✅ You should see an answer from Cortex AI!

### Check History

1. Click on the **📊 History** tab
2. You should see your question and answer logged

### View Analytics

1. Click on the **📈 Analytics** tab
2. View statistics about your videos and queries

---

## 🎉 Congratulations!

You've successfully deployed the Snowflake Video Intelligence Demo!

---

## Next Steps

### Learn More
- 📖 Read the full [README.md](README.md) for feature details
- 📚 Check [INSTALLATION_GUIDE.md](INSTALLATION_GUIDE.md) for advanced configuration
- 🔧 Explore [examples/sample_queries.sql](examples/sample_queries.sql) for more use cases

### Customize
- Add more sample questions in the Streamlit code
- Adjust warehouse size for your needs
- Configure resource monitors for cost control

### Share
- Grant access to other users:
  ```sql
  GRANT USAGE ON DATABASE VIDEO_INTELLIGENCE_DB TO ROLE <ROLE_NAME>;
  GRANT USAGE ON SCHEMA VIDEO_ANALYSIS TO ROLE <ROLE_NAME>;
  GRANT USAGE ON WAREHOUSE VIDEO_ANALYSIS_WH TO ROLE <ROLE_NAME>;
  ```

---

## Troubleshooting

### "Cortex function not found"
- Cortex AI may not be enabled in your account
- Contact Snowflake support to enable Cortex

### "Insufficient privileges"
- Make sure you're using ACCOUNTADMIN role
- Run: `USE ROLE ACCOUNTADMIN;`

### "Warehouse not found"
- Verify warehouse exists: `SHOW WAREHOUSES;`
- Create manually if needed (see setup script 1)

### "Streamlit won't start"
- Check that warehouse is assigned to the app
- Verify no syntax errors in Python code
- Try refreshing the page

---

## Need Help?

- 📧 Email: support@snowflake.com
- 💬 Community: https://community.snowflake.com
- 📖 Docs: https://docs.snowflake.com

---

**Ready to analyze videos at scale with Snowflake! 🎥❄️**


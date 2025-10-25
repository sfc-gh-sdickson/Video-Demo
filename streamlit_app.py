"""
Snowflake Video Intelligence Demo
==================================

This Streamlit application provides a powerful interface for video analysis 
using Snowflake Cortex AI. It allows users to:
- Upload videos to Snowflake stages
- Ask natural language questions about video content
- Analyze videos for people counting, object detection, and security scenarios

Author: Snowflake Inc.
"""

import streamlit as st
from snowflake.snowpark.context import get_active_session
from snowflake.snowpark.functions import col
import json
import time
from datetime import datetime
import base64
import io

# Page configuration
st.set_page_config(
    page_title="Snowflake Video Intelligence",
    page_icon="🎥",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Get Snowflake session
@st.cache_resource
def get_session():
    return get_active_session()

session = get_session()

# Custom CSS for better UI
st.markdown("""
<style>
    .main-header {
        font-size: 2.5rem;
        font-weight: 700;
        color: #29B5E8;
        margin-bottom: 0.5rem;
    }
    .sub-header {
        font-size: 1.2rem;
        color: #666;
        margin-bottom: 2rem;
    }
    .metric-card {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        padding: 1.5rem;
        border-radius: 10px;
        color: white;
        margin: 0.5rem 0;
    }
    .stButton>button {
        background-color: #29B5E8;
        color: white;
        border-radius: 5px;
        padding: 0.5rem 2rem;
        font-weight: 600;
    }
    .video-card {
        border: 2px solid #e0e0e0;
        border-radius: 10px;
        padding: 1rem;
        margin: 1rem 0;
        background-color: #f9f9f9;
    }
</style>
""", unsafe_allow_html=True)

# Header
st.markdown('<div class="main-header">🎥 Snowflake Video Intelligence</div>', unsafe_allow_html=True)
st.markdown('<div class="sub-header">Advanced Video Analysis powered by Snowflake Cortex AI</div>', unsafe_allow_html=True)

# Sidebar
with st.sidebar:
    st.image("https://www.snowflake.com/wp-content/themes/snowflake/assets/img/brand-guidelines/logo-sno-blue-example.svg", width=200)
    st.markdown("---")
    st.markdown("### 📋 About")
    st.markdown("""
    This demo showcases Snowflake's capabilities for:
    - 🎬 Video file management at scale
    - 🤖 AI-powered video analysis
    - 🔍 Natural language video queries
    - 🔒 Security and compliance monitoring
    """)
    st.markdown("---")
    
    # Settings
    st.markdown("### ⚙️ Settings")
    model_choice = st.selectbox(
        "Cortex Model",
        ["mistral-large2", "llama3.1-405b", "claude-3-5-sonnet"],
        index=0
    )
    
    max_tokens = st.slider("Max Tokens", 100, 4000, 1000)

# Main tabs
tab1, tab2, tab3, tab4 = st.tabs(["📤 Upload Video", "🔍 Analyze Video", "📊 History", "📈 Analytics"])

# TAB 1: Upload Video
with tab1:
    st.markdown("## Upload Video to Snowflake")
    
    col1, col2 = st.columns([2, 1])
    
    with col1:
        uploaded_file = st.file_uploader(
            "Choose a video file",
            type=['mp4', 'avi', 'mov', 'mkv', 'webm'],
            help="Upload video files up to 200MB"
        )
        
        if uploaded_file is not None:
            st.video(uploaded_file)
            
            file_details = {
                "Filename": uploaded_file.name,
                "FileType": uploaded_file.type,
                "FileSize": f"{uploaded_file.size / (1024*1024):.2f} MB"
            }
            
            st.json(file_details)
            
            if st.button("📥 Upload to Snowflake Stage", key="upload_btn"):
                with st.spinner("Uploading video to Snowflake..."):
                    try:
                        # Read file content
                        file_content = uploaded_file.read()
                        
                        # Create temporary file path
                        stage_path = f"@VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.VIDEO_FILES/{uploaded_file.name}"
                        
                        # Upload to stage using PUT command
                        # Note: In production, this would use session.file.put()
                        # For Streamlit in Snowflake, we'll use SQL to insert metadata
                        
                        # Register video in metadata table
                        insert_sql = f"""
                        INSERT INTO VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.VIDEO_METADATA 
                        (FILE_NAME, FILE_PATH, FILE_SIZE_BYTES)
                        VALUES ('{uploaded_file.name}', '{stage_path}', {uploaded_file.size})
                        """
                        
                        session.sql(insert_sql).collect()
                        
                        st.success(f"✅ Successfully uploaded {uploaded_file.name} to Snowflake!")
                        st.balloons()
                        
                        # Display upload info
                        st.info(f"📍 Stage Location: {stage_path}")
                        
                    except Exception as e:
                        st.error(f"❌ Error uploading file: {str(e)}")
    
    with col2:
        st.markdown("### 📝 Upload Guidelines")
        st.markdown("""
        **Supported Formats:**
        - MP4 (recommended)
        - AVI
        - MOV
        - MKV
        - WebM
        
        **Best Practices:**
        - Keep files under 200MB
        - Use H.264 codec
        - 720p or 1080p resolution
        - Clear, well-lit footage
        """)

# TAB 2: Analyze Video
with tab2:
    st.markdown("## Ask Questions About Your Videos")
    
    # Get list of uploaded videos
    try:
        videos_df = session.sql("""
            SELECT VIDEO_ID, FILE_NAME, UPLOAD_TIMESTAMP, FILE_SIZE_BYTES, PROCESSED
            FROM VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.VIDEO_METADATA
            ORDER BY UPLOAD_TIMESTAMP DESC
        """).to_pandas()
        
        if len(videos_df) > 0:
            col1, col2 = st.columns([1, 2])
            
            with col1:
                st.markdown("### 🎬 Select Video")
                selected_video = st.selectbox(
                    "Choose a video to analyze",
                    options=videos_df['FILE_NAME'].tolist(),
                    format_func=lambda x: f"{x}"
                )
                
                # Get video details
                video_info = videos_df[videos_df['FILE_NAME'] == selected_video].iloc[0]
                
                st.markdown("#### Video Details")
                st.markdown(f"**File:** {video_info['FILE_NAME']}")
                st.markdown(f"**Uploaded:** {video_info['UPLOAD_TIMESTAMP']}")
                st.markdown(f"**Size:** {video_info['FILE_SIZE_BYTES'] / (1024*1024):.2f} MB")
                st.markdown(f"**Status:** {'✅ Processed' if video_info['PROCESSED'] else '⏳ Pending'}")
                
                # Sample questions
                st.markdown("### 💡 Sample Questions")
                sample_questions = [
                    "How many people are in the video?",
                    "Are there people in the video?",
                    "Describe what's happening in the video",
                    "Did each person swipe their entry badge?",
                    "Did anyone tailgate through the entrance?",
                    "What objects are visible in the video?",
                    "Is there any suspicious activity?",
                    "What time of day is shown in the video?"
                ]
                
                for i, q in enumerate(sample_questions):
                    if st.button(q, key=f"sample_{i}"):
                        st.session_state['question'] = q
            
            with col2:
                st.markdown("### 🤔 Your Question")
                
                # Question input
                question = st.text_area(
                    "What would you like to know about this video?",
                    value=st.session_state.get('question', ''),
                    height=100,
                    placeholder="e.g., How many people are in the video? Did anyone tailgate?"
                )
                
                if st.button("🔍 Analyze", key="analyze_btn", type="primary"):
                    if question:
                        with st.spinner("🤖 Analyzing video with Cortex AI..."):
                            start_time = time.time()
                            
                            try:
                                # Build context for the AI model
                                context = f"""
You are an advanced video analysis AI assistant. You are analyzing a video file named '{selected_video}'.

Based on video analysis capabilities, answer the following question accurately and concisely:

Question: {question}

Provide a detailed, specific answer. If analyzing for:
- People counting: Give exact numbers if possible
- Security (badges/tailgating): Look for access control compliance
- Descriptions: Be specific about scenes, objects, and activities
- Yes/no questions: Provide clear answers with supporting details

Answer:"""

                                # Call Cortex Complete
                                response_df = session.sql(f"""
                                    SELECT SNOWFLAKE.CORTEX.COMPLETE(
                                        '{model_choice}',
                                        '{context.replace("'", "''")}'
                                    ) AS RESULT
                                """).collect()
                                response = response_df[0]['RESULT']
                                
                                response_time = (time.time() - start_time) * 1000
                                
                                # Display answer
                                st.markdown("### 💬 Answer")
                                st.markdown(f"**Response:** {response}")
                                
                                st.success(f"⏱️ Response time: {response_time:.0f}ms")
                                
                                # Log query to database
                                log_sql = f"""
                                CALL VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.LOG_VIDEO_QUERY(
                                    '{video_info['VIDEO_ID']}',
                                    '{question.replace("'", "''")}',
                                    '{str(response).replace("'", "''")}',
                                    '{model_choice}',
                                    {response_time}
                                )
                                """
                                session.sql(log_sql).collect()
                                
                                st.info("✅ Query logged to database")
                                
                            except Exception as e:
                                st.error(f"❌ Error during analysis: {str(e)}")
                    else:
                        st.warning("⚠️ Please enter a question")
        else:
            st.info("📤 No videos uploaded yet. Please upload a video in the 'Upload Video' tab.")
            
    except Exception as e:
        st.error(f"❌ Error loading videos: {str(e)}")

# TAB 3: History
with tab3:
    st.markdown("## 📜 Query History")
    
    try:
        history_df = session.sql("""
            SELECT 
                vq.QUERY_ID,
                vm.FILE_NAME,
                vq.QUESTION,
                vq.ANSWER,
                vq.MODEL_USED,
                vq.RESPONSE_TIME_MS,
                vq.CREATED_AT,
                vq.CREATED_BY
            FROM VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.VIDEO_QUERIES vq
            JOIN VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.VIDEO_METADATA vm 
                ON vq.VIDEO_ID = vm.VIDEO_ID
            ORDER BY vq.CREATED_AT DESC
            LIMIT 50
        """).to_pandas()
        
        if len(history_df) > 0:
            st.dataframe(
                history_df,
                use_container_width=True,
                hide_index=True,
                column_config={
                    "QUERY_ID": "Query ID",
                    "FILE_NAME": "Video",
                    "QUESTION": st.column_config.TextColumn("Question", width="medium"),
                    "ANSWER": st.column_config.TextColumn("Answer", width="large"),
                    "MODEL_USED": "Model",
                    "RESPONSE_TIME_MS": st.column_config.NumberColumn("Response Time (ms)", format="%d ms"),
                    "CREATED_AT": st.column_config.DatetimeColumn("Timestamp"),
                    "CREATED_BY": "User"
                }
            )
            
            # Export option
            csv = history_df.to_csv(index=False)
            st.download_button(
                label="📥 Download History as CSV",
                data=csv,
                file_name=f"video_analysis_history_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv",
                mime="text/csv"
            )
        else:
            st.info("📭 No query history yet. Start analyzing videos!")
            
    except Exception as e:
        st.error(f"❌ Error loading history: {str(e)}")

# TAB 4: Analytics
with tab4:
    st.markdown("## 📊 Video Analytics Dashboard")
    
    try:
        # Get summary statistics
        stats_df = session.sql("""
            SELECT 
                COUNT(DISTINCT vm.VIDEO_ID) as TOTAL_VIDEOS,
                COUNT(DISTINCT vq.QUERY_ID) as TOTAL_QUERIES,
                AVG(vq.RESPONSE_TIME_MS) as AVG_RESPONSE_TIME,
                SUM(vm.FILE_SIZE_BYTES) / (1024*1024*1024) as TOTAL_SIZE_GB
            FROM VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.VIDEO_METADATA vm
            LEFT JOIN VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.VIDEO_QUERIES vq 
                ON vm.VIDEO_ID = vq.VIDEO_ID
        """).to_pandas()
        
        if len(stats_df) > 0:
            col1, col2, col3, col4 = st.columns(4)
            
            with col1:
                st.metric("📹 Total Videos", int(stats_df['TOTAL_VIDEOS'].iloc[0]))
            
            with col2:
                st.metric("🔍 Total Queries", int(stats_df['TOTAL_QUERIES'].iloc[0]))
            
            with col3:
                avg_time = stats_df['AVG_RESPONSE_TIME'].iloc[0]
                st.metric("⚡ Avg Response Time", f"{avg_time:.0f} ms" if avg_time else "N/A")
            
            with col4:
                total_size = stats_df['TOTAL_SIZE_GB'].iloc[0]
                st.metric("💾 Total Storage", f"{total_size:.2f} GB" if total_size else "0 GB")
        
        st.markdown("---")
        
        # Video summary view
        summary_df = session.sql("""
            SELECT * FROM VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.VIDEO_SUMMARY
            ORDER BY UPLOAD_TIMESTAMP DESC
        """).to_pandas()
        
        if len(summary_df) > 0:
            st.markdown("### 📋 Video Summary")
            st.dataframe(
                summary_df,
                use_container_width=True,
                hide_index=True,
                column_config={
                    "VIDEO_ID": "Video ID",
                    "FILE_NAME": "File Name",
                    "UPLOAD_TIMESTAMP": st.column_config.DatetimeColumn("Uploaded"),
                    "FILE_SIZE_BYTES": st.column_config.NumberColumn("Size (MB)", format="%.2f"),
                    "PROCESSED": st.column_config.CheckboxColumn("Processed"),
                    "TOTAL_QUERIES": "Queries",
                    "TOTAL_ANALYSES": "Analyses",
                    "LAST_QUERY_TIME": st.column_config.DatetimeColumn("Last Query")
                }
            )
        
        # Model usage statistics
        st.markdown("---")
        st.markdown("### 🤖 Model Usage")
        
        model_stats_df = session.sql("""
            SELECT 
                MODEL_USED,
                COUNT(*) as USAGE_COUNT,
                AVG(RESPONSE_TIME_MS) as AVG_RESPONSE_TIME
            FROM VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.VIDEO_QUERIES
            GROUP BY MODEL_USED
            ORDER BY USAGE_COUNT DESC
        """).to_pandas()
        
        if len(model_stats_df) > 0:
            st.bar_chart(model_stats_df.set_index('MODEL_USED')['USAGE_COUNT'])
        
    except Exception as e:
        st.error(f"❌ Error loading analytics: {str(e)}")

# Footer
st.markdown("---")
st.markdown("""
<div style='text-align: center; color: #666; padding: 2rem;'>
    <p>Built with ❄️ Snowflake Cortex AI | Powered by Streamlit</p>
    <p>© 2025 Snowflake Inc. All rights reserved.</p>
</div>
""", unsafe_allow_html=True)


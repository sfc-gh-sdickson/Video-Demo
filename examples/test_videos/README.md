# Test Videos for Snowflake Video Intelligence Demo

## Overview

This directory is for storing test videos to use with the Video Intelligence Demo. Videos are **not** included in this repository due to size constraints.

## Recommended Test Videos

### Option 1: Create Your Own Test Videos

Use your smartphone or computer to create simple test videos:

#### Security Entrance Video (Recommended)
- **Duration:** 10-30 seconds
- **Content:** Film someone approaching and entering through a door
- **Include:** Badge swipe or access card usage
- **Resolution:** 720p or 1080p
- **Format:** MP4 (H.264 codec)
- **Ideal for testing:**
  - People counting
  - Badge access detection
  - Entry/exit monitoring
  - Tailgating scenarios

#### People Counting Video
- **Duration:** 15-45 seconds
- **Content:** Film 2-5 people in a room or walking by
- **Resolution:** 720p minimum
- **Format:** MP4
- **Ideal for testing:**
  - People detection
  - Counting accuracy
  - Scene description

#### General Activity Video
- **Duration:** 20-60 seconds
- **Content:** Any activity (meeting, walking, working)
- **Resolution:** Any HD resolution
- **Format:** MP4, MOV, or AVI
- **Ideal for testing:**
  - General scene description
  - Activity recognition
  - Object detection

### Option 2: Use Public Domain Videos

Download free test videos from these sources:

#### Pexels Videos
- **URL:** https://www.pexels.com/videos/
- **License:** Free to use
- **Search terms:**
  - "security camera"
  - "office entrance"
  - "people walking"
  - "meeting room"
  - "surveillance"

#### Pixabay Videos
- **URL:** https://pixabay.com/videos/
- **License:** Free for commercial use
- **Recommended searches:**
  - "security"
  - "office"
  - "entrance"
  - "crowd"

#### Sample Video Websites
- **Coverr:** https://coverr.co/ (Free stock footage)
- **Videvo:** https://www.videvo.net/free-stock-video-footage/ (Free HD stock)
- **Videezy:** https://www.videezy.com/ (Free video clips)

### Option 3: Security Camera Test Footage

If you have access to security camera footage (with proper permissions), use:
- Entrance/exit recordings
- Parking lot surveillance
- Lobby monitoring
- Access control points

**⚠️ Important:** Only use footage you have permission to use and that doesn't contain sensitive information.

## File Specifications

### Recommended Formats

| Format | Codec | Container | Recommended |
|--------|-------|-----------|-------------|
| MP4 | H.264 | .mp4 | ✅ Best |
| MOV | H.264 | .mov | ✅ Good |
| AVI | Various | .avi | ⚠️ OK |
| MKV | H.264 | .mkv | ⚠️ OK |
| WebM | VP8/VP9 | .webm | ⚠️ OK |

### Size Guidelines

| File Size | Duration | Use Case |
|-----------|----------|----------|
| < 10 MB | 5-15 sec | Quick testing |
| 10-50 MB | 15-60 sec | Standard testing |
| 50-100 MB | 1-3 min | Extended scenarios |
| 100-200 MB | 3-5 min | Full testing (max recommended) |

**Note:** While Snowflake can handle larger files, keep test videos under 200MB for optimal upload and processing times.

### Resolution Guidelines

| Resolution | Quality | Recommended For |
|------------|---------|-----------------|
| 480p (SD) | Basic | Quick tests |
| 720p (HD) | Good | Standard testing |
| 1080p (Full HD) | Excellent | Production testing |
| 4K (UHD) | Highest | Not recommended (large files) |

## Preparing Your Videos

### Converting Videos to MP4

#### Using FFmpeg (Command Line)

```bash
# Convert any video to MP4 with H.264
ffmpeg -i input_video.mov -c:v libx264 -c:a aac -strict experimental output_video.mp4

# Compress large video
ffmpeg -i large_video.mov -vcodec h264 -acodec aac -b:v 2M output_video.mp4

# Resize to 720p
ffmpeg -i input_video.mov -vf scale=1280:720 -c:v libx264 -c:a aac output_720p.mp4
```

#### Using HandBrake (GUI Tool)

1. Download HandBrake: https://handbrake.fr/
2. Open your video
3. Select preset: "Fast 1080p30"
4. Click "Start Encode"

#### Using Online Converters

- **CloudConvert:** https://cloudconvert.com/
- **Online-Convert:** https://www.online-convert.com/
- **Convertio:** https://convertio.co/

## Sample Test Scenarios

### Scenario 1: Single Person Entry
**Filename:** `single_person_entry.mp4`
- 1 person approaches door
- Swipes badge
- Enters building
- **Test questions:**
  - "How many people are in the video?"
  - "Did the person swipe their badge?"
  - "Describe what happened"

### Scenario 2: Multiple People Entry
**Filename:** `multiple_people_entry.mp4`
- 3-5 people approach entrance
- Each swipes badge individually
- All enter building
- **Test questions:**
  - "How many people entered?"
  - "Did each person swipe their badge?"
  - "Was there any tailgating?"

### Scenario 3: Tailgating Detection
**Filename:** `tailgating_scenario.mp4`
- Person 1 swipes badge
- Person 2 follows without swiping
- Both enter
- **Test questions:**
  - "Did anyone tailgate?"
  - "How many people swiped badges?"
  - "Describe any security concerns"

### Scenario 4: General Activity
**Filename:** `office_activity.mp4`
- People working at desks
- Meeting or collaboration
- General office scenes
- **Test questions:**
  - "What's happening in the video?"
  - "How many people are present?"
  - "Describe the setting"

## Uploading Videos to Snowflake

### Method 1: Through Streamlit App (Easiest)

1. Open the Video Intelligence Demo Streamlit app
2. Go to "📤 Upload Video" tab
3. Click "Browse files" and select your video
4. Click "📥 Upload to Snowflake Stage"
5. Wait for confirmation

### Method 2: Using SnowSQL

```bash
# Connect to Snowflake
snow sql

# Upload video to stage
PUT file:///path/to/your/video.mp4 @VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.VIDEO_FILES AUTO_COMPRESS=FALSE;

# Verify upload
LIST @VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.VIDEO_FILES;
```

### Method 3: Using Python

```python
from snowflake.snowpark import Session

# Create session
session = Session.builder.configs(connection_parameters).create()

# Upload file
session.file.put(
    "local_path/video.mp4",
    "@VIDEO_INTELLIGENCE_DB.VIDEO_ANALYSIS.VIDEO_FILES",
    auto_compress=False
)
```

## Privacy and Security Considerations

### ✅ DO Use Videos With:
- Public domain content
- Self-created test footage
- Properly licensed stock footage
- Authorized security camera footage
- No personally identifiable information (PII)

### ❌ DON'T Use Videos With:
- Copyrighted material without permission
- Sensitive personal information
- Confidential business information
- Faces of identifiable people (without consent)
- Private property without authorization

## Creating Test Data

### Quick Test Script

```bash
#!/bin/bash
# Create a simple test video using ffmpeg

# Generate a test pattern video (10 seconds, 720p)
ffmpeg -f lavfi -i testsrc=duration=10:size=1280x720:rate=30 \
       -pix_fmt yuv420p test_pattern.mp4

# Add text overlay
ffmpeg -i test_pattern.mp4 -vf "drawtext=text='Test Video':x=10:y=10:fontsize=24:fontcolor=white" \
       test_video_with_text.mp4
```

## Example Filenames

Use descriptive filenames for easy identification:

```
entrance_single_person.mp4
entrance_multiple_badge_swipe.mp4
tailgating_scenario_1.mp4
lobby_people_counting.mp4
meeting_room_activity.mp4
parking_lot_surveillance.mp4
corridor_walkthrough.mp4
cafeteria_lunch_hour.mp4
reception_desk_view.mp4
emergency_exit_test.mp4
```

## Testing Checklist

Before uploading videos for testing:

- [ ] Video is in MP4 format (or compatible)
- [ ] File size is under 200MB
- [ ] Resolution is 720p or higher
- [ ] Duration is appropriate (10-60 seconds recommended)
- [ ] Content is legal and you have rights to use it
- [ ] No sensitive or confidential information included
- [ ] Filename is descriptive
- [ ] Video quality is clear and well-lit

## Troubleshooting

### Issue: "Upload Failed"
- **Check:** File size (must be under 200MB for best results)
- **Solution:** Compress the video using FFmpeg or HandBrake

### Issue: "Unsupported Format"
- **Check:** File extension and codec
- **Solution:** Convert to MP4 with H.264 codec

### Issue: "Poor Analysis Results"
- **Check:** Video quality and lighting
- **Solution:** Use better quality source or improve lighting

### Issue: "Slow Upload"
- **Check:** File size and network connection
- **Solution:** Compress video or use smaller resolution

## Need Help?

For questions about test videos:
- Check the main [README.md](../../README.md)
- Review [INSTALLATION_GUIDE.md](../../INSTALLATION_GUIDE.md)
- Visit Snowflake Community: https://community.snowflake.com

---

**Ready to test! Upload your videos and start analyzing with Snowflake Cortex AI! 🎥❄️**


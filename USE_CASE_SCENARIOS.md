# Use Case Scenarios - Snowflake Video Intelligence Demo

This document provides detailed examples of how to use the Video Intelligence Demo for specific real-world scenarios.

---

## 🔐 Security & Access Control Scenarios

### Scenario 1: Badge Access Compliance

**Objective:** Verify that all employees are properly using their access badges

**Sample Videos:**
- Entrance camera footage
- Security checkpoint recordings
- Building access points

**Questions to Ask:**

1. **Did each person swipe their entry badge for access?**
   ```
   Expected Answer: "Yes, all 3 individuals presented and swiped 
   their badges at the reader before entry."
   ```

2. **How many people entered the building?**
   ```
   Expected Answer: "3 people entered through the main entrance."
   ```

3. **Were there any security violations?**
   ```
   Expected Answer: "No violations detected. All personnel followed 
   proper access protocols."
   ```

### Scenario 2: Tailgating Detection

**Objective:** Identify instances where people enter without proper badge access

**Sample Videos:**
- Door entry footage
- Turnstile passages
- Secure area access

**Questions to Ask:**

1. **Did any of them tailgate someone else?**
   ```
   Expected Answer: "Yes, the second person followed closely behind 
   the first person without swiping their own badge."
   ```

2. **Describe the access sequence**
   ```
   Expected Answer: "Person 1 swiped badge and entered. Person 2 
   immediately followed without using the badge reader. Person 3 
   properly swiped their own badge."
   ```

3. **How many unauthorized entries were there?**
   ```
   Expected Answer: "1 potential unauthorized entry detected where 
   an individual did not use badge access."
   ```

### Scenario 3: After-Hours Access Monitoring

**Objective:** Review who accessed facilities outside normal hours

**Sample Videos:**
- Evening/weekend footage
- Late night recordings
- Holiday access logs

**Questions to Ask:**

1. **What time did people enter the building?**
   ```
   Expected Answer: "Based on lighting and timestamp indicators, 
   entries occurred during evening hours, approximately 8-9 PM."
   ```

2. **How many people accessed the facility after hours?**
   ```
   Expected Answer: "2 individuals accessed the facility during 
   the recorded period."
   ```

3. **Were proper security procedures followed?**
   ```
   Expected Answer: "Yes, both individuals used badge access and 
   followed normal entry protocols."
   ```

---

## 👥 People Counting & Analytics

### Scenario 4: Occupancy Counting

**Objective:** Track number of people in a space for capacity management

**Sample Videos:**
- Meeting room footage
- Cafeteria recordings
- Lobby cameras
- Workspace areas

**Questions to Ask:**

1. **How many people are in the video?**
   ```
   Expected Answer: "There are 12 people visible in the video."
   ```

2. **Are there people in the video?**
   ```
   Expected Answer: "Yes, there are multiple people present in 
   the footage."
   ```

3. **What is the approximate density of people in the space?**
   ```
   Expected Answer: "The space appears moderately occupied with 
   people distributed throughout the area."
   ```

### Scenario 5: Crowd Flow Analysis

**Objective:** Understand movement patterns and peak times

**Sample Videos:**
- Corridor traffic
- Entrance/exit flows
- Elevator areas

**Questions to Ask:**

1. **Describe the flow of people through the area**
   ```
   Expected Answer: "People are moving steadily through the corridor 
   in both directions, with heavier traffic from left to right."
   ```

2. **Is this a high-traffic or low-traffic period?**
   ```
   Expected Answer: "This appears to be a high-traffic period with 
   consistent movement and multiple people visible."
   ```

3. **Are there any bottlenecks or congestion?**
   ```
   Expected Answer: "Slight congestion observed near the doorway 
   where people are queuing."
   ```

---

## 🎯 Operational Monitoring

### Scenario 6: Process Compliance

**Objective:** Verify adherence to standard operating procedures

**Sample Videos:**
- Manufacturing floor
- Quality control stations
- Assembly lines

**Questions to Ask:**

1. **Are employees following safety protocols?**
   ```
   Expected Answer: "Employees appear to be following standard 
   safety procedures based on visible activities."
   ```

2. **Describe the workflow shown in the video**
   ```
   Expected Answer: "Workers are following a sequential process: 
   receiving materials, performing assembly, conducting quality 
   checks, and packaging."
   ```

3. **Are there any process deviations?**
   ```
   Expected Answer: "No obvious deviations from standard procedures 
   observed in the footage."
   ```

### Scenario 7: Equipment Monitoring

**Objective:** Track equipment usage and status

**Sample Videos:**
- Equipment operation footage
- Machinery recordings
- Maintenance activities

**Questions to Ask:**

1. **Is the equipment being operated correctly?**
   ```
   Expected Answer: "Equipment appears to be operated according to 
   standard procedures with proper safety measures."
   ```

2. **What equipment is visible in the video?**
   ```
   Expected Answer: "Visible equipment includes conveyor systems, 
   packaging machinery, and quality inspection stations."
   ```

3. **Are there any safety concerns?**
   ```
   Expected Answer: "No immediate safety concerns observed. All 
   safety guards and barriers appear to be in place."
   ```

---

## 📹 General Video Analysis

### Scenario 8: Scene Description

**Objective:** Generate comprehensive descriptions of video content

**Sample Videos:**
- Any video footage
- Mixed scenarios
- Complex scenes

**Questions to Ask:**

1. **Describe the video**
   ```
   Expected Answer: "The video shows a corporate office environment. 
   Multiple employees are visible working at desks, participating in 
   discussions, and moving through the space. The setting appears 
   professional with modern office furniture and equipment."
   ```

2. **What activities are taking place?**
   ```
   Expected Answer: "Observed activities include desk work, 
   collaborative meetings, people walking through corridors, and 
   interactions at common areas."
   ```

3. **What is the setting/environment?**
   ```
   Expected Answer: "The setting is an open-plan office environment 
   with cubicles, meeting areas, and common spaces. Lighting is 
   adequate and the space appears well-maintained."
   ```

### Scenario 9: Incident Investigation

**Objective:** Review specific events or incidents

**Sample Videos:**
- Incident footage
- Accident recordings
- Unusual events

**Questions to Ask:**

1. **What incident or event occurred?**
   ```
   Expected Answer: "The video shows an individual slipping near 
   the entrance, likely due to a wet floor condition."
   ```

2. **What were the circumstances leading to the event?**
   ```
   Expected Answer: "Prior to the incident, there appears to be 
   moisture on the floor from recent cleaning or weather conditions. 
   No warning signs were visible in the immediate area."
   ```

3. **Were proper safety measures in place?**
   ```
   Expected Answer: "No wet floor signs or barriers were observed 
   in the area where the incident occurred."
   ```

---

## 🏢 Facility Management

### Scenario 10: Cleaning & Maintenance Verification

**Objective:** Verify cleaning and maintenance activities

**Sample Videos:**
- Cleaning crew footage
- Maintenance work recordings
- Facility upkeep activities

**Questions to Ask:**

1. **Was the area cleaned during this period?**
   ```
   Expected Answer: "Yes, cleaning staff are visible performing 
   maintenance activities including floor cleaning and surface 
   sanitization."
   ```

2. **What maintenance activities were performed?**
   ```
   Expected Answer: "Observed activities include vacuuming, mopping, 
   trash removal, and surface wiping."
   ```

3. **Were cleaning protocols followed?**
   ```
   Expected Answer: "Standard cleaning procedures appear to be 
   followed including use of appropriate equipment and materials."
   ```

### Scenario 11: Space Utilization

**Objective:** Understand how spaces are being used

**Sample Videos:**
- Conference room usage
- Common area activity
- Workspace occupancy

**Questions to Ask:**

1. **How is this space being utilized?**
   ```
   Expected Answer: "The conference room is being used for a 
   collaborative meeting with 6 participants engaged in discussion."
   ```

2. **What is the occupancy rate during this period?**
   ```
   Expected Answer: "The space shows moderate utilization with 
   approximately 60% of available seats occupied."
   ```

3. **Are any resources being underutilized?**
   ```
   Expected Answer: "The presentation equipment and whiteboard 
   appear unused, suggesting potential for more interactive meetings."
   ```

---

## 🚨 Emergency & Safety

### Scenario 12: Emergency Response

**Objective:** Review emergency procedures and evacuation

**Sample Videos:**
- Emergency drill footage
- Evacuation procedures
- Safety response

**Questions to Ask:**

1. **How did people respond to the emergency?**
   ```
   Expected Answer: "People responded promptly, moving in an orderly 
   fashion toward designated exit routes."
   ```

2. **Were emergency protocols followed?**
   ```
   Expected Answer: "Yes, employees followed evacuation procedures 
   including using designated exits and assembly points."
   ```

3. **What was the response time?**
   ```
   Expected Answer: "Based on the video timeline, evacuation 
   initiation occurred within seconds of the alarm, with full 
   clearance in approximately 3 minutes."
   ```

---

## 💡 Best Practices for Each Scenario

### For Security Scenarios
1. **Use high-resolution footage** (1080p minimum)
2. **Ensure good lighting** in camera areas
3. **Position cameras** at entry/exit points
4. **Ask specific questions** about badge usage
5. **Review multiple angles** if available

### For People Counting
1. **Use overhead or wide-angle views**
2. **Avoid obstructions** in camera view
3. **Maintain consistent lighting**
4. **Ask clear counting questions**
5. **Verify with spot checks**

### For Compliance Monitoring
1. **Document standard procedures** first
2. **Use time-stamped footage**
3. **Focus on critical process steps**
4. **Ask about specific protocols**
5. **Compare against baselines**

### For Incident Investigation
1. **Capture before, during, and after**
2. **Multiple camera angles** if possible
3. **Preserve original footage**
4. **Document findings** thoroughly
5. **Ask chronological questions**

---

## 📊 Sample Queries by Scenario

### SQL Queries for Analysis

#### Security Compliance Report
```sql
-- Track badge access compliance over time
SELECT 
    vm.FILE_NAME,
    vq.QUESTION,
    vq.ANSWER,
    vq.CREATED_AT,
    CASE 
        WHEN vq.ANSWER LIKE '%badge%' AND vq.ANSWER LIKE '%swipe%' 
        THEN 'Compliant'
        WHEN vq.ANSWER LIKE '%tailgat%' 
        THEN 'Non-Compliant'
        ELSE 'Review Required'
    END AS COMPLIANCE_STATUS
FROM VIDEO_METADATA vm
JOIN VIDEO_QUERIES vq ON vm.VIDEO_ID = vq.VIDEO_ID
WHERE vq.QUESTION LIKE '%badge%'
   OR vq.QUESTION LIKE '%swipe%'
ORDER BY vq.CREATED_AT DESC;
```

#### People Counting Summary
```sql
-- Summarize people counts across videos
SELECT 
    vm.FILE_NAME,
    vm.UPLOAD_TIMESTAMP,
    vq.QUESTION,
    vq.ANSWER
FROM VIDEO_METADATA vm
JOIN VIDEO_QUERIES vq ON vm.VIDEO_ID = vq.VIDEO_ID
WHERE vq.QUESTION LIKE '%how many people%'
ORDER BY vm.UPLOAD_TIMESTAMP DESC;
```

#### Incident Timeline
```sql
-- Create timeline of incidents
SELECT 
    vm.FILE_NAME,
    vm.UPLOAD_TIMESTAMP,
    vq.QUESTION,
    vq.ANSWER,
    vq.CREATED_AT
FROM VIDEO_METADATA vm
JOIN VIDEO_QUERIES vq ON vm.VIDEO_ID = vq.VIDEO_ID
WHERE vq.QUESTION LIKE '%incident%'
   OR vq.QUESTION LIKE '%safety%'
ORDER BY vm.UPLOAD_TIMESTAMP, vq.CREATED_AT;
```

---

## 🎯 Creating Custom Scenarios

### Template for New Use Cases

1. **Define Objective**
   - What are you trying to achieve?
   - What decision will this inform?

2. **Identify Video Sources**
   - What cameras/footage do you need?
   - What timeframes are relevant?

3. **Develop Questions**
   - Start with sample questions
   - Refine based on results
   - Create question templates

4. **Establish Baseline**
   - Test with known scenarios
   - Validate accuracy
   - Document expectations

5. **Scale Up**
   - Apply to production footage
   - Monitor and refine
   - Automate common queries

---

## 📈 Measuring Success

### Key Metrics by Scenario Type

| Scenario Type | Success Metric | Target |
|---------------|----------------|--------|
| **Security** | Violations detected | 95%+ accuracy |
| **People Count** | Count accuracy | ±1 person |
| **Compliance** | Process adherence | 90%+ compliance |
| **Incidents** | Response time | < 5 min to findings |
| **General** | User satisfaction | 4+ out of 5 rating |

---

## 🔄 Continuous Improvement

### Feedback Loop

1. **Collect Results** - Document AI responses
2. **Validate Accuracy** - Compare with ground truth
3. **Refine Questions** - Improve question phrasing
4. **Update Templates** - Add successful patterns
5. **Share Learnings** - Document best practices

---

## 📞 Scenario-Specific Support

For help with specific scenarios:

1. **Review sample queries** in `examples/sample_queries.sql`
2. **Check documentation** for related features
3. **Test with similar videos** to understand capabilities
4. **Iterate on questions** to improve accuracy
5. **Contact support** for advanced use cases

---

**Ready to analyze your specific scenarios! 🎥✨**


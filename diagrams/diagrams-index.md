<img src="Snowflake_Logo.svg" alt="Snowflake Logo" width="200"/>

# Architecture Diagrams Index

Quick reference for all SVG diagrams in the project.

## Available Diagrams

| Diagram | Filename | Purpose | Used In |
|---------|----------|---------|---------|
| **Architecture** | `architecture.svg` | 5-layer system architecture | README.md, INSTALLATION_GUIDE.md |
| **Deployment** | `deployment-architecture.svg` | Deployment architecture | DEPLOYMENT_GUIDE.md |
| **Workflow** | `workflow.svg` | End-to-end video analysis workflow | README.md, QUICK_START.md |
| **System Components** | `system-components.svg` | Detailed component breakdown | PROJECT_SUMMARY.md |
| **Project Structure** | `project-structure.svg` | File/folder organization | README.md, PROJECT_SUMMARY.md |

## Preview

### Architecture
Shows the complete 5-layer architecture:
1. Streamlit UI Layer
2. Cortex AI Layer
3. Data Processing Layer
4. Storage Layer
5. Compute Layer

### Deployment Architecture
Illustrates production deployment including:
- User access via web browser
- Snowsight UI integration
- Database and schema structure
- Virtual warehouse configuration
- Security features

### Workflow
Step-by-step process flow:
1. Upload Video
2. Store in Stage
3. Register Metadata
4. Ask Question
5. Analyze with AI
6. Get Answer
7. Continuous feedback loop

### System Components
Detailed breakdown showing:
- Tables (VIDEO_METADATA, VIDEO_ANALYSIS_RESULTS, VIDEO_QUERIES)
- Procedures (REGISTER_VIDEO, LOG_VIDEO_QUERY, etc.)
- Views (VIDEO_SUMMARY)
- Layer interactions

### Project Structure
Visual representation of repository structure with all files and folders.

## Usage

Reference diagrams in markdown:

```markdown
![Architecture Diagram](diagrams/architecture.svg)
```

Or as HTML with custom sizing:

```html
<img src="diagrams/architecture.svg" width="600" alt="Architecture Diagram">
```

## Viewing Diagrams

- **GitHub/GitLab**: Renders automatically in markdown
- **VS Code**: Preview with Markdown Preview
- **Browser**: Open SVG files directly
- **Documentation Sites**: Works with most markdown renderers

---

See [README.md](README.md) in this directory for detailed diagram documentation.


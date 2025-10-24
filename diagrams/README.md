<img src="Snowflake_Logo.svg" alt="Snowflake Logo" width="200"/>

# Architecture Diagrams - SVG Files

This directory contains all architecture and workflow diagrams for the Snowflake Video Intelligence Demo in SVG format.

## Diagrams

### 1. architecture.svg
**Main Architecture Diagram**
- Shows the 5-layer architecture of the system
- Streamlit UI Layer
- Cortex AI Layer
- Data Processing Layer
- Storage Layer
- Compute Layer

**Used in:**
- README.md
- INSTALLATION_GUIDE.md

### 2. deployment-architecture.svg
**Deployment Architecture**
- Shows how components are deployed in Snowflake
- User access flow
- Snowsight UI
- Database and warehouse components
- Security features

**Used in:**
- DEPLOYMENT_GUIDE.md

### 3. workflow.svg
**Video Analysis Workflow**
- Shows the end-to-end workflow
- Upload → Store → Register → Ask → Analyze → Answer
- Includes feedback loop for analytics

**Used in:**
- README.md
- QUICK_START.md

### 4. system-components.svg
**Detailed System Components**
- Comprehensive view of all system components
- Tables, procedures, views breakdown
- Layer-by-layer detailed architecture

**Used in:**
- PROJECT_SUMMARY.md
- Technical documentation

## SVG File Specifications

All SVG files follow these standards:

- **Format:** SVG 1.1
- **Encoding:** UTF-8
- **Viewbox:** Responsive (scales to container)
- **Font:** Arial, sans-serif (system font for compatibility)
- **Color Scheme:** Matches Snowflake branding
  - Primary Blue: #29B5E8
  - Purple: #764ba2
  - Green: #00D4AA
  - Red: #FF4B4B
  - Navy: #4A90E2

## Editing SVG Files

### Using Code Editor
SVG files are text-based XML and can be edited directly in any text editor.

### Using Vector Graphics Tools
- **Adobe Illustrator** - Professional SVG editor
- **Inkscape** (Free) - Open-source vector graphics editor
- **Figma** - Web-based design tool
- **Sketch** - macOS design tool

### Online SVG Editors
- https://www.figma.com
- https://vectr.com
- https://boxy-svg.com

## Usage in Markdown

Reference SVG files in markdown documentation:

```markdown
![Architecture Diagram](diagrams/architecture.svg)
```

## Browser Compatibility

All SVG files are compatible with:
- ✅ Chrome/Edge (Chromium)
- ✅ Firefox
- ✅ Safari
- ✅ GitHub/GitLab rendering
- ✅ VS Code preview
- ✅ Most markdown viewers

## Customization

To customize diagrams for your organization:

1. **Colors:** Update fill and stroke attributes
2. **Text:** Modify text elements
3. **Sizes:** Adjust viewBox and element dimensions
4. **Logos:** Add custom logos as embedded images or paths

### Example: Changing Primary Color

Find all instances of `fill="#29B5E8"` and replace with your brand color.

## Exporting to Other Formats

### To PNG (Raster)
```bash
# Using Inkscape
inkscape architecture.svg --export-type=png --export-dpi=300

# Using ImageMagick
convert -density 300 architecture.svg architecture.png
```

### To PDF
```bash
# Using Inkscape
inkscape architecture.svg --export-type=pdf

# Using Chrome headless
chrome --headless --print-to-pdf=architecture.pdf architecture.svg
```

## File Sizes

| Diagram | File Size | Complexity |
|---------|-----------|------------|
| architecture.svg | ~4 KB | Simple |
| deployment-architecture.svg | ~5 KB | Medium |
| workflow.svg | ~6 KB | Medium |
| system-components.svg | ~7 KB | Complex |

Total: ~22 KB (minimal impact on repository size)

## Accessibility

All SVG files include:
- Descriptive text elements
- Semantic grouping with `<g>` tags
- Clear contrast ratios (WCAG 2.1 AA compliant)
- Readable font sizes

## Version Control

When updating diagrams:
1. Make changes to SVG files
2. Update this README if adding new diagrams
3. Verify rendering in markdown preview
4. Commit with descriptive message

---

**Need help?** See the main [README.md](../README.md) for more information.


# Contributing to Snowflake Video Intelligence Demo

Thank you for your interest in contributing to this project! This document provides guidelines and instructions for contributing.

## 🤝 How to Contribute

### Reporting Issues

If you encounter bugs or have feature requests:

1. **Check existing issues** first to avoid duplicates
2. **Create a new issue** with:
   - Clear, descriptive title
   - Detailed description of the problem or feature
   - Steps to reproduce (for bugs)
   - Expected vs. actual behavior
   - Screenshots (if applicable)
   - Environment details (Snowflake version, region, etc.)

### Suggesting Enhancements

We welcome suggestions for:
- New analysis capabilities
- UI/UX improvements
- Performance optimizations
- Additional documentation
- New use cases or examples

Please open an issue describing your enhancement with:
- **Use case:** Why is this needed?
- **Proposal:** How would it work?
- **Examples:** Provide concrete examples
- **Impact:** Who would benefit?

## 🔧 Development Setup

### Prerequisites

- Snowflake account with Cortex AI
- ACCOUNTADMIN or equivalent privileges
- Familiarity with SQL and Python
- Understanding of Streamlit framework

### Local Development (Optional)

For local testing of Streamlit components:

```bash
# Clone the repository
git clone <repository-url>
cd video-intelligence-demo

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Set up Snowflake credentials
# Create a .env file with:
# SNOWFLAKE_ACCOUNT=<your_account>
# SNOWFLAKE_USER=<your_user>
# SNOWFLAKE_PASSWORD=<your_password>
```

## 📝 Code Style Guidelines

### SQL Code

```sql
-- Use uppercase for keywords
SELECT 
    column_name,
    COUNT(*) AS total_count
FROM table_name
WHERE condition = TRUE
GROUP BY column_name
ORDER BY total_count DESC;

-- Add comments for complex logic
-- Descriptive naming conventions
-- Consistent indentation (4 spaces)
```

### Python Code

```python
# Follow PEP 8 style guide
# Use type hints where applicable
# Add docstrings to functions

def analyze_video(video_id: str, question: str) -> str:
    """
    Analyze video using Cortex AI.
    
    Args:
        video_id: Unique identifier for the video
        question: Natural language question about the video
        
    Returns:
        Analysis result as a string
    """
    # Implementation here
    pass
```

### Streamlit UI

- Use descriptive variable names
- Add helpful tooltips and help text
- Provide clear error messages
- Follow the existing UI patterns
- Ensure responsive design

## 🧪 Testing

### Manual Testing Checklist

Before submitting changes:

- [ ] SQL scripts run without errors
- [ ] Streamlit app loads correctly
- [ ] All tabs functional
- [ ] Video upload works
- [ ] Query analysis returns results
- [ ] No Python errors in console
- [ ] No SQL errors in logs
- [ ] Performance is acceptable

### Test Cases

Include test cases for:
- Video upload (various formats)
- Question answering (different types)
- Edge cases (empty inputs, large files)
- Error handling
- Permission scenarios

## 📚 Documentation

When contributing, please update:

### README.md
- Feature descriptions
- Usage examples
- Screenshots (if UI changed)

### INSTALLATION_GUIDE.md
- New setup steps
- Configuration changes
- Troubleshooting sections

### Code Comments
- Complex logic explanations
- SQL query purposes
- Function documentation

## 🎯 Areas for Contribution

### High Priority
- [ ] Enhanced video analysis capabilities
- [ ] Performance optimizations
- [ ] Additional security features
- [ ] More comprehensive error handling
- [ ] Expanded test coverage

### Medium Priority
- [ ] Additional UI themes
- [ ] Export functionality improvements
- [ ] Batch processing features
- [ ] Advanced analytics dashboards
- [ ] Mobile responsiveness

### Low Priority (Nice to Have)
- [ ] Multi-language support
- [ ] Custom model training
- [ ] Video comparison tools
- [ ] Real-time streaming analysis
- [ ] Integration examples

## 🚀 Submission Process

### For Small Changes (Documentation, Bug Fixes)

1. **Fork the repository**
2. **Create a branch:** `git checkout -b fix/description`
3. **Make your changes**
4. **Test thoroughly**
5. **Commit:** `git commit -m "Fix: description of change"`
6. **Push:** `git push origin fix/description`
7. **Submit pull request**

### For Large Changes (Features, Major Refactors)

1. **Open an issue first** to discuss the change
2. **Wait for feedback** from maintainers
3. **Fork and create feature branch:** `git checkout -b feature/description`
4. **Implement the feature**
5. **Add tests and documentation**
6. **Submit pull request** with detailed description

## 📋 Pull Request Guidelines

### PR Title Format
```
[Type] Brief description

Examples:
[Feature] Add video comparison tool
[Fix] Correct SQL syntax in query
[Docs] Update installation guide
[Perf] Optimize video upload process
```

### PR Description Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Code refactoring

## Testing
Describe testing performed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings generated
- [ ] Tests pass
```

## 🔍 Code Review Process

### What We Look For
- **Functionality:** Does it work as intended?
- **Code Quality:** Is it clean and maintainable?
- **Performance:** Any performance impacts?
- **Security:** Any security concerns?
- **Documentation:** Is it well-documented?
- **Testing:** Adequately tested?

### Review Timeline
- Small changes: 1-3 days
- Medium changes: 3-7 days
- Large changes: 1-2 weeks

## 🏆 Recognition

Contributors will be:
- Acknowledged in release notes
- Listed in CONTRIBUTORS.md (if we create one)
- Mentioned in relevant documentation

## ❓ Questions?

If you have questions about contributing:

- **Open an issue** with the "question" label
- **Join discussions** in existing issues
- **Contact maintainers** via email (if provided)

## 📜 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors.

### Our Standards

**Positive behavior:**
- Using welcoming and inclusive language
- Being respectful of differing viewpoints
- Gracefully accepting constructive criticism
- Focusing on what's best for the community

**Unacceptable behavior:**
- Harassment or discriminatory language
- Trolling or insulting comments
- Public or private harassment
- Publishing others' private information

### Enforcement

Violations may result in:
1. Warning from maintainers
2. Temporary ban from project
3. Permanent ban from project

## 🙏 Thank You!

Your contributions help make this project better for everyone. We appreciate your time and effort!

---

**Happy Contributing! 🎉**


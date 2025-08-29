# Easy Prompt App - Brainstorming Session Results

## Executive Summary

**Session Topic:** Easy Prompt - AI-powered content planning and prompt generation app  
**Date:** August 21, 2025  
**Techniques Used:** First Principles Thinking, SCAMPER Method, Role Playing  
**Total Ideas Generated:** 25+ concepts refined to core MVP  
**Key Innovation:** Two-stage generation (content → prompts) with dual-mode approach

## Core Concept Definition

### The Problem
Content creators need high-quality prompts for Google's VEO3 and Image Generation tools, but creating effective prompts requires deep technical knowledge and significant time investment.

### The Solution - MVP Architecture

**Input Simplicity:** 3 essential fields only
1. Business type (text field)
2. Target audience (text field)  
3. Content goal (text field)

**Dual Mode System:**
- **Quick Mode:** Instant generation (3 inputs → immediate results)
- **Quality Mode:** Detailed setup with full SMM brief for better results

**Two-Stage Generation:**
1. Stage 1: Generate week's content ideas with captions
2. Stage 2: Generate prompts for selected content (user-triggered)

## Technical Insights from First Principles

### VEO3 Prompt Fundamentals (from research)
- JSON structure critical for consistency
- Camera positioning with "(thats where the camera is)" syntax
- Audio layering (dialogue, primary sounds, ambient)
- 8-second video constraint shapes content design
- Movement quality descriptors essential

### Image Generation Fundamentals (from research)
- 4 core elements: subject, context, visual quality, technical markers
- Imagen 4 family optimal for quality/cost balance
- JSON provides 300% better consistency than plain text
- Hierarchical prompt structure maximizes quality

## Feature Innovation (SCAMPER Results)

### Core MVP Features
1. **3-Input Quick Mode**
   - Minimal friction entry point
   - Instant gratification
   - Perfect for testing/iteration

2. **Content-First Approach**
   - See content plan before committing to prompts
   - Allows human curation/selection
   - Reduces credit waste on unwanted content

3. **Prompt Generation Button**
   - User-triggered per content piece
   - Transparent credit usage
   - Enables selective high-quality generation

### Eliminated Complexity
- No multi-client management
- No saved profiles (single-use)
- No complex categorization
- No advanced settings in Quick Mode
- Reduced 12 sections to 3 inputs

## User Experience Flow

### Quick Mode Journey
1. Open app → See 3 fields
2. Enter: "Coffee shop" / "Young professionals" / "Drive morning traffic"
3. Tap "Generate Week" → 5-10 second wait
4. See 7 days of content ideas with captions
5. Select any content piece → Tap "Generate Prompts"
6. Receive VEO3 + Image prompts in JSON format
7. Copy and use in Google's platforms

### Quality Mode Journey
1. Choose "Quality Mode" toggle
2. Fill comprehensive SMM brief (all 12 sections)
3. Generate more nuanced, brand-aligned content
4. Same prompt generation flow

## System Prompt Requirements

### Critical Knowledge Areas
1. **Content Planning Expertise**
   - SMM category understanding
   - Platform-specific optimization
   - Engagement patterns

2. **VEO3 Mastery**
   - JSON structure formatting
   - Camera positioning syntax
   - Audio specification layers
   - 8-second scene construction

3. **Image Generation Excellence**
   - Imagen 4 optimization
   - Hierarchical prompt structure
   - Negative prompt strategy
   - Style consistency

### Prompt Engineering Rules
- Always output JSON format for consistency
- Include negative prompts by default
- Specify all audio layers for VEO3
- Front-load critical elements
- Maintain brand voice consistency across week

## Implementation Architecture (SwiftUI)

### Core Views
1. **InputView:** 3 fields + mode toggle
2. **ContentPlanView:** Weekly grid with content cards
3. **PromptDetailView:** JSON prompts display with copy function

### Data Models
```swift
struct ContentInput {
    let businessType: String
    let targetAudience: String
    let contentGoal: String
    let mode: GenerationMode
}

struct ContentPiece {
    let day: String
    let category: String
    let caption: String
    let hashtags: [String]
    var imagePrompt: String?
    var videoPrompt: String?
}
```

### AI Integration
- Single API call for content generation
- Separate call per prompt generation
- Local caching of generated content
- No backend required for MVP

## Success Metrics

### MVP Validation Targets
- Generate coherent week plan in <10 seconds
- Prompt quality score >85% (user feedback)
- VEO3 prompts produce usable videos 80%+ of time
- Image prompts achieve aesthetic score >7.0
- User can go from input to prompts in <3 minutes

### Quality Indicators
- Content variety across week
- Platform-appropriate formatting
- Technical prompt accuracy
- Brand consistency maintenance

## Next Steps

### Immediate Actions
1. Create SwiftUI prototype with 3-field input
2. Develop system prompt combining all requirements
3. Test with sample inputs across different business types
4. Iterate on prompt quality based on generation results

### Future Enhancements (Post-MVP)
- Saved templates for repeat users
- Performance analytics on generated content
- Direct API integration with Google platforms
- Multi-week planning
- Competitor analysis integration

## Key Insights

### What Makes This Different
1. **Radical Simplicity:** 3 inputs vs 12+ in competitors
2. **Two-Stage Generation:** See before you spend credits
3. **Technical Excellence:** Deep VEO3/Imagen optimization
4. **Speed Focus:** Quick Mode for instant results

### Critical Success Factors
1. System prompt quality determines everything
2. JSON formatting must be perfect
3. Speed of generation crucial for Quick Mode
4. Content quality must justify prompt generation

### Risk Mitigation
- Start with single-use to avoid complexity
- Focus on prompt quality over features
- Test extensively with real VEO3/Imagen
- Keep UI dead simple

## Session Reflection

### What Worked Well
- Identifying radical simplification opportunity (12→3 inputs)
- Two-stage generation concept
- Dual-mode approach for different users
- Focus on technical prompt excellence

### Key Decisions Made
1. MVP uses 3 inputs only
2. Content first, then prompts
3. Single-use simplicity
4. Quick vs Quality modes
5. JSON output format

### Questions Resolved
- How simple can we make it? → 3 fields
- When to generate prompts? → User-triggered
- How to balance speed/quality? → Dual modes
- What's the core value? → Perfect prompts

This MVP approach balances radical simplicity with technical excellence, creating a tool that's both accessible to beginners and valuable to professionals.
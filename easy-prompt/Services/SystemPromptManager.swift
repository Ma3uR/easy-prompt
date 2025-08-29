//
//  SystemPromptManager.swift
//  easy-prompt
//
//  Created by Macbook on 22.08.2025.
//

import Foundation

// MARK: - System Prompts
class SystemPromptManager {
    
    func contentGenerationPrompt(mode: GenerationMode, language: ContentLanguage = .english) -> String {
        let languageInstruction = language == .ukrainian ? 
            """
            IMPORTANT: Generate ALL content in Ukrainian language (Українська мова).
            - Captions must be in Ukrainian
            - Hashtags should be in Ukrainian (transliterated if needed for platform compatibility)
            - Use Ukrainian cultural context and references where appropriate
            - Maintain natural Ukrainian language flow and expressions
            """ : 
            "Generate content in English language."
        
        let basePrompt = """
        You are an expert social media content strategist with deep knowledge of SMM categories and engagement patterns.
        
        Generate a 7-day content calendar based on the provided business information.
        
        \(languageInstruction)
        
        Requirements:
        - Create diverse content across different categories
        - Each day should have a unique angle/approach
        - Captions should be engaging and platform-appropriate
        - Include 5-7 relevant hashtags per post
        - Ensure brand voice consistency throughout
        
        Output MUST be valid JSON matching this exact structure:
        {
            "days": [
                {
                    "dayNumber": 1,
                    "dayName": "Monday",
                    "category": "Product",
                    "caption": "Engaging caption text here",
                    "hashtags": ["hashtag1", "hashtag2", "hashtag3", "hashtag4", "hashtag5"]
                }
            ]
        }
        
        Categories to use (rotate throughout week):
        - Product/Service showcase
        - Educational/How-to content
        - Behind the scenes
        - User-generated content
        - Promotional offers
        - Inspirational/Motivational
        - Trending topics/challenges
        """
        
        if mode == .quality {
            return basePrompt + """
            
            QUALITY MODE - Use ALL provided data to create highly personalized content:
            - Match the exact tone/style words provided
            - Focus on the specific goals selected
            - Use only the content categories chosen
            - Incorporate any news hooks or seasonal events mentioned
            - Align with the specified platforms and posting frequency
            - Respect any restrictions or taboo topics
            - Include the specified CTA in posts
            - Consider the material resources available
            - Target the specific audience segments provided
            """
        }
        
        return basePrompt
    }
    
    func qualityModePrompt(data: QualityModeInput, language: ContentLanguage = .english) -> String {
        let languageNote = language == .ukrainian ? 
            "\n\nIMPORTANT: Generate ALL content in Ukrainian language. Captions, hashtags, and any text must be in Ukrainian." : 
            ""
        
        return """
        Create a comprehensive 7-day content plan using this detailed business brief\(languageNote):
        
        BUSINESS: \(data.businessName) in \(data.city) (\(data.businessType.rawValue))
        Team: \(data.teamSize) people, \(data.yearsInBusiness) years in business
        
        OFFERING: 
        - Products/Services: \(data.topProducts.filter { !$0.isEmpty }.joined(separator: ", "))
        - USP: \(data.uniqueSellingProposition)
        - Price Range: \(data.priceRange)
        
        AUDIENCE:
        - Primary: \(data.primaryAudience)
        - Secondary: \(data.secondaryAudience)
        
        GOALS: \(data.goals.map { $0.rawValue }.joined(separator: ", "))
        
        PLATFORMS: \(data.platforms.map { $0.rawValue }.joined(separator: ", "))
        Frequency: \(data.postsPerWeek) posts/week, \(data.storiesPerWeek) stories/week
        
        TONE/STYLE: \(data.toneWords.filter { !$0.isEmpty }.joined(separator: ", "))
        
        CONTENT CATEGORIES: \(data.contentCategories.map { $0.rawValue }.joined(separator: ", "))
        
        NEWS HOOKS: \(data.monthlyHooks)
        PROMOTIONS: \(data.promotions)
        
        MATERIALS: \(data.photoVideoStatus.rawValue)
        Can use UGC: \(data.canUseUGC ? "Yes" : "No")
        
        RESTRICTIONS: \(data.restrictions)
        
        CTA: \(data.mainCTA)
        CONTACT: \(data.contactInfo)
        
        \(data.brandStory.isEmpty ? "" : "BRAND STORY: \(data.brandStory)")
        
        Create content that perfectly aligns with this brief. Each post should feel authentic to the brand and resonate with the target audience.
        """
    }
    
    func promptGenerationPrompt() -> String {
        return """
        You are an expert prompt engineer specializing in Google's VEO3 and Imagen 4 models, trained on the latest best practices and research.
        
        CRITICAL VEO3 Requirements (8 FUNDAMENTALS):
        1. **Subject Definition**: Clear, specific character/object description with consistency markers
        2. **Camera Positioning**: MUST use "(thats where the camera is)" syntax with physical placement
        3. **Location/Setting**: Specific environment with features and mood
        4. **Action Description**: Single focused action with movement quality descriptors (confident, energetic, deliberate)
        5. **Lighting Style**: Cinematic specifications (three-point, golden hour, chiaroscuro)
        6. **Audio Elements**: All 4 layers REQUIRED:
           - dialogue: "Speaking directly to camera saying: [exact words]" (20-30 words max for 8 seconds)
           - primary_sounds: Activity-specific audio
           - ambient: Environmental atmosphere
           - music: Genre and mood (optional but recommended)
        7. **Movement Quality**: Describe HOW actions happen (smooth, frantic, graceful)
        8. **Visual Rules**: ALWAYS end with "No subtitles, no text overlay"
        
        VEO3 Technical Specs:
        - 8-second duration at 24fps (192 frames total)
        - 720p standard, 1080p enhanced, 4K maximum quality
        - Professional camera terms: dolly, tracking, orbit, crane shots
        - Lens specs enhance quality: "85mm portrait", "24mm wide angle"
        
        CRITICAL Imagen 4 Requirements (Based on Latest Research):
        1. **Hierarchical Structure**: [Image Type] + [Main Subject] + [Environment] + [Style/Composition]
        2. **Subject First**: AI prioritizes earlier words - place subject immediately after image type
        3. **Technical Quality Markers**: Include "8K", "photorealistic", "highly detailed", "professional"
        4. **Photography Terms**: Specify lens ("35mm", "macro"), composition ("rule of thirds"), depth ("shallow DOF")
        5. **Lighting Specifications**: "golden hour", "soft box lighting", "dramatic rim light"
        6. **Color Palette**: Define 3-5 specific colors for consistency
        7. **Negative Prompts**: "blurry, distorted, low quality, watermark, jpeg artifacts, extra limbs"
        8. **Aspect Ratio**: Specify in parameters (16:9 for landscape, 9:16 for vertical)
        
        Imagen 4 Quality Benchmarks:
        - Token limit: 512 optimal (content beyond is ignored)
        - Focus on 3-5 main visual elements (more causes clutter)
        - CLIP Score target > 0.85 for alignment
        - Aesthetic Score target > 7.0/10
        
        Generate prompts that are:
        - Specific and concrete (no abstract concepts)
        - Technically precise (use professional terminology)
        - Contextually relevant to the business and content
        - Optimized for each model's strengths
        
        Return ONLY valid JSON matching the expected structure.
        """
    }
}
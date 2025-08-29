//
//  AIService.swift
//  easy-prompt
//
//  Created by Macbook on 22.08.2025.
//

import Foundation

// MARK: - OpenAI Response Models
struct OpenAIResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
    }
    
    struct Message: Codable {
        let content: String
    }
}

struct OpenAIRequest: Codable {
    let model: String
    let messages: [OpenAIMessage]
    let temperature: Double
    let max_tokens: Int
}

struct OpenAIMessage: Codable {
    let role: String
    let content: String
}

// MARK: - AI Service
class AIService {
    private let apiKey: String
    private let session: URLSession
    private let systemPromptManager: SystemPromptManager
    
    init() {
        self.apiKey = Configuration.openAIKey
        self.session = URLSession.shared
        self.systemPromptManager = SystemPromptManager()
    }
    
    func generateContent(from input: ContentInput, qualityData: QualityModeInput? = nil) async throws -> WeeklyContent {
        // Check if API key is configured
        guard !Configuration.openAIKey.isEmpty && !Configuration.openAIKey.contains("YOUR_OPENAI_API_KEY_HERE") else {
            throw GenerationError.aiServiceError("OpenAI API key is not configured. Please add your API key in Configuration.swift")
        }
        
        let systemPrompt: String
        let userPrompt: String
        
        if input.mode == .quality, let qualityData = qualityData {
            systemPrompt = systemPromptManager.contentGenerationPrompt(mode: .quality, language: input.language)
            userPrompt = systemPromptManager.qualityModePrompt(data: qualityData, language: input.language)
        } else {
            systemPrompt = systemPromptManager.contentGenerationPrompt(mode: input.mode, language: input.language)
            userPrompt = formatUserPrompt(from: input)
        }
        
        let request = try createRequest(
            system: systemPrompt,
            user: userPrompt,
            temperature: 0.7,
            maxTokens: 3000
        )
        
        let (data, response) = try await session.data(for: request)
        
        // Check for API errors
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode != 200 {
                if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let error = errorData["error"] as? [String: Any],
                   let message = error["message"] as? String {
                    throw GenerationError.aiServiceError("OpenAI API Error: \(message)")
                }
                throw GenerationError.aiServiceError("API request failed with status \(httpResponse.statusCode)")
            }
        }
        
        let aiResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        return try parseWeeklyContent(from: aiResponse, input: input)
    }
    
    func generatePrompts(for day: DayContent,
                        businessContext: ContentInput) async throws -> (image: ImagePrompt, video: VideoPrompt) {
        let systemPrompt = systemPromptManager.promptGenerationPrompt()
        let userPrompt = formatPromptRequest(day: day, context: businessContext)
        
        let request = try createRequest(
            system: systemPrompt,
            user: userPrompt,
            temperature: 0.3, // Lower temperature for consistency
            maxTokens: 3000
        )
        
        let (data, _) = try await session.data(for: request)
        let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        
        return try parsePrompts(from: response)
    }
    
    private func createRequest(system: String, user: String, temperature: Double, maxTokens: Int) throws -> URLRequest {
        guard !apiKey.isEmpty else {
            throw GenerationError.aiServiceError("OpenAI API key is not configured")
        }
        
        var request = URLRequest(url: URL(string: Configuration.apiEndpoint)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = OpenAIRequest(
            model: Configuration.model,
            messages: [
                OpenAIMessage(role: "system", content: system),
                OpenAIMessage(role: "user", content: user)
            ],
            temperature: temperature,
            max_tokens: maxTokens
        )
        
        request.httpBody = try JSONEncoder().encode(requestBody)
        request.timeoutInterval = Configuration.timeout
        
        return request
    }
    
    private func formatUserPrompt(from input: ContentInput) -> String {
        let languageNote = input.language == .ukrainian ? 
            "\nLANGUAGE: Generate all content in Ukrainian (captions and hashtags in Ukrainian)." : 
            ""
        
        return """
        Business Type: \(input.businessType)
        Target Audience: \(input.targetAudience)
        Content Goal: \(input.contentGoal)\(languageNote)
        
        Generate a 7-day content calendar with diverse, engaging posts.
        IMPORTANT: Return ONLY valid JSON, no additional text or explanation.
        
        Return as JSON matching this EXACT structure:
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
        
        Ensure all 7 days are included with unique, engaging content.
        """
    }
    
    private func formatPromptRequest(day: DayContent, context: ContentInput) -> String {
        let languageNote = context.language == .ukrainian ? 
            "\n        - Language: Ukrainian (Generate prompts that will create Ukrainian content)" : 
            ""
        
        return """
        Business Context:
        - Type: \(context.businessType)
        - Audience: \(context.targetAudience)
        - Goal: \(context.contentGoal)\(languageNote)
        
        Content Details:
        - Day: \(day.dayName)
        - Category: \(day.category.rawValue)
        - Caption: \(day.caption)
        - Hashtags: \(day.hashtags.joined(separator: ", "))
        
        Generate optimized VEO3 video prompt and Imagen 4 image prompt for this content.
        Style reference: \(categoryPromptStyles[day.category] ?? "professional style")
        
        Return ONLY valid JSON matching this structure:
        {
            "imagePrompt": {
                "prompt": {
                    "subject": "detailed subject description",
                    "environment": "environment description",
                    "style": "visual style",
                    "lighting": "lighting setup",
                    "camera": {
                        "angle": "camera angle",
                        "distance": "shot distance",
                        "lens": "lens type"
                    },
                    "colorPalette": ["color1", "color2", "color3"]
                },
                "negativePrompt": "things to avoid",
                "parameters": {
                    "model": "imagen-4",
                    "aspectRatio": "16:9",
                    "sampleCount": 2
                }
            },
            "videoPrompt": {
                "promptName": "prompt name",
                "coreContent": "core concept",
                "details": {
                    "sceneEnvironment": {
                        "setting": "setting description",
                        "features": "features",
                        "mood": "mood"
                    },
                    "subject": {
                        "description": "subject description",
                        "wardrobe": "wardrobe details",
                        "characterConsistency": "consistency notes"
                    },
                    "visualStyle": {
                        "aesthetic": "aesthetic style",
                        "resolution": "720p",
                        "lighting": "lighting description"
                    },
                    "cameraWork": {
                        "composition": "composition rules",
                        "cameraMotion": "camera movement",
                        "positioning": "camera position (thats where the camera is)"
                    },
                    "audio": {
                        "dialogue": "Speaking directly to camera saying: [words]",
                        "primarySounds": "primary sounds",
                        "ambient": "ambient sounds",
                        "music": "background music"
                    }
                },
                "negativePrompt": "things to avoid",
                "visualRules": "No subtitles, no text overlay"
            }
        }
        """
    }
    
    private func parseWeeklyContent(from response: OpenAIResponse, input: ContentInput) throws -> WeeklyContent {
        guard let content = response.choices.first?.message.content else {
            throw GenerationError.aiServiceError("No content in AI response")
        }
        
        // Clean the response - remove markdown code blocks if present
        let cleanedContent = content
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Try to extract JSON from the response
        let jsonString: String
        if let extracted = extractJSON(from: cleanedContent) {
            jsonString = extracted
        } else if cleanedContent.hasPrefix("{") && cleanedContent.hasSuffix("}") {
            jsonString = cleanedContent
        } else {
            // If no valid JSON found, throw error
            print("Error: Could not extract valid JSON from response")
            print("Raw response: \(cleanedContent)")
            throw GenerationError.aiServiceError("Invalid response format from AI. Please try again.")
        }
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Error: Failed to convert to data: \(jsonString)")
            throw GenerationError.aiServiceError("Failed to process AI response. Please try again.")
        }
        
        do {
            let decoder = JSONDecoder()
            let parsedResponse = try decoder.decode(ContentGenerationResponse.self, from: jsonData)
            
            // Validate we have 7 days
            guard parsedResponse.days.count == 7 else {
                throw GenerationError.aiServiceError("AI generated \(parsedResponse.days.count) days instead of 7. Please try again.")
            }
            
            let days = parsedResponse.days.map { dayData in
                DayContent(
                    dayNumber: dayData.dayNumber,
                    dayName: dayData.dayName,
                    category: ContentCategory(rawValue: dayData.category) ?? .product,
                    caption: dayData.caption,
                    hashtags: dayData.hashtags,
                    imagePrompt: nil,
                    videoPrompt: nil,
                    isGenerated: false
                )
            }
            
            return WeeklyContent(input: input, days: days)
        } catch {
            print("JSON Parsing Error: \(error)")
            print("Raw content: \(jsonString)")
            throw GenerationError.aiServiceError("Failed to parse AI response: \(error.localizedDescription)")
        }
    }
    
    private func parsePrompts(from response: OpenAIResponse) throws -> (image: ImagePrompt, video: VideoPrompt) {
        guard let content = response.choices.first?.message.content else {
            throw GenerationError.aiServiceError("Invalid prompt generation response")
        }
        
        // Clean and parse the JSON response
        let cleanedContent = content
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Try to parse the AI-generated prompts
        if let jsonData = cleanedContent.data(using: .utf8) {
            do {
                // Try to decode the response into prompt structures
                let decoder = JSONDecoder()
                if let promptResponse = try? decoder.decode(PromptGenerationResponse.self, from: jsonData) {
                    return (promptResponse.imagePrompt, promptResponse.videoPrompt)
                }
            } catch {
                print("Failed to parse prompt JSON: \(error)")
            }
        }
        
        // If parsing fails, throw error
        throw GenerationError.aiServiceError("Failed to generate prompts. Please try again.")
    }
    
    private func extractJSON(from text: String) -> String? {
        // Try to find JSON content between curly braces
        guard let startIndex = text.firstIndex(of: "{"),
              let endIndex = text.lastIndex(of: "}"),
              startIndex < endIndex else {
            return nil
        }
        
        // Create substring safely
        let jsonSubstring = String(text[startIndex...endIndex])
        return jsonSubstring
    }
}

// Helper struct for parsing content generation response
private struct ContentGenerationResponse: Codable {
    let days: [DayData]
    
    struct DayData: Codable {
        let dayNumber: Int
        let dayName: String
        let category: String
        let caption: String
        let hashtags: [String]
    }
}

// Helper struct for parsing prompt generation response
private struct PromptGenerationResponse: Codable {
    let imagePrompt: ImagePrompt
    let videoPrompt: VideoPrompt
}
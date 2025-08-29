//
//  ContentModels.swift
//  easy-prompt
//
//  Created by Macbook on 22.08.2025.
//

import Foundation

// MARK: - Input Models
struct ContentInput: Codable, Hashable {
    let id: UUID = UUID()
    var businessType: String
    var targetAudience: String
    var contentGoal: String
    var mode: GenerationMode
    var language: ContentLanguage = .english
    let createdAt: Date = Date()
}

enum GenerationMode: String, Codable, CaseIterable {
    case quick = "quick"
    case quality = "quality"
}

enum ContentLanguage: String, CaseIterable, Codable {
    case english = "English"
    case ukrainian = "Українська"
    
    var code: String {
        switch self {
        case .english: return "en"
        case .ukrainian: return "uk"
        }
    }
    
    var flag: String {
        switch self {
        case .english: return "🇬🇧"
        case .ukrainian: return "🇺🇦"
        }
    }
}

// MARK: - Content Models
struct WeeklyContent: Codable, Hashable {
    let id: UUID = UUID()
    let input: ContentInput
    var days: [DayContent]
    let generatedAt: Date = Date()
}

struct DayContent: Codable, Identifiable, Hashable {
    let id: UUID = UUID()
    let dayNumber: Int // 1-7
    let dayName: String // "Monday"
    let category: ContentCategory
    let caption: String
    let hashtags: [String]
    var imagePrompt: ImagePrompt?
    var videoPrompt: VideoPrompt?
    var isGenerated: Bool = false
}

enum ContentCategory: String, Codable, CaseIterable {
    case product = "Product"
    case educational = "Educational"
    case behindScenes = "Behind the Scenes"
    case userContent = "User Content"
    case promotional = "Promotional"
    case inspirational = "Inspirational"
    case trending = "Trending"
    
    var color: String {
        switch self {
        case .product: return "blue"
        case .educational: return "green"
        case .behindScenes: return "purple"
        case .userContent: return "orange"
        case .promotional: return "red"
        case .inspirational: return "yellow"
        case .trending: return "pink"
        }
    }
    
    var icon: String {
        switch self {
        case .product: return "bag.fill"
        case .educational: return "graduationcap.fill"
        case .behindScenes: return "camera.fill"
        case .userContent: return "person.2.fill"
        case .promotional: return "megaphone.fill"
        case .inspirational: return "sparkles"
        case .trending: return "chart.line.uptrend.xyaxis"
        }
    }
}

// MARK: - Category Style Mapping
let categoryPromptStyles = [
    ContentCategory.product: "professional product photography, studio lighting",
    ContentCategory.educational: "clean infographic style, educational diagram",
    ContentCategory.behindScenes: "documentary style, candid moment",
    ContentCategory.userContent: "authentic user-generated content style",
    ContentCategory.promotional: "eye-catching promotional design, bold colors",
    ContentCategory.inspirational: "motivational aesthetic, uplifting mood",
    ContentCategory.trending: "viral content style, dynamic and energetic"
]
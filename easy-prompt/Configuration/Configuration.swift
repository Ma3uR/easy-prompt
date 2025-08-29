//
//  Configuration.swift
//  easy-prompt
//
//  Created by Macbook on 22.08.2025.
//

import Foundation

enum Configuration {
    // PLACEHOLDER: Replace with your actual OpenAI API key
    static let openAIKey = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String ?? 
                          ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? "your-api-key"
    
    static let apiEndpoint = "https://api.openai.com/v1/chat/completions"
    static let model = "gpt-4o-mini" // Using newer, more cost-effective model
    static let maxRetries = 3
    static let timeout: TimeInterval = 30
}

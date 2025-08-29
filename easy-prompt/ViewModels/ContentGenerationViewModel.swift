//
//  ContentGenerationViewModel.swift
//  easy-prompt
//
//  Created by Macbook on 22.08.2025.
//

import Foundation
import SwiftUI

// MARK: - Main View Model
@MainActor
class ContentGenerationViewModel: ObservableObject {
    @Published var currentInput = ContentInput(
        businessType: "",
        targetAudience: "",
        contentGoal: "",
        mode: .quick
    )
    
    @Published var qualityModeData = QualityModeInput()
    @Published var weeklyContent: WeeklyContent?
    @Published var isGenerating = false
    @Published var error: GenerationError?
    @Published var selectedDay: DayContent?
    
    private let aiService: AIService
    private let storageService: StorageService
    
    init(aiService: AIService = AIService(),
         storageService: StorageService = StorageService()) {
        self.aiService = aiService
        self.storageService = storageService
    }
    
    func generateWeeklyContent() async {
        isGenerating = true
        error = nil
        
        do {
            let content: WeeklyContent
            
            if currentInput.mode == .quality {
                // Use quality mode data
                content = try await aiService.generateContent(
                    from: currentInput,
                    qualityData: qualityModeData
                )
            } else {
                // Use quick mode with basic inputs
                content = try await aiService.generateContent(from: currentInput)
            }
            
            await MainActor.run {
                self.weeklyContent = content
                self.isGenerating = false
            }
            
            // Save to storage if API key is configured
            if !Configuration.openAIKey.contains("YOUR_OPENAI_API_KEY_HERE") {
                try await storageService.save(content)
            }
        } catch {
            await MainActor.run {
                self.error = GenerationError.from(error)
                self.isGenerating = false
            }
        }
    }
    
    func generatePrompts(for day: DayContent) async {
        do {
            let prompts = try await aiService.generatePrompts(
                for: day,
                businessContext: currentInput
            )
            
            await MainActor.run {
                if let index = weeklyContent?.days.firstIndex(where: { $0.id == day.id }) {
                    weeklyContent?.days[index].imagePrompt = prompts.image
                    weeklyContent?.days[index].videoPrompt = prompts.video
                    weeklyContent?.days[index].isGenerated = true
                }
            }
        } catch {
            await MainActor.run {
                self.error = GenerationError.from(error)
            }
        }
    }
    
}
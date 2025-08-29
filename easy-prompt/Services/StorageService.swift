//
//  StorageService.swift
//  easy-prompt
//
//  Created by Macbook on 22.08.2025.
//

import Foundation
import SwiftData

// MARK: - Storage Service
class StorageService {
    private var container: ModelContainer?
    private var context: ModelContext?
    
    init() {
        setupContainer()
    }
    
    private func setupContainer() {
        do {
            let schema = Schema([
                StoredContent.self
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            if let container = container {
                context = ModelContext(container)
            }
        } catch {
            print("Failed to setup SwiftData container: \(error)")
        }
    }
    
    @MainActor
    func save(_ content: WeeklyContent) async throws {
        guard let context = context else {
            throw StorageError(message: "Storage not initialized")
        }
        
        let stored = StoredContent(from: content)
        context.insert(stored)
        
        do {
            try context.save()
        } catch {
            throw StorageError(message: "Failed to save content: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func loadHistory() async throws -> [WeeklyContent] {
        guard let context = context else {
            throw StorageError(message: "Storage not initialized")
        }
        
        let descriptor = FetchDescriptor<StoredContent>(
            sortBy: [SortDescriptor(\.generatedAt, order: .reverse)]
        )
        
        do {
            let items = try context.fetch(descriptor)
            return items.compactMap { $0.toWeeklyContent() }
        } catch {
            throw StorageError(message: "Failed to load history: \(error.localizedDescription)")
        }
    }
}

// SwiftData Model
@Model
final class StoredContent {
    var id: UUID
    var businessType: String
    var targetAudience: String
    var contentGoal: String
    var mode: String
    var contentData: Data?
    var generatedAt: Date
    
    init(from content: WeeklyContent) {
        self.id = content.id
        self.businessType = content.input.businessType
        self.targetAudience = content.input.targetAudience
        self.contentGoal = content.input.contentGoal
        self.mode = content.input.mode.rawValue
        self.generatedAt = content.generatedAt
        
        // Encode the full content as JSON
        if let data = try? JSONEncoder().encode(content) {
            self.contentData = data
        }
    }
    
    func toWeeklyContent() -> WeeklyContent? {
        guard let data = contentData,
              let content = try? JSONDecoder().decode(WeeklyContent.self, from: data) else {
            return nil
        }
        return content
    }
}
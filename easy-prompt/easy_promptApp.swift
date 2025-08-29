//
//  easy_promptApp.swift
//  easy-prompt
//
//  Created by Macbook on 22.08.2025.
//

import SwiftUI
import SwiftData

@main
struct easy_promptApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            StoredContent.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

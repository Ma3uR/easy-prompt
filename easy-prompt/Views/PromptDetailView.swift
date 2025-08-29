//
//  PromptDetailView.swift
//  easy-prompt
//
//  Created by Macbook on 22.08.2025.
//

import SwiftUI
import UIKit

// MARK: - Prompts View
struct PromptsView: View {
    let day: DayContent
    @State private var selectedTab = 0
    @State private var copiedPrompt: String?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Prompt Type", selection: $selectedTab) {
                    Text("VEO3 Video").tag(0)
                    Text("Imagen 4").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                
                TabView(selection: $selectedTab) {
                    PromptDisplayView(
                        title: "VEO3 Video Prompt",
                        jsonContent: day.videoPrompt?.asJSON ?? "",
                        onCopy: { copyToClipboard(day.videoPrompt?.asJSON ?? "") }
                    )
                    .tag(0)
                    
                    PromptDisplayView(
                        title: "Imagen 4 Prompt",
                        jsonContent: day.imagePrompt?.asJSON ?? "",
                        onCopy: { copyToClipboard(day.imagePrompt?.asJSON ?? "") }
                    )
                    .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle("\(day.dayName) Prompts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
        copiedPrompt = text
    }
}
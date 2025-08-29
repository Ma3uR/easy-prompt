//
//  PostDetailView.swift
//  easy-prompt
//
//  Created by Macbook on 22.08.2025.
//

import SwiftUI

struct PostDetailView: View {
    let day: DayContent
    let businessContext: ContentInput
    @ObservedObject var viewModel: ContentGenerationViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isGeneratingPrompts = false
    @State private var showingPrompts = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    contentSection
                    hashtagsSection
                    
                    if day.isGenerated {
                        promptsSection
                    } else {
                        generatePromptsButton
                    }
                }
                .padding()
            }
            .navigationTitle("Day \(day.dayNumber) - \(day.dayName)")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingPrompts) {
            if day.isGenerated {
                PromptsView(day: day)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(day.category.rawValue, systemImage: categoryIcon)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(categoryColor.gradient)
                    .cornerRadius(20)
                
                Spacer()
                
                if day.isGenerated {
                    Label("Prompts Ready", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Text("Post for \(day.dayName)")
                .font(.title2)
                .fontWeight(.semibold)
        }
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Caption")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(day.caption)
                .font(.body)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
        }
    }
    
    private var hashtagsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hashtags")
                .font(.headline)
                .foregroundColor(.secondary)
            
            FlowLayout(spacing: 8) {
                ForEach(day.hashtags, id: \.self) { hashtag in
                    Text("\(hashtag)")
                        .font(.callout)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(15)
                }
            }
        }
    }
    
    private var generatePromptsButton: some View {
        VStack(spacing: 16) {
            Text("Ready to create AI prompts for this post?")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button(action: generatePrompts) {
                HStack {
                    if isGeneratingPrompts {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "sparkles")
                    }
                    Text(isGeneratingPrompts ? "Generating..." : "Generate AI Prompts")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.gradient)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(isGeneratingPrompts)
            
            Text("This will create optimized prompts for VEO3 video and Imagen 4 image generation")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
    
    private var promptsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text("AI Prompts Generated")
                    .font(.headline)
                Spacer()
            }
            
            Button(action: { showingPrompts = true }) {
                HStack {
                    Image(systemName: "eye")
                    Text("View Generated Prompts")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green.gradient)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            
            if !isGeneratingPrompts {
                Button(action: generatePrompts) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Regenerate Prompts")
                    }
                    .font(.callout)
                    .foregroundColor(.blue)
                }
            }
        }
        .padding(.top, 20)
    }
    
    private var categoryIcon: String {
        switch day.category {
        case .product: return "bag.fill"
        case .educational: return "book.fill"
        case .behindScenes: return "camera.fill"
        case .userContent: return "person.2.fill"
        case .promotional: return "tag.fill"
        case .inspirational: return "star.fill"
        case .trending: return "flame.fill"
        }
    }
    
    private var categoryColor: Color {
        switch day.category {
        case .product: return .blue
        case .educational: return .purple
        case .behindScenes: return .orange
        case .userContent: return .green
        case .promotional: return .red
        case .inspirational: return .yellow
        case .trending: return .pink
        }
    }
    
    private func generatePrompts() {
        isGeneratingPrompts = true
        Task {
            await viewModel.generatePrompts(for: day)
            await MainActor.run {
                isGeneratingPrompts = false
                if day.isGenerated {
                    showingPrompts = true
                }
            }
        }
    }
}

// Simple flow layout for hashtags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: result.positions[index].x + bounds.minX,
                                     y: result.positions[index].y + bounds.minY),
                         proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var maxHeight: CGFloat = 0
            
            for subview in subviews {
                let viewSize = subview.sizeThatFits(.unspecified)
                
                if x + viewSize.width > maxWidth, x > 0 {
                    x = 0
                    y += maxHeight + spacing
                    maxHeight = 0
                }
                
                positions.append(CGPoint(x: x, y: y))
                x += viewSize.width + spacing
                maxHeight = max(maxHeight, viewSize.height)
            }
            
            size = CGSize(width: maxWidth, height: y + maxHeight)
        }
    }
}
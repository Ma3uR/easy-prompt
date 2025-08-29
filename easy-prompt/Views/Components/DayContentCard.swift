//
//  DayContentCard.swift
//  easy-prompt
//
//  Created by Macbook on 22.08.2025.
//

import SwiftUI

// MARK: - Day Content Card
struct DayContentCard: View {
    let day: DayContent
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Day \(day.dayNumber)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(day.dayName)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                    CategoryBadge(category: day.category)
                }
                
                Text(day.caption)
                    .font(.body)
                    .lineLimit(3)
                    .foregroundColor(.primary.opacity(0.8))
                    .multilineTextAlignment(.leading)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(day.hashtags.prefix(3), id: \.self) { hashtag in
                            Text("\(hashtag)")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(4)
                                .foregroundColor(.blue)
                        }
                        if day.hashtags.count > 3 {
                            Text("+\(day.hashtags.count - 3) more")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                        }
                    }
                }
                
                HStack {
                    if day.isGenerated {
                        Label("Prompts Ready", systemImage: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                    } else {
                        Label("Tap to view details", systemImage: "arrow.right.circle")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                }
                .padding(.top, 4)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
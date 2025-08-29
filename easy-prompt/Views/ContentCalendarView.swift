//
//  ContentCalendarView.swift
//  easy-prompt
//
//  Created by Macbook on 22.08.2025.
//

import SwiftUI

// MARK: - Content Calendar View
struct ContentCalendarView: View {
    let weeklyContent: WeeklyContent
    @ObservedObject var viewModel: ContentGenerationViewModel
    @State private var selectedDay: DayContent?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
                ForEach(weeklyContent.days) { day in
                    DayContentCard(
                        day: day,
                        onTap: {
                            selectedDay = day
                        }
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Your Content Week")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selectedDay) { day in
            // Always get the latest version of the day from viewModel
            if let latestDay = viewModel.weeklyContent?.days.first(where: { $0.id == day.id }) {
                PostDetailView(
                    day: latestDay,
                    businessContext: weeklyContent.input,
                    viewModel: viewModel
                )
            }
        }
    }
}
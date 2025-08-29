//
//  InputView.swift
//  easy-prompt
//
//  Created by Macbook on 22.08.2025.
//

import SwiftUI

// MARK: - Input View
struct InputView: View {
    @StateObject private var viewModel = ContentGenerationViewModel()
    @State private var selectedMode: GenerationMode = .quick
    @State private var showingQualityMode = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case businessType, targetAudience, contentGoal
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Mode Selector
                Picker("Mode", selection: $selectedMode) {
                    Text("Quick Mode").tag(GenerationMode.quick)
                    Text("Quality Mode").tag(GenerationMode.quality)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .onChange(of: selectedMode) { newValue in
                    viewModel.currentInput.mode = newValue
                    if newValue == .quality {
                        showingQualityMode = true
                    }
                }
                
                // Language Selector
                HStack {
                    Text("Content Language")
                        .font(.headline)
                    Spacer()
                    Picker("Language", selection: $viewModel.currentInput.language) {
                        ForEach(ContentLanguage.allCases, id: \.self) { language in
                            HStack {
                                Text(language.flag)
                                Text(language.rawValue)
                            }
                            .tag(language)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .padding(.horizontal)
                
                // Input Fields
                if selectedMode == .quick {
                    VStack(spacing: 16) {
                        CustomTextField(
                            title: "Business Type",
                            text: $viewModel.currentInput.businessType,
                            placeholder: "e.g., Coffee Shop",
                            focused: $focusedField,
                            field: .businessType
                        )
                        
                        CustomTextField(
                            title: "Target Audience",
                            text: $viewModel.currentInput.targetAudience,
                            placeholder: "e.g., Young professionals",
                            focused: $focusedField,
                            field: .targetAudience
                        )
                        
                        CustomTextField(
                            title: "Content Goal",
                            text: $viewModel.currentInput.contentGoal,
                            placeholder: "e.g., Drive morning traffic",
                            focused: $focusedField,
                            field: .contentGoal
                        )
                    }
                    .padding(.horizontal)
                } else {
                    // Quality Mode Summary
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Quality Mode Data")
                                .font(.headline)
                            Spacer()
                            Button("Edit") {
                                showingQualityMode = true
                            }
                            .buttonStyle(.bordered)
                        }
                        
                        if !viewModel.qualityModeData.businessName.isEmpty {
                            Label(viewModel.qualityModeData.businessName, systemImage: "building.2")
                            Label(viewModel.qualityModeData.city, systemImage: "location")
                            Label("\(viewModel.qualityModeData.goals.count) goals selected", systemImage: "target")
                            Label("\(viewModel.qualityModeData.platforms.count) platforms", systemImage: "square.grid.2x2")
                        } else {
                            Text("Tap 'Edit' to fill in detailed business information")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Generate Button
                Button(action: {
                    Task {
                        await viewModel.generateWeeklyContent()
                    }
                }) {
                    if viewModel.isGenerating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Generate Week")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(isFormValid ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
                .disabled(!isFormValid || viewModel.isGenerating)
                .padding(.horizontal)
                
                // Error display
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Easy Prompt")
            .navigationDestination(item: $viewModel.weeklyContent) { content in
                ContentCalendarView(weeklyContent: content, viewModel: viewModel)
            }
            .sheet(isPresented: $showingQualityMode) {
                NavigationView {
                    QualityModeInputView(qualityData: $viewModel.qualityModeData)
                        .navigationTitle("Quality Mode Setup")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done") {
                                    // Update basic inputs from quality data
                                    viewModel.currentInput.businessType = viewModel.qualityModeData.businessName
                                    viewModel.currentInput.targetAudience = viewModel.qualityModeData.primaryAudience
                                    viewModel.currentInput.contentGoal = viewModel.qualityModeData.goals.map { $0.rawValue }.joined(separator: ", ")
                                    showingQualityMode = false
                                }
                            }
                        }
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        if selectedMode == .quick {
            return !viewModel.currentInput.businessType.isEmpty &&
                   !viewModel.currentInput.targetAudience.isEmpty &&
                   !viewModel.currentInput.contentGoal.isEmpty
        } else {
            // Quality mode validation
            return !viewModel.qualityModeData.businessName.isEmpty &&
                   !viewModel.qualityModeData.primaryAudience.isEmpty &&
                   !viewModel.qualityModeData.goals.isEmpty
        }
    }
}
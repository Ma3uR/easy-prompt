//
//  QualityModeInputView.swift
//  easy-prompt
//
//  Created by Macbook on 22.08.2025.
//

import SwiftUI

struct QualityModeInputView: View {
    @Binding var qualityData: QualityModeInput
    @State private var currentSection = 1
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress indicator
            ProgressView(value: Double(currentSection), total: 12)
                .padding()
            
            // Section title
            Text(sectionTitle)
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 16) {
                    switch currentSection {
                    case 1:
                        BasicInfoSection(data: $qualityData)
                    case 2:
                        OfferingSection(data: $qualityData)
                    case 3:
                        AudienceSection(data: $qualityData)
                    case 4:
                        GoalsSection(data: $qualityData)
                    case 5:
                        PlatformsSection(data: $qualityData)
                    case 6:
                        ToneStyleSection(data: $qualityData)
                    case 7:
                        ContentCategoriesSection(data: $qualityData)
                    case 8:
                        NewsHooksSection(data: $qualityData)
                    case 9:
                        PromotionsSection(data: $qualityData)
                    case 10:
                        MaterialsSection(data: $qualityData)
                    case 11:
                        RestrictionsSection(data: $qualityData)
                    case 12:
                        CTASection(data: $qualityData)
                    default:
                        EmptyView()
                    }
                }
                .padding()
            }
            
            // Navigation buttons
            HStack {
                if currentSection > 1 {
                    Button("Previous") {
                        withAnimation {
                            currentSection -= 1
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
                if currentSection < 12 {
                    Button("Next") {
                        withAnimation {
                            currentSection += 1
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
    }
    
    private var sectionTitle: String {
        switch currentSection {
        case 1: return "Basic Info"
        case 2: return "Offering / USP"
        case 3: return "Target Audience"
        case 4: return "Monthly Goals"
        case 5: return "Platforms"
        case 6: return "Tone & Style"
        case 7: return "Content Categories"
        case 8: return "News Hooks"
        case 9: return "Promotions & Budget"
        case 10: return "Materials & Resources"
        case 11: return "Restrictions"
        case 12: return "CTA & Contacts"
        default: return ""
        }
    }
}

// MARK: - Section Views
struct BasicInfoSection: View {
    @Binding var data: QualityModeInput
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Business Name", text: $data.businessName)
                .textFieldStyle(.roundedBorder)
            
            TextField("City", text: $data.city)
                .textFieldStyle(.roundedBorder)
            
            Picker("Business Type", selection: $data.businessType) {
                ForEach(BusinessType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.segmented)
            
            TextField("Years in Business", text: $data.yearsInBusiness)
                .textFieldStyle(.roundedBorder)
            
            TextField("Team Size", text: $data.teamSize)
                .textFieldStyle(.roundedBorder)
        }
    }
}

struct OfferingSection: View {
    @Binding var data: QualityModeInput
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top 3 Products/Services")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ForEach(0..<3) { index in
                TextField("Product/Service \(index + 1)", text: Binding(
                    get: { 
                        index < data.topProducts.count ? data.topProducts[index] : ""
                    },
                    set: { newValue in
                        while data.topProducts.count <= index {
                            data.topProducts.append("")
                        }
                        data.topProducts[index] = newValue
                    }
                ))
                .textFieldStyle(.roundedBorder)
            }
            
            TextField("What makes you different (USP)", text: $data.uniqueSellingProposition, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(2...4)
            
            TextField("Price Range / Average Check", text: $data.priceRange)
                .textFieldStyle(.roundedBorder)
        }
    }
}

struct AudienceSection: View {
    @Binding var data: QualityModeInput
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Primary Audience (age, interests, problem solved)", text: $data.primaryAudience, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(2...3)
            
            TextField("Secondary Audience (optional)", text: $data.secondaryAudience, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(2...3)
        }
    }
}

struct GoalsSection: View {
    @Binding var data: QualityModeInput
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select up to 3 goals for this month")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ForEach(ContentGoal.allCases, id: \.self) { goal in
                HStack {
                    Image(systemName: data.goals.contains(goal) ? "checkmark.square.fill" : "square")
                        .foregroundColor(data.goals.contains(goal) ? .blue : .gray)
                    Text(goal.rawValue)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if data.goals.contains(goal) {
                        data.goals.remove(goal)
                    } else if data.goals.count < 3 {
                        data.goals.insert(goal)
                    }
                }
            }
        }
    }
}

struct PlatformsSection: View {
    @Binding var data: QualityModeInput
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select your platforms")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ForEach(Platform.allCases, id: \.self) { platform in
                HStack {
                    Image(systemName: data.platforms.contains(platform) ? "checkmark.square.fill" : "square")
                        .foregroundColor(data.platforms.contains(platform) ? .blue : .gray)
                    Text(platform.rawValue)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if data.platforms.contains(platform) {
                        data.platforms.remove(platform)
                    } else {
                        data.platforms.insert(platform)
                    }
                }
            }
            
            Divider()
            
            HStack {
                Text("Posts per week:")
                Stepper("\(data.postsPerWeek)", value: $data.postsPerWeek, in: 1...14)
            }
            
            HStack {
                Text("Stories per week:")
                Stepper("\(data.storiesPerWeek)", value: $data.storiesPerWeek, in: 0...21)
            }
        }
    }
}

struct ToneStyleSection: View {
    @Binding var data: QualityModeInput
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Describe your tone/style in 3 words")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("Example: friendly, expert, aesthetic")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            ForEach(0..<3) { index in
                TextField("Word \(index + 1)", text: Binding(
                    get: { 
                        index < data.toneWords.count ? data.toneWords[index] : ""
                    },
                    set: { newValue in
                        while data.toneWords.count <= index {
                            data.toneWords.append("")
                        }
                        data.toneWords[index] = newValue
                    }
                ))
                .textFieldStyle(.roundedBorder)
            }
        }
    }
}

struct ContentCategoriesSection: View {
    @Binding var data: QualityModeInput
    @State private var showingAllCategories = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose 6-8 content categories")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("Selected: \(data.contentCategories.count)/8")
                .font(.caption2)
                .foregroundColor(data.contentCategories.count >= 6 ? .green : .orange)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 8) {
                ForEach(Array(SMMContentCategory.allCases.prefix(showingAllCategories ? 20 : 8)), id: \.self) { category in
                    CategoryChip(
                        title: category.rawValue,
                        isSelected: data.contentCategories.contains(category),
                        action: {
                            if data.contentCategories.contains(category) {
                                data.contentCategories.remove(category)
                            } else if data.contentCategories.count < 8 {
                                data.contentCategories.insert(category)
                            }
                        }
                    )
                }
            }
            
            if !showingAllCategories {
                Button("Show All Categories") {
                    showingAllCategories = true
                }
                .font(.caption)
            }
        }
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Text(title)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(15)
            .onTapGesture(perform: action)
    }
}

struct NewsHooksSection: View {
    @Binding var data: QualityModeInput
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Dates/news hooks this month")
                .font(.caption)
                .foregroundColor(.secondary)
            
            TextField("Holidays, local events, releases, collaborations", text: $data.monthlyHooks, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...5)
        }
    }
}

struct PromotionsSection: View {
    @Binding var data: QualityModeInput
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Promotions/discounts/giveaways", text: $data.promotions, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(2...4)
            
            TextField("Advertising budget (optional)", text: $data.advertisingBudget)
                .textFieldStyle(.roundedBorder)
        }
    }
}

struct MaterialsSection: View {
    @Binding var data: QualityModeInput
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Photo/Video Materials")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Picker("Materials", selection: $data.photoVideoStatus) {
                ForEach(MaterialStatus.allCases, id: \.self) { status in
                    Text(status.rawValue).tag(status)
                }
            }
            .pickerStyle(.segmented)
            
            TextField("Who can be on camera", text: $data.whoOnCamera)
                .textFieldStyle(.roundedBorder)
            
            Toggle("Can use UGC (customer mentions)", isOn: $data.canUseUGC)
        }
    }
}

struct RestrictionsSection: View {
    @Binding var data: QualityModeInput
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Taboo topics / legal nuances / what not to show", text: $data.restrictions, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...5)
        }
    }
}

struct CTASection: View {
    @Binding var data: QualityModeInput
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Main action (DM us / order / call / visit)", text: $data.mainCTA)
                .textFieldStyle(.roundedBorder)
            
            TextField("Link/address/hours", text: $data.contactInfo, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(2...3)
            
            Divider()
            
            Text("Optional Fields")
                .font(.headline)
                .padding(.top)
            
            TextField("Brand story (1-2 sentences)", text: $data.brandStory, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(2...3)
            
            TextField("Competitors/references", text: $data.competitors)
                .textFieldStyle(.roundedBorder)
            
            TextField("Geography", text: $data.geography)
                .textFieldStyle(.roundedBorder)
            
            TextField("Peak days/seasonality", text: $data.peakDays)
                .textFieldStyle(.roundedBorder)
            
            TextField("Hashtags/keywords", text: $data.hashtags)
                .textFieldStyle(.roundedBorder)
        }
    }
}
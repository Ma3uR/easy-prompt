# Product Requirements Document: Easy Prompt

## 1. Product Overview

### 1.1 Executive Summary
Easy Prompt is an iOS application that generates optimized content plans and AI prompts for Google's VEO3 and Imagen 4 platforms. The app transforms three simple business inputs into a week of content ideas, then generates technically perfect JSON prompts on demand.

### 1.2 Core Value Proposition
- **Problem**: Content creators lack the technical knowledge to properly prompt Google's AI tools
- **Solution**: Expert-level prompt generation through a 3-input interface
- **Key Differentiator**: Model-specific JSON optimization for VEO3 and Imagen 4

### 1.3 Success Metrics
- Generate content plan in <10 seconds
- 3 minutes from launch to first prompt
- 85%+ prompt success rate in Google's platforms

## 2. User Experience Design

### 2.1 User Flow

```
App Launch → Mode Selection → Input Form → Content Generation → Prompt Generation → Copy/Export
     ↓            ↓              ↓              ↓                   ↓              ↓
  Splash     Quick/Quality   3 Fields    Weekly Calendar    JSON Display    Share Sheet
```

### 2.2 Screen Specifications

#### 2.2.1 Launch Screen
- App logo and name
- Tagline: "Perfect AI Prompts in Seconds"
- Auto-transition after 1.5 seconds

#### 2.2.2 Mode Selection View
```swift
// UI Components
- SegmentedControl: [Quick Mode | Quality Mode]
- Description labels for each mode
- "Continue" button (primary CTA)
```

#### 2.2.3 Input Form View (Quick Mode)
```swift
// Three TextField components
1. Business Type (placeholder: "e.g., Coffee Shop")
2. Target Audience (placeholder: "e.g., Young professionals")  
3. Content Goal (placeholder: "e.g., Drive morning traffic")

// CTA Button
- "Generate Week" (disabled until all fields filled)
- Loading indicator overlay during generation
```

#### 2.2.4 Content Calendar View
```swift
// 7-day grid layout
- Each day shows:
  - Day name
  - Content category (badge)
  - Caption preview (2 lines)
  - "Generate Prompts" button
  - Completed indicator (checkmark)
```

#### 2.2.5 Prompt Detail View
```swift
// Tabbed interface
- Tab 1: VEO3 Prompt (JSON)
- Tab 2: Imagen Prompt (JSON)
- Copy button for each
- "Copy All" action
- Share button
```

## 3. Technical Architecture

### 3.1 Technology Stack
- **Platform**: iOS 16.0+ (SwiftUI)
- **Language**: Swift 5.9
- **Architecture**: MVVM with Combine
- **AI Integration**: OpenAI API (GPT-4)
- **Local Storage**: SwiftData
- **JSON Handling**: Codable protocols

### 3.2 Core Data Models

```swift
// MARK: - Input Models
struct ContentInput: Codable {
    let id: UUID = UUID()
    let businessType: String
    let targetAudience: String
    let contentGoal: String
    let mode: GenerationMode
    let createdAt: Date = Date()
}

enum GenerationMode: String, Codable, CaseIterable {
    case quick = "quick"
    case quality = "quality"
}

// MARK: - Content Models
struct WeeklyContent: Codable {
    let id: UUID = UUID()
    let input: ContentInput
    let days: [DayContent]
    let generatedAt: Date = Date()
}

struct DayContent: Codable, Identifiable {
    let id: UUID = UUID()
    let dayNumber: Int // 1-7
    let dayName: String // "Monday"
    let category: ContentCategory
    let caption: String
    let hashtags: [String]
    var imagePrompt: ImagePrompt?
    var videoPrompt: VideoPrompt?
    var isGenerated: Bool = false
}

enum ContentCategory: String, Codable, CaseIterable {
    case product = "Product"
    case educational = "Educational"
    case behindScenes = "Behind the Scenes"
    case userContent = "User Content"
    case promotional = "Promotional"
    case inspirational = "Inspirational"
    case trending = "Trending"
}

// MARK: - Prompt Models
struct ImagePrompt: Codable {
    let prompt: ImagePromptStructure
    let negativePrompt: String
    let parameters: ImageParameters
    
    var asJSON: String {
        // Convert to Google Imagen JSON format
    }
}

struct ImagePromptStructure: Codable {
    let subject: String
    let environment: String
    let style: String
    let lighting: String
    let camera: CameraSettings
    let colorPalette: [String]
}

struct ImageParameters: Codable {
    let model: String = "imagen-4"
    let aspectRatio: String = "16:9"
    let sampleCount: Int = 2
    let seed: Int?
}

struct VideoPrompt: Codable {
    let promptName: String
    let coreContent: String
    let details: VideoDetails
    let negativePrompt: String
    let visualRules: String
    
    var asJSON: String {
        // Convert to VEO3 JSON format
    }
}

struct VideoDetails: Codable {
    let sceneEnvironment: SceneEnvironment
    let subject: SubjectDescription
    let visualStyle: VisualStyle
    let cameraWork: CameraWork
    let audio: AudioLayers
}

struct SceneEnvironment: Codable {
    let setting: String
    let features: String
    let mood: String
}

struct SubjectDescription: Codable {
    let description: String
    let wardrobe: String?
    let characterConsistency: String
}

struct VisualStyle: Codable {
    let aesthetic: String
    let resolution: String = "720p"
    let lighting: String
}

struct CameraWork: Codable {
    let composition: String
    let cameraMotion: String
    let positioning: String // Must include "(thats where the camera is)"
}

struct AudioLayers: Codable {
    let dialogue: String?
    let primarySounds: String
    let ambient: String
    let music: String?
}

struct CameraSettings: Codable {
    let angle: String
    let distance: String
    let lens: String?
}
```

### 3.3 View Models

```swift
// MARK: - Main View Model
@MainActor
class ContentGenerationViewModel: ObservableObject {
    @Published var currentInput = ContentInput(
        businessType: "",
        targetAudience: "",
        contentGoal: "",
        mode: .quick
    )
    
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
            let content = try await aiService.generateContent(from: currentInput)
            await MainActor.run {
                self.weeklyContent = content
                self.isGenerating = false
            }
            try await storageService.save(content)
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

enum GenerationError: LocalizedError {
    case invalidInput
    case networkError
    case aiServiceError(String)
    case storageError
    
    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Please fill in all fields"
        case .networkError:
            return "Check your internet connection"
        case .aiServiceError(let message):
            return message
        case .storageError:
            return "Failed to save content"
        }
    }
}
```

### 3.4 AI Service Implementation

```swift
// MARK: - AI Service
class AIService {
    private let apiKey: String
    private let session: URLSession
    private let systemPromptManager: SystemPromptManager
    
    init() {
        self.apiKey = Configuration.openAIKey
        self.session = URLSession.shared
        self.systemPromptManager = SystemPromptManager()
    }
    
    func generateContent(from input: ContentInput) async throws -> WeeklyContent {
        let systemPrompt = systemPromptManager.contentGenerationPrompt(mode: input.mode)
        let userPrompt = formatUserPrompt(from: input)
        
        let request = createRequest(
            system: systemPrompt,
            user: userPrompt,
            temperature: 0.7,
            maxTokens: 2000
        )
        
        let (data, _) = try await session.data(for: request)
        let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        
        return try parseWeeklyContent(from: response, input: input)
    }
    
    func generatePrompts(for day: DayContent, 
                        businessContext: ContentInput) async throws -> (image: ImagePrompt, video: VideoPrompt) {
        let systemPrompt = systemPromptManager.promptGenerationPrompt()
        let userPrompt = formatPromptRequest(day: day, context: businessContext)
        
        let request = createRequest(
            system: systemPrompt,
            user: userPrompt,
            temperature: 0.3, // Lower temperature for consistency
            maxTokens: 3000
        )
        
        let (data, _) = try await session.data(for: request)
        let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        
        return try parsePrompts(from: response)
    }
}
```

### 3.5 System Prompt Manager

```swift
// MARK: - System Prompts
class SystemPromptManager {
    
    func contentGenerationPrompt(mode: GenerationMode) -> String {
        let basePrompt = """
        You are an expert social media content strategist with deep knowledge of SMM categories and engagement patterns.
        
        Generate a 7-day content calendar based on the provided business information.
        
        Requirements:
        - Create diverse content across different categories
        - Each day should have a unique angle/approach
        - Captions should be engaging and platform-appropriate
        - Include 5-7 relevant hashtags per post
        - Ensure brand voice consistency throughout
        
        Categories to use (rotate throughout week):
        - Product/Service showcase
        - Educational/How-to content
        - Behind the scenes
        - User-generated content
        - Promotional offers
        - Inspirational/Motivational
        - Trending topics/challenges
        
        Output format: JSON with structure matching WeeklyContent model
        """
        
        if mode == .quality {
            return basePrompt + """
            
            Additional requirements for Quality Mode:
            - Deep personalization based on business type
            - Industry-specific best practices
            - Seasonal/temporal relevance
            - Competitor differentiation strategies
            - Multi-platform optimization notes
            """
        }
        
        return basePrompt
    }
    
    func promptGenerationPrompt() -> String {
        return """
        You are an expert prompt engineer specializing in Google's VEO3 and Imagen 4 models.
        
        CRITICAL VEO3 Requirements:
        1. Always use JSON structure
        2. Camera positioning must include "(thats where the camera is)" syntax
        3. Specify all audio layers: dialogue, primary sounds, ambient
        4. Use colon format for dialogue: "Speaking directly to camera saying: [words]"
        5. Include "No subtitles, no text overlay" in visual rules
        6. Design for 8-second duration at 24fps
        7. Specify movement quality descriptors
        
        CRITICAL Imagen 4 Requirements:
        1. Use hierarchical structure: [Type] + [Subject] + [Environment] + [Style]
        2. Front-load critical elements for maximum weight
        3. Include negative prompts for quality control
        4. Specify technical markers: "8K", "photorealistic", "highly detailed"
        5. Use photography terms: lens type, lighting setup, composition
        
        Generate both prompts based on the content piece provided.
        Ensure brand consistency with the business context.
        
        Output format: JSON with ImagePrompt and VideoPrompt structures
        """
    }
}
```

### 3.6 Views Implementation

```swift
// MARK: - Input View
struct InputView: View {
    @StateObject private var viewModel = ContentGenerationViewModel()
    @State private var selectedMode: GenerationMode = .quick
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
                
                // Input Fields
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
            }
            .navigationTitle("Easy Prompt")
            .navigationDestination(item: $viewModel.weeklyContent) { content in
                ContentCalendarView(weeklyContent: content, viewModel: viewModel)
            }
        }
    }
    
    private var isFormValid: Bool {
        !viewModel.currentInput.businessType.isEmpty &&
        !viewModel.currentInput.targetAudience.isEmpty &&
        !viewModel.currentInput.contentGoal.isEmpty
    }
}

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
                        onGeneratePrompts: {
                            selectedDay = day
                            Task {
                                await viewModel.generatePrompts(for: day)
                            }
                        }
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Your Content Week")
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selectedDay) { day in
            if let dayWithPrompts = weeklyContent.days.first(where: { $0.id == day.id }),
               dayWithPrompts.isGenerated {
                PromptDetailView(day: dayWithPrompts)
            }
        }
    }
}

// MARK: - Day Content Card
struct DayContentCard: View {
    let day: DayContent
    let onGeneratePrompts: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(day.dayName)
                    .font(.headline)
                Spacer()
                CategoryBadge(category: day.category)
            }
            
            Text(day.caption)
                .font(.body)
                .lineLimit(3)
                .foregroundColor(.primary.opacity(0.8))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(day.hashtags, id: \.self) { hashtag in
                        Text("#\(hashtag)")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
            }
            
            Button(action: onGeneratePrompts) {
                HStack {
                    Image(systemName: day.isGenerated ? "checkmark.circle.fill" : "sparkles")
                    Text(day.isGenerated ? "View Prompts" : "Generate Prompts")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(day.isGenerated ? Color.green : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

// MARK: - Prompt Detail View
struct PromptDetailView: View {
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

// MARK: - Prompt Display View
struct PromptDisplayView: View {
    let title: String
    let jsonContent: String
    let onCopy: () -> Void
    @State private var showCopied = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScrollView {
                Text(jsonContent)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
            }
            
            Button(action: {
                onCopy()
                showCopied = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showCopied = false
                }
            }) {
                HStack {
                    Image(systemName: showCopied ? "checkmark" : "doc.on.doc")
                    Text(showCopied ? "Copied!" : "Copy Prompt")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(showCopied ? Color.green : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
    }
}
```

## 4. Implementation Plan

### 4.1 Development Phases

#### Phase 1: Core Infrastructure (Week 1)
- [ ] Project setup and configuration
- [ ] Data models implementation
- [ ] AI service integration
- [ ] System prompt development

#### Phase 2: UI Implementation (Week 2)
- [ ] Input view and validation
- [ ] Content calendar view
- [ ] Prompt detail views
- [ ] Navigation flow

#### Phase 3: AI Integration (Week 3)
- [ ] OpenAI API integration
- [ ] Prompt generation logic
- [ ] Error handling
- [ ] Response parsing

#### Phase 4: Polish & Testing (Week 4)
- [ ] UI animations and transitions
- [ ] Performance optimization
- [ ] Edge case handling
- [ ] Beta testing

### 4.2 Technical Requirements

#### Minimum iOS Version
- iOS 16.0+ (for SwiftUI 4.0 features)

#### Device Support
- iPhone 12 and newer (optimal)
- iPhone X and newer (supported)
- iPad support (future enhancement)

#### Performance Targets
- App launch: <1 second
- Content generation: <10 seconds
- Prompt generation: <5 seconds
- Memory usage: <100MB

### 4.3 API Configuration

```swift
// Configuration.swift
enum Configuration {
    static let openAIKey = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String ?? ""
    static let apiEndpoint = "https://api.openai.com/v1/chat/completions"
    static let model = "gpt-4-turbo-preview"
    static let maxRetries = 3
    static let timeout: TimeInterval = 30
}
```

### 4.4 Error Handling Strategy

```swift
// Comprehensive error handling
enum AppError: LocalizedError {
    case network(URLError)
    case decoding(DecodingError)
    case api(APIError)
    case validation(ValidationError)
    case storage(StorageError)
    
    var errorDescription: String? {
        switch self {
        case .network(let error):
            return "Network error: \(error.localizedDescription)"
        case .decoding:
            return "Failed to process response"
        case .api(let error):
            return error.message
        case .validation(let error):
            return error.message
        case .storage:
            return "Failed to save data"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .network:
            return "Check your internet connection and try again"
        case .api(let error) where error.code == 429:
            return "Too many requests. Please wait a moment"
        default:
            return "Please try again"
        }
    }
}
```

## 5. Testing Strategy

### 5.1 Unit Tests
- Model serialization/deserialization
- Prompt generation logic
- Input validation
- JSON formatting

### 5.2 Integration Tests
- API communication
- End-to-end content generation
- Prompt copying functionality
- Storage operations

### 5.3 UI Tests
- Input flow completion
- Navigation between screens
- Error state handling
- Loading states

### 5.4 Beta Testing Plan
- TestFlight distribution to 50 users
- Feedback collection via in-app survey
- Prompt quality validation
- Performance monitoring

## 6. Success Criteria

### MVP Launch Criteria
- [ ] 3-input to content generation works reliably
- [ ] Prompts generate valid JSON for VEO3/Imagen
- [ ] <10 second generation time achieved
- [ ] Copy functionality works on all devices
- [ ] Error states handled gracefully
- [ ] 85%+ prompts work without modification

### Post-Launch Metrics
- 100+ downloads in first week
- 40% activation rate (generate first prompt)
- 60% retention after one week
- 4.5+ App Store rating
- <1% crash rate

## 7. Future Enhancements

### Version 1.1
- Prompt history/favorites
- Share prompts via link
- Basic analytics dashboard

### Version 1.2
- Multi-week planning
- Custom content categories
- Template library

### Version 2.0
- API integration with Google platforms
- Real-time preview generation
- Team collaboration features
- Subscription model implementation

## 8. Risk Mitigation

### Technical Risks
- **API Rate Limits**: Implement caching and request queuing
- **OpenAI Downtime**: Add fallback to local templates
- **JSON Parsing Failures**: Robust error handling with retry logic

### Business Risks
- **Google API Changes**: Monitor documentation, version prompts
- **Competition**: Focus on speed and simplicity as differentiators
- **User Adoption**: Implement onboarding tutorial

## 9. Appendix

### A. JSON Prompt Templates

#### VEO3 Template
```json
{
  "prompt_name": "{{title}}",
  "version": 1.0,
  "target_ai_model": "VEO3",
  "core_concept": "{{concept}}",
  "details": {
    "scene_environment": {
      "setting": "{{setting}}",
      "features": "{{features}}",
      "mood": "{{mood}}"
    },
    "subject": {
      "description": "{{subject_desc}}",
      "wardrobe": "{{wardrobe}}",
      "character_consistency": "{{consistency}}"
    },
    "camera_work": {
      "composition": "{{composition}}",
      "camera_motion": "{{motion}}",
      "positioning": "{{position}} (thats where the camera is)"
    },
    "audio": {
      "dialogue": "Speaking directly to camera saying: {{dialogue}}",
      "primary_sounds": "{{sounds}}",
      "ambient": "{{ambient}}",
      "music": "{{music}}"
    }
  },
  "negative_prompt": "{{negative}}",
  "visual_rules": "No subtitles, no text overlay"
}
```

#### Imagen 4 Template
```json
{
  "instances": [
    {
      "prompt": "{{type}} of {{subject}} in {{environment}}, {{style}}, {{lighting}}, {{technical_markers}}"
    }
  ],
  "parameters": {
    "sampleCount": 2,
    "aspectRatio": "16:9",
    "negativePrompt": "{{negative}}",
    "seed": {{seed}}
  }
}
```

### B. Content Categories Mapping

```swift
let categoryPromptStyles = [
    .product: "professional product photography, studio lighting",
    .educational: "clean infographic style, educational diagram",
    .behindScenes: "documentary style, candid moment",
    .userContent: "authentic user-generated content style",
    .promotional: "eye-catching promotional design, bold colors",
    .inspirational: "motivational aesthetic, uplifting mood",
    .trending: "viral content style, dynamic and energetic"
]
```

---

*This PRD serves as the complete technical specification for Easy Prompt MVP development in Swift/SwiftUI.*
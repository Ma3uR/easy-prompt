# Easy Prompt

> Transform 3 simple inputs into a week of AI-powered social media content with perfect prompts for Google's VEO3 and Imagen 4

![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![iOS](https://img.shields.io/badge/iOS-16.0%2B-blue)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20macOS-lightgray)
![License](https://img.shields.io/badge/License-MIT-green)

## Overview

Easy Prompt is an iOS application that revolutionizes social media content creation by generating optimized prompts for Google's cutting-edge AI platforms - VEO3 for video and Imagen 4 for images. With just three simple inputs about your business, the app creates a complete week of diverse content ideas, then generates technically perfect JSON prompts on demand.

### Key Features

- **3-Input Simplicity**: Just provide business type, target audience, and content goal
- **Dual Mode System**: Quick Mode for instant results, Quality Mode for nuanced output
- **Weekly Content Calendar**: 7 days of diverse, engaging content ideas
- **Model-Specific Prompts**: Perfectly formatted JSON for VEO3 and Imagen 4
- **Copy-Paste Ready**: Direct integration with Google AI Studio, ImageFX, and Vertex AI
- **Professional Quality**: Expert-level prompt engineering built-in

## Problem We Solve

Content creators spend 5-10 hours weekly planning and creating social media content, yet struggle to leverage Google's powerful AI tools due to:
- Complex JSON structures required by VEO3
- Specific syntax requirements (e.g., camera positioning)
- Hierarchical prompt optimization for Imagen 4
- Lack of technical prompt engineering knowledge

Easy Prompt eliminates this knowledge gap, making professional AI content generation accessible to everyone.

## Installation

### Requirements

- iOS 16.0+ / macOS 13.0+
- Xcode 15.0+
- Swift 5.9+
- OpenAI API key

### Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/easy-prompt.git
cd easy-prompt
```

2. Open the project in Xcode:
```bash
open easy-prompt.xcodeproj
```

3. Configure your OpenAI API key:
   - Add your API key to the project's Info.plist:
   ```xml
   <key>OPENAI_API_KEY</key>
   <string>your-api-key-here</string>
   ```
   
4. Build and run:
   - Select your target device/simulator
   - Press `Cmd+R` to build and run

## Usage

### Quick Start

1. **Launch the app** and select your generation mode:
   - **Quick Mode**: Fast results with standard optimization
   - **Quality Mode**: Enhanced personalization and industry-specific strategies

2. **Enter your business information**:
   - Business Type (e.g., "Coffee Shop")
   - Target Audience (e.g., "Young professionals")
   - Content Goal (e.g., "Drive morning traffic")

3. **Generate your content week**: 
   - Tap "Generate Week" to create 7 days of content ideas
   - Each day includes category, caption, and relevant hashtags

4. **Create AI prompts**:
   - Select any day's content
   - Tap "Generate Prompts" for JSON-formatted VEO3 and Imagen 4 prompts
   - Copy prompts directly to clipboard

5. **Use in Google's platforms**:
   - Paste VEO3 prompts into Google AI Studio for 8-second videos
   - Use Imagen 4 prompts in ImageFX or Vertex AI for stunning visuals

### Content Categories

The app rotates through 7 professional content categories:
- Product/Service Showcase
- Educational/How-to Content
- Behind the Scenes
- User-Generated Content
- Promotional Offers
- Inspirational/Motivational
- Trending Topics/Challenges

## Architecture

### Project Structure

```
easy-prompt/
├── Configuration/
│   └── Configuration.swift       # API configuration
├── Models/
│   ├── ContentModels.swift      # Content data structures
│   ├── PromptModels.swift       # Prompt generation models
│   ├── QualityModeModels.swift  # Quality mode enhancements
│   └── Errors.swift              # Error definitions
├── Services/
│   ├── AIService.swift          # OpenAI integration
│   ├── StorageService.swift     # Local data persistence
│   └── SystemPromptManager.swift # Prompt templates
├── ViewModels/
│   └── ContentGenerationViewModel.swift # Business logic
├── Views/
│   ├── Components/              # Reusable UI components
│   ├── InputView.swift          # Initial input form
│   ├── ContentCalendarView.swift # Weekly calendar
│   ├── PromptDetailView.swift   # Prompt display
│   └── QualityModeInputView.swift # Extended input form
└── easy_promptApp.swift         # App entry point
```

### Technology Stack

- **UI Framework**: SwiftUI
- **Architecture**: MVVM with Combine
- **AI Integration**: OpenAI GPT-4
- **Storage**: SwiftData
- **Minimum iOS**: 16.0+

## Development

### Building the Project

```bash
# Build for debugging
xcodebuild -scheme easy-prompt -configuration Debug build

# Build for release
xcodebuild -scheme easy-prompt -configuration Release build

# Run tests
xcodebuild -scheme easy-prompt test
```

### Testing

The project includes comprehensive test coverage:
- **Unit Tests**: Model validation, prompt generation logic
- **Integration Tests**: API communication, end-to-end workflows
- **UI Tests**: User flow validation, error handling

Run tests with `Cmd+U` in Xcode or:
```bash
xcodebuild -scheme easy-prompt test -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Code Style

- Follow Swift API Design Guidelines
- Use SwiftLint for code consistency
- Format code with Xcode's built-in formatter (`Ctrl+I`)

## Prompt Generation

### VEO3 Video Prompts

Easy Prompt generates structured JSON for VEO3 including:
- Scene environment with mood and features
- Subject descriptions with character consistency
- Camera work with specific positioning syntax
- Complete audio layers (dialogue, sounds, ambient, music)
- Visual rules and negative prompts

### Imagen 4 Image Prompts

Optimized hierarchical prompts featuring:
- Type + Subject + Environment + Style structure
- Technical markers for quality (8K, photorealistic)
- Photography terminology (lens, lighting, composition)
- Negative prompts for quality control
- JSON parameters for consistency

## Performance

- **App Launch**: <1 second
- **Content Generation**: <10 seconds
- **Prompt Generation**: <5 seconds
- **Memory Usage**: <100MB
- **Success Rate**: 85%+ prompts work without modification

## Roadmap

### Version 1.0 (Current)
- ✅ 3-input content generation
- ✅ Weekly calendar view
- ✅ VEO3 and Imagen 4 prompt generation
- ✅ Copy to clipboard functionality

### Version 1.1 (Planned)
- [ ] Prompt history and favorites
- [ ] Share prompts via link
- [ ] Basic analytics dashboard
- [ ] Export calendar to CSV

### Version 1.2 (Future)
- [ ] Multi-week planning
- [ ] Custom content categories
- [ ] Template library
- [ ] Team collaboration

### Version 2.0 (Long-term)
- [ ] Direct API integration with Google platforms
- [ ] Real-time preview generation
- [ ] Subscription model
- [ ] Enterprise features

## Contributing

We welcome contributions! Please see our contributing guidelines for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Contact support at support@easyprompt.app
- Check our [documentation](docs/)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with SwiftUI and modern iOS technologies
- Powered by OpenAI's GPT-4 for intelligent content generation
- Optimized for Google's VEO3 and Imagen 4 platforms

---

**Easy Prompt** - Professional AI prompts in seconds, not hours.
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a SwiftUI macOS/iOS application called "easy-prompt" built with Xcode. It's a minimal SwiftUI project with a basic app structure.

## Common Development Tasks

### Building the Project
- **Build**: `Cmd+B` in Xcode or `xcodebuild -scheme easy-prompt build`
- **Run**: `Cmd+R` in Xcode or `xcodebuild -scheme easy-prompt -destination 'platform=macOS' build`
- **Clean Build**: `Cmd+Shift+K` in Xcode or `xcodebuild -scheme easy-prompt clean`

### Testing
- **Run Unit Tests**: `Cmd+U` in Xcode or `xcodebuild -scheme easy-prompt test`
- **Run Specific Test**: Click the diamond next to the test method in Xcode
- **UI Tests**: Located in `easy-promptUITests/` using XCTest framework
- **Unit Tests**: Located in `easy-promptTests/` using Swift Testing framework

### Code Formatting & Linting
- **SwiftLint** (if installed): `swiftlint` in project root
- **Format Code**: Xcode Editor → Structure → Re-Indent (`Ctrl+I`)

## Architecture

### Project Structure
- **easy-prompt/**: Main app source code
  - `easy_promptApp.swift`: App entry point with @main attribute
  - `ContentView.swift`: Main view of the application
  - `Assets.xcassets/`: App icons and color assets
  - `Preview Content/`: SwiftUI preview assets

### Key Patterns
- **SwiftUI App Lifecycle**: Uses the modern SwiftUI @main app structure
- **View Architecture**: Views are defined as SwiftUI `View` structs
- **Testing Strategy**: 
  - Unit tests use Swift Testing framework with `@Test` macro
  - UI tests use XCTest framework for end-to-end testing

### Dependencies
Currently no external dependencies. Project uses only Apple frameworks:
- SwiftUI for UI
- Swift Testing for unit tests
- XCTest for UI tests
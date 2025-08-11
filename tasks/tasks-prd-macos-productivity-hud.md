# Task List: macOS Always-Visible Productivity HUD

## Relevant Files

- `SpeedometerHUDApp.swift` - Main SwiftUI app entry point with AppKit bridge setup
- `AppDelegate.swift` - Status bar integration, app lifecycle, and global hotkey handling
- `FloatingPanel.swift` - Custom NSPanel subclass with always-on-top behaviors and drag support
- `HUDView.swift` - Main SwiftUI content view with compact/expanded states
- `SpeedometerGauge.swift` - Custom semi-circular gauge component with animated needle
- `Nudger.swift` - Toast notification system for pace feedback and celebrations
- `Preferences.swift` - UserDefaults wrapper for window position and app preferences
- `LoginItem.swift` - Start-at-login functionality using SMAppService
- `TaskManager.swift` - Core business logic for timer, pace calculations, and state management
- `TaskManagerTests.swift` - Unit tests for pace calculations, ETA logic, and color state rules
- `HUDViewTests.swift` - Unit tests for UI interactions and state changes
- `PreferencesTests.swift` - Unit tests for UserDefaults persistence

### Notes

- Unit tests should be placed alongside the code files they are testing
- Use `swift test` to run tests for the Swift package
- The app will be structured as a SwiftUI app with AppKit bridge for advanced window behaviors
- All animations should respect the system's "Reduce Motion" setting

## Tasks

- [ ] 1.0 Project Setup and Core Architecture
  - [x] 1.1 Create Xcode project with SwiftUI app template targeting macOS 13+
  - [x] 1.2 Set up project structure with proper file organization
  - [x] 1.3 Configure app bundle identifier and deployment target
  - [x] 1.5 Create basic app entry point with AppKit bridge setup
  - [x] 1.6 Configure app to hide from Dock and run as menu bar utility

- [ ] 2.0 Window Management and Display System
  - [x] 2.1 Create FloatingPanel subclass extending NSPanel
  - [x] 2.2 Configure panel properties: borderless, transparent, rounded corners
  - [x] 2.3 Set window level to .floating with fullScreenAuxiliary behavior
  - [x] 2.4 Implement canJoinAllSpaces and fullScreenAuxiliary collection behaviors
  - [ ] 2.5 Add NSVisualEffectView with blur effects for glass morphism
  - [x] 2.6 Implement drag functionality with mouse event handling
  - [x] 2.7 Add edge snapping behavior (snap when <10px from edges)
  - [x] 2.10 Implement window positioning logic (top-right with 16px margins)

- [ ] 3.0 Core UI Components and Visual Design
  - [ ] 3.1 Create HUDView as main SwiftUI content view
  - [ ] 3.2 Implement compact mode layout (260×140px) with basic elements
  - [ ] 3.3 Add header with green status dot and "Reminder" label
  - [ ] 3.4 Display hard-coded task title prominently
  - [ ] 3.5 Create SpeedometerGauge component with semi-circular design
  - [ ] 3.6 Implement gauge needle animation with spring/easeOut (180ms)
  - [ ] 3.7 Add progress stats display ("X / Y units")
  - [ ] 3.8 Show countdown timer in MM:SS format
  - [ ] 3.9 Display ETA calculation ("Pace: finish in MM:SS")
  - [ ] 3.10 Implement hover expansion to detailed mode (~300×180px)
  - [ ] 3.11 Add smooth expand/contract animation (120ms)
  - [ ] 3.13 Add subtle shadow and visual polish

- [ ] 4.0 Task Logic and Timer Implementation
  - [ ] 4.1 Create TaskManager class for core business logic
  - [ ] 4.2 Implement countdown timer with 1-second updates
  - [ ] 4.4 Implement pace calculation: completedUnits / elapsedTime
  - [ ] 4.5 Add ETA calculation: remainingUnits / pace (with pace=0 guard)
  - [ ] 4.6 Create color state logic with discrete thresholds:
    - Green (#4ADE80): ETA ≤ remaining time
    - Yellow (#FACC15): ETA within +20% of remaining time
    - Red (#F87171): ETA > remaining time
  - [ ] 4.8 Add [+1] button functionality with immediate recalculation
  - [ ] 4.9 Implement [Accomplished] button (complete regardless of progress)


- [ ] 6.0 Celebration System and Micro-Interactions
  - [ ] 6.1 Create Nudger component for toast notifications
  - [ ] 6.2 Implement confetti animation system (1-2 seconds duration)
  - [ ] 6.3 Add confetti particle system with SwiftUI animations
  - [ ] 6.4 Respect "Reduce Motion" setting (skip confetti, use static badge)
  - [ ] 6.5 Implement pace feedback toasts:
    - Green: "On track."
    - Yellow: "Slightly behind—one more now keeps pace."
    - Red: "Pick it up: 3 left, 8 min."
  - [ ] 6.6 Add completion celebration with time saved message
  - [ ] 6.7 Implement subtle pulse animation for red state
  - [ ] 6.8 Add color cross-fade transitions (150ms)
  - [ ] 6.9 Create non-blocking toast display system
  - [ ] 6.10 Handle task completion flow (5-second celebration, then reset to idle)

- [ ] 7.0 Persistence and Preferences Management
  - [ ] 7.1 Create Preferences class as UserDefaults wrapper
  - [ ] 7.2 Implement window position saving/restoration
  - [ ] 7.3 Add compact/expanded state preference persistence
  - [ ] 7.4 Structure code for easy replacement of hard-coded demo values
  - [ ] 7.5 Add "Reset Position" functionality
  - [ ] 7.6 Implement preference validation and fallback values
  - [ ] 7.7 Add preference change notifications for UI updates
  - [ ] 7.8 Handle preference migration for future updates

- [ ] 8.0 Testing and Performance Optimization
  - [ ] 8.1 Create TaskManagerTests for core business logic
  - [ ] 8.2 Test pace calculation accuracy with various scenarios
  - [ ] 8.3 Test ETA calculation and edge cases (pace=0, no progress)
  - [ ] 8.4 Test color state transitions and threshold logic
  - [ ] 8.5 Create HUDViewTests for UI interactions
  - [ ] 8.6 Test timer pause/resume functionality
  - [ ] 8.7 Test progress capping and boundary conditions
  - [ ] 8.8 Create PreferencesTests for UserDefaults persistence
  - [ ] 8.9 Optimize CPU usage to target <1-2% when idle
  - [ ] 8.10 Ensure sub-100ms response time for user interactions
  - [ ] 8.11 Add performance monitoring and logging
  - [ ] 8.12 Test accessibility features (VoiceOver, keyboard navigation)
  - [ ] 8.13 Verify "Reduce Motion" compliance
  - [ ] 8.14 Test multi-display scenarios and window positioning
  - [ ] 8.15 Conduct integration testing across all Spaces and full-screen apps 
# Product Requirements Document: macOS Always-Visible Productivity HUD

## Introduction/Overview

The macOS Always-Visible Productivity HUD is a native macOS floating overlay that serves as a productivity co-pilot. It provides real-time task progress, pacing feedback, and micro-actions to keep users focused and motivated. The HUD is always visible across all Spaces and full-screen applications, removing the need for context switching while providing delightful micro-interactions that reinforce progress.

**Problem Statement:** Founders and productivity-focused users need constant visual reminders of their "One Thing" without the friction of switching between applications or losing focus on their current work.

**Solution:** A lightweight, always-on-screen HUD that provides immediate feedback, celebrates progress, and maintains user flow through elegant micro-interactions.

## Goals

1. **Zero Friction Access**: Provide instant visibility of current task status without requiring window switching or app launching
2. **Real-Time Pacing Feedback**: Show users if they're on track, slightly behind, or need to pick up pace through visual color states
3. **Micro-Progress Tracking**: Enable one-click progress logging with immediate visual feedback
4. **Celebration Moments**: Provide dopamine-boosting celebrations for task completion and progress milestones
5. **Always Available**: Ensure the HUD is visible across all Spaces, full-screen apps, and system states
6. **Minimal Resource Usage**: Maintain near-zero CPU usage when idle and snappy responsiveness

## User Stories

1. **As a founder**, I want to see my current task progress at a glance so that I stay focused on my "One Thing" without context switching.

2. **As a productivity-focused user**, I want to log micro-progress with a single click so that I can maintain momentum without breaking my flow.

3. **As a busy professional**, I want real-time pacing feedback so that I can adjust my effort to meet deadlines effectively.

4. **As a user working across multiple Spaces**, I want the HUD to always be visible so that I never lose track of my current task.

5. **As someone who values celebration**, I want to be rewarded with confetti and positive feedback when I complete tasks so that I stay motivated.

6. **As a user with accessibility needs**, I want the HUD to respect system preferences so that it works for everyone.

## Functional Requirements

### 1. Window Management & Display
- The system must display an NSPanel with borderless, transparent background and rounded corners
- The system must position the HUD at top-right by default with 16px margins from screen edges
- The system must ensure the HUD appears on all Spaces and over full-screen applications
- The system must allow the HUD to be dragged and repositioned by the user
- The system must constrain the HUD to visible screen bounds with edge snapping
- The system must persist the HUD position across app restarts
- The system must automatically reposition to the display containing the active menu bar

### 2. Visual Design & Layout
- The system must display the HUD in compact mode (260×140px) by default
- The system must expand to detailed mode (~300×180px) on hover with 120ms animation
- The system must use glassy visual effects with automatic light/dark mode support
- The system must show a green status dot and "Reminder" label in the header
- The system must display the current task title prominently
- The system must include a semi-circular speedometer gauge (0-100%) with animated needle
- The system must show progress stats: "X / Y units" and "Time left: MM:SS"
- The system must display ETA calculation: "Pace: finish in MM:SS"

### 3. Task Progress & Timer Logic
- The system must start a countdown timer from the target minutes on app launch
- The system must update the timer every second
- The system must pause the timer when the app is backgrounded
- The system must resume the timer when the app becomes active
- The system must calculate pace as: completedUnits / elapsedTime
- The system must calculate ETA as: remainingUnits / pace (with guard for pace=0)
- The system must cap progress at target units (ignore clicks beyond target)

### 4. Color States & Visual Feedback
- The system must use discrete color thresholds with instant transitions:
  - Green (#4ADE80): ETA ≤ remaining time
  - Yellow (#FACC15): ETA within +20% of remaining time  
  - Red (#F87171): ETA > remaining time
- The system must animate the gauge needle with spring/easeOut animation (180ms)
- The system must provide subtle pulse animation for red state
- The system must show color cross-fade transitions (150ms)

### 5. Micro-Actions & User Interactions
- The system must provide a [+1] button that increments completed units
- The system must provide an [Accomplished] button that marks task complete regardless of progress
- The system must support keyboard shortcuts: [+1] = ⌘⇧=, [Accomplished] = ⌘⇧Enter
- The system must recalculate pace, ETA, and color state immediately after each [+1] click
- The system must show "N/A" or "—" for ETA before first progress is logged

### 6. Celebration & Feedback
- The system must display confetti animation when task is accomplished (1-2 seconds)
- The system must show completion message with time saved: "6 minutes saved!"
- The system must display non-blocking toast notifications for pace feedback:
  - Green: "On track."
  - Yellow: "Slightly behind—one more now keeps pace."
  - Red: "Pick it up: 3 left, 8 min."
- The system must respect "Reduce Motion" setting (skip confetti, use static badge)

### 7. Menu Bar Integration
- The system must add a status bar item with "⏱" icon
- The system must provide menu items: Show/Hide HUD, Start at Login, Reset Position, Quit
- The system must support global hotkey ⌘⇧R to toggle HUD visibility
- The system must implement "Start at Login" using SMAppService.mainApp.register()

### 8. State Management & Persistence
- The system must reset to demo values on app launch (no persistence in v0)
- The system must save window position in UserDefaults
- The system must save compact/expanded state preference
- The system must structure code to easily replace hard-coded values with dynamic config

## Non-Goals (Out of Scope)

1. **External Data Integration**: No API calls, cloud sync, or external data sources
2. **Multiple Task Management**: No task switching, task lists, or project management features
3. **Notifications**: No push notifications or system notification integration
4. **Advanced Analytics**: No detailed progress reports, charts, or historical data
5. **Team Features**: No collaboration, sharing, or multi-user functionality
6. **Custom Task Types**: No dynamic task configuration beyond hard-coded demo values
7. **Sound Effects**: No audio feedback beyond system haptics
8. **Export/Import**: No data export or import functionality

## Design Considerations

### Visual Design
- **Glass Morphism**: Use NSVisualEffectView with blur effects for modern appearance
- **Color Palette**: 
  - Success Green: #4ADE80
  - Warning Amber: #FACC15  
  - Alert Red: #F87171
- **Typography**: System fonts with appropriate hierarchy for readability
- **Animations**: Smooth, purposeful animations that enhance rather than distract

### Accessibility
- **VoiceOver Support**: Basic labels for buttons and stats
- **Keyboard Navigation**: Full keyboard accessibility with shortcuts
- **Reduced Motion**: Respect system accessibility preferences
- **High Contrast**: Support for high contrast mode

### Performance
- **CPU Usage**: Target <1-2% CPU usage when idle
- **Memory**: Minimal memory footprint for always-on application
- **Responsiveness**: Sub-100ms response time for user interactions
- **Battery Impact**: Minimal impact on battery life

## Technical Considerations

### Architecture
- **SwiftUI Lifecycle**: Use SwiftUI app with AppKit bridge for NSPanel
- **Window Management**: Custom NSPanel subclass with specific behaviors
- **State Management**: Simple state management with UserDefaults for persistence
- **Animation System**: SwiftUI animations with performance optimization

### Dependencies
- **macOS 13+**: Target minimum macOS version
- **AppKit Bridge**: For NSPanel and advanced window behaviors
- **SwiftUI**: For modern UI development
- **UserDefaults**: For simple preference storage

### Security & Privacy
- **Local Only**: No network access or data transmission
- **System Integration**: Minimal system permissions required
- **Privacy Respectful**: No user data collection or analytics

## Success Metrics

1. **User Engagement**: HUD remains visible and used throughout work sessions
2. **Task Completion Rate**: Users complete tasks within target timeframes
3. **System Performance**: CPU usage remains below 2% during normal operation
4. **User Satisfaction**: Positive feedback on micro-interactions and celebration moments
5. **Accessibility Compliance**: Works seamlessly with system accessibility features

## Open Questions

1. **Auto-hide Behavior**: Should the HUD auto-hide after inactivity? (Assumed: OFF for v0)
2. **Click-through Mode**: Should users be able to click through the HUD? (Assumed: OFF for v0)
3. **Multi-display Behavior**: Should position be saved per-display or globally? (Assumed: Global)
4. **Future Task Management**: How should the system handle multiple tasks in future versions?
5. **Data Export**: Should users be able to export their progress data?

## Definition of Done

The feature is complete when:

1. **Core Functionality**: HUD launches and displays correctly in top-right position
2. **Timer Logic**: Countdown timer works accurately with pause/resume on backgrounding
3. **Progress Tracking**: [+1] button increments progress and updates all calculations
4. **Visual Feedback**: Color states change correctly based on pace calculations
5. **Celebration**: Confetti and completion messages work as specified
6. **Window Management**: HUD appears on all Spaces and over full-screen apps
7. **Menu Bar Integration**: Status bar item and hotkeys function correctly
8. **Persistence**: Window position and preferences save/restore properly
9. **Performance**: CPU usage remains minimal during normal operation
10. **Accessibility**: Basic VoiceOver support and keyboard shortcuts work

## Implementation Notes

### File Structure
- `SpeedometerHUDApp.swift`: Main SwiftUI app entry point
- `AppDelegate.swift`: Status bar integration and app lifecycle
- `FloatingPanel.swift`: Custom NSPanel subclass with window behaviors
- `HUDView.swift`: Main SwiftUI content view
- `SpeedometerGauge.swift`: Custom gauge component
- `Nudger.swift`: Toast notification system
- `Preferences.swift`: UserDefaults wrapper for settings
- `LoginItem.swift`: Start-at-login functionality

### Development Phases
1. **Phase 1**: Core window and basic UI implementation
2. **Phase 2**: Timer logic and progress tracking
3. **Phase 3**: Visual feedback and color states
4. **Phase 4**: Celebration animations and micro-interactions
5. **Phase 5**: Menu bar integration and system behaviors
6. **Phase 6**: Performance optimization and accessibility
7. **Phase 7**: Testing and refinement

This PRD captures Anton's vision for a frictionless, delightful productivity co-pilot that enhances focus and celebrates progress through elegant micro-interactions. 


- [ ] 5.0 Menu Bar Integration and System Behaviors
  - [ ] 5.1 Create AppDelegate for status bar integration
  - [ ] 5.2 Add status bar item with "⏱" icon
  - [ ] 5.3 Implement menu items: Show/Hide HUD, Start at Login, Reset Position, Quit
  - [ ] 5.4 Add global hotkey ⌘⇧R to toggle HUD visibility
  - [ ] 5.5 Create LoginItem helper using SMAppService.mainApp.register()
  - [ ] 5.6 Handle "Start at Login" toggle with fallback for unsupported OS
  - [ ] 5.7 Implement app lifecycle management (launch, quit, background)
  - [ ] 5.8 Add system notification handling for display changes
  - [ ] 5.9 Ensure HUD hides for critical system alerts and reappears after
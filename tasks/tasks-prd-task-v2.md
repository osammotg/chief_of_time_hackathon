# Tasks — macOS Always-Visible Productivity HUD v2

## Relevant Files

- `SpeedometerHUD/SpeedometerHUD/Components/ProgressLoader.swift` - New horizontal progress bar component with color states and Reduce Motion support.
- `SpeedometerHUD/SpeedometerHUD/Views/DayPanelView.swift` - New expanded day panel view with task table and stats.
- `SpeedometerHUD/SpeedometerHUD/Views/HUDView.swift` - Main HUD view to be updated with new components and actions.
- `SpeedometerHUD/SpeedometerHUD/Models/TaskManager.swift` - Task state management, timer logic, and demo data integration.
- `SpeedometerHUD/SpeedometerHUD/Components/Nudger.swift` - Toast notification system for user feedback.
- `SpeedometerHUD/SpeedometerHUD/AppDelegate.swift` - Status bar menu updates and global hotkey registration.
- `SpeedometerHUD/SpeedometerHUD/Utils/Preferences.swift` - Basic preference management for expanded state.

### Notes

- The existing `FloatingPanel.swift` and `OverlayWindowController.swift` will be reused as-is.
- Demo data will be hard-coded in `TaskManager.swift` using the provided JSON structure.
- Screenshot functionality is UI-only (stub) for v2.
- No persistence implementation required for v2 (demo mode only).

## Tasks

- [x] 1.0 Implement Progress Loader Component
  - [x] 1.1 Create ProgressLoader.swift with horizontal bar layout and basic styling
  - [x] 1.2 Add progress animation with 180ms duration and Reduce Motion support
  - [x] 1.3 Implement color state logic (green/yellow/red) based on pace thresholds
  - [x] 1.4 Add cross-fade transitions (150ms) and subtle pulse for red state
  - [x] 1.5 Add accessibility labels and VoiceOver support for progress value
  - [x] 1.6 Create preview with demo data to test different progress states

- [x] 2.0 Update Compact HUD with Actions and Expand/Collapse
  - [x] 2.1 Replace SpeedometerGauge stub with ProgressLoader in HUDView
  - [x] 2.2 Add action buttons (+1, Finish, 📸 stub, Expand ▲) with proper spacing
  - [x] 2.3 Implement expand/collapse state management in HUDView
  - [x] 2.4 Add smooth animation for expand/collapse (180ms, respect Reduce Motion)
  - [x] 2.5 Wire action buttons to TaskManager methods (increment, finish)
  - [x] 2.7 Update meta row to show static demo strings (Time left | ETA | Pace)y
  - [x] 2.8 Panel sizing anchor: implement "expand upward to ~70% height / ~20% width" from current bottom edge
  - [x] 2.9 Add small helper in FloatingPanel to set size & keep bottom-left/right anchor

- [x] 3.0 Create Day Panel View with Task Table
  - [x] 3.1 Create DayPanelView.swift with basic layout structure
  - [x] 3.2 Implement Today's Plan table with Time | Task | Status columns
  - [x] 3.3 Add task status styling (done: crossed+green, pending: normal, missed: dim/red)
  - [x] 3.4 Add meeting rows with 📅 badge and read-only styling
  - [x] 3.5 Create current task section with loader, units, time, ETA, pace
  - [x] 3.6 Add stats section (tasks done/total, % day complete)
  - [x] 3.7 Add collapse button (▼) and action buttons for current task
  - [x] 3.8 Implement scrollable content for long task lists
  - [x] 3.9 Sort by time: ensure DayPanel rows are sorted by start (string → minutes) so the schedule looks CEO-clean

- [ ] 4.0 Implement Task Logic and Timer System
  - [ ] 4.1 Add hard-coded demo data to TaskManager using provided JSON structure
  - [ ] 4.2 Implement timer loop with 1-second ticks (always-on for demo)
  - [ ] 4.3 Add pace calculation (unitsDone / elapsedTime) with proper error handling
  - [ ] 4.4 Implement ETA calculation (remainingUnits / pace) with "—" fallback
  - [ ] 4.5 Add progress capping logic to prevent exceeding unitsTarget
  - [ ] 4.6 Implement task completion flow with status updates (manual advancement)
  - [ ] 4.7 Add color threshold logic for loader states (ETA ≤ remaining = green, etc.)
  - [ ] 4.8 Wire TaskManager to HUDView and DayPanelView for real-time updates
  - [ ] 4.9 Demo-safe fallbacks: if pace==0 or timer not implemented, show ETA: — and drive color by % complete (≤50% red, 50–80% yellow, >80% green) for the demo

- [ ] 5.0 Add Menu Integration and Polish Features
  - [ ] 5.1 Remove debug window and print statements from AppDelegate
  - [ ] 5.2 Centralize constants (window sizes, snap distance, animation durations)
  - [ ] 5.3 Add basic VoiceOver labels for loader and buttons
  - [ ] 5.4 Test expand/collapse behavior with different screen sizes and positions
  - [ ] 5.5 Screenshot stub: button present in HUD and DayPanel calling a TODO() (no menu item needed for hackathon) 
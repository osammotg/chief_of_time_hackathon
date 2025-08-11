# PRD — macOS Always-Visible Productivity HUD v2 (Compact → Day Panel)

## Introduction/Overview

A native macOS **always-on HUD** that shows the **current task** with a **sexy horizontal progress loader** and one-tap actions. On click, it **expands upward** into a **Day Panel**: today's plan (tasks + meetings), current progress, and pacing stats. Built to be beautiful, low-friction, and always visible.

**Problem Statement:** Users need constant visual reminders of their current task without context switching, with the ability to quickly expand to see their full day's plan and track progress with immediate feedback.

**Solution:** A lightweight, always-on-screen HUD with smooth animations, micro-interactions, and an expandable day panel that provides comprehensive task visibility and control.

## What We Already Have (Reuse)

* **Window layer:** Floating NSPanel, glass effect, always-on-top, all Spaces/full-screen, drag + edge snap, position autosave.
  *Files: `FloatingPanel.swift`, `OverlayWindowController.swift`*
* **App shell:** SwiftUI entry, status bar item, hide from Dock, global hotkey.
  *Files: `SpeedometerHUDApp.swift`, `AppDelegate.swift`, `GlobalHotKey.swift`*
* **HUD skeleton:** Compact HUD view layout (static).
  *File: `HUDView.swift`*
* **Prefs (basic):** window frame autosave.
  *File: `Preferences.swift`*

## Goals

1. **Zero-friction focus:** Current task is always visible and actionable.
2. **Instant progress feedback:** Smooth horizontal loader with color pacing (🟢🟡🔴).
3. **Click→Control:** Expand to a focused Day Panel (today's plan + stats) without context switching.
4. **Delight, not distraction:** Micro feedback, minimal chrome, respects Reduce Motion.
5. **Lightweight:** Idle CPU <2%, snappy interactions.

## User Stories

1. **As a productivity-focused user**, I want to see my current task progress at a glance so that I stay focused without context switching.

2. **As a busy professional**, I want to log micro-progress with a single click so that I can maintain momentum without breaking my flow.

3. **As a user working across multiple Spaces**, I want the HUD to always be visible so that I never lose track of my current task.

4. **As someone who values celebration**, I want to be rewarded with visual feedback when I complete tasks so that I stay motivated.

5. **As a user with accessibility needs**, I want the HUD to respect system preferences so that it works for everyone.

6. **As a user planning my day**, I want to quickly expand the HUD to see my full day's plan so that I can understand my progress and upcoming commitments.

## Functional Requirements

### 1. Compact HUD (Always Visible)

**Layout (≈260×140):**
- **Title:** Current task (bold, single line, truncates tail).
- **Progress Loader:** Smooth horizontal bar, shows unitsDone/unitsTarget; anim duration ≤180ms.
- **Meta row:** `Time left MM:SS | ETA MM:SS | Pace verdict` (static strings for demo).
- **Actions:** **+1**, **Finish**, **📸 (stub)**, **Expand (▲)**.

**Color states:**
- 🟢 `ETA ≤ remaining`
- 🟡 `ETA ≤ remaining × 1.2`
- 🔴 otherwise
- Cross-fade ≤150ms; subtle pulse only in 🔴 (skip when Reduce Motion on).

**Screenshot:** UI-only button (stub/TODO) - no functionality for v2.

### 2. Expanded Day Panel (On Click of Arrow)

**Behavior:** Expands **upward** from the HUD's anchor. Size target: **~70% screen height, ~20% width**. Stays draggable; edge-snaps.

**Content:**
- **Today's Plan table:** `Time | Task | Status`
  - **Done:** crossed + green; **Pending:** normal; **Missed:** dim/red outline.
  - **Meetings:** inline rows with 📅 badge; read-only.
- **Current Task section:** loader, `unitsDone/unitsTarget`, time left, ETA, pace verdict.
- **Stats:** tasks done/total, % day complete, time saved/behind.

**Controls:** Collapse (▼). Same **+1 / Finish / 📸 (stub)** for current task.

### 3. Task Logic & Pacing

**Timer:** 1s tick; pauses when app inactive, resumes when active.
**Pace:** `unitsDone / elapsedTime`.
**ETA:** `remainingUnits / pace` (guard pace=0 → show "—").
**Progress capping:** do not exceed `unitsTarget`.
**Completion flow:** mark task done; show visual feedback; advance to next task if available.

### 4. Window & Menu

Keep `.floating`, `canJoinAllSpaces`, `fullScreenAuxiliary`, drag, edge snap, autosave frame.
**Status bar menu:** Show/Hide HUD, Start at Login, Reset Position, Screenshot HUD (stub), Quit.
**Global hotkeys (user-configurable):**
- `⌘⇧=` **+1**
- `⌘⇧↩` **Finish**
- `⌘⇧S` **Screenshot (stub)**
- `⌘⇧↑` **Expand/Collapse**
- Existing toggle remains.

### 5. Data Model (Demo Only - No Persistence)

```swift
struct Task: Identifiable, Codable {
  let id: String
  var title: String
  var start: String?   // "HH:mm"
  var end: String?     // "HH:mm"
  var unitsTarget: Int
  var unitsDone: Int
  var status: String   // "todo", "done", "missed"
  var isMeeting: Bool  // meetings are read-only rows
}

struct TodayPlan: Codable {
  var currentTaskId: String
  var tasks: [Task]
}
```

**Hard-coded demo data:**
```json
{
  "todayPlan": {
    "currentTaskId": "build_inline_ai_assist",
    "tasks": [
      { "id": "standup", "title": "Daily Standup (team)", "start": "08:30", "end": "08:45", "unitsTarget": 1, "unitsDone": 0, "status": "todo", "isMeeting": true },
      { "id": "recruit_outbound", "title": "Recruiting: Outbound Reach-outs (15)", "start": "08:45", "end": "09:15", "unitsTarget": 15, "unitsDone": 0, "status": "todo", "isMeeting": false },
      { "id": "build_inline_ai_assist", "title": "Deep Work: Build Inline AI Assist", "start": "09:15", "end": "11:15", "unitsTarget": 8, "unitsDone": 3, "status": "todo", "isMeeting": false },
      { "id": "client_demo", "title": "Client Demo (Acme)", "start": "13:00", "end": "13:45", "unitsTarget": 1, "unitsDone": 0, "status": "todo", "isMeeting": true },
      { "id": "ship_release", "title": "Ship: Finalize PR & Release Notes", "start": "15:00", "end": "16:00", "unitsTarget": 4, "unitsDone": 0, "status": "todo", "isMeeting": false }
    ]
  }
}
```

### 6. Accessibility & Performance

- VoiceOver labels for all buttons, loader value/description.
- Full keyboard access (tab focus) and shortcuts.
- Respect **Reduce Motion** for all animations.
- Idle CPU target <2%; interaction latency <100ms.

## Non-Goals (Out of Scope)

1. **Screenshot functionality:** Button exists but no actual screenshot capture.
2. **Persistence:** No data persistence - demo mode only, resets on restart.
3. **Calendar integration:** Manual entries only, no calendar API.
4. **Multi-day history:** Single day view only.
5. **External data sources:** No API calls or cloud sync.
6. **Team features:** No collaboration or sharing.
7. **Sound effects:** No audio feedback beyond system haptics.

## Design Considerations

### Visual Design
- **Glass Morphism:** Use NSVisualEffectView with blur effects for modern appearance.
- **Color Palette:** 
  - Success Green: #4ADE80
  - Warning Amber: #FACC15  
  - Alert Red: #F87171
- **Typography:** System fonts with appropriate hierarchy for readability.
- **Animations:** Smooth, purposeful animations that enhance rather than distract.

### Accessibility
- **VoiceOver Support:** Basic labels for buttons and stats.
- **Keyboard Navigation:** Full keyboard accessibility with shortcuts.
- **Reduced Motion:** Respect system accessibility preferences.
- **High Contrast:** Support for high contrast mode.

### Performance
- **CPU Usage:** Target <1-2% CPU usage when idle.
- **Memory:** Minimal memory footprint for always-on application.
- **Responsiveness:** Sub-100ms response time for user interactions.
- **Battery Impact:** Minimal impact on battery life.

## Technical Considerations

### Architecture
- **SwiftUI Lifecycle:** Use SwiftUI app with AppKit bridge for NSPanel.
- **Window Management:** Custom NSPanel subclass with specific behaviors.
- **State Management:** Simple state management with demo data only.
- **Animation System:** SwiftUI animations with performance optimization.

### Dependencies
- **macOS 13+:** Target minimum macOS version.
- **AppKit Bridge:** For NSPanel and advanced window behaviors.
- **SwiftUI:** For modern UI development.

### Security & Privacy
- **Local Only:** No network access or data transmission.
- **System Integration:** Minimal system permissions required.
- **Privacy Respectful:** No user data collection or analytics.

## Components & Responsibilities

- **`FloatingPanel.swift`** (reuse): window level/behaviors, drag, snap, autosave, glass.
- **`OverlayWindowController.swift`** (reuse): panel lifecycle.
- **`HUDView.swift`**: compact UI; displays title, loader, meta row, actions; toggles expanded.
- **`ProgressLoader.swift`** (new): animated horizontal loader with color states; value 0…1; respects Reduce Motion.
- **`DayPanelView.swift`** (new): table of Today's Plan, current task detail, stats; collapse control.
- **`TaskManager.swift`**: timer loop, pace/ETA/thresholds, increment/finish, today plan state, demo data.
- **`Nudger.swift`**: lightweight toast presenter; success/warn/alert styles; non-blocking.
- **`AppDelegate.swift`**: status bar menu; screenshot action (stub); start-at-login; global hotkeys.
- **`Preferences.swift`**: keys for expanded state (basic).

## Interaction Flows (Happy Paths)

**+1 in Compact HUD**
1. User taps **+1** → `TaskManager.increment()` updates `unitsDone`.
2. Recompute pace/ETA → loader animates to new value → color may change.
3. Optional toast (e.g., "On track"/"One more keeps pace").

**Expand to Day Panel**
1. User taps **▲** → panel animates upward to target size; content switches to Day Panel.
2. Current task highlighted; actions available; user can scroll plan if needed.
3. Tap **▼** to return to compact.

**Finish Task**
1. User taps **Finish** → mark done, show visual feedback → advance `currentTaskId` if next task exists.

**Screenshot (Stub)**
1. User taps 📸 → nothing happens (TODO: hook).

## Success Metrics

1. **User Engagement:** HUD remains visible and used throughout work sessions.
2. **Task Completion Rate:** Users complete tasks within target timeframes.
3. **System Performance:** CPU usage remains below 2% during normal operation.
4. **User Satisfaction:** Positive feedback on micro-interactions and visual feedback.
5. **Accessibility Compliance:** Works seamlessly with system accessibility features.

## Acceptance Criteria (Definition of Done)

- Compact HUD shows task, horizontal loader, meta row, actions; color states update with thresholds; Reduce Motion honored.
- Day Panel expands upward to ~70% H / ~20% W, remains draggable; shows table, current task detail, stats; collapse works.
- +1, Finish, 📸 (stub) actions function in both views; keyboard shortcuts work.
- Timer, pace, ETA correct; progress caps at target; ETA shows "—" before first unit.
- Window floats across Spaces/full-screen; edge-snaps; restores position on relaunch.
- Demo data renders correctly; no persistence required.
- Idle CPU <2%; interaction <100ms; basic VoiceOver labels present.

## Task Breakdown

**Epic A — Compact HUD Completion**
- A1: Implement `ProgressLoader.swift` (animated horizontal bar, color states, Reduce Motion).
- A2: Wire loader into `HUDView`; replace gauge stub.
- A3: Add actions (+1, Finish, 📸 stub, Expand) with icons and tooltips.
- A4: Keyboard shortcuts and accessibility labels.

**Epic B — Day Panel**
- B1: Create `DayPanelView.swift` (table, current task, stats, collapse).
- B2: Expand/collapse behavior: anchored growth upward; size constraints.
- B3: Highlight current task; inline meetings with 📅 badge; status styling.

**Epic C — Task Logic**
- C1: `TaskManager` timer loop; pace/ETA; thresholds.
- C2: Increment/finish APIs; progress capping.
- C3: Demo data integration; task advancement logic.

**Epic D — Menu & Polish**
- D1: Status bar menu additions (Start at Login, Reset Position, Screenshot HUD stub).
- D2: Remove debug window; centralize constants (sizes, snap distance).
- D3: Performance pass; accessibility pass (VoiceOver strings).

## Open Questions

1. **Loader style final:** Horizontal bar confirmed.
2. **Screenshot scope:** UI-only button (stub) for v2.
3. **Meetings source:** Manual entries only (hard-coded demo data).
4. **Persistence scope:** No persistence for v2 (demo mode only).
5. **Animation preferences:** Smooth slide animation (~180ms) with Reduce Motion respect.
6. **Color thresholds:** Fixed thresholds confirmed.
7. **Hotkey conflicts:** User-configurable with manual conflict resolution.

## Implementation Notes

### File Structure
- `SpeedometerHUDApp.swift`: Main SwiftUI app entry point
- `AppDelegate.swift`: Status bar integration and app lifecycle
- `FloatingPanel.swift`: Custom NSPanel subclass with window behaviors
- `HUDView.swift`: Main SwiftUI content view (compact mode)
- `ProgressLoader.swift`: Horizontal progress bar component
- `DayPanelView.swift`: Expanded day panel view
- `Nudger.swift`: Toast notification system
- `Preferences.swift`: UserDefaults wrapper for settings
- `TaskManager.swift`: Task state management and demo data

### Development Phases
1. **Phase 1**: Replace gauge with horizontal loader
2. **Phase 2**: Add action buttons and expand/collapse
3. **Phase 3**: Implement Day Panel with demo data
4. **Phase 4**: Task logic and timer implementation
5. **Phase 5**: Menu integration and polish
6. **Phase 6**: Performance optimization and accessibility

This PRD captures the vision for a frictionless, delightful productivity co-pilot that enhances focus and provides immediate visual feedback through elegant micro-interactions, with a focus on demo functionality for v2. 
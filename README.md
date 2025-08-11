# Speedometer HUD - macOS Productivity HUD

A macOS SwiftUI+AppKit HUD application that provides an always-on-top productivity interface with a debug window system for undeniable visibility testing.

## 🎯 Project Overview

This project demonstrates a robust approach to creating macOS HUD applications by first proving window visibility with a debug system, then building the actual productivity interface on top of the proven foundation.

## 🚀 What We Accomplished

### ✅ **Phase 1: Debug Window System (COMPLETED)**

We solved the classic macOS HUD visibility problem by creating an **undeniable on-screen proof** system:

#### **Debug Window Features:**
- 🔧 **Hot-pink debug window** (400x200 pixels) with "I AM VISIBLE" text
- 🎯 **Centered positioning** on screen with proper margins
- ⌨️ **Global hotkey support** (⌘⇧R) to force-show the window
- 🔄 **Status bar toggle** - click the ⏱ icon to show/hide
- 📊 **Screen intersection validation** - ensures window is actually visible
- 🏷️ **Debug flag support** (`--debug` flag for debug mode)

#### **Technical Implementation:**
```swift
// Debug window creation with undeniable visibility
let debugWindow = NSWindow(
    contentRect: NSRect(x: 0, y: 0, width: 400, height: 200),
    styleMask: [.titled, .closable],
    backing: .buffered,
    defer: false
)
debugWindow.backgroundColor = NSColor.systemPink
debugWindow.isOpaque = true
```

### ✅ **Phase 2: Production HUD System (COMPLETED)**

Built on the proven debug foundation:

#### **Production HUD Features:**
- 🪟 **NSPanel with visual effects** (glass morphism)
- 🎨 **SwiftUI integration** with custom HUDView
- 📍 **Smart positioning** (top-right with 16px margins)
- 🔄 **Always-on-top behavior** with proper window levels
- 🖱️ **Drag and drop** functionality
- 🎯 **Edge snapping** for precise positioning
- 🌙 **Light/dark mode support**

## 🛠️ Technical Architecture

### **Core Components:**

1. **AppDelegate.swift** - Main application controller
   - Debug window management
   - Status bar integration
   - Global hotkey handling
   - Window lifecycle management

2. **FloatingPanel.swift** - Custom NSPanel implementation
   - Visual effects and glass morphism
   - Drag and drop functionality
   - Edge snapping behavior
   - Always-on-top window levels

3. **HUDView.swift** - SwiftUI content view
   - Custom UI components
   - Responsive design
   - Accessibility support

### **Key Technical Decisions:**

- **Debug-first approach**: Prove visibility before building features
- **Strong window references**: Prevent premature deallocation
- **Proper window levels**: `.floating` for production, `.screenSaver` for testing
- **Collection behavior**: `[.canJoinAllSpaces, .fullScreenAuxiliary]`
- **Visual effect materials**: `.hudWindow` for authentic macOS look

## 🚀 Getting Started

### **Prerequisites:**
- macOS 13.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later

### **Installation:**

1. **Clone the repository:**
   ```bash
   git clone https://github.com/osammotg/chief_of_time_hackathon.git
   cd chief_of_time_hackathon
   ```

2. **Build the project:**
   ```bash
   cd SpeedometerHUD
   swift build
   ```

3. **Run in debug mode (recommended for testing):**
   ```bash
   .build/debug/SpeedometerHUD --debug
   ```

4. **Run in production mode:**
   ```bash
   .build/debug/SpeedometerHUD
   ```

## 🎮 Usage

### **Debug Mode (`--debug` flag):**
- Shows hot-pink "I AM VISIBLE" window
- Perfect for testing window visibility
- Use status bar icon (⏱) to toggle
- Press ⌘⇧R to force-show window

### **Production Mode (default):**
- Shows glass morphism HUD panel
- Drag to reposition
- Snap to screen edges
- Always stays on top

### **Controls:**
- **Status Bar Icon**: Click to toggle visibility
- **Global Hotkey**: ⌘⇧R to force-show
- **Mouse**: Drag to reposition (production mode)
- **Keyboard**: Standard window shortcuts

## 🔧 Development

### **Project Structure:**
```
SpeedometerHUD/
├── Package.swift                 # Swift Package Manager configuration
├── SpeedometerHUD/
│   ├── AppDelegate.swift         # Main application controller
│   ├── SpeedometerHUDApp.swift   # App entry point
│   ├── Views/
│   │   └── HUDView.swift         # SwiftUI content view
│   ├── Utils/
│   │   └── FloatingPanel.swift   # Custom NSPanel implementation
│   ├── Components/               # Reusable UI components
│   ├── Models/                   # Data models
│   └── Info.plist               # App configuration
└── tasks/                       # Project documentation
```

### **Building and Testing:**

```bash
# Build the project
swift build

# Run tests
swift test

# Run in debug mode
.build/debug/SpeedometerHUD --debug

# Run in production mode
.build/debug/SpeedometerHUD
```

### **Debugging Tips:**

1. **Check window visibility:**
   ```swift
   print("🔍 Window isVisible: \(window.isVisible)")
   print("🔍 Window frame: \(window.frame)")
   ```

2. **Verify screen intersection:**
   ```swift
   let intersection = windowFrame.intersection(screenFrame)
   if intersection.width > 50 && intersection.height > 50 {
       print("✅ Window is on screen")
   }
   ```

3. **Test window levels:**
   ```swift
   window.level = .floating      // Normal operation
   window.level = .screenSaver   // Maximum visibility
   ```

## 🎯 Key Achievements

### **✅ Solved the "Invisible HUD" Problem**
- Created undeniable proof of window visibility
- Implemented robust window management
- Added comprehensive debugging tools

### **✅ Built a Production-Ready Foundation**
- Proper window lifecycle management
- Visual effects and modern UI
- Accessibility and usability features

### **✅ Established Best Practices**
- Debug-first development approach
- Comprehensive logging and validation
- Proper error handling and edge cases

## 🔮 Future Enhancements

### **Planned Features:**
- [ ] Task management integration
- [ ] Time tracking functionality
- [ ] Customizable themes
- [ ] Plugin system
- [ ] Multi-monitor support
- [ ] Keyboard shortcuts customization

### **Technical Improvements:**
- [ ] Performance optimization
- [ ] Memory management improvements
- [ ] Enhanced accessibility
- [ ] Unit test coverage
- [ ] CI/CD pipeline

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **macOS HUD Community** - For inspiration and best practices
- **SwiftUI Team** - For the amazing framework
- **AppKit Team** - For the robust window management system

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/osammotg/chief_of_time_hackathon/issues) page
2. Create a new issue with detailed information
3. Include system information and error logs

---

**🎉 The "I AM VISIBLE" debug window proves that this HUD system works correctly and provides a solid foundation for building amazing macOS productivity tools!**

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var floatingPanel: FloatingPanel?
    var debugWindow: NSWindow? // Add debug window reference
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("🚀 App launching...")
        
        // Ensure app runs as background utility
        NSApp.setActivationPolicy(.accessory)
        print("✅ Set activation policy to accessory")
        
        setupStatusBar()
        
        // Check for debug flag
        if CommandLine.arguments.contains("--debug") {
            print("🔧 Debug mode enabled - showing debug window")
            showDebugWindow()
        } else {
            setupFloatingPanel()
        }
        
        setupGlobalHotkey()
        print("✅ App launch complete")
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        cleanup()
    }
    
    // MARK: - Debug Window
    
    func showDebugWindow() {
        print("🔧 Creating debug window...")
        
        // Create a strong-referenced NSWindow with hot-pink background
        let windowRect = NSRect(x: 0, y: 0, width: 400, height: 200)
        debugWindow = NSWindow(
            contentRect: windowRect,
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        
        guard let window = debugWindow else {
            print("❌ Failed to create debug window")
            return
        }
        
        // Configure window properties
        window.backgroundColor = NSColor.systemPink
        window.isOpaque = true
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        
        // Create content view with "I AM VISIBLE" label
        let label = NSTextField()
        label.stringValue = "I AM VISIBLE"
        label.font = NSFont.systemFont(ofSize: 48, weight: .bold)
        label.textColor = NSColor.white
        label.backgroundColor = NSColor.clear
        label.isEditable = false
        label.isSelectable = false
        label.isBordered = false
        label.alignment = .center
        
        // Center the label in the window
        label.frame = NSRect(x: 0, y: 0, width: 400, height: 200)
        label.autoresizingMask = [.width, .height]
        
        window.contentView = label
        
        // Center the window on screen
        window.center()
        
        // Show the window
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: false)
        
        print("🔧 Debug window created and shown")
        print("🔍 Debug window isVisible: \(window.isVisible)")
        print("🔍 Debug window frame: \(window.frame)")
        
        // Log screen information
        if let screen = NSScreen.main {
            print("🖥️ Main screen frame: \(screen.frame)")
            print("🖥️ Main screen visible frame: \(screen.visibleFrame)")
        }
        
        // Assert window is on screen
        assertWindowOnScreen(window)
    }
    
    private func assertWindowOnScreen(_ window: NSWindow) {
        let windowFrame = window.frame
        var isOnScreen = false
        
        for screen in NSScreen.screens {
            let screenFrame = screen.frame
            let intersection = windowFrame.intersection(screenFrame)
            
            print("🔍 Window frame: \(windowFrame)")
            print("🔍 Screen frame: \(screenFrame)")
            print("🔍 Intersection: \(intersection)")
            
            if intersection.width > 50 && intersection.height > 50 {
                isOnScreen = true
                print("✅ Window is on screen: \(screen.localizedName)")
                break
            }
        }
        
        if !isOnScreen {
            print("❌ WARNING: Window may not be visible on any screen!")
        }
    }
    
    // MARK: - Global Hotkey
    
    private func setupGlobalHotkey() {
        print("⌨️ Setting up global hotkey (⌘⇧R)...")
        
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            // Check for ⌘⇧R (Command+Shift+R)
            if event.modifierFlags.contains([.command, .shift]) && event.keyCode == 15 { // R key
                print("⌨️ Global hotkey pressed (⌘⇧R)")
                DispatchQueue.main.async {
                    self?.forceShow()
                }
            }
        }
        
        print("✅ Global hotkey configured")
    }
    
    @objc private func forceShow() {
        print("🔧 Force showing window...")
        
        if let debugWindow = debugWindow {
            debugWindow.makeKeyAndOrderFront(nil)
            debugWindow.orderFrontRegardless()
            NSApp.activate(ignoringOtherApps: false)
            print("✅ Debug window force shown")
        } else if let panel = floatingPanel {
            panel.makeKeyAndOrderFront(nil)
            panel.orderFrontRegardless()
            NSApp.activate(ignoringOtherApps: false)
            print("✅ Panel force shown")
        }
    }
    
    private func setupStatusBar() {
        print("📱 Setting up status bar...")
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.title = "⏱"
            button.action = #selector(toggleHUD)
            button.target = self
            print("✅ Status bar button configured")
        } else {
            print("❌ Failed to get status bar button")
        }
    }
    
    private func setupFloatingPanel() {
        print("🪟 Setting up floating panel...")
        
        // Create the floating panel with default size
        let panelRect = NSRect(x: 0, y: 0, width: 260, height: 140)
        floatingPanel = FloatingPanel(contentRect: panelRect, styleMask: [.borderless], backing: .buffered, defer: false)
        
        // Force the panel to use its default positioning
        floatingPanel?.setDefaultPosition()
        
        // Ensure window level is set correctly
        floatingPanel?.ensureAlwaysOnTop()
        
        print("✅ Floating panel created")
        
        // Create and set the SwiftUI content view
        let hudView = HUDView()
        let hostingView = NSHostingView(rootView: hudView)
        
        // Get the visual effect view from the panel and add the hosting view to it
        if let visualEffectView = floatingPanel?.contentView as? NSVisualEffectView {
            visualEffectView.addSubview(hostingView)
            print("✅ Added SwiftUI content to visual effect view")
        } else {
            // Fallback: add to content view directly
            floatingPanel?.contentView?.addSubview(hostingView)
            print("⚠️ Added SwiftUI content to content view (fallback)")
        }
        
        // Configure the hosting view to fill the panel
        hostingView.frame = panelRect
        hostingView.autoresizingMask = [.width, .height]
        
        // Make sure the hosting view is on top
        hostingView.wantsLayer = true
        hostingView.layer?.backgroundColor = NSColor.clear.cgColor
        
        print("✅ SwiftUI content configured")
        
        // Show the panel
        floatingPanel?.makeKeyAndOrderFront(nil)
        print("✅ Panel should now be visible")
        
        // Debug: check if panel is actually visible
        if let panel = floatingPanel {
            print("🔍 Panel isVisible: \(panel.isVisible)")
            print("🔍 Panel frame: \(panel.frame)")
            print("🔍 Panel level: \(panel.level.rawValue)")
            print("🔍 Panel contentView: \(String(describing: panel.contentView))")
            print("🔍 Hosting view frame: \(hostingView.frame)")
        }
    }
    
    @objc private func toggleHUD() {
        print("🖱️ Toggle HUD clicked!")
        
        if let debugWindow = debugWindow {
            print("🔧 Toggling debug window...")
            print("🔍 Debug window isVisible before toggle: \(debugWindow.isVisible)")
            
            if debugWindow.isVisible {
                print("👁️ Hiding debug window...")
                debugWindow.orderOut(nil)
            } else {
                print("👁️ Showing debug window...")
                debugWindow.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: false)
            }
            
            print("🔍 Debug window isVisible after toggle: \(debugWindow.isVisible)")
        } else if let panel = floatingPanel {
            print("🔍 Panel isVisible before toggle: \(panel.isVisible)")
            
            if panel.isVisible {
                print("👁️ Hiding panel...")
                panel.orderOut(nil)
            } else {
                print("👁️ Showing panel...")
                panel.makeKeyAndOrderFront(nil)
            }
            
            print("🔍 Panel isVisible after toggle: \(panel.isVisible)")
        }
    }
    
    private func cleanup() {
        debugWindow?.close()
        floatingPanel?.close()
        statusItem = nil
    }
} 
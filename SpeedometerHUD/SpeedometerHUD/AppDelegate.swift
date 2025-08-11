import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var overlayController = OverlayWindowController()
    var debugWindow: NSWindow? // Add debug window reference
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("🚀 App launching...")
        
        // Ensure app runs as background utility
        NSApp.setActivationPolicy(.accessory)
        print("✅ Set activation policy to accessory")
        
        setupStatusBar()
        
        // Always show both components for testing
        print("🔧 Showing both I AM VISIBLE and persistent overlay window")
        showDebugWindow()
        overlayController.show()
        
        // Register global hotkey for HUD toggle
        GlobalHotKey.register(key: "h", modifiers: [.command, .option]) { [weak self] in
            self?.toggleHUD()
        }
        
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
    
    @objc private func forceShow() {
        print("🔧 Force showing window...")
        
        if let debugWindow = debugWindow {
            debugWindow.makeKeyAndOrderFront(nil)
            debugWindow.orderFrontRegardless()
            NSApp.activate(ignoringOtherApps: false)
            print("✅ Debug window force shown")
        }
        
        overlayController.show()
        print("✅ Overlay window force shown")
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
    
    // setupFloatingPanel method removed - replaced with OverlayWindowController
    
    @objc private func toggleHUD() {
        print("🖱️ Toggle HUD clicked!")
        
        // Handle debug window if it exists
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
        }
        
        // Handle overlay window
        overlayController.toggle()
    }
    
    private func cleanup() {
        print("🧹 Cleaning up...")
        
        // Clean up global hotkeys
        GlobalHotKey.cleanup()
        print("✅ Global hotkeys cleaned up")
        
        // Clean up status bar item
        if let statusItem = statusItem {
            NSStatusBar.system.removeStatusItem(statusItem)
            print("✅ Status bar item removed")
        }
        
        // Clean up debug window
        debugWindow?.close()
        print("✅ Debug window closed")
        
        // Clean up overlay window
        overlayController.hide()
        print("✅ Overlay window closed")
        
        print("✅ Cleanup complete")
    }
} 
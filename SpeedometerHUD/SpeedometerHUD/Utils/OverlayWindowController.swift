import Cocoa
import SwiftUI

final class OverlayWindowController: NSWindowController {
    private static let defaultSize = NSSize(width: 260, height: 140)
    
    init() {
        // Calculate center position on main screen
        let screenFrame = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 1920, height: 1080)
        let windowRect = NSRect(
            x: screenFrame.midX - Self.defaultSize.width / 2,
            y: screenFrame.midY - Self.defaultSize.height / 2,
            width: Self.defaultSize.width,
            height: Self.defaultSize.height
        )
        
        let w = NSWindow(contentRect: windowRect,
                         styleMask: [.borderless],
                         backing: .buffered,
                         defer: false)
        
        // Configure for persistent overlay behavior
        w.isOpaque = false
        w.backgroundColor = .clear
        w.level = .floating // App Store safe, above normal windows
        w.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        w.isMovableByWindowBackground = true
        w.hasShadow = true
        w.hidesOnDeactivate = false
        w.isReleasedWhenClosed = false
        w.styleMask.insert(.nonactivatingPanel)
        
        super.init(window: w)
        
        // Set up SwiftUI HUD content
        let hosting = NSHostingController(rootView: HUDView())
        self.contentViewController = hosting
        
        // Persist window position
        w.setFrameAutosaveName("HUDWindowFrame")
        
        print("🪟 OverlayWindowController created with centered window at: \(windowRect)")
    }
    
    required init?(coder: NSCoder) { 
        fatalError("init(coder:) has not been implemented") 
    }
    
    func toggle() {
        guard let w = window else { return }
        if w.isVisible { 
            w.orderOut(nil)
            print("👁️ Hiding overlay window")
        } else { 
            w.makeKeyAndOrderFront(nil)
            print("👁️ Showing overlay window")
        }
    }
    
    func show() {
        window?.makeKeyAndOrderFront(nil)
        print("👁️ Showing overlay window")
    }
    
    func hide() {
        window?.orderOut(nil)
        print("👁️ Hiding overlay window")
    }
} 
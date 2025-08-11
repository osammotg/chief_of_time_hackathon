import Cocoa
import SwiftUI

final class OverlayWindowController: NSWindowController {
    private static let defaultFrame = NSRect(x: 734, y: 510, width: 260, height: 140)
    
    init() {
        let w = NSWindow(contentRect: Self.defaultFrame,
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
        
        print("🪟 OverlayWindowController created with persistent window")
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
import Cocoa
import SwiftUI
import QuartzCore

class FloatingPanel: NSPanel {
    
    // Visual properties
    private var visualEffectView: NSVisualEffectView?
    
    // Drag properties
    private var isDragging = false
    private var dragStartPoint: NSPoint = .zero
    private var dragStartFrame: NSRect = .zero
    private var isSnapped = false
    
    var cornerRadius: CGFloat = 12.0 {
        didSet {
            updateCornerRadius()
        }
    }
    
    var shadowRadius: CGFloat = 8.0 {
        didSet {
            updateShadow()
        }
    }
    
    var shadowOpacity: Float = 0.3 {
        didSet {
            updateShadow()
        }
    }
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        configurePanel()
        setupSpaceChangeNotifications()
        setupMouseEventHandling()
    }
    
    private func configurePanel() {
        // Set window level for always-on-top behavior
        level = .screenSaver // Use screen saver level for maximum visibility
        print("🔍 Set window level to: \(level.rawValue)")
        
        // Configure collection behavior for all Spaces and full-screen
        configureCollectionBehavior()
        
        // Ensure panel stays on top of other windows
        isReleasedWhenClosed = false
        
        // Make panel borderless and transparent
        isOpaque = false
        backgroundColor = NSColor.clear
        hasShadow = true
        
        // Set panel properties
        isMovableByWindowBackground = true
        isFloatingPanel = true
        
        // Disable standard window features
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
        
        // Set title bar to be transparent
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        
        // Configure rounded corners and visual effects
        configureVisualEffects()
        
        // Set default position
        setDefaultPosition()
    }
    
    private func configureCollectionBehavior() {
        // Set collection behavior for all Spaces and full-screen
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        
        // Additional behaviors for better Space management
        collectionBehavior.insert(.stationary) // Keeps panel in place during Space transitions
        collectionBehavior.insert(.ignoresCycle) // Prevents panel from being cycled through with Tab key
    }
    
    private func configureVisualEffects() {
        // Create and configure NSVisualEffectView for glass morphism
        setupVisualEffectView()
        
        // Apply corner radius and shadow
        updateCornerRadius()
        updateShadow()
    }
    
    private func setupVisualEffectView() {
        // Create visual effect view with glass morphism
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = .hudWindow
        visualEffectView.state = .active
        visualEffectView.blendingMode = .behindWindow
        
        // Configure visual effect view properties
        visualEffectView.wantsLayer = true
        visualEffectView.layer?.cornerRadius = cornerRadius
        visualEffectView.layer?.masksToBounds = true
        
        // Set the visual effect view as the content view
        contentView = visualEffectView
        
        // Store reference for later updates
        self.visualEffectView = visualEffectView
    }
    
    override var canBecomeKey: Bool {
        return false
    }
    
    override var canBecomeMain: Bool {
        return false
    }
    
    // Method to ensure proper window level and behavior
    func ensureAlwaysOnTop() {
        // Set to screen saver level for maximum visibility
        if level != .screenSaver {
            level = .screenSaver
        }
        
        // Ensure collection behavior is correct
        configureCollectionBehavior()
    }
    
    private func setupSpaceChangeNotifications() {
        // Listen for Space changes to ensure panel remains visible
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSpaceChange),
            name: NSWorkspace.activeSpaceDidChangeNotification,
            object: nil
        )
        
        // Listen for display changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDisplayChange),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )
    }
    
    @objc private func handleSpaceChange() {
        // Ensure panel remains visible after Space change
        DispatchQueue.main.async { [weak self] in
            self?.ensureAlwaysOnTop()
        }
    }
    
    @objc private func handleDisplayChange() {
        // Handle display changes (e.g., external monitor connected/disconnected)
        DispatchQueue.main.async { [weak self] in
            self?.ensureAlwaysOnTop()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Mouse Event Handling
    
    private func setupMouseEventHandling() {
        // Override default window dragging with custom implementation
        isMovableByWindowBackground = false
    }
    
    override func mouseDown(with event: NSEvent) {
        dragStartPoint = event.locationInWindow
        dragStartFrame = frame
        isDragging = true
        
        // Track mouse events
        self.trackEvents(matching: [.leftMouseDragged, .leftMouseUp], timeout: NSEvent.foreverDuration, mode: .eventTracking, handler: { [weak self] event, stop in
            if let event = event {
                self?.handleMouseEvent(event, stop: stop)
            }
        })
    }
    
    private func handleMouseEvent(_ event: NSEvent, stop: UnsafeMutablePointer<ObjCBool>) {
        switch event.type {
        case .leftMouseDragged:
            handleMouseDragged(event)
        case .leftMouseUp:
            handleMouseUp(event)
            stop.pointee = true
        default:
            break
        }
    }
    
    private func handleMouseDragged(_ event: NSEvent) {
        guard isDragging else { return }
        
        let currentPoint = event.locationInWindow
        let deltaX = currentPoint.x - dragStartPoint.x
        let deltaY = currentPoint.y - dragStartPoint.y
        
        var newFrame = dragStartFrame
        newFrame.origin.x += deltaX
        newFrame.origin.y += deltaY
        
        // Constrain to screen bounds
        newFrame = constrainFrameToScreen(newFrame)
        
        // Apply edge snapping
        newFrame = applyEdgeSnapping(newFrame)
        
        setFrame(newFrame, display: true)
    }
    
    private func handleMouseUp(_ event: NSEvent) {
        isDragging = false
        isSnapped = false
        // Save position to preferences (will be implemented in task 7.0)
    }
    
    private func constrainFrameToScreen(_ frame: NSRect) -> NSRect {
        guard let screen = NSScreen.main else { return frame }
        
        var constrainedFrame = frame
        let screenFrame = screen.visibleFrame
        
        // Ensure window doesn't go off-screen
        if constrainedFrame.maxX > screenFrame.maxX {
            constrainedFrame.origin.x = screenFrame.maxX - constrainedFrame.width
        }
        if constrainedFrame.minX < screenFrame.minX {
            constrainedFrame.origin.x = screenFrame.minX
        }
        if constrainedFrame.maxY > screenFrame.maxY {
            constrainedFrame.origin.y = screenFrame.maxY - constrainedFrame.height
        }
        if constrainedFrame.minY < screenFrame.minY {
            constrainedFrame.origin.y = screenFrame.minY
        }
        
        return constrainedFrame
    }
    
    private func applyEdgeSnapping(_ frame: NSRect) -> NSRect {
        guard let screen = NSScreen.main else { return frame }
        
        var snappedFrame = frame
        let screenFrame = screen.visibleFrame
        let snapDistance: CGFloat = 10.0
        var wasSnapped = false
        
        // Snap to left edge
        if abs(frame.minX - screenFrame.minX) < snapDistance {
            snappedFrame.origin.x = screenFrame.minX
            wasSnapped = true
        }
        
        // Snap to right edge
        if abs(frame.maxX - screenFrame.maxX) < snapDistance {
            snappedFrame.origin.x = screenFrame.maxX - frame.width
            wasSnapped = true
        }
        
        // Snap to top edge
        if abs(frame.maxY - screenFrame.maxY) < snapDistance {
            snappedFrame.origin.y = screenFrame.maxY - frame.height
            wasSnapped = true
        }
        
        // Snap to bottom edge
        if abs(frame.minY - screenFrame.minY) < snapDistance {
            snappedFrame.origin.y = screenFrame.minY
            wasSnapped = true
        }
        
        // Update snap state and provide visual feedback
        updateSnapState(wasSnapped)
        
        return snappedFrame
    }
    
    private func updateSnapState(_ snapped: Bool) {
        if snapped != isSnapped {
            isSnapped = snapped
            
            // Visual feedback for snapping
            if snapped {
                // Add subtle animation or visual cue when snapped
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = 0.1
                    context.timingFunction = CAMediaTimingFunction(name: .easeOut)
                    
                    // Slightly increase shadow when snapped
                    visualEffectView?.layer?.shadowRadius = shadowRadius + 2.0
                }) {
                    // Restore normal shadow
                    self.visualEffectView?.layer?.shadowRadius = self.shadowRadius
                }
            }
        }
    }
    
    private func updateCornerRadius() {
        visualEffectView?.wantsLayer = true
        visualEffectView?.layer?.cornerRadius = cornerRadius
        visualEffectView?.layer?.masksToBounds = true
    }
    
    private func updateShadow() {
        visualEffectView?.wantsLayer = true
        visualEffectView?.layer?.shadowRadius = shadowRadius
        visualEffectView?.layer?.shadowOpacity = shadowOpacity
        visualEffectView?.layer?.shadowOffset = CGSize(width: 0, height: 2)
        visualEffectView?.layer?.shadowColor = NSColor.black.cgColor
    }
    
    // Method to update visual effect material (for light/dark mode support)
    func updateVisualEffectMaterial() {
        visualEffectView?.material = .hudWindow
        visualEffectView?.state = .active
    }
    
    // Public method to check if panel is currently snapped to an edge
    var isCurrentlySnapped: Bool {
        return isSnapped
    }
    
    // Method to get the snap distance
    var snapDistance: CGFloat {
        return 10.0
    }
    
    // MARK: - Window Positioning
    
    func setDefaultPosition() {
        let defaultFrame = calculateDefaultFrame()
        print("📍 Setting default position: \(defaultFrame)")
        setFrame(defaultFrame, display: false)
    }
    
    private func calculateDefaultFrame() -> NSRect {
        guard let screen = NSScreen.main else {
            print("⚠️ No main screen found, using fallback position")
            // Fallback to a reasonable default if no screen is available
            return NSRect(x: 100, y: 100, width: 260, height: 140)
        }
        
        let screenFrame = screen.visibleFrame
        print("🖥️ Screen visible frame: \(screenFrame)")
        
        let margin: CGFloat = 16.0
        let defaultWidth: CGFloat = 260.0
        let defaultHeight: CGFloat = 140.0
        
        // For debugging, position in center of screen
        let centerX = screenFrame.midX - defaultWidth / 2
        let centerY = screenFrame.midY - defaultHeight / 2
        
        print("📍 Center position: (\(centerX), \(centerY))")
        
        // Use center position for now
        let x = centerX
        let y = centerY
        
        let frame = NSRect(x: x, y: y, width: defaultWidth, height: defaultHeight)
        print("📍 Calculated frame: \(frame)")
        
        return frame
    }
    
    // Public method to reposition to default location
    func repositionToDefault() {
        let defaultFrame = calculateDefaultFrame()
        setFrame(defaultFrame, display: true, animate: true)
    }
    
    // Method to position on specific screen
    func positionOnScreen(_ screen: NSScreen) {
        let screenFrame = screen.visibleFrame
        let margin: CGFloat = 16.0
        let currentSize = frame.size
        
        // Position in top-right corner of the specified screen
        let x = screenFrame.maxX - currentSize.width - margin
        let y = screenFrame.maxY - currentSize.height - margin
        
        let newFrame = NSRect(x: x, y: y, width: currentSize.width, height: currentSize.height)
        setFrame(newFrame, display: true, animate: true)
    }
    
    // Method to get current position relative to screen
    func getCurrentPosition() -> (x: CGFloat, y: CGFloat) {
        guard let screen = NSScreen.main else { return (0, 0) }
        
        let screenFrame = screen.visibleFrame
        let relativeX = (frame.origin.x - screenFrame.origin.x) / screenFrame.width
        let relativeY = (frame.origin.y - screenFrame.origin.y) / screenFrame.height
        
        return (relativeX, relativeY)
    }
} 
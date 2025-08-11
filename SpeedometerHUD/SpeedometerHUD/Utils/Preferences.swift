import Foundation

class Preferences: ObservableObject {
    static let shared = Preferences()
    
    @Published var windowPosition: CGPoint = CGPoint(x: 0, y: 0)
    @Published var isCompactMode: Bool = true
    
    private init() {
        // Load preferences from UserDefaults
    }
} 
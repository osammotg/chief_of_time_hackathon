import Foundation

struct TaskItem: Identifiable, Codable {
    let id: String
    var title: String
    var start: String?
    var end: String?
    var unitsTarget: Int
    var unitsDone: Int
    var status: String
    var isMeeting: Bool
}

class TaskManager: ObservableObject {
    @Published var completedUnits: Int = 3 // Demo: 3/5 units
    @Published var targetUnits: Int = 5
    @Published var elapsedTime: TimeInterval = 0
    
    init() {
        // Initialize with demo values
    }
    
    func increment() {
        if completedUnits < targetUnits {
            completedUnits += 1
        }
    }
    
    func finish() {
        completedUnits = targetUnits
    }
    
    var progress: Double {
        guard targetUnits > 0 else { return 0.0 }
        return Double(completedUnits) / Double(targetUnits)
    }
} 
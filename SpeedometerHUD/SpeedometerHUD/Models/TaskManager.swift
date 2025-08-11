import Foundation

class TaskManager: ObservableObject {
    @Published var completedUnits: Int = 0
    @Published var targetUnits: Int = 10
    @Published var elapsedTime: TimeInterval = 0
    
    init() {
        // Initialize with demo values
    }
} 
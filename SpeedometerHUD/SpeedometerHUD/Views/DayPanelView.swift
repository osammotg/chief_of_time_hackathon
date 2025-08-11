import SwiftUI

struct DayPanelView: View {
    @StateObject private var taskManager = TaskManager()
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text("Today's Plan")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
                Button("▼") {
                    // TODO: Collapse back to compact
                }
                .buttonStyle(ActionButtonStyle())
                
                // Action buttons for current task
                HStack(spacing: 8) {
                    Button("+1") {
                        // TODO: Wire to TaskManager.increment()
                    }
                    .buttonStyle(ActionButtonStyle())
                    
                    Button("Finish") {
                        // TODO: Wire to TaskManager.finish()
                    }
                    .buttonStyle(ActionButtonStyle())
                    
                    Button("📸") {
                        // TODO: Screenshot stub
                    }
                    .buttonStyle(ActionButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            // Today's Plan table
            VStack(alignment: .leading, spacing: 8) {
                // Table header
                HStack {
                    Text("Time")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.7))
                        .frame(width: 60, alignment: .leading)
                    
                    Text("Task")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Status")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.7))
                        .frame(width: 60, alignment: .trailing)
                }
                .padding(.horizontal, 16)
                
                                // Scrollable table content
                ScrollView {
                    VStack(spacing: 4) {
                        // Tasks sorted by time (CEO-clean schedule)
                        ForEach(getSortedTasks(), id: \.id) { task in
                            HStack {
                                Text(task.start ?? "—")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                    .frame(width: 60, alignment: .leading)
                                
                                HStack(spacing: 4) {
                                    if task.isMeeting {
                                        Text("📅")
                                            .font(.caption)
                                    }
                                    Text(task.title)
                                        .font(.caption)
                                        .foregroundColor(getTaskColor(task))
                                        .strikethrough(task.status == "done")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(task.status)
                                    .font(.caption)
                                    .foregroundColor(getStatusColor(task.status))
                                    .frame(width: 60, alignment: .trailing)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
                .frame(maxHeight: 200) // Limit height for scrolling
            }
            
            Spacer()
            
            // Current task section
            VStack(alignment: .leading, spacing: 12) {
                Text("Current Task")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                
                // Task title
                Text("Deep Work: Build Inline AI Assist")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                
                // Progress loader
                ProgressLoader(progress: 0.6, colorState: .green)
                    .padding(.horizontal, 16)
                
                // Task details
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Progress")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                        Text("3 / 5 units")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 4) {
                        Text("Time left")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                        Text("08:45")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("ETA")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                        Text("06:30")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 16)
                
                // Pace verdict
                HStack {
                    Spacer()
                    Text("On track")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            
            // Stats section
            VStack(alignment: .leading, spacing: 12) {
                Text("Stats")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                
                // Stats grid
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Tasks")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                        Text("1 / 5 done")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 4) {
                        Text("Day")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                        Text("20% complete")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Meetings")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                        Text("2 scheduled")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            // Glass morphism effect with transparency
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .opacity(0.95)
        )
        .overlay(
            // Subtle border for definition
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
        )
    }
    
    // MARK: - Helper Functions
    
    private func getSortedTasks() -> [TaskItem] {
        return getDemoTasks().sorted { task1, task2 in
            let time1 = parseTime(task1.start ?? "00:00")
            let time2 = parseTime(task2.start ?? "00:00")
            return time1 < time2
        }
    }
    
    private func parseTime(_ timeString: String) -> Int {
        let components = timeString.split(separator: ":")
        guard components.count == 2,
              let hours = Int(components[0]),
              let minutes = Int(components[1]) else {
            return 0
        }
        return hours * 60 + minutes
    }
    
    private func getTaskColor(_ task: TaskItem) -> Color {
        switch task.status {
        case "done":
            return .green
        case "missed":
            return .white.opacity(0.5)
        default:
            return task.isMeeting ? .white.opacity(0.6) : .white.opacity(0.8)
        }
    }
    
    private func getStatusColor(_ status: String) -> Color {
        switch status {
        case "done":
            return .green
        case "missed":
            return .red
        case "meeting":
            return .white.opacity(0.6)
        default:
            return .white.opacity(0.8)
        }
    }
    
    private func getDemoTasks() -> [TaskItem] {
        return [
            TaskItem(id: "standup", title: "Daily Standup (team)", start: "08:30", end: "08:45", unitsTarget: 1, unitsDone: 1, status: "done", isMeeting: true),
            TaskItem(id: "recruit_outbound", title: "Recruiting: Outbound Reach-outs (15)", start: "08:45", end: "09:15", unitsTarget: 15, unitsDone: 0, status: "meeting", isMeeting: true),
            TaskItem(id: "build_inline_ai_assist", title: "Deep Work: Build Inline AI Assist", start: "09:15", end: "11:15", unitsTarget: 8, unitsDone: 3, status: "todo", isMeeting: false),
            TaskItem(id: "client_demo", title: "Client Demo (Acme)", start: "13:00", end: "13:45", unitsTarget: 1, unitsDone: 0, status: "missed", isMeeting: true),
            TaskItem(id: "ship_release", title: "Ship: Finalize PR & Release Notes", start: "15:00", end: "16:00", unitsTarget: 4, unitsDone: 0, status: "todo", isMeeting: false)
        ]
    }
}

#Preview {
    DayPanelView()
        .frame(width: 400, height: 600)
        .background(Color.black)
} 
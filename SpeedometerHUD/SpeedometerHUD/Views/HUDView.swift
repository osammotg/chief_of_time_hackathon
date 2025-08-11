import SwiftUI

struct CompactFrameModifier: ViewModifier {
    let isExpanded: Bool
    
    func body(content: Content) -> some View {
        if isExpanded {
            content // No frame constraints when expanded
        } else {
            content.frame(width: 260, height: 140) // Only constrain when compact
        }
    }
}

struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white.opacity(configuration.isPressed ? 0.3 : 0.2))
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct HUDView: View {
    @StateObject private var taskManager = TaskManager()
    @State private var colorState: ProgressLoader.ColorState = .green
    @State private var isExpanded: Bool = false
    
    // Callback for window size changes
    let onExpandToggle: ((Bool) -> Void)?
    
    init(onExpandToggle: ((Bool) -> Void)? = nil) {
        self.onExpandToggle = onExpandToggle
    }
    
    // Check if Reduce Motion is enabled
    private var accessibilityReduceMotion: Bool {
        NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
    }
    
    var body: some View {
        VStack(spacing: 8) {
            if isExpanded {
                DayPanelView()
                    .background(Color.red.opacity(0.1)) // Debug: see if content is tiny
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
            } else {
            // Header with green status dot and "Reminder" label
            HStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                Text("Reminder")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.8))
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            // Task title (hard-coded for now)
            Text("Complete project documentation")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            
            // Progress loader
            ProgressLoader(progress: taskManager.progress, colorState: colorState)
                .padding(.horizontal, 16)
            
            // Action buttons
            HStack(spacing: 12) {
                Button("+1") {
                    taskManager.increment()
                }
                .buttonStyle(ActionButtonStyle())
                
                Button("Finish") {
                    taskManager.finish()
                }
                .buttonStyle(ActionButtonStyle())
                
                Button("📸") {
                    // TODO: Screenshot stub
                }
                .buttonStyle(ActionButtonStyle())
                
                Spacer()
                
                Button(isExpanded ? "▼" : "▲") {
                    print("🔍 Button clicked, isExpanded before:", isExpanded)
                    isExpanded.toggle()
                    print("🔍 Button clicked, isExpanded after:", isExpanded)
                    onExpandToggle?(isExpanded)
                }
                .buttonStyle(ActionButtonStyle())
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            // Progress stats and timer
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Time left")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                    Text("08:45")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 4) {
                    Text("ETA")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                    Text("06:30")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Pace")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                    Text("On track")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            .transition(.asymmetric(
                insertion: .move(edge: .top).combined(with: .opacity),
                removal: .move(edge: .top).combined(with: .opacity)
            ))
            }
        }
        .animation(
            .easeInOut(duration: 0.18)
            .speed(accessibilityReduceMotion ? 0.5 : 1.0),
            value: isExpanded
        )
        .modifier(CompactFrameModifier(isExpanded: isExpanded))
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
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    HUDView()
        .background(Color.black)
} 
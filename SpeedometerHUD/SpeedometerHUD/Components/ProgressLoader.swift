import SwiftUI

struct ProgressLoader: View {
    let progress: Double // 0.0 to 1.0
    let colorState: ColorState
    
    enum ColorState {
        case green, yellow, red
        
        var color: Color {
            switch self {
            case .green:
                return Color(red: 0.29, green: 0.87, blue: 0.50) // #4ADE80
            case .yellow:
                return Color(red: 0.98, green: 0.80, blue: 0.08) // #FACC15
            case .red:
                return Color(red: 0.97, green: 0.44, blue: 0.44) // #F87171
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 12)
                
                // Progress fill
                RoundedRectangle(cornerRadius: 6)
                    .fill(colorState.color)
                    .frame(width: geometry.size.width * progress, height: 12)
                    .animation(
                        .easeInOut(duration: 0.18)
                        .speed(accessibilityReduceMotion ? 0.5 : 1.0),
                        value: progress
                    )
                    .animation(
                        .easeInOut(duration: 0.15)
                        .speed(accessibilityReduceMotion ? 0.5 : 1.0),
                        value: colorState
                    )
                    .scaleEffect(colorState == .red && !accessibilityReduceMotion ? 1.02 : 1.0)
                    .animation(
                        .easeInOut(duration: 0.15)
                        .speed(accessibilityReduceMotion ? 0.5 : 1.0),
                        value: colorState
                    )
            }
        }
        .frame(height: 12)
        .accessibilityLabel("Progress indicator")
        .accessibilityValue("\(Int(progress * 100))% complete")
        .accessibilityAddTraits(.updatesFrequently)
    }
    
    // Check if Reduce Motion is enabled
    private var accessibilityReduceMotion: Bool {
        NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
    }
}

#Preview {
    VStack(spacing: 20) {
        // Demo progress states with different color states
        VStack(alignment: .leading, spacing: 8) {
            Text("Demo Progress States").font(.headline).foregroundColor(.white)
            ProgressLoader(progress: 0.0, colorState: .green)
            ProgressLoader(progress: 0.25, colorState: .yellow)
            ProgressLoader(progress: 0.5, colorState: .red)
            ProgressLoader(progress: 0.75, colorState: .green)
            ProgressLoader(progress: 1.0, colorState: .green)
        }
        
        // Demo with consistent progress but different colors
        VStack(alignment: .leading, spacing: 8) {
            Text("Color State Demo (50% progress)").font(.headline).foregroundColor(.white)
            ProgressLoader(progress: 0.5, colorState: .green)
            ProgressLoader(progress: 0.5, colorState: .yellow)
            ProgressLoader(progress: 0.5, colorState: .red)
        }
    }
    .padding()
    .background(Color.black)
} 
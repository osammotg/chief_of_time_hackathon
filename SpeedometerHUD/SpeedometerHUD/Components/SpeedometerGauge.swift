import SwiftUI

struct SpeedometerGauge: View {
    var progress: Double = 0.0
    
    var body: some View {
        VStack {
            Text("Speedometer Gauge")
                .padding()
        }
    }
}

#Preview {
    SpeedometerGauge(progress: 0.5)
} 
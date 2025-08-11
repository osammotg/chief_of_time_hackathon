import SwiftUI

struct HUDView: View {
    var body: some View {
        VStack {
            Text("HUD View")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
        }
        .frame(width: 260, height: 140)
        .background(Color.red.opacity(0.9)) // Bright red for maximum visibility
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white, lineWidth: 3)
        )
    }
}

#Preview {
    HUDView()
} 
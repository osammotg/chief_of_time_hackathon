import SwiftUI

struct HUDView: View {
    var body: some View {
        VStack(spacing: 8) {
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
            
            Spacer()
            
            // Progress stats and timer
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
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Time")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.7))
                    Text("12:34")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .frame(width: 260, height: 140)
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
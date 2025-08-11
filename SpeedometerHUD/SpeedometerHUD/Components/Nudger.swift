import SwiftUI

struct Nudger: View {
    var message: String = ""
    var isVisible: Bool = false
    
    var body: some View {
        VStack {
            Text("Nudger Component")
                .padding()
        }
    }
}

#Preview {
    Nudger(message: "Test message", isVisible: true)
} 
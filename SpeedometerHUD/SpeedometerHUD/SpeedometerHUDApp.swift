import SwiftUI

@main
struct SpeedometerHUDApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("SpeedometerHUD")
            .padding()
    }
}

#Preview {
    ContentView()
} 
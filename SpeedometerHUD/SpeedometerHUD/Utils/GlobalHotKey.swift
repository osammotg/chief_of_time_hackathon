import Foundation

enum KeyModifier { 
    case command, option, control, shift 
}

enum GlobalHotKey {
    // Replace with actual library implementation if available in the project.
    static func register(key: Character, modifiers: [KeyModifier], handler: @escaping () -> Void) {
        // TODO: Integrate SPM package 'HotKey' (Sindre Sorhus) or 'MASShortcut'.
        // If an existing hotkey utility is present in the project, call into it here.
        // Leave empty to avoid build errors.
        print("⌨️ Global hotkey registration (stub): \(key) with modifiers \(modifiers)")
    }
} 
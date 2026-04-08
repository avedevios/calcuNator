import SwiftUI

// Typed button model instead of raw strings.
// Each case is a specific button, eliminating typos and fragile string comparisons.
enum CalcButton: Hashable {
    case digit(String)     // "0"–"9"
    case dot
    case operation(String) // "+", "-", "×", "÷"
    case trig(String)      // "sin", "cos", "tan"
    case equals
    case clear

    var label: String {
        switch self {
        case .digit(let d):     return d
        case .dot:              return "."
        case .operation(let o): return o
        case .trig(let t):      return t
        case .equals:           return "="
        case .clear:            return "C"
        }
    }

    var color: Color {
        switch self {
        case .operation, .equals: return .orange
        case .trig:               return .gray.opacity(0.5)
        default:                  return .gray.opacity(0.2)
        }
    }

    // Haptic feedback belongs to the button, not the View
    func triggerHaptic() {
        switch self {
        case .digit, .dot:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .operation, .trig:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .equals:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .clear:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        }
    }
}

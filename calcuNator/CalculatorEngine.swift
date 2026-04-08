import Foundation

// Pure business logic layer.
// No SwiftUI dependencies — fully testable in isolation.
// CalculatorFramework (ObjC) is isolated here and not exposed to the ViewModel.
class CalculatorEngine {

    private let framework = CalculatorFramework()

    // MARK: - Arithmetic

    func evaluate(first: Double, operation: String, second: Double) -> Double {
        framework.inputNumber(first)
        framework.setOperation(operation)
        framework.inputNumber(second)
        let result = framework.calculate()
        framework.clear()
        return result
    }

    // MARK: - Trigonometry (input in degrees)

    func trig(_ fn: String, degrees: Double) -> Double {
        let radians = degrees * .pi / 180
        switch fn {
        case "sin": return sin(radians)
        case "cos": return cos(radians)
        case "tan": return tan(radians)
        default:    return .nan
        }
    }

    // MARK: - Formatting

    func format(_ value: Double) -> String {
        if value.isNaN || value.isInfinite { return "Error" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 10
        formatter.minimumFractionDigits = 0
        formatter.usesGroupingSeparator = false
        formatter.notANumberSymbol = "Error"
        formatter.positiveInfinitySymbol = "Error"
        formatter.negativeInfinitySymbol = "Error"
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

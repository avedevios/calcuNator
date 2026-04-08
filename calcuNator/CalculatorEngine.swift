import Foundation

// Pure business logic layer.
// No SwiftUI dependencies — fully testable in isolation.
// CalculatorFramework (ObjC) is isolated here and not exposed to the ViewModel.
class CalculatorEngine {

    private let framework = CalculatorFramework()

    // Created once and reused — NumberFormatter is expensive to instantiate
    private lazy var formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 10
        f.minimumFractionDigits = 0
        f.usesGroupingSeparator = false
        f.notANumberSymbol = "Error"
        f.positiveInfinitySymbol = "Error"
        f.negativeInfinitySymbol = "Error"
        return f
    }()

    // MARK: - Arithmetic

    func evaluate(first: Double, operation: String, second: Double) -> Double {
        framework.inputNumber(first)
        framework.setOperation(operation)
        framework.inputNumber(second)
        let result = framework.calculate()
        framework.clear()
        return result
    }

    // MARK: - Trigonometry (input in degrees, conversion handled in ObjC)

    func trig(_ fn: String, degrees: Double) -> Double {
        framework.inputNumber(degrees)
        framework.setTrigFunction(fn)
        let result = framework.calculateTrigonometric()
        framework.clear()
        return result
    }

    // MARK: - Formatting

    func format(_ value: Double) -> String {
        if value.isNaN || value.isInfinite { return "Error" }
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

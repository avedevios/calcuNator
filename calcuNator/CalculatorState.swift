import Foundation

// Encapsulates all mutable calculator state in one place.
// Easier to reason about, reset, and test than scattered private vars.
struct CalculatorState {
    var firstNumber: Double? = nil
    var operation: String? = nil
    var isTypingNumber = false
    var operationCompleted = false
    var pointUsed = false
    var operationUsed = false

    mutating func reset() {
        firstNumber = nil
        operation = nil
        isTypingNumber = false
        operationCompleted = false
        pointUsed = false
        operationUsed = false
    }
}

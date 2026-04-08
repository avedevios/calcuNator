import Foundation

// Thin mediator between CalculatorEngine and CalculatorView.
// Owns UI state and translates button presses into engine calls.
class CalculatorViewModel: ObservableObject {
    @Published var display = "0"
    @Published var operationDisplay = ""
    @Published var showOperationDisplay = false

    private let engine = CalculatorEngine()

    private var firstNumber: Double? = nil
    private var operation: String? = nil
    private var isTypingNumber = false
    private var operationCompleted = false
    private var pointUsed = false
    private var operationUsed = false

    // MARK: - Input Handling

    func handle(_ button: CalcButton) {
        if operationCompleted && button != .equals && button != .clear {
            display = ""
            operationDisplay = ""
            showOperationDisplay = false
            operationCompleted = false
        }

        switch button {
        case .digit(let d):
            if isTypingNumber {
                // Prevent leading zeros: "0" + "5" → "5", not "05"
                if display == "0" && d != "." {
                    display = d
                    operationDisplay = d
                } else {
                    display += d
                    operationDisplay += d
                }
            } else {
                if operation != nil {
                    display += d
                    operationDisplay += d
                } else {
                    display = d
                    operationDisplay = operationDisplay.isEmpty ? d : operationDisplay + d
                }
                isTypingNumber = true
            }

        case .dot:
            if !pointUsed {
                display += "."
                operationDisplay += "."
                pointUsed = true
            }

        case .operation(let op):
            // Allow if currently typing a number OR if operator was already chosen (to replace it)
            if !isTypingNumber && !operationUsed { return }
            let base = display.split(separator: " ").first.map(String.init) ?? display
            firstNumber = Double(base) ?? firstNumber
            operation = op
            // Replace operator in display if one was already chosen
            display = base + " " + op + " "
            operationDisplay = display
            isTypingNumber = false
            showOperationDisplay = false
            pointUsed = false
            operationUsed = true

        case .trig(let fn):
            guard let number = Double(display) else { return }
            let result = engine.trig(fn, degrees: number)
            display = engine.format(result)
            operationDisplay = fn + "(" + engine.format(number) + "°)"
            operationCompleted = true
            showOperationDisplay = true

        case .equals:
            guard let firstNumber = firstNumber,
                  let operation = operation,
                  let secondNumber = Double(display.split(separator: " ").last ?? "") else {
                isTypingNumber = false
                return
            }
            let result = engine.evaluate(first: firstNumber, operation: operation, second: secondNumber)
            display = engine.format(result)
            operationCompleted = true
            showOperationDisplay = true
            pointUsed = false
            operationUsed = false
            isTypingNumber = false

        case .clear:
            display = "0"
            operationDisplay = ""
            firstNumber = nil
            operation = nil
            isTypingNumber = false
            operationCompleted = false
            showOperationDisplay = false
            pointUsed = false
            operationUsed = false
        }
    }
}

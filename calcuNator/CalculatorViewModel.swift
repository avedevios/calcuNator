import Foundation

// Thin mediator between CalculatorEngine and CalculatorView.
// Owns UI state and translates button presses into engine calls.
class CalculatorViewModel: ObservableObject {
    @Published var display = "0"
    @Published var operationDisplay = ""
    @Published var showOperationDisplay = false

    private let engine = CalculatorEngine()
    private var state = CalculatorState()

    // MARK: - Input Handling

    func handle(_ button: CalcButton) {
        if state.operationCompleted && button != .equals && button != .clear {
            // Capture result as firstNumber before reset if chaining with an operation
            if case .operation = button {
                state.firstNumber = Double(display)
            }
            display = ""
            operationDisplay = ""
            showOperationDisplay = false
            state.operationCompleted = false
        }

        switch button {
        case .digit(let d):
            appendDigit(d)

        case .dot:
            appendDot()

        case .operation(let op):
            applyOperation(op)

        case .trig(let fn):
            applyTrig(fn)

        case .equals:
            applyEquals()

        case .clear:
            applyClear()
        }
    }

    // MARK: - Private Handlers

    private func appendDigit(_ d: String) {
        if state.isTypingNumber {
            // Prevent leading zeros: "0" + "5" → "5", not "05"
            if display == "0" {
                display = d
                operationDisplay = d
            } else {
                display += d
                operationDisplay += d
            }
        } else {
            if state.operation != nil {
                display += d
                operationDisplay += d
            } else {
                display = d
                operationDisplay = operationDisplay.isEmpty ? d : operationDisplay + d
            }
            state.isTypingNumber = true
        }
    }

    private func appendDot() {
        if !state.pointUsed {
            display += "."
            operationDisplay += "."
            state.pointUsed = true
        }
    }

    private func applyOperation(_ op: String) {
        if !state.isTypingNumber && !state.operationUsed && state.firstNumber == nil { return }
        // Only update firstNumber from display if not already captured from a previous result
        if state.isTypingNumber || state.operationUsed {
            let base = display.split(separator: " ").first.map(String.init) ?? display
            state.firstNumber = Double(base) ?? state.firstNumber
        }
        state.operation = op
        let displayBase = engine.format(state.firstNumber ?? 0)
        display = displayBase + " " + op + " "
        operationDisplay = display
        state.isTypingNumber = false
        showOperationDisplay = false
        state.pointUsed = false
        state.operationUsed = true
    }

    private func applyTrig(_ fn: String) {
        guard let number = Double(display) else { return }
        let result = engine.trig(fn, degrees: number)
        display = engine.format(result)
        operationDisplay = fn + "(" + engine.format(number) + "°)"
        state.operationCompleted = true
        showOperationDisplay = true
    }

    private func applyEquals() {
        guard let firstNumber = state.firstNumber,
              let operation = state.operation,
              let secondNumber = Double(display.split(separator: " ").last ?? "") else {
            state.isTypingNumber = false
            return
        }
        let result = engine.evaluate(first: firstNumber, operation: operation, second: secondNumber)
        display = engine.format(result)
        state.operationCompleted = true
        showOperationDisplay = true
        state.pointUsed = false
        state.operationUsed = false
        state.isTypingNumber = false
    }

    private func applyClear() {
        display = "0"
        operationDisplay = ""
        showOperationDisplay = false
        state.reset()
    }
}

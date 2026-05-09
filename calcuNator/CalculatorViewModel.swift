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
            let result = Double(display)
            state.reset()
            operationDisplay = ""
            showOperationDisplay = false

            if case .operation = button {
                state.firstNumber = result
                display = engine.format(result ?? 0)
            } else {
                display = "0"
            }
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
        guard display != "Error" else { return }

        if let pendingOperation = state.operation,
           let firstNumber = state.firstNumber {
            if state.isTypingNumber {
                guard let secondNumber = currentInputNumber() else { return }
                let result = engine.evaluate(first: firstNumber, operation: pendingOperation, second: secondNumber)
                state.firstNumber = result
                display = engine.format(result)
            }
            // If the user taps operators back-to-back, Apple Calculator replaces the pending operator.
        } else if let number = currentInputNumber() {
            state.firstNumber = number
        } else {
            return
        }

        state.operation = op
        let displayBase = engine.format(state.firstNumber ?? 0)
        display = displayBase + " " + op + " "
        operationDisplay = display
        state.isTypingNumber = false
        showOperationDisplay = false
        state.pointUsed = false
        state.operationUsed = true
        state.operationCompleted = false
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
              let secondNumber = currentInputNumber() else {
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

    private func currentInputNumber() -> Double? {
        if let lastToken = display.split(separator: " ").last {
            return Double(lastToken)
        }
        return Double(display)
    }
}

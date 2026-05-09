//
//  calcuNatorTests.swift
//  calcuNatorTests
//
//  Created by Anton Averianov on 2026-04-07.
//

import Testing
@testable import calcuNator

// MARK: - CalculatorEngine Tests

struct CalculatorEngineTests {

    let engine = CalculatorEngine()

    // MARK: Arithmetic

    @Test func addition() {
        let result = engine.evaluate(first: 3, operation: "+", second: 5)
        #expect(result == 8)
    }

    @Test func subtraction() {
        let result = engine.evaluate(first: 10, operation: "-", second: 4)
        #expect(result == 6)
    }

    @Test func multiplication() {
        let result = engine.evaluate(first: 6, operation: "×", second: 7)
        #expect(result == 42)
    }

    @Test func division() {
        let result = engine.evaluate(first: 10, operation: "÷", second: 2)
        #expect(result == 5)
    }

    @Test func divisionByZero() {
        let result = engine.evaluate(first: 5, operation: "÷", second: 0)
        #expect(result.isNaN)
    }

    // MARK: Trigonometry (degrees)

    @Test func sinOf90() {
        let result = engine.trig("sin", degrees: 90)
        #expect(abs(result - 1.0) < 0.0001)
    }

    @Test func cosOf0() {
        let result = engine.trig("cos", degrees: 0)
        #expect(abs(result - 1.0) < 0.0001)
    }

    @Test func tanOf45() {
        let result = engine.trig("tan", degrees: 45)
        #expect(abs(result - 1.0) < 0.0001)
    }

    @Test func sinOf0() {
        let result = engine.trig("sin", degrees: 0)
        #expect(abs(result) < 0.0001)
    }

    // MARK: Formatting

    @Test func formatInteger() {
        #expect(engine.format(42) == "42")
    }

    @Test func formatDecimal() {
        #expect(engine.format(3.14) == "3.14")
    }

    @Test func formatNaN() {
        #expect(engine.format(.nan) == "Error")
    }

    @Test func formatInfinity() {
        #expect(engine.format(.infinity) == "Error")
    }

    @Test func formatNoScientificNotation() {
        // %g would give "1e+10", NumberFormatter should give "10000000000"
        #expect(engine.format(10_000_000_000) == "10000000000")
    }

    @Test func negativeResult() {
        let result = engine.evaluate(first: 5, operation: "-", second: 10)
        #expect(result == -5)
    }

    @Test func decimalArithmetic() {
        let result = engine.evaluate(first: 0.1, operation: "+", second: 0.2)
        #expect(abs(result - 0.3) < 0.0001)
    }

    @Test func unknownOperationReturnsNaN() {
        let result = engine.evaluate(first: 5, operation: "%", second: 2)
        #expect(result.isNaN)
    }

    @Test func formatNegativeNumber() {
        #expect(engine.format(-42) == "-42")
    }

    @Test func formatZero() {
        #expect(engine.format(0) == "0")
    }

    @Test func cos90IsNearZero() {
        let result = engine.trig("cos", degrees: 90)
        #expect(abs(result) < 0.0001)
    }

    @Test func tan90IsLarge() {
        let result = engine.trig("tan", degrees: 90)
        #expect(result.isInfinite || abs(result) > 1_000_000)
    }

    @Test func sinNegative90() {
        let result = engine.trig("sin", degrees: -90)
        #expect(abs(result - (-1.0)) < 0.0001)
    }

    @Test func multiplyByZero() {
        let result = engine.evaluate(first: 5, operation: "×", second: 0)
        #expect(result == 0)
    }

    @Test func multiplyNegatives() {
        let result = engine.evaluate(first: -3, operation: "×", second: -4)
        #expect(result == 12)
    }

    @Test func verySmallDecimal() {
        let result = engine.evaluate(first: 0.0000001, operation: "+", second: 0.0000002)
        #expect(abs(result - 0.0000003) < 0.00000001)
    }
}

// MARK: - CalculatorViewModel Tests

@MainActor
struct CalculatorViewModelTests {

    @Test func initialDisplay() {
        let vm = CalculatorViewModel()
        #expect(vm.display == "0")
    }

    @Test func digitInput() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("5"))
        #expect(vm.display == "5")
    }

    @Test func multipleDigits() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("1"))
        vm.handle(.digit("2"))
        vm.handle(.digit("3"))
        #expect(vm.display == "123")
    }

    @Test func leadingZeroPrevented() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("0"))
        vm.handle(.digit("0"))
        vm.handle(.digit("5"))
        #expect(vm.display == "5")
    }

    @Test func clearResetsDisplay() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("9"))
        vm.handle(.clear)
        #expect(vm.display == "0")
    }

    @Test func operatorReplacement() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("5"))
        vm.handle(.operation("+"))
        vm.handle(.operation("-"))
        #expect(vm.display == "5 - ")
    }

    @Test func basicCalculation() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("4"))
        vm.handle(.operation("+"))
        vm.handle(.digit("3"))
        vm.handle(.equals)
        #expect(vm.display == "7")
    }

    @Test func divisionByZeroShowsError() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("5"))
        vm.handle(.operation("÷"))
        vm.handle(.digit("0"))
        vm.handle(.equals)
        #expect(vm.display == "Error")
    }

    @Test func dotInput() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("0"))
        vm.handle(.dot)
        vm.handle(.digit("5"))
        #expect(vm.display == "0.5")
    }

    @Test func doubleDotIgnored() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("5"))
        vm.handle(.dot)
        vm.handle(.dot)
        vm.handle(.digit("3"))
        #expect(vm.display == "5.3")
    }

    @Test func trigSin90() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("9"))
        vm.handle(.digit("0"))
        vm.handle(.trig("sin"))
        #expect(vm.display == "1")
    }

    @Test func newInputAfterEqualsResetsDisplay() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("4"))
        vm.handle(.operation("+"))
        vm.handle(.digit("3"))
        vm.handle(.equals)
        vm.handle(.digit("5"))
        #expect(vm.display == "5")
    }

    @Test func operationDisplayShownAfterEquals() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("4"))
        vm.handle(.operation("+"))
        vm.handle(.digit("3"))
        vm.handle(.equals)
        #expect(vm.showOperationDisplay == true)
    }

    @Test func operationDisplayHiddenInitially() {
        let vm = CalculatorViewModel()
        #expect(vm.showOperationDisplay == false)
    }

    @Test func chainedCalculation() {
        let vm = CalculatorViewModel()
        // 2 + 3 = 5, then 5 × 4 = 20
        vm.handle(.digit("2"))
        vm.handle(.operation("+"))
        vm.handle(.digit("3"))
        vm.handle(.equals)
        vm.handle(.operation("×"))
        vm.handle(.digit("4"))
        vm.handle(.equals)
        #expect(vm.display == "20")
    }

    @Test func consecutiveOperationsEvaluatePreviousOperation() {
        let vm = CalculatorViewModel()
        // Apple Calculator basic mode evaluates pending binary operations as the next operator is pressed.
        vm.handle(.digit("2"))
        vm.handle(.operation("+"))
        vm.handle(.digit("3"))
        vm.handle(.operation("×"))
        vm.handle(.digit("4"))
        vm.handle(.equals)
        #expect(vm.display == "20")
    }

    @Test func multipleConsecutiveOperationsWithoutEquals() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("2"))
        vm.handle(.operation("+"))
        vm.handle(.digit("3"))
        vm.handle(.operation("+"))
        vm.handle(.digit("4"))
        vm.handle(.operation("+"))
        vm.handle(.digit("5"))
        vm.handle(.equals)
        #expect(vm.display == "14")
    }

    @Test func equalsWithoutOperationDoesNotCrash() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("5"))
        vm.handle(.equals)
        #expect(vm.display == "5")
    }

    @Test func equalsWithoutSecondNumberDoesNotCrash() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("5"))
        vm.handle(.operation("+"))
        vm.handle(.equals)
        #expect(vm.display.isEmpty == false)
    }

    @Test func clearAfterCalculationHidesOperationDisplay() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("4"))
        vm.handle(.operation("+"))
        vm.handle(.digit("3"))
        vm.handle(.equals)
        vm.handle(.clear)
        #expect(vm.showOperationDisplay == false)
    }

    @Test func clearResetsOperationDisplay() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("4"))
        vm.handle(.operation("+"))
        vm.handle(.digit("3"))
        vm.handle(.equals)
        vm.handle(.clear)
        #expect(vm.operationDisplay == "")
    }

    @Test func dotAtStartOfNumber() {
        let vm = CalculatorViewModel()
        vm.handle(.dot)
        vm.handle(.digit("5"))
        // "0.5" or ".5" — either way should parse correctly and not crash
        #expect(vm.display.contains("5"))
    }

    @Test func trigOperationDisplayContainsDegreeSymbol() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("9"))
        vm.handle(.digit("0"))
        vm.handle(.trig("sin"))
        #expect(vm.operationDisplay.contains("°"))
    }

    @Test func newInputAfterTrigResetsDisplay() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("9"))
        vm.handle(.digit("0"))
        vm.handle(.trig("sin"))
        vm.handle(.digit("5"))
        #expect(vm.display == "5")
    }

    @Test func multipleOperatorsWithoutSecondNumberKeepsState() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("5"))
        vm.handle(.operation("+"))
        vm.handle(.operation("-"))
        vm.handle(.operation("×"))
        // Should still have 5 as first number and × as operation
        vm.handle(.digit("3"))
        vm.handle(.equals)
        #expect(vm.display == "15")
    }

    @Test func operationDisplayUpdatesOnOperatorReplacement() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("5"))
        vm.handle(.operation("+"))
        vm.handle(.operation("-"))
        #expect(vm.operationDisplay == "5 - ")
    }

    @Test func freshCalculationAfterClear() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("9"))
        vm.handle(.operation("+"))
        vm.handle(.digit("1"))
        vm.handle(.equals)
        vm.handle(.clear)
        vm.handle(.digit("3"))
        vm.handle(.operation("+"))
        vm.handle(.digit("2"))
        vm.handle(.equals)
        #expect(vm.display == "5")
    }

    @Test func largeNumberNoScientificNotation() {
        let vm = CalculatorViewModel()
        // 99999 × 99999 = 9999800001
        vm.handle(.digit("9"))
        vm.handle(.digit("9"))
        vm.handle(.digit("9"))
        vm.handle(.digit("9"))
        vm.handle(.digit("9"))
        vm.handle(.operation("×"))
        vm.handle(.digit("9"))
        vm.handle(.digit("9"))
        vm.handle(.digit("9"))
        vm.handle(.digit("9"))
        vm.handle(.digit("9"))
        vm.handle(.equals)
        #expect(vm.display == "9999800001")
    }

    @Test func negativeResultDisplayed() {
        let vm = CalculatorViewModel()
        vm.handle(.digit("3"))
        vm.handle(.operation("-"))
        vm.handle(.digit("1"))
        vm.handle(.digit("0"))
        vm.handle(.equals)
        #expect(vm.display == "-7")
    }
}

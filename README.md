# calcuNator

> Test assignment for [DGTL Factory](https://dgtl-factory.com)

A iOS calculator app built with SwiftUI, featuring basic arithmetic and trigonometric functions.

## Features

- Addition, subtraction, multiplication, division
- Trigonometric functions: sin, cos, tan (input in degrees)
- Operator replacement — change operator before entering second number
- Error handling for division by zero and invalid operations
- Adaptive layout for portrait and landscape
- Haptic feedback
- Animated display transitions

## Architecture

MVVM with a separate business logic layer:

```
CalcButton.swift          — typed button model
CalculatorState.swift     — encapsulates all mutable state
CalculatorEngine.swift    — arithmetic, trig, formatting (no SwiftUI dependencies)
CalculatorViewModel.swift — mediator between engine and view
CalculatorView.swift      — UI only
```

The core arithmetic logic is powered by a custom **Objective-C framework** (`CalculatorFramework`), integrated into Swift via a bridging header. This demonstrates Swift–ObjC interoperability in a real project setup.

## Requirements

- iOS 18.2+
- Xcode 16.2+
- Swift 5

## Running

Open `calcuNator.xcodeproj` in Xcode and run on simulator or device.

## Tests

52 unit tests written with Swift Testing framework, covering:

**CalculatorEngine**
- Arithmetic: addition, subtraction, multiplication, division
- Edge cases: division by zero, multiply by zero, negative numbers, very small decimals
- Trigonometry: sin/cos/tan in degrees, negative angles
- Formatting: integers, decimals, negative numbers, zero, NaN, infinity, large numbers without scientific notation

**CalculatorViewModel**
- Input: digits, dot, leading zero prevention, double dot ignored
- Operations: basic calculation, operator replacement, chained calculations
- Trig via VM: correct result and operationDisplay with degree symbol
- Error handling: division by zero shows "Error", equals without operands doesn't crash
- State: clear resets display and operationDisplay, new input after result resets display

Run with `Cmd+U` in Xcode.

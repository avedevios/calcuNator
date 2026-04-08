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

## Requirements

- iOS 18.2+
- Xcode 16.2+
- Swift 5

## Running

Open `calcuNator.xcodeproj` in Xcode and run on simulator or device.

## Tests

Unit tests cover `CalculatorEngine` and `CalculatorViewModel`. Run with `Cmd+U`.

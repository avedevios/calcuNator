import SwiftUI

// MARK: - Button View

struct CalcButtonView: View {
    let button: CalcButton
    let width: CGFloat
    let height: CGFloat
    let font: Font
    let action: () -> Void

    var body: some View {
        Button {
            button.triggerHaptic()
            action()
        } label: {
            Text(button.label)
                .font(font)
                .frame(width: width, height: height)
                .foregroundColor(.white)
                .background(button.color)
                .cornerRadius(height / 2)
        }
    }
}

// MARK: - Calculator View

struct CalculatorView: View {
    @StateObject private var vm = CalculatorViewModel()

    let buttons: [[CalcButton]] = [
        [.trig("sin"), .trig("cos"), .trig("tan"), .operation("÷")],
        [.digit("7"),  .digit("8"),  .digit("9"),  .operation("×")],
        [.digit("4"),  .digit("5"),  .digit("6"),  .operation("-")],
        [.digit("1"),  .digit("2"),  .digit("3"),  .operation("+")],
        [.clear,       .digit("0"),  .dot,         .equals]
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(edges: .all)
            GeometryReader { geometry in
                let isLandscape = geometry.size.width > geometry.size.height
                // 4 columns, 5 spacing gaps, outer padding on both sides
                let buttonWidth  = isLandscape ? geometry.size.width  / 4 - 10 : (geometry.size.width - 5 * 10 - 32) / 4
                let buttonHeight = isLandscape ? geometry.size.height / 10 - 10 : buttonWidth
                let displayTextSize: CGFloat = isLandscape ? 40 : 60
                let buttonFont = isLandscape ? Font.title : Font.largeTitle

                VStack(spacing: 10) {
                    Spacer()
                    if vm.showOperationDisplay {
                        Text(vm.operationDisplay)
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding([.leading, .trailing])
                            .foregroundColor(.gray)
                    }
                    Text(vm.display)
                        .font(.system(size: displayTextSize))
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding()
                        .foregroundColor(.white)
                        .contentTransition(.numericText())
                        .animation(.easeInOut(duration: 0.15), value: vm.display)

                    ForEach(buttons, id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(row, id: \.self) { button in
                                CalcButtonView(
                                    button: button,
                                    width: buttonWidth,
                                    height: buttonHeight,
                                    font: buttonFont
                                ) {
                                    vm.handle(button)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}

// MARK: - App Entry

@main
struct CalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            CalculatorView()
        }
    }
}

#Preview {
    CalculatorView()
}

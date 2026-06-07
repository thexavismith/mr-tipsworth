import SwiftUI

struct BillEntryView: View {
    @Bindable var calculation: TipCalculation
    @Environment(ThemeStore.self) private var themeStore
    var isActive: Bool = false
    var onAccent: Bool = false
    var onTap: (() -> Void)?
    var onClear: (() -> Void)?

    private var labelColor: Color {
        onAccent ? themeStore.activeTheme.accentText.opacity(0.7) : themeStore.activeTheme.accent
    }
    private var amountColor: Color {
        onAccent ? themeStore.activeTheme.accentText : themeStore.activeTheme.primaryText
    }
    private var symbolColor: Color {
        onAccent ? themeStore.activeTheme.accentText.opacity(0.6) : themeStore.activeTheme.secondaryText
    }
    private var clearColor: Color {
        onAccent ? themeStore.activeTheme.accentText.opacity(0.5) : themeStore.activeTheme.secondaryText
    }
    private var strokeColor: Color {
        if onAccent { return isActive ? themeStore.activeTheme.accentText : .clear }
        return isActive ? themeStore.activeTheme.accent : themeStore.activeTheme.cardStroke
    }

    private var displayText: String {
        guard let bill = calculation.billAmount else { return "" }
        return formatted(bill)
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Bill amount")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(labelColor)
                    .textCase(.uppercase)
                    .kerning(0.8)

                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(currencySymbol)
                        .font(.system(size: 28, weight: .heavy, design: .rounded))
                        .foregroundStyle(displayText.isEmpty ? symbolColor : amountColor)

                    Text(displayText.isEmpty ? "0.00" : displayText)
                        .font(.system(size: 44, weight: .heavy, design: .rounded))
                        .foregroundStyle(displayText.isEmpty ? symbolColor : amountColor)
                        .contentTransition(.numericText())
                        .animation(.snappy(duration: 0.15), value: displayText)
                }
            }

            Spacer()

            if calculation.billAmount != nil {
                Button {
                    onClear?()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(clearColor)
                }
                .accessibilityLabel("Clear bill amount")
            }
        }
        .padding(.horizontal, onAccent ? 0 : 20)
        .padding(.vertical, onAccent ? 0 : 18)
        .background(onAccent ? .clear : themeStore.activeTheme.cardBackground, in: .rect(cornerRadius: 20))
        .overlay {
            if !onAccent {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(strokeColor, lineWidth: isActive ? 2 : 1.5)
            }
        }
        .animation(.easeInOut(duration: 0.15), value: isActive)
        .contentShape(Rectangle())
        .onTapGesture { onTap?() }
    }

    private var currencySymbol: String { Locale.current.currencySymbol ?? "$" }

    private func formatted(_ value: Double) -> String {
        let str = String(format: "%.2f", value)
        if str.hasSuffix(".00") { return String(str.dropLast(3)) }
        if str.hasSuffix("0") { return String(str.dropLast()) }
        return str
    }
}

#Preview {
    VStack(spacing: 20) {
        BillEntryView(calculation: TipCalculation(), onAccent: true)
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .background(Color.lavender)
        BillEntryView(calculation: TipCalculation(), onAccent: false)
            .padding(.horizontal, 20)
    }
    .environment(ThemeStore())
    .background(Color.warmCream)
}

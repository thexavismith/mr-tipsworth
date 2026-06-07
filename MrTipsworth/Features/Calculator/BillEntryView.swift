import SwiftUI

struct BillEntryView: View {
    @Bindable var calculation: TipCalculation
    @Environment(ThemeStore.self) private var themeStore
    var onAccent: Bool = false

    @State private var rawText: String = ""
    @FocusState private var isFocused: Bool

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
    private var bgColor: Color { onAccent ? .clear : themeStore.activeTheme.cardBackground }
    private var strokeColor: Color {
        if onAccent { return isFocused ? themeStore.activeTheme.accentText : .clear }
        return isFocused ? themeStore.activeTheme.accent : themeStore.activeTheme.cardStroke
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
                        .foregroundStyle(rawText.isEmpty ? symbolColor : amountColor)

                    TextField("0.00", text: $rawText)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 44, weight: .heavy, design: .rounded))
                        .foregroundStyle(amountColor)
                        .tint(onAccent ? themeStore.activeTheme.accentText : themeStore.activeTheme.accent)
                        .focused($isFocused)
                        .onChange(of: rawText) { _, new in
                            rawText = sanitized(new)
                            calculation.billAmount = Double(rawText)
                        }
                }
            }

            Spacer()

            if !rawText.isEmpty {
                Button {
                    rawText = ""
                    calculation.billAmount = nil
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
        .background(onAccent ? .clear : bgColor, in: .rect(cornerRadius: 20))
        .overlay {
            if !onAccent {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(strokeColor, lineWidth: isFocused ? 2 : 1.5)
            }
        }
        .animation(.easeInOut(duration: 0.15), value: isFocused)
        .onTapGesture { isFocused = true }
    }

    private var currencySymbol: String { Locale.current.currencySymbol ?? "$" }

    private func sanitized(_ input: String) -> String {
        let sep = Locale.current.decimalSeparator ?? "."
        var result = input.filter { $0.isNumber || String($0) == sep }
        let parts = result.components(separatedBy: sep)
        if parts.count > 2 { result = parts[0] + sep + parts[1...].joined() }
        return result
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

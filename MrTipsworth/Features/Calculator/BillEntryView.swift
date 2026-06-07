import SwiftUI

struct BillEntryView: View {
    @Bindable var calculation: TipCalculation
    @Environment(ThemeStore.self) private var themeStore

    @State private var rawText: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Bill amount")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(themeStore.activeTheme.secondaryText)
                .textCase(.uppercase)
                .kerning(0.8)

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(currencySymbol)
                    .font(.system(size: 36, weight: .heavy, design: .rounded))
                    .foregroundStyle(themeStore.activeTheme.secondaryText)

                TextField("0.00", text: $rawText)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 52, weight: .heavy, design: .rounded))
                    .foregroundStyle(themeStore.activeTheme.primaryText)
                    .onChange(of: rawText) { _, new in
                        rawText = sanitized(new)
                        calculation.billAmount = Double(rawText)
                    }

                if !rawText.isEmpty {
                    Button {
                        rawText = ""
                        calculation.billAmount = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(themeStore.activeTheme.secondaryText)
                    }
                    .accessibilityLabel("Clear bill amount")
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(themeStore.activeTheme.cardBackground, in: .rect(cornerRadius: 24))
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(themeStore.activeTheme.cardStroke, lineWidth: 1.5)
        }
    }

    private var currencySymbol: String {
        Locale.current.currencySymbol ?? "$"
    }

    private func sanitized(_ input: String) -> String {
        let sep = Locale.current.decimalSeparator ?? "."
        var result = input.filter { $0.isNumber || String($0) == sep }
        let parts = result.components(separatedBy: sep)
        if parts.count > 2 {
            result = parts[0] + sep + parts[1...].joined()
        }
        return result
    }
}

#Preview {
    BillEntryView(calculation: TipCalculation())
        .environment(ThemeStore())
        .padding()
        .background(Color.warmCream)
}

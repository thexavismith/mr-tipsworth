import SwiftUI

struct BillEntryView: View {
    @Bindable var calculation: TipCalculation
    @Environment(ThemeStore.self) private var themeStore

    @State private var rawText: String = ""

    var body: some View {
        HStack {
            TextField("Enter bill amount", text: $rawText)
                .keyboardType(.decimalPad)
                .font(.system(size: 40, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(themeStore.activeTheme.primaryText)
                .onChange(of: rawText) { _, new in
                    rawText = sanitized(new)
                    calculation.billAmount = Double(rawText)
                }

            if !rawText.isEmpty {
                Button("Clear", systemImage: "xmark.circle.fill") {
                    rawText = ""
                    calculation.billAmount = nil
                }
                .labelStyle(.iconOnly)
                .foregroundStyle(themeStore.activeTheme.secondaryText)
                .accessibilityLabel("Clear bill amount")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(themeStore.activeTheme.surface, in: .rect(cornerRadius: 16))
    }

    private func sanitized(_ input: String) -> String {
        let decimalSeparator = Locale.current.decimalSeparator ?? "."
        var result = input.filter { $0.isNumber || String($0) == decimalSeparator }
        // Allow only one decimal separator
        let parts = result.components(separatedBy: decimalSeparator)
        if parts.count > 2 {
            result = parts[0] + decimalSeparator + parts[1...].joined()
        }
        return result
    }
}

#Preview {
    BillEntryView(calculation: TipCalculation())
        .environment(ThemeStore())
        .padding()
}

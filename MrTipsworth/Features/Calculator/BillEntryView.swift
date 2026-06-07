import SwiftUI

struct BillEntryView: View {
    @Bindable var calculation: TipCalculation
    @Environment(ThemeStore.self) private var themeStore

    var body: some View {
        HStack {
            TextField(
                "Enter bill amount",
                value: $calculation.billAmount,
                format: .currency(code: Locale.current.currency?.identifier ?? "USD")
            )
                .keyboardType(.decimalPad)
                .font(.system(size: 40, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(themeStore.activeTheme.primaryText)

            if calculation.billAmount != nil {
                Button("Clear", systemImage: "xmark.circle.fill") {
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
}

#Preview {
    BillEntryView(calculation: TipCalculation())
        .environment(ThemeStore())
        .padding()
}

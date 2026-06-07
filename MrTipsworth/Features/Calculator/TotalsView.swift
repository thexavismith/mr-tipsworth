import SwiftUI

struct TotalsView: View {
    var calculation: TipCalculation
    @Environment(ThemeStore.self) private var themeStore

    var body: some View {
        VStack(spacing: 12) {
            TotalRow(
                label: "Tip",
                value: calculation.tipAmount,
                theme: themeStore.activeTheme
            )
            Divider()
                .background(themeStore.activeTheme.secondaryText.opacity(0.3))
            TotalRow(
                label: "Total",
                value: calculation.displayTotal,
                isEmphasized: true,
                theme: themeStore.activeTheme
            )
        }
        .padding(20)
        .background(themeStore.activeTheme.surface, in: .rect(cornerRadius: 16))
    }
}

private struct TotalRow: View {
    let label: String
    let value: Double
    var isEmphasized: Bool = false
    let theme: AppTheme

    var body: some View {
        HStack {
            Text(label)
                .font(isEmphasized ? .headline : .body)
                .foregroundStyle(theme.secondaryText)
            Spacer()
            Text(value, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .font(isEmphasized ? .system(size: 28, weight: .bold, design: .rounded) : .body.bold())
                .foregroundStyle(theme.primaryText)
                .contentTransition(.numericText())
        }
    }
}

#Preview {
    TotalsView(calculation: TipCalculation())
        .environment(ThemeStore())
        .padding()
}

import SwiftUI

struct TotalsView: View {
    var calculation: TipCalculation
    @Environment(ThemeStore.self) private var themeStore

    var body: some View {
        HStack(spacing: 12) {
            TotalChip(label: "Tip", value: calculation.tipAmount, isEmphasized: false, theme: themeStore.activeTheme)
            TotalChip(label: "Total", value: calculation.displayTotal, isEmphasized: true, theme: themeStore.activeTheme)
        }
    }
}

private struct TotalChip: View {
    let label: String
    let value: Double
    let isEmphasized: Bool
    let theme: AppTheme

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(theme.secondaryText)
                .textCase(.uppercase)
                .kerning(0.8)

            Text(value, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .font(.system(size: isEmphasized ? 36 : 28, weight: isEmphasized ? .heavy : .bold, design: .rounded))
                .foregroundStyle(isEmphasized ? theme.accent : theme.primaryText)
                .contentTransition(.numericText())
                .animation(.snappy(duration: 0.2), value: value)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(isEmphasized ? theme.accent.opacity(0.08) : theme.cardBackground, in: .rect(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(isEmphasized ? theme.accent.opacity(0.5) : theme.cardStroke, lineWidth: 1.5)
        }
    }
}

#Preview {
    TotalsView(calculation: TipCalculation())
        .environment(ThemeStore())
        .padding()
        .background(Color.warmCream)
}

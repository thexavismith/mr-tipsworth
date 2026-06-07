import SwiftUI

struct TotalsView: View {
    var calculation: TipCalculation
    @Environment(ThemeStore.self) private var themeStore

    var body: some View {
        HStack(spacing: 12) {
            TotalChip(
                label: "Tip",
                value: calculation.tipAmount,
                isEmphasized: false,
                theme: themeStore.activeTheme
            )
            TotalChip(
                label: "Total",
                value: calculation.displayTotal,
                isEmphasized: true,
                theme: themeStore.activeTheme
            )
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
                .font(.system(size: isEmphasized ? 36 : 28, weight: .black, design: .rounded))
                .foregroundStyle(isEmphasized ? theme.accent : theme.primaryText)
                .contentTransition(.numericText())
                .minimumScaleFactor(0.6)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(
            isEmphasized ? theme.accent.opacity(0.12) : theme.cardBackground,
            in: .rect(cornerRadius: 20)
        )
        .overlay {
            if isEmphasized {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(theme.accent.opacity(0.35), lineWidth: 1.5)
            }
        }
    }
}

#Preview {
    TotalsView(calculation: TipCalculation())
        .environment(ThemeStore())
        .padding()
        .background(Color.warmCream)
}

import SwiftUI

struct TotalsView: View {
    var calculation: TipCalculation
    @Environment(ThemeStore.self) private var themeStore

    var body: some View {
        HStack(spacing: 10) {
            TotalChip(
                label: "Tip",
                value: calculation.displayTipAmount,
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
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(isEmphasized ? theme.accentText.opacity(0.7) : theme.secondaryText)
                .textCase(.uppercase)
                .kerning(0.8)

            Text(value, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .font(.system(size: isEmphasized ? 34 : 28, weight: .heavy, design: .rounded))
                .foregroundStyle(isEmphasized ? theme.accentText : theme.primaryText)
                .contentTransition(.numericText())
                .animation(.snappy(duration: 0.2), value: value)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .background(
            isEmphasized ? theme.accentFill : theme.cardBackground,
            in: .rect(cornerRadius: 20)
        )
        .overlay {
            if !isEmphasized {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(theme.cardStroke, lineWidth: 1.5)
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

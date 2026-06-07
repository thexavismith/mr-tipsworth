import SwiftUI

struct NumpadView: View {
    @Bindable var calculation: TipCalculation
    @Environment(ThemeStore.self) private var themeStore
    var onDone: () -> Void

    // Raw string being built; synced to calculation.billAmount
    @State private var raw: String = ""

    private let keys: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        [".", "0", "⌫"]
    ]

    var body: some View {
        VStack(spacing: 12) {
            Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                ForEach(keys, id: \.self) { row in
                    GridRow {
                        ForEach(row, id: \.self) { key in
                            NumpadKey(
                                label: key,
                                theme: themeStore.activeTheme,
                                action: { handle(key) }
                            )
                        }
                    }
                }
            }

            Button(action: onDone) {
                Text("Done")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(themeStore.activeTheme.accentText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(themeStore.activeTheme.accentFill, in: .rect(cornerRadius: 16))
            }
        }
        .padding(.horizontal, 20)
        .onAppear {
            if let bill = calculation.billAmount {
                let str = String(format: "%.2f", bill)
                raw = str.hasSuffix(".00") ? String(str.dropLast(3)) : str
            } else {
                raw = ""
            }
        }
    }

    private func handle(_ key: String) {
        let sep = Locale.current.decimalSeparator ?? "."
        let localKey = key == "." ? sep : key

        switch localKey {
        case "⌫":
            if !raw.isEmpty { raw.removeLast() }
        case sep:
            guard !raw.contains(sep) else { return }
            raw += sep
        default:
            // Limit to 2 decimal places
            if let sepIdx = raw.firstIndex(of: Character(sep)) {
                let decimals = raw.distance(from: raw.index(after: sepIdx), to: raw.endIndex)
                guard decimals < 2 else { return }
            }
            // Prevent leading zeros (e.g. "007")
            if raw == "0" { raw = localKey; return }
            raw += localKey
        }

        calculation.billAmount = raw.isEmpty || raw == sep ? nil : Double(raw.replacingOccurrences(of: sep, with: "."))
    }
}

private struct NumpadKey: View {
    let label: String
    let theme: AppTheme
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                if label == "⌫" {
                    Image(systemName: "delete.backward")
                        .font(.system(size: 20, weight: .medium))
                } else {
                    Text(label)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                }
            }
            .foregroundStyle(theme.primaryText)
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(theme.cardBackground, in: .rect(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(theme.cardStroke, lineWidth: 1.5)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NumpadView(calculation: TipCalculation(), onDone: {})
        .environment(ThemeStore())
        .padding(.vertical)
        .background(Color.warmCream)
}

import SwiftUI

struct RoundingToggleView: View {
    @Binding var isRounding: Bool
    let effectiveTip: Double?
    @Environment(ThemeStore.self) private var themeStore

    var body: some View {
        VStack(spacing: 8) {
            Toggle("Round up total", isOn: $isRounding)
                .font(.body.bold())
                .foregroundStyle(themeStore.activeTheme.primaryText)
                .tint(themeStore.activeTheme.accent)

            if let effectiveTip {
                Text("Effective tip: \(effectiveTip, format: .number.precision(.fractionLength(1)))%")
                    .font(.caption)
                    .foregroundStyle(themeStore.activeTheme.secondaryText)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(20)
        .background(themeStore.activeTheme.surface, in: .rect(cornerRadius: 16))
        .animation(.easeInOut, value: isRounding)
    }
}

#Preview {
    RoundingToggleView(isRounding: .constant(true), effectiveTip: 18.4)
        .environment(ThemeStore())
        .padding()
}

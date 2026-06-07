import SwiftUI

struct RoundingToggleView: View {
    @Binding var isRounding: Bool
    let effectiveTip: Double?
    @Environment(ThemeStore.self) private var themeStore

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Round up total")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(themeStore.activeTheme.primaryText)

                if let effectiveTip {
                    Text("Effective tip: \(effectiveTip, format: .number.precision(.fractionLength(1)))%")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(themeStore.activeTheme.secondaryText)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }

            Spacer()

            Toggle("", isOn: $isRounding)
                .labelsHidden()
                .tint(themeStore.activeTheme.accent)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(themeStore.activeTheme.cardBackground, in: .rect(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(themeStore.activeTheme.cardStroke, lineWidth: 1.5)
        }
        .animation(.easeInOut(duration: 0.2), value: isRounding)
    }
}

#Preview {
    RoundingToggleView(isRounding: .constant(true), effectiveTip: 18.4)
        .environment(ThemeStore())
        .padding()
        .background(Color.warmCream)
}

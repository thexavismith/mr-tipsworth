import SwiftUI

struct RoundingToggleView: View {
    @Binding var isRounding: Bool
    let effectiveTip: Double?
    @Environment(ThemeStore.self) private var themeStore

    var body: some View {
        HStack(spacing: 16) {
            // Custom toggle track
            Button {
                isRounding.toggle()
            } label: {
                ZStack {
                    Capsule()
                        .fill(isRounding ? themeStore.activeTheme.accentFill : themeStore.activeTheme.cardStroke)
                        .frame(width: 48, height: 28)

                    Circle()
                        .fill(.white)
                        .frame(width: 22, height: 22)
                        .offset(x: isRounding ? 10 : -10)
                        .shadow(color: .black.opacity(0.12), radius: 2, x: 0, y: 1)
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isRounding)
            }
            .accessibilityLabel("Round up total")
            .accessibilityValue(isRounding ? "On" : "Off")

            VStack(alignment: .leading, spacing: 2) {
                Text("Round up total")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(themeStore.activeTheme.primaryText)

                if let effectiveTip {
                    Text("Effective tip: \(effectiveTip, format: .number.precision(.fractionLength(1)))%")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(themeStore.activeTheme.secondaryText)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }

            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(themeStore.activeTheme.cardBackground, in: .rect(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20)
            .strokeBorder(themeStore.activeTheme.cardStroke, lineWidth: 1.5))
        .animation(.easeInOut(duration: 0.2), value: isRounding)
    }
}

#Preview {
    VStack(spacing: 16) {
        RoundingToggleView(isRounding: .constant(false), effectiveTip: nil)
        RoundingToggleView(isRounding: .constant(true), effectiveTip: 18.4)
    }
    .environment(ThemeStore())
    .padding()
    .background(Color.warmCream)
}

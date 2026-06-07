import SwiftUI

struct RewardUnlockView: View {
    let product: IAPProduct
    @Environment(\.dismiss) private var dismiss
    @Environment(ThemeStore.self) private var themeStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var starScale: Double = 0.1
    @State private var starOpacity: Double = 0
    @State private var contentOpacity: Double = 0

    var body: some View {
        ZStack {
            themeStore.activeTheme.background
                .ignoresSafeArea()

            CelebrationParticleView()

            VStack(spacing: 32) {
                Spacer()

                starBurst

                VStack(spacing: 12) {
                    Text("Thank you!")
                        .font(.largeTitle.bold())
                        .foregroundStyle(themeStore.activeTheme.primaryText)
                    Text(product.rewardDescription)
                        .font(.body)
                        .foregroundStyle(themeStore.activeTheme.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .opacity(contentOpacity)

                Spacer()

                Button("Awesome!") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(themeStore.activeTheme.accent)
                .controlSize(.large)
                .opacity(contentOpacity)
            }
            .padding(32)
        }
        .interactiveDismissDisabled()
        .onAppear {
            animateIn()
        }
    }

    private var starBurst: some View {
        ZStack {
            // Radial glow rings
            ForEach(0..<3, id: \.self) { ring in
                Circle()
                    .fill(themeStore.activeTheme.highlight.opacity(0.08 - Double(ring) * 0.02))
                    .frame(width: CGFloat(120 + ring * 50), height: CGFloat(120 + ring * 50))
                    .scaleEffect(starScale)
            }

            Image(systemName: "star.fill")
                .font(.system(size: 80))
                .foregroundStyle(themeStore.activeTheme.highlight)
                .scaleEffect(starScale)
                .opacity(starOpacity)
                .symbolEffect(.bounce, options: reduceMotion ? .default : .repeating)
        }
    }

    private func animateIn() {
        if reduceMotion {
            starScale = 1
            starOpacity = 1
            contentOpacity = 1
            return
        }

        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            starScale = 1
            starOpacity = 1
        }

        withAnimation(.easeIn(duration: 0.3).delay(0.3)) {
            contentOpacity = 1
        }
    }
}

#Preview {
    RewardUnlockView(product: .superCoin)
        .environment(ThemeStore())
}

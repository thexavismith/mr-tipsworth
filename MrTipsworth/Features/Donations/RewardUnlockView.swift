import SwiftUI

struct RewardUnlockView: View {
    let product: IAPProduct
    @Environment(\.dismiss) private var dismiss
    @Environment(ThemeStore.self) private var themeStore

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "star.fill")
                .font(.system(size: 80))
                .foregroundStyle(themeStore.activeTheme.highlight)
                .symbolEffect(.bounce, options: .repeating)

            VStack(spacing: 12) {
                Text("Thank you!")
                    .font(.largeTitle.bold())
                Text(product.rewardDescription)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            Button("Awesome!") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(32)
        .interactiveDismissDisabled()
    }
}

#Preview {
    RewardUnlockView(product: .superCoin)
        .environment(ThemeStore())
}

import SwiftUI

struct MainCalculatorView: View {
    @Environment(ThemeStore.self) private var themeStore
    @Environment(IAPStore.self) private var store
    @State private var calculation = TipCalculation()
    @State private var isShowingSettings = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            themeStore.activeTheme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Text("Mr. Tipsworth")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(themeStore.activeTheme.secondaryText)
                    Spacer()
                    settingsButton
                }
                .padding(.horizontal, 28)
                .padding(.top, 16)

                BillEntryView(calculation: calculation)
                    .padding(.horizontal, 24)
                    .padding(.top, 28)

                TotalsView(calculation: calculation)
                    .padding(.horizontal, 24)
                    .padding(.top, 12)

                RoundingToggleView(
                    isRounding: $calculation.isRounding,
                    effectiveTip: calculation.effectiveTipPercent
                )
                .padding(.horizontal, 24)
                .padding(.top, 12)

                Spacer()

                TipDialView(tipPercent: $calculation.tipPercent)
                    .padding(.bottom, 24)
            }
        }
        .task {
            await store.updatePurchasedProducts()
        }
        .sheet(isPresented: $isShowingSettings) {
            SettingsView()
        }
    }

    private var settingsButton: some View {
        Button {
            isShowingSettings = true
        } label: {
            Image(systemName: "gearshape.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(themeStore.activeTheme.primaryText)
                .frame(width: 40, height: 40)
                .background(themeStore.activeTheme.cardBackground, in: Circle())
                .overlay {
                    Circle().strokeBorder(themeStore.activeTheme.cardStroke, lineWidth: 1.5)
                }
        }
        .accessibilityLabel("Settings")
    }
}

#Preview {
    MainCalculatorView()
        .environment(ThemeStore())
        .environment(IAPStore())
}

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
                // Top bar
                HStack {
                    Text("Mr. Tipsworth")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(themeStore.activeTheme.secondaryText)
                    Spacer()
                    settingsButton
                }
                .padding(.horizontal, 28)
                .padding(.top, 16)

                // Bill entry — hero element
                BillEntryView(calculation: calculation)
                    .padding(.horizontal, 24)
                    .padding(.top, 28)

                // Totals block
                TotalsView(calculation: calculation)
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                // Rounding toggle
                RoundingToggleView(
                    isRounding: $calculation.isRounding,
                    effectiveTip: calculation.effectiveTipPercent
                )
                .padding(.horizontal, 24)
                .padding(.top, 12)

                Spacer()

                // Dial anchored to bottom
                TipDialView(tipPercent: $calculation.tipPercent)
                    .padding(.bottom, 52)
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
                .background(themeStore.activeTheme.surface, in: Circle())
        }
        .accessibilityLabel("Settings")
    }
}

#Preview {
    MainCalculatorView()
        .environment(ThemeStore())
        .environment(IAPStore())
}

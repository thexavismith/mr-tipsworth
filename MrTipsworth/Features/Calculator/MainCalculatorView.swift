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

            VStack(spacing: 32) {
                BillEntryView(calculation: calculation)
                TipDialView(tipPercent: $calculation.tipPercent)
                TotalsView(calculation: calculation)
                RoundingToggleView(isRounding: $calculation.isRounding, effectiveTip: calculation.effectiveTipPercent)
            }
            .padding(.horizontal, 24)
            .padding(.top, 60)

            settingsButton
        }
        .task {
            await store.updatePurchasedProducts()
        }
        .sheet(isPresented: $isShowingSettings) {
            SettingsView()
        }
    }

    private var settingsButton: some View {
        Button("Settings", systemImage: "gearshape.fill") {
            isShowingSettings = true
        }
        .labelStyle(.iconOnly)
        .font(.title2)
        .foregroundStyle(themeStore.activeTheme.secondaryText)
        .padding(20)
    }
}

#Preview {
    MainCalculatorView()
        .environment(ThemeStore())
        .environment(IAPStore())
}

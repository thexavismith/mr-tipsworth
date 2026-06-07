import SwiftUI

struct MainCalculatorView: View {
    @Environment(ThemeStore.self) private var themeStore
    @Environment(IAPStore.self) private var store
    @State private var calculation = TipCalculation()
    @State private var isShowingSettings = false
    @State private var isEnteringBill = false

    var body: some View {
        ZStack(alignment: .top) {
            themeStore.activeTheme.background
                .ignoresSafeArea()

            themeStore.activeTheme.accentFill
                .ignoresSafeArea()
                .frame(maxHeight: .infinity, alignment: .top)
                .frame(height: 1)

            VStack(spacing: 0) {
                header
                VStack(spacing: 10) {
                    TotalsView(calculation: calculation)
                    RoundingToggleView(
                        isRounding: $calculation.isRounding,
                        effectiveTip: calculation.effectiveTipPercent
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                Spacer(minLength: 16)

                if isEnteringBill {
                    NumpadView(calculation: calculation, onDone: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            isEnteringBill = false
                        }
                    })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 20)
                } else {
                    TipDialView(tipPercent: $calculation.tipPercent)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 20)
                }
            }
        }
        .task { await store.updatePurchasedProducts() }
        .sheet(isPresented: $isShowingSettings) { SettingsView() }
    }

    private var header: some View {
        ZStack(alignment: .bottom) {
            themeStore.activeTheme.accentFill
                .ignoresSafeArea(edges: .top)

            VStack(spacing: 0) {
                ZStack {
                    Text("MR. TIPSWORTH")
                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                        .foregroundStyle(themeStore.activeTheme.accentText)
                        .kerning(2.5)
                        .frame(maxWidth: .infinity)

                    HStack {
                        Spacer()
                        Button {
                            isShowingSettings = true
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(themeStore.activeTheme.accentText)
                                .frame(width: 42, height: 42)
                                .background(.white, in: Circle())
                        }
                        .accessibilityLabel("Settings")
                        .padding(.trailing, 20)
                    }
                }
                .padding(.bottom, 28)

                BillEntryView(
                    calculation: calculation,
                    isActive: isEnteringBill,
                    onAccent: true,
                    onTap: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            isEnteringBill = true
                        }
                    },
                    onClear: {
                        calculation.billAmount = nil
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            isEnteringBill = false
                        }
                    }
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 36)
            }
        }
        .frame(height: 210)
        .clipShape(.rect(cornerRadii: .init(bottomLeading: 48, bottomTrailing: 48)))
    }
}

#Preview {
    MainCalculatorView()
        .environment(ThemeStore())
        .environment(IAPStore())
}

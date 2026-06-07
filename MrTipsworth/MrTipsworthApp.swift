import SwiftUI

@main
struct MrTipsworthApp: App {
    @State private var store = IAPStore()
    @State private var themeStore = ThemeStore()

    var body: some Scene {
        WindowGroup {
            MainCalculatorView()
                .environment(store)
                .environment(themeStore)
                .task { await store.updatePurchasedProducts() }
                .onChange(of: store.hasAnyPurchase) { _, _ in
                    themeStore.syncPurchases(from: store)
                }
        }
    }
}

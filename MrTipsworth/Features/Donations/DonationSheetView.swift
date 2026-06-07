import SwiftUI
import StoreKit

struct DonationSheetView: View {
    @Environment(IAPStore.self) private var store
    @Environment(ThemeStore.self) private var themeStore
    @Environment(\.dismiss) private var dismiss
    @State private var purchasedProduct: IAPProduct?

    var body: some View {
        NavigationStack {
            ZStack {
                themeStore.activeTheme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(IAPProduct.allCases) { product in
                            DonationTierView(
                                product: product,
                                storeProduct: store.products.first(where: { $0.id == product.rawValue }),
                                isPurchased: store.isPurchased(product),
                                theme: themeStore.activeTheme,
                                onPurchase: { await purchase(product) }
                            )
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Support the Dev")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(themeStore.activeTheme.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(themeStore.activeTheme.accent)
                }
            }
        }
        .task { await store.loadProducts() }
        .sheet(item: $purchasedProduct, content: RewardUnlockView.init)
    }

    private func purchase(_ product: IAPProduct) async {
        do {
            if try await store.purchase(product) != nil {
                applyRewards(for: product)
                purchasedProduct = product
            }
        } catch {}
    }

    private func applyRewards(for product: IAPProduct) {
        if let theme = product.unlocksTheme { themeStore.unlock(theme) }
        if let icon = product.unlocksIcon { themeStore.unlock(icon: icon) }
    }
}

private struct DonationTierView: View {
    let product: IAPProduct
    let storeProduct: Product?
    let isPurchased: Bool
    let theme: AppTheme
    let onPurchase: () async -> Void

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(product.displayName)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(theme.primaryText)
                Text(product.rewardDescription)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(theme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            if isPurchased {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(theme.accent)
                    .accessibilityLabel("Purchased")
            } else {
                Button(storeProduct?.displayPrice ?? "—") {
                    Task { await onPurchase() }
                }
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(theme.accent, in: Capsule())
            }
        }
        .padding(16)
        .background(theme.cardBackground, in: .rect(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16)
            .strokeBorder(theme.cardStroke, lineWidth: 1.5))
    }
}

#Preview {
    DonationSheetView()
        .environment(IAPStore())
        .environment(ThemeStore())
}

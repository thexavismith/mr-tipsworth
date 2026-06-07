import SwiftUI
import StoreKit

struct DonationSheetView: View {
    @Environment(IAPStore.self) private var store
    @Environment(ThemeStore.self) private var themeStore
    @Environment(\.dismiss) private var dismiss
    @State private var purchasedProduct: IAPProduct?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(IAPProduct.allCases) { product in
                        DonationTierView(
                            product: product,
                            storeProduct: store.products.first(where: { $0.id == product.rawValue }),
                            isPurchased: store.isPurchased(product),
                            onPurchase: { await purchase(product) }
                        )
                    }
                }
                .padding(24)
            }
            .navigationTitle("Support the Dev")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done", action: dismiss.callAsFunction)
                }
            }
        }
        .task {
            await store.loadProducts()
        }
        .sheet(item: $purchasedProduct, content: RewardUnlockView.init)
    }

    private func purchase(_ product: IAPProduct) async {
        do {
            if try await store.purchase(product) != nil {
                applyRewards(for: product)
                purchasedProduct = product
            }
        } catch {
            // Surface via alert in full implementation
        }
    }

    private func applyRewards(for product: IAPProduct) {
        if let theme = product.unlocksTheme {
            themeStore.unlock(theme)
        }
        if let icon = product.unlocksIcon {
            themeStore.unlock(icon: icon)
        }
    }
}

private struct DonationTierView: View {
    let product: IAPProduct
    let storeProduct: Product?
    let isPurchased: Bool
    let onPurchase: () async -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(product.displayName)
                    .font(.headline)
                Text(product.rewardDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if isPurchased {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.green)
                    .accessibilityLabel("Purchased")
            } else {
                Button(storeProduct?.displayPrice ?? "—") {
                    Task { await onPurchase() }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(16)
        .background(.regularMaterial, in: .rect(cornerRadius: 12))
    }
}

#Preview {
    DonationSheetView()
        .environment(IAPStore())
        .environment(ThemeStore())
}

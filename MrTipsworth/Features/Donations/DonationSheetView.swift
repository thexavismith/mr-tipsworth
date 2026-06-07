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
                VStack(spacing: 24) {
                    heroSection
                    tierSection
                    aboutSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
            .background(themeStore.activeTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .task { await store.loadProducts() }
        .sheet(item: $purchasedProduct, content: RewardUnlockView.init)
    }

    private var heroSection: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(themeStore.activeTheme.accentFill)
                .frame(width: 72, height: 72)
                .overlay {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(.white)
                }

            VStack(spacing: 8) {
                Text("Support Development")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(themeStore.activeTheme.primaryText)
                    .multilineTextAlignment(.center)

                Text(
                    "Donations are never expected, but would be greatly appreciated " +
                    "if you enjoy using Mr. Tipsworth and want to support its continued development."
                )
                    .font(.system(size: 15, design: .rounded))
                    .foregroundStyle(themeStore.activeTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 8)
    }

    private var tierSection: some View {
        VStack(spacing: 12) {
            ForEach(IAPProduct.allCases) { product in
                DonationTierRow(
                    product: product,
                    storeProduct: store.products.first(where: { $0.id == product.rawValue }),
                    isPurchased: store.isPurchased(product),
                    theme: themeStore.activeTheme,
                    onPurchase: { await purchase(product) }
                )
            }
        }
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About Donations")
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(themeStore.activeTheme.primaryText)
                .frame(maxWidth: .infinity, alignment: .center)

            VStack(alignment: .leading, spacing: 8) {
                ForEach([
                    "Donations are completely voluntary and one-time purchases",
                    "All app features are free regardless of donation status",
                    "Your support helps keep Mr. Tipsworth maintained and updated"
                ], id: \.self) { bullet in
                    HStack(alignment: .top, spacing: 10) {
                        Text("•")
                            .foregroundStyle(themeStore.activeTheme.secondaryText)
                        Text(bullet)
                            .font(.system(size: 14, design: .rounded))
                            .foregroundStyle(themeStore.activeTheme.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .padding(20)
        .background(themeStore.activeTheme.cardBackground, in: .rect(cornerRadius: 20))
    }

    private func purchase(_ product: IAPProduct) async {
        do {
            if try await store.purchase(product) != nil {
                themeStore.syncPurchases(from: store)
                purchasedProduct = product
            }
        } catch {}
    }
}

private struct DonationTierRow: View {
    let product: IAPProduct
    let storeProduct: Product?
    let isPurchased: Bool
    let theme: AppTheme
    let onPurchase: () async -> Void

    var body: some View {
        Button {
            guard !isPurchased else { return }
            Task { await onPurchase() }
        } label: {
            HStack(spacing: 14) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(theme.accentFill.opacity(0.15))
                    .frame(width: 52, height: 52)
                    .overlay {
                        Image(systemName: product.iconName)
                            .font(.system(size: 22))
                            .foregroundStyle(theme.accentFill)
                    }

                VStack(alignment: .leading, spacing: 2) {
                    Text(product.displayName)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(theme.primaryText)
                    Text(storeProduct?.displayPrice ?? product.fallbackPrice)
                        .font(.system(size: 14, design: .rounded))
                        .foregroundStyle(theme.secondaryText)
                }

                Spacer()

                if isPurchased {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(theme.accent)
                        .accessibilityLabel("Purchased")
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(theme.secondaryText)
                }
            }
            .padding(16)
            .background(theme.cardBackground, in: .rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    DonationSheetView()
        .environment(IAPStore())
        .environment(ThemeStore())
}

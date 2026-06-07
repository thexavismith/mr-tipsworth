import StoreKit

@MainActor
@Observable
final class IAPStore {
    var purchasedProductIDs: Set<String> = []
    var isLoading: Bool = false
    var products: [Product] = []

    var hasAnyPurchase: Bool { !purchasedProductIDs.isEmpty }

    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        do {
            products = try await Product.products(for: IAPProduct.allCases.map(\.rawValue))
        } catch {
            // Surface errors through a published alert in a real implementation
        }
    }

    func purchase(_ product: IAPProduct) async throws -> Transaction? {
        guard let storeProduct = products.first(where: { $0.id == product.rawValue }) else {
            return nil
        }
        let result = try await storeProduct.purchase()
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            purchasedProductIDs.insert(transaction.productID)
            return transaction
        case .userCancelled, .pending:
            return nil
        @unknown default:
            return nil
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
        } catch {
            // Surface errors through a published alert in a real implementation
        }
    }

    func isPurchased(_ product: IAPProduct) -> Bool {
        purchasedProductIDs.contains(product.rawValue)
    }

    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
            }
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let value):
            return value
        }
    }
}

enum StoreError: Error {
    case failedVerification
}

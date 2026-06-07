import Foundation

enum IAPProduct: String, CaseIterable, Identifiable {
    case smallCoin = "com.tipsworth.smallcoin"
    case superCoin = "com.tipsworth.supercoin"
    case starCoin  = "com.tipsworth.starcoin"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .smallCoin: "Small Coin"
        case .superCoin: "Super Coin"
        case .starCoin:  "Star Coin"
        }
    }

    var rewardDescription: String {
        switch self {
        case .smallCoin: "Unlocks the Warm Mushroom color theme"
        case .superCoin: "Unlocks an alternate app icon"
        case .starCoin:  "Unlocks the premium theme and icon bundle"
        }
    }

    var unlocksTheme: AppTheme? {
        switch self {
        case .smallCoin: .warmMushroom
        case .starCoin:  .warmMushroom
        case .superCoin: nil
        }
    }

    var unlocksIcon: String? {
        switch self {
        case .superCoin: "AlternateIcon"
        case .starCoin:  "PremiumIcon"
        case .smallCoin: nil
        }
    }
}

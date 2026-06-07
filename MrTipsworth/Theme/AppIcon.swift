import SwiftUI

enum AppIcon: String, CaseIterable, Identifiable {
    case `default` = "Default"
    case alternate = "AlternateIcon"
    case premium   = "PremiumIcon"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .default:   "Classic"
        case .alternate: "Super Coin"
        case .premium:   "Star Coin"
        }
    }

    // nil means use the primary icon
    var alternateIconName: String? {
        switch self {
        case .default:   nil
        case .alternate: "AlternateIcon"
        case .premium:   "PremiumIcon"
        }
    }

    var requiredProduct: IAPProduct? {
        switch self {
        case .default:   nil
        case .alternate: .superCoin
        case .premium:   .starCoin
        }
    }
}

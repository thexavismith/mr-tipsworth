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

    var iconName: String {
        switch self {
        case .smallCoin: "cup.and.saucer.fill"
        case .superCoin: "takeoutbag.and.cup.and.straw.fill"
        case .starCoin:  "birthday.cake.fill"
        }
    }

    var fallbackPrice: String {
        switch self {
        case .smallCoin: "$2.99"
        case .superCoin: "$4.99"
        case .starCoin:  "$9.99"
        }
    }
}

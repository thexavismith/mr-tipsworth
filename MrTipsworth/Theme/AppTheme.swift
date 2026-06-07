import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case classic
    case warmMushroom

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .classic:      "Classic"
        case .warmMushroom: "Warm Mushroom"
        }
    }

    var background: Color {
        switch self {
        case .classic:      .warmCream
        case .warmMushroom: Color(hex: 0xFFF8EE)
        }
    }

    var surface: Color {
        switch self {
        case .classic:      .white
        case .warmMushroom: Color(hex: 0xFFF1DC)
        }
    }

    var accent: Color {
        switch self {
        case .classic:      .plum
        case .warmMushroom: .cozyPeach
        }
    }

    var dialFace: Color {
        switch self {
        case .classic:      .plum
        case .warmMushroom: .cozyPeach
        }
    }

    var dialPip: Color {
        switch self {
        case .classic:      .lightPlum
        case .warmMushroom: .richBrown
        }
    }

    var primaryText: Color {
        switch self {
        case .classic:      .inkBrown
        case .warmMushroom: .richBrown
        }
    }

    var secondaryText: Color {
        switch self {
        case .classic:      .inkBrown.opacity(0.45)
        case .warmMushroom: .richBrown.opacity(0.5)
        }
    }

    var highlight: Color {
        switch self {
        case .classic:      .deepTeal
        case .warmMushroom: .warmYellow
        }
    }

    // Card chip backgrounds (bill entry, totals, rounding)
    var cardBackground: Color {
        switch self {
        case .classic:      .lightPlum
        case .warmMushroom: Color(hex: 0xFFF1DC)
        }
    }
}

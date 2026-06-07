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

    // Interactive accent — used on buttons, toggles, borders, gear icon
    var accent: Color {
        switch self {
        case .classic:      .lavenderText
        case .warmMushroom: .cozyPeach
        }
    }

    // Header/dial face fill
    var accentFill: Color {
        switch self {
        case .classic:      .lavender
        case .warmMushroom: .cozyPeach
        }
    }

    // Text that sits on top of the accentFill surface
    var accentText: Color {
        switch self {
        case .classic:      .lavenderText
        case .warmMushroom: .richBrown
        }
    }

    var cardBackground: Color {
        switch self {
        case .classic:      .lavenderCard
        case .warmMushroom: Color(hex: 0xFFF1DC)
        }
    }

    var cardStroke: Color {
        switch self {
        case .classic:      .lavenderStroke
        case .warmMushroom: .cozyPeach.opacity(0.3)
        }
    }

    var dialFace: Color {
        switch self {
        case .classic:      .lavender
        case .warmMushroom: .cozyPeach
        }
    }

    var dialPip: Color {
        switch self {
        case .classic:      .lavenderText
        case .warmMushroom: .white
        }
    }

    var primaryText: Color {
        switch self {
        case .classic:      .purpleGrey
        case .warmMushroom: .richBrown
        }
    }

    var secondaryText: Color {
        switch self {
        case .classic:      .purpleGrey.opacity(0.5)
        case .warmMushroom: .richBrown.opacity(0.5)
        }
    }

    var highlight: Color {
        switch self {
        case .classic:      .amberGold
        case .warmMushroom: .warmYellow
        }
    }
}

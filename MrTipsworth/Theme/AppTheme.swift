import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case classic
    case warmMushroom

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .classic:     "Classic"
        case .warmMushroom: "Warm Mushroom"
        }
    }

    // Page / screen background
    var background: Color {
        switch self {
        case .classic:     .softCream
        case .warmMushroom: Color(hex: 0xFFF8EE)
        }
    }

    // Card / surface background
    var surface: Color {
        switch self {
        case .classic:     .white.opacity(0.85)
        case .warmMushroom: Color(hex: 0xFFF1DC)
        }
    }

    // Primary interactive accent (buttons, dial ring, toggle tint)
    var accent: Color {
        switch self {
        case .classic:     .sparkleGold
        case .warmMushroom: .cozyPeach
        }
    }

    // Dial face fill
    var dialFace: Color {
        switch self {
        case .classic:     .warmYellow
        case .warmMushroom: .cozyPeach
        }
    }

    // Snap pip markers on the dial
    var dialPip: Color {
        switch self {
        case .classic:     .richBrown
        case .warmMushroom: .sparkleGold
        }
    }

    // Primary body text
    var primaryText: Color {
        switch self {
        case .classic:     .richBrown
        case .warmMushroom: .richBrown
        }
    }

    // Secondary / caption text
    var secondaryText: Color {
        switch self {
        case .classic:     .richBrown.opacity(0.55)
        case .warmMushroom: .richBrown.opacity(0.55)
        }
    }

    // Decorative highlight (e.g. reward screen star)
    var highlight: Color {
        switch self {
        case .classic:     .tealBlue
        case .warmMushroom: .warmYellow
        }
    }
}

import SwiftUI

extension Color {
    static let lavender       = Color(hex: 0xC4B0E2)
    static let lavenderText   = Color(hex: 0x2A1A58)
    static let lavenderLight  = Color(hex: 0xEDE5FF)
    static let lavenderCard   = Color(hex: 0xF5F0FF)
    static let lavenderStroke = Color(hex: 0xE0D4F7)
    static let lavenderDark   = Color(hex: 0x5C3D99)
    static let warmCream      = Color(hex: 0xFAF6EF)
    static let purpleGrey     = Color(hex: 0x2A2035)
    static let amberGold      = Color(hex: 0xF5C842)
    static let cozyPeach      = Color(hex: 0xF5A57A)
    static let warmYellow     = Color(hex: 0xF5C842)
    static let sparkleGold    = Color(hex: 0xC8971A)
    static let tealBlue       = Color(hex: 0x2A7F8F)
    static let softCream      = Color(hex: 0xF5F0E8)
    static let richBrown      = Color(hex: 0x6B2D1A)

    init(hex: UInt32) {
        let red   = Double((hex >> 16) & 0xFF) / 255
        let green = Double((hex >> 8)  & 0xFF) / 255
        let blue  = Double( hex        & 0xFF) / 255
        self.init(red: red, green: green, blue: blue)
    }
}

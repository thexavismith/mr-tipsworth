import SwiftUI

extension Color {
    static let plum         = Color(hex: 0x7B3F7A)
    static let lightPlum    = Color(hex: 0xF3E6F3)
    static let deepPlum     = Color(hex: 0x4E1F4D)
    static let amberGold    = Color(hex: 0xF0A500)
    static let deepTeal     = Color(hex: 0x1A7A6E)
    static let warmCream    = Color(hex: 0xFAF6EF)
    static let richAmber    = Color(hex: 0xE8890A)
    static let softAmber    = Color(hex: 0xFDE9B0)
    static let inkBrown     = Color(hex: 0x1C1209)
    static let mutedSage    = Color(hex: 0xB8C9A3)
    static let cozyPeach    = Color(hex: 0xF5A57A)
    static let warmYellow   = Color(hex: 0xF5C842)
    static let sparkleGold  = Color(hex: 0xC8971A)
    static let tealBlue     = Color(hex: 0x2A7F8F)
    static let softCream    = Color(hex: 0xF5F0E8)
    static let richBrown    = Color(hex: 0x6B2D1A)

    init(hex: UInt32) {
        let red   = Double((hex >> 16) & 0xFF) / 255
        let green = Double((hex >> 8)  & 0xFF) / 255
        let blue  = Double( hex        & 0xFF) / 255
        self.init(red: red, green: green, blue: blue)
    }
}

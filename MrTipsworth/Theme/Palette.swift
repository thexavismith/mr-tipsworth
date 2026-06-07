import SwiftUI

extension Color {
    // Core palette
    static let warmYellow  = Color(hex: 0xF5C842)
    static let cozyPeach   = Color(hex: 0xF5A57A)
    static let sparkleGold = Color(hex: 0xC8971A)
    static let tealBlue    = Color(hex: 0x2A7F8F)
    static let softCream   = Color(hex: 0xF5F0E8)
    static let richBrown   = Color(hex: 0x6B2D1A)

    init(hex: UInt32) {
        let red   = Double((hex >> 16) & 0xFF) / 255
        let green = Double((hex >> 8)  & 0xFF) / 255
        let blue  = Double( hex        & 0xFF) / 255
        self.init(red: red, green: green, blue: blue)
    }
}

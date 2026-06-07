import SwiftUI

@MainActor
@Observable
final class ThemeStore {
    var activeTheme: AppTheme = .classic
    var unlockedThemes: Set<AppTheme> = [.classic]

    var activeIcon: String?
    var unlockedIcons: Set<String> = []

    func unlock(_ theme: AppTheme) {
        unlockedThemes.insert(theme)
    }

    func unlock(icon: String) {
        unlockedIcons.insert(icon)
    }
}

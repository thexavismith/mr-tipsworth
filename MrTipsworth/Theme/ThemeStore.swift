import SwiftUI

@MainActor
@Observable
final class ThemeStore {
    var activeTheme: AppTheme = .classic
    var unlockedThemes: Set<AppTheme> = [.classic]

    var activeIcon: AppIcon = .default
    var unlockedIcons: Set<AppIcon> = [.default]

    func unlock(_ theme: AppTheme) {
        unlockedThemes.insert(theme)
    }

    func unlock(icon: AppIcon) {
        unlockedIcons.insert(icon)
    }

    func setIcon(_ icon: AppIcon) async {
        guard unlockedIcons.contains(icon) else { return }
        do {
            try await UIApplication.shared.setAlternateIconName(icon.alternateIconName)
            activeIcon = icon
        } catch {
            // Icon change failed — likely running in simulator or icon not declared in Info.plist
        }
    }
}

import SwiftUI

@MainActor
@Observable
final class ThemeStore {
    var activeTheme: AppTheme = .classic
    var activeIcon: AppIcon = .default

    let unlockedThemes: Set<AppTheme> = Set(AppTheme.allCases)
    let unlockedIcons: Set<AppIcon> = Set(AppIcon.allCases)

    func syncPurchases(from store: IAPStore) {}

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

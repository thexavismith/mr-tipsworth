import SwiftUI

struct IconPickerSectionView: View {
    @Environment(ThemeStore.self) private var themeStore

    var body: some View {
        Section("App Icon") {
            ForEach(AppIcon.allCases) { icon in
                IconPickerRow(icon: icon, themeStore: themeStore)
            }
        }
    }
}

private struct IconPickerRow: View {
    let icon: AppIcon
    let themeStore: ThemeStore

    private var isUnlocked: Bool { themeStore.unlockedIcons.contains(icon) }
    private var isActive: Bool { themeStore.activeIcon == icon }

    var body: some View {
        Button {
            guard isUnlocked else { return }
            Task { await themeStore.setIcon(icon) }
        } label: {
            HStack {
                iconPreview
                Text(icon.displayName)
                    .foregroundStyle(isUnlocked ? .primary : .secondary)
                Spacer()
                if !isUnlocked {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.secondary)
                        .accessibilityLabel("Locked")
                } else if isActive {
                    Image(systemName: "checkmark")
                        .foregroundStyle(Color.accentColor)
                        .accessibilityLabel("Selected")
                }
            }
        }
        .disabled(!isUnlocked)
    }

    private var iconPreview: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(isUnlocked ? Color.sparkleGold.opacity(0.2) : Color.secondary.opacity(0.1))
            .frame(width: 44, height: 44)
            .overlay {
                Image(systemName: isUnlocked ? "app.fill" : "app")
                    .foregroundStyle(isUnlocked ? Color.sparkleGold : .secondary)
            }
            .accessibilityHidden(true)
    }
}

#Preview {
    List {
        IconPickerSectionView()
    }
    .environment(ThemeStore())
}

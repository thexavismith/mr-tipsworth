import SwiftUI

struct IconPickerSectionView: View {
    @Environment(ThemeStore.self) private var themeStore

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(AppIcon.allCases.enumerated()), id: \.element) { index, icon in
                if index > 0 {
                    Divider().padding(.leading, 72)
                }
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
            HStack(spacing: 14) {
                iconPreview
                Text(icon.displayName)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(
                        isUnlocked ? themeStore.activeTheme.primaryText : themeStore.activeTheme.secondaryText
                    )
                Spacer()
                if !isUnlocked {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(themeStore.activeTheme.secondaryText)
                        .accessibilityLabel("Locked")
                } else if isActive {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.plum)
                        .accessibilityLabel("Selected")
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .disabled(!isUnlocked)
    }

    private var iconPreview: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(isUnlocked ? Color.plum.opacity(0.15) : Color.secondary.opacity(0.1))
            .frame(width: 44, height: 44)
            .overlay {
                Image(systemName: isUnlocked ? "app.fill" : "app")
                    .foregroundStyle(isUnlocked ? Color.plum : .secondary)
            }
            .accessibilityHidden(true)
    }
}

#Preview {
    IconPickerSectionView()
        .environment(ThemeStore())
        .padding()
        .background(Color.warmCream)
}

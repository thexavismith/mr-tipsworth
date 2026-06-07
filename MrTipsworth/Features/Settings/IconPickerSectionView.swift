import SwiftUI

struct IconPickerSectionView: View {
    @Environment(ThemeStore.self) private var themeStore

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(AppIcon.allCases.enumerated()), id: \.element) { index, icon in
                if index > 0 {
                    Divider().overlay(themeStore.activeTheme.cardStroke).padding(.leading, 72)
                }
                IconPickerRow(icon: icon, themeStore: themeStore)
            }
        }
    }
}

private struct IconPickerRow: View {
    let icon: AppIcon
    let themeStore: ThemeStore

    private var isActive: Bool { themeStore.activeIcon == icon }

    var body: some View {
        Button {
            Task { await themeStore.setIcon(icon) }
        } label: {
            HStack(spacing: 14) {
                iconPreview
                Text(icon.displayName)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(themeStore.activeTheme.primaryText)
                Spacer()
                if isActive {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(themeStore.activeTheme.accent)
                        .accessibilityLabel("Selected")
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var iconPreview: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(themeStore.activeTheme.accentFill.opacity(0.15))
            .frame(width: 44, height: 44)
            .overlay {
                Image(systemName: "app.fill")
                    .foregroundStyle(themeStore.activeTheme.accentFill)
            }
            .accessibilityHidden(true)
    }
}

#Preview {
    IconPickerSectionView()
        .environment(ThemeStore())
        .padding()
        .background(Color.lavenderLight)
}

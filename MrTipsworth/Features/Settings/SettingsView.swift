import SwiftUI

struct SettingsView: View {
    @Environment(ThemeStore.self) private var themeStore
@State private var isShowingDonations = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    HStack {
                        Text("Settings")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(themeStore.activeTheme.primaryText)
                        Spacer()
                        Button("Done") { dismiss() }
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(themeStore.activeTheme.accent)
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 12)

                    themeSection
                    iconSection
                    supportSection
                    versionSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
            .background(themeStore.activeTheme.background.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $isShowingDonations) {
            DonationSheetView()
        }
    }

    private var themeSection: some View {
        SettingsCard(title: "Appearance", theme: themeStore.activeTheme) {
            VStack(spacing: 0) {
                ForEach(Array(AppTheme.allCases.enumerated()), id: \.element) { index, theme in
                    if index > 0 {
                        Divider().overlay(themeStore.activeTheme.cardStroke).padding(.leading, 20)
                    }
                    ThemePickerRow(
                        theme: theme,
                        isActive: themeStore.activeTheme == theme,
                        activeTheme: themeStore.activeTheme
                    ) {
                        themeStore.activeTheme = theme
                    }
                }
            }
        }
    }

    private var iconSection: some View {
        SettingsCard(title: "App Icon", theme: themeStore.activeTheme) {
            IconPickerSectionView()
        }
    }

    private var supportSection: some View {
        let theme = themeStore.activeTheme
        return SettingsCard(title: "Support", theme: theme) {
            VStack(spacing: 0) {
                SettingsRow(theme: theme) {
                    Button { isShowingDonations = true } label: {
                        settingsRowLabel("Support the Dev", icon: "heart.fill", iconColor: theme.accent, theme: theme)
                    }
                    .buttonStyle(.plain)
                }

                Divider().overlay(theme.cardStroke).padding(.leading, 20)

                SettingsRow(theme: theme) {
                    Button {
                        let address = "xavi@xavibenjamin.com"
                        let subject = "Mr. Tipsworth Feedback"
                        let allowed = CharacterSet.urlQueryAllowed
                        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: allowed) ?? subject
                        let encoded = "mailto:\(address)?subject=\(encodedSubject)"
                        if let url = URL(string: encoded) { UIApplication.shared.open(url) }
                    } label: {
                        settingsRowLabel("Send Feedback", icon: "envelope",
                                         iconColor: theme.secondaryText, theme: theme)
                    }
                    .buttonStyle(.plain)
                }

            }
        }
    }

    private func settingsRowLabel(_ title: String, icon: String, iconColor: Color, theme: AppTheme) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(theme.primaryText)
            Spacer()
            Image(systemName: icon)
                .foregroundStyle(iconColor)
        }
        .contentShape(Rectangle())
    }

    private var versionSection: some View {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—"
        return SettingsCard(title: "About", theme: themeStore.activeTheme) {
            SettingsRow(theme: themeStore.activeTheme) {
                HStack {
                    Text("Version")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(themeStore.activeTheme.primaryText)
                    Spacer()
                    Text("\(version) (\(build))")
                        .font(.system(size: 15, design: .rounded))
                        .foregroundStyle(themeStore.activeTheme.secondaryText)
                }
            }
        }
    }
}

// MARK: - Theme picker row

private struct ThemePickerRow: View {
    let theme: AppTheme
    let isActive: Bool
    let activeTheme: AppTheme
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                themeSwatches
                Text(theme.displayName)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(activeTheme.primaryText)
                Spacer()
                if isActive {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(activeTheme.accent)
                        .accessibilityLabel("Selected")
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var themeSwatches: some View {
        HStack(spacing: -6) {
            ForEach([theme.accentFill, theme.cardBackground, theme.background], id: \.self) { color in
                Circle()
                    .fill(color)
                    .frame(width: 22, height: 22)
                    .overlay {
                        Circle().strokeBorder(Color.black.opacity(0.35), lineWidth: 1)
                    }
                    .overlay {
                        Circle().strokeBorder(.white, lineWidth: 2)
                    }
            }
        }
        .accessibilityHidden(true)
    }
}

// MARK: - Reusable card container

private struct SettingsCard<Content: View>: View {
    let title: String
    let theme: AppTheme
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(theme.secondaryText)
                .textCase(.uppercase)
                .kerning(0.8)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                content()
            }
            .background(theme.cardBackground, in: .rect(cornerRadius: 20))
        }
    }
}

private struct SettingsRow<Content: View>: View {
    let theme: AppTheme
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
    }
}

#Preview {
    SettingsView()
        .environment(ThemeStore())
        .environment(IAPStore())
}

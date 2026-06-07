import SwiftUI

struct SettingsView: View {
    @Environment(ThemeStore.self) private var themeStore
    @Environment(IAPStore.self) private var store
    @State private var isShowingDonations = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                themeStore.activeTheme.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 12) {
                        themeSection
                        iconSection
                        supportSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(themeStore.activeTheme.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(themeStore.activeTheme.accent)
                }
            }
        }
        .sheet(isPresented: $isShowingDonations) {
            DonationSheetView()
        }
    }

    private var themeSection: some View {
        SettingsCard(title: "Appearance", theme: themeStore.activeTheme) {
            @Bindable var themeStore = themeStore
            Picker("Theme", selection: $themeStore.activeTheme) {
                ForEach(AppTheme.allCases) { theme in
                    HStack {
                        Text(theme.displayName)
                        if !themeStore.unlockedThemes.contains(theme) {
                            Image(systemName: "lock.fill")
                                .foregroundStyle(themeStore.activeTheme.secondaryText)
                        }
                    }
                    .tag(theme)
                }
            }
            .pickerStyle(.menu)
            .tint(themeStore.activeTheme.accent)
        }
    }

    private var iconSection: some View {
        SettingsCard(title: "App Icon", theme: themeStore.activeTheme) {
            IconPickerSectionView()
        }
    }

    private var supportSection: some View {
        SettingsCard(title: "Support", theme: themeStore.activeTheme) {
            VStack(spacing: 0) {
                SettingsRow(theme: themeStore.activeTheme) {
                    Button {
                        isShowingDonations = true
                    } label: {
                        HStack {
                            Text("Support the Dev")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundStyle(themeStore.activeTheme.primaryText)
                            Spacer()
                            Image(systemName: "heart.fill")
                                .foregroundStyle(themeStore.activeTheme.accent)
                        }
                    }
                }

                Divider()
                    .padding(.leading, 16)

                SettingsRow(theme: themeStore.activeTheme) {
                    Button {
                        Task { await store.restorePurchases() }
                    } label: {
                        HStack {
                            Text("Restore Purchases")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundStyle(themeStore.activeTheme.primaryText)
                            Spacer()
                            Image(systemName: "arrow.clockwise")
                                .foregroundStyle(themeStore.activeTheme.secondaryText)
                        }
                    }
                }
            }
        }
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

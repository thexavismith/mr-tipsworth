import SwiftUI

struct SettingsView: View {
    @Environment(ThemeStore.self) private var themeStore
    @Environment(IAPStore.self) private var store
    @State private var isShowingDonations = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                themeSection
                iconSection
                supportSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done", action: dismiss.callAsFunction)
                }
            }
        }
        .sheet(isPresented: $isShowingDonations) {
            DonationSheetView()
        }
    }

    private var themeSection: some View {
        Section("Appearance") {
            @Bindable var themeStore = themeStore
            Picker("Theme", selection: $themeStore.activeTheme) {
                ForEach(AppTheme.allCases) { theme in
                    HStack {
                        Text(theme.displayName)
                        if !themeStore.unlockedThemes.contains(theme) {
                            Image(systemName: "lock.fill")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .tag(theme)
                }
            }
        }
    }

    private var iconSection: some View {
        Section("App Icon") {
            Text("Default")
        }
    }

    private var supportSection: some View {
        Section {
            Button("Support the Dev") {
                isShowingDonations = true
            }
            Button("Restore Purchases") {
                Task { await store.restorePurchases() }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(ThemeStore())
        .environment(IAPStore())
}

import SwiftUI

struct SettingsView: View {
    @AppStorage("lastfmUsername") private var username: String = ""
    @EnvironmentObject private var serviceContainer: ServiceContainer
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Last.fm Account") {
                    if !username.isEmpty {
                        Text("Signed in as \(username)")
                        Button("Sign Out", role: .destructive) {
                            UserDefaults.standard.removeObject(forKey: "lastfmSessionKey")
                            UserDefaults.standard.removeObject(forKey: "lastfmUsername")
                            username = ""
                        }
                    }
                }
                Section("About") {
                    Text("Version 1.0")
                    Link("View on Github",
                        destination: URL(string: "https://google.com")!)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
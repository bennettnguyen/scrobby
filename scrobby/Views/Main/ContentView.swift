import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = ContentViewModel()
    @State private var showingManualScrobble = false
    @State private var showingSettings = false

    var body: some View {
        Group {
            NavigationSplitView {
                ZStack {
                    LinearGradient(colors: [.blue, .white], startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                    List {
                        ForEach(viewModel.items) { item in
                            NavigationLink {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(item.trackName)
                                        .font(.headline)
                                    Text(item.artistName)
                                        .font(.subheadline)
                                    if let album = item.albumName {
                                        Text(album)
                                            .font(.caption)
                                    }
                                    Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(item.trackName)
                                    Text(item.artistName)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button(action: { showingSettings = true }) {
                                Label("Settings", systemImage: "gear")
                            }
                            Button(action: { showingManualScrobble = true }) {
                                Label("Manual Scrobble", systemImage: "plus")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            } detail: {
                Text("Select a track")
            }
        }
        .onAppear {
            viewModel.modelContext = modelContext
        }
        .sheet(isPresented: $showingManualScrobble) {
            ManualScrobbleView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }

    private func addItem() {
        withAnimation {
            viewModel.addItem()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            viewModel.deleteItems(offsets: offsets, from: viewModel.items)
        }
    }
}

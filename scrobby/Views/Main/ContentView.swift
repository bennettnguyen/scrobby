import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        Group {
            NavigationSplitView {
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
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
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
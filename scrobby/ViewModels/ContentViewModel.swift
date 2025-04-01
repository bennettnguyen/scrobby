import Foundation
import SwiftUI
import SwiftData

class ContentViewModel: ObservableObject {
    @Published var modelContext: ModelContext? {
        didSet {
            loadItems()
        }
    }
    @Published var items: [Scrobble] = []

    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }

    func loadItems() {
        guard let modelContext else { return }
        do {
            let descriptor = FetchDescriptor<Scrobble>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
            items = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }

    func addItem() {
        guard let modelContext else { return }
        let newItem = Scrobble(
            trackName: "Test Track",
            artistName: "Test Artist"
        )
        modelContext.insert(newItem)
    }

    func deleteItems(offsets: IndexSet, from items: [Scrobble]) {
        guard let modelContext else { return }
        for index in offsets {
            modelContext.delete(items[index])
        }
    }
}
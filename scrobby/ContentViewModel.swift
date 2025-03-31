//
//  ContentViewModel.swift
//  scrobby
//
//  Created by Bennett Nguyen on 3/29/25.
//

import Foundation
import SwiftUI
import SwiftData

class ContentViewModel: ObservableObject {
    @Published var modelContext: ModelContext?

    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }

    func addItem() {
        guard let modelContext else { return }
        let newItem = Item(timestamp: Date())
        modelContext.insert(newItem)
    }

    func deleteItems(offsets: IndexSet, from items: [Item]) {
        guard let modelContext else { return }
        for index in offsets {
            modelContext.delete(items[index])
        }
    }
}

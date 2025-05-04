import Foundation
import SwiftData

class ServiceContainer: ObservableObject {
    let lastFMService: LastFMService
    let scrobbleQueueService: ScrobbleQueueService
    let nowPlayingService: NowPlayingService
    
    init(modelContext: ModelContext?) {
        self.lastFMService = LastFMService(
            apiKey: "ce1a31392d28ad522984c380bf1fb3af",
            apiSecret: "461f134b376c8288347578b1c058e580"
        )
        self.scrobbleQueueService = ScrobbleQueueService(
            modelContext: modelContext,
            lastFMService: lastFMService
        )
        self.nowPlayingService = NowPlayingService(
            queueService: scrobbleQueueService
        )
    }
}

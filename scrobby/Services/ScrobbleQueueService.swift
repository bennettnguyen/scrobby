import SwiftData
import Foundation

@Observable class ScrobbleQueueService {
    private var modelContext: ModelContext?
    private let lastFMService: LastFMService
    
    init(modelContext: ModelContext? = nil, 
         lastFMService: LastFMService = LastFMService(
            apiKey: "ce1a31392d28ad522984c380bf1fb3af",
            apiSecret: "461f134b376c8288347578b1c058e580"
         )) {
        self.modelContext = modelContext
        self.lastFMService = lastFMService
    }
    
    func queueScrobble(_ scrobble: Scrobble) {
        guard let modelContext else { return }
        modelContext.insert(scrobble)
        tryScrobbling()
    }
    
    func tryScrobbling() {
        guard let modelContext else { return }
        Task {
            do {
                let descriptor = FetchDescriptor<Scrobble>(
                    predicate: #Predicate<Scrobble> { !$0.isScrobbled }
                )
                let unscrobbled = try modelContext.fetch(descriptor)
                
                for scrobble in unscrobbled {
                    try await lastFMService.scrobbleTrack(scrobble)
                    scrobble.isScrobbled = true
                }
            } catch {
                print("Failed to scrobble: \(error)")
            }
        }
    }
}

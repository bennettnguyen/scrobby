import XCTest
import SwiftData
@testable import scrobby

@MainActor
final class ScrobbleTests: XCTestCase {
    var modelContainer: ModelContainer!
    var modelContext: ModelContext!
    var lastFMService: LastFMService!
    var scrobbleQueueService: ScrobbleQueueService!
    
    override func setUp() async throws {
        // Create an in-memory model container for testing
        let schema = Schema([Scrobble.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: schema, configurations: [config])
        modelContext = modelContainer.mainContext
        
        // Initialize a LastFMService instance.
        lastFMService = LastFMService(
            apiKey: "ce1a31392d28ad522984c380bf1fb3af",
            apiSecret: "461f134b376c8288347578b1c058e580"
        )
        
        // Initialize the scrobble queue service with the in-memory context.
        scrobbleQueueService = ScrobbleQueueService(
            modelContext: modelContext,
            lastFMService: lastFMService
        )
    }
    
    func testManualScrobble() async throws {
        // Create a manual scrobble record.
        let scrobble = Scrobble(
            trackName: "THE GAS",
            artistName: "Brian",
            albumName: "Classics"
        )
        
        // Insert the scrobble via your queue service.
        scrobbleQueueService.queueScrobble(scrobble)
        
        // Fetch all scrobbles from the model context.
        let descriptor = FetchDescriptor<Scrobble>()
        let results = try modelContext.fetch(descriptor)
        
        // Verify that the scrobble was saved correctly.
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.trackName, "THE GAS")
        XCTAssertEqual(results.first?.artistName, "Brian")
        XCTAssertEqual(results.first?.albumName, "Classics")
    }
    
    func testAutoScrobbleInQueueProcessing() async throws {
        // Create multiple scrobble records.
        let scrobbles = [
            Scrobble(trackName: "Track 1", artistName: "Artist 1"),
            Scrobble(trackName: "Track 2", artistName: "Artist 2"),
            Scrobble(trackName: "Track 3", artistName: "Artist 3")
        ]
        
        // Queue each scrobble.
        for scrobble in scrobbles {
            scrobbleQueueService.queueScrobble(scrobble)
        }
        
        // Wait for the asynchronous task in tryScrobbling() to process the items.
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Fetch only the processed scrobbles (those flagged as isScrobbled).
        let predicateDescriptor = FetchDescriptor<Scrobble>(
            predicate: #Predicate<Scrobble> { $0.isScrobbled }
        )
        let processedScrobbles = try modelContext.fetch(predicateDescriptor)
        
        // Assert that each queued scrobble was marked as scrobbled.
        XCTAssertEqual(processedScrobbles.count, scrobbles.count)
    }
}

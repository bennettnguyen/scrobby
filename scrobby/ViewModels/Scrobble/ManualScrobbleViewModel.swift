import Foundation
import SwiftUI

@MainActor
class ManualScrobbleViewModel: ObservableObject {
    @Published var trackName = ""
    @Published var artistName = ""
    @Published var albumName = ""
    @Published var isScrobbling = false
    
    var isValid: Bool {
        !trackName.isEmpty && !artistName.isEmpty
    }
    
    func createScrobble() -> Scrobble {
        Scrobble(
            trackName: trackName,
            artistName: artistName,
            albumName: albumName.isEmpty ? nil : albumName
        )
    }
    
    func reset() {
        trackName = ""
        artistName = ""
        albumName = ""
    }
}
import Foundation
import SwiftData

@Model
final class Scrobble {
    var timestamp: Date
    var trackName: String
    var artistName: String
    var albumName: String?
    var duration: TimeInterval?
    var isScrobbled: Bool
    
    init(
        timestamp: Date = Date(),
        trackName: String,
        artistName: String,
        albumName: String? = nil,
        duration: TimeInterval? = nil,
        isScrobbled: Bool = false
    ) {
        self.timestamp = timestamp
        self.trackName = trackName
        self.artistName = artistName
        self.albumName = albumName
        self.duration = duration
        self.isScrobbled = isScrobbled
    }
}
import MediaPlayer
import Foundation
import SwiftData

class NowPlayingService: ObservableObject {
    @Published var currentTrack: MPMediaItem?
    private let queueService: ScrobbleQueueService
    
    init(queueService: ScrobbleQueueService) {
        self.queueService = queueService
    }
    
    func startMonitoring() {
        let center = MPMusicPlayerController.systemMusicPlayer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePlayingItemChanged),
            name: .MPMusicPlayerControllerNowPlayingItemDidChange,
            object: center
        )
        center.beginGeneratingPlaybackNotifications()
    }
    
    @objc private func handlePlayingItemChanged(_ notification: Notification) {
        currentTrack = MPMusicPlayerController.systemMusicPlayer.nowPlayingItem
        if let track = currentTrack {
            createScrobble(from: track)
        }
    }
    
    private func createScrobble(from track: MPMediaItem) {
        let scrobble = Scrobble(
            trackName: track.title ?? "",
            artistName: track.artist ?? "",
            albumName: track.albumTitle,
            duration: track.playbackDuration
        )
        queueService.queueScrobble(scrobble)
    }
}
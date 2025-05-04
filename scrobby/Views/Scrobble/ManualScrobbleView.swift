import SwiftUI

struct ManualScrobbleView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var serviceContainer: ServiceContainer
    
    @State private var trackName = ""
    @State private var artistName = ""
    @State private var albumName = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Track Name", text: $trackName)
                    TextField("Artist Name", text: $artistName)
                    TextField("Album (Optional)", text: $albumName)
                }
                
                Button("Add Scrobble") {
                    print("ManualScrobbleView -> serviceContainer: \(serviceContainer)")

                    let scrobble = Scrobble(
                        trackName: trackName,
                        artistName: artistName,
                        albumName: albumName.isEmpty ? nil : albumName
                    )
                    serviceContainer.scrobbleQueueService.queueScrobble(scrobble)
                    dismiss()
                }
                .disabled(trackName.isEmpty || artistName.isEmpty)
            }
            .navigationTitle("Manual Scrobble")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
import Foundation
import UIKit
import BackgroundTasks

class BackgroundTaskManager {
    static let shared = BackgroundTaskManager()
    static let scrobbleTaskIdentifier = "com.ballers.scrobby.backgroundscrobble"

    private init() {}

    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Self.scrobbleTaskIdentifier, using: nil) { task in
            self.handleBackgroundScrobble(task: task as! BGProcessingTask)
        }
    }

    func scheduleBackgroundScrobble() {
        let request = BGProcessingTaskRequest(identifier: Self.scrobbleTaskIdentifier)
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule background scrobble: \(error)")
        }
    }

    private func handleBackgroundScrobble(task: BGProcessingTask) {
        task.expirationHandler = {
            print("Background scrobble task expired.")
        }

        Task {
            do {
                if let serviceContainer = (UIApplication.shared.delegate as? scrobbyApp)?.serviceContainer {
                    serviceContainer.scrobbleQueueService.tryScrobbling()
                }
                task.setTaskCompleted(success: true)
            } catch {
                task.setTaskCompleted(success: false)
            }
        }
    }
}

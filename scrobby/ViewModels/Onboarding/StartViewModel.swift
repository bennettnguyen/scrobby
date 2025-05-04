import SwiftUI

@MainActor
class StartViewModel: ObservableObject {
    @AppStorage("isFirstTime") private(set) var isFirstTime: Bool = true
    @Published var showLogin: Bool = false
    
    func startOnboarding() {
        showLogin = true
    }
    
    func completeOnboarding() {
        withAnimation {
            isFirstTime = false
            showLogin = false
        }
    }
}
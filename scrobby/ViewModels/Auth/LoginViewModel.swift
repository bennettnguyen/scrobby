import Foundation
import AuthenticationServices
import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    @Published var lastfmUsername = ""
    @Published var lastfmPassword = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @AppStorage("lastfmUsername") private var storedLastfmUsername: String = ""
    @AppStorage("lastfmSessionKey") private var sessionKey: String = ""
    
    private let apiKey = "ce1a31392d28ad522984c380bf1fb3af"
    private let apiSecret = "461f134b376c8288347578b1c058e580"

    private lazy var lastFMService = LastFMService(apiKey: apiKey, apiSecret: apiSecret)
    
    func signInToLastFm() async {
        guard !lastfmUsername.isEmpty, !lastfmPassword.isEmpty else {
            errorMessage = "Please enter both username and password"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // Perform the actual authentication API call.
            let returnedSessionKey = try await lastFMService.authenticate(username: lastfmUsername, password: lastfmPassword)
            
            // Save credentials using AppStorage.
            storedLastfmUsername = lastfmUsername
            sessionKey = returnedSessionKey

            withAnimation {
                isFirstTime = false
                isAuthenticated = true
            }
        } catch {
            errorMessage = "Last.fm authentication failed: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func handleSignInWithAppleResult(_ result: Result<ASAuthorization, Error>) async {
        isLoading = true
        errorMessage = nil
        
        do {
            switch result {
            case .success(let authorization):
                guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid credential"])
                }
                
                let userId = credential.user
                UserDefaults.standard.set(userId, forKey: "appleUserID")
                
                if let email = credential.email {
                    UserDefaults.standard.set(email, forKey: "userEmail")
                }
                
            case .failure(let error):
                throw error
            }
        } catch {
            errorMessage = "Apple sign in failed: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

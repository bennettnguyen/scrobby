import XCTest
@testable import scrobby

class LastFMAuthTests: XCTestCase {
    var lastFMService: LastFMService!
    
    override func setUp() {
        super.setUp()
        lastFMService = LastFMService(
            apiKey: "ce1a31392d28ad522984c380bf1fb3af",
            apiSecret: "461f134b376c8288347578b1c058e580"
        )
    }
    
    func testAuthentication() async throws {
        // Test valid credentials
        do {
            let sessionKey = try await lastFMService.authenticate(
                username: "benrito30",
                password: ""
            )
            XCTAssertFalse(sessionKey.isEmpty, "Session key should not be empty")
            
            // Verify the credentials were stored
            let storedUsername = UserDefaults.standard.string(forKey: "lastfmUsername")
            let storedSessionKey = UserDefaults.standard.string(forKey: "lastfmSessionKey")
            
            XCTAssertEqual(storedUsername, "benrito30")
            XCTAssertFalse(storedSessionKey?.isEmpty ?? true)
        } catch {
            XCTFail("Authentication failed: \(error)")
        }
    }
    
    func testInvalidCredentials() async {
        do {
            _ = try await lastFMService.authenticate(
                username: "invalid_username",
                password: "invalid_password"
            )
            XCTFail("Should have thrown an error for invalid credentials")
        } catch {
            // Expected error
            XCTAssertNotNil(error)
        }
    }
}

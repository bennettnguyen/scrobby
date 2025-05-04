import Foundation

class LastFMService {
    private let apiKey: String
    private let apiSecret: String
    private let session: URLSession
    private let baseURL = "https://ws.audioscrobbler.com/2.0/" // last.fm api endpoint

    init(apiKey: String, apiSecret: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
        self.session = URLSession.shared
    }

    private func generateSignature(params: [String: String]) -> String {
        // Sort parameters alphabetically, concatenate key+value pairs, append secret, then MD5
        let sortedParams = params
            .filter { $0.key != "format" } // format should not be included in the signature
            .sorted { $0.key < $1.key }
            .map { "\($0.key)\($0.value)" }
            .joined()
        
        let stringToHash = sortedParams + apiSecret
        print("Signature input: \(stringToHash)")
        return stringToHash.md5()
    }
    

    func authenticate(username: String, password: String) async throws -> String {
        let authParams: [String: String] = [
            "method": "auth.getMobileSession",
            "username": username,
            "password": password,
            "api_key": apiKey
        ]

        var finalParams = authParams
        finalParams["api_sig"] = generateSignature(params: authParams)
        finalParams["format"] = "json"

        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyString = finalParams
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)" }
            .joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "LastFMError", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Authentication failed"])
        }

        struct AuthResponse: Decodable {
            struct Session: Decodable {
                let key: String
                let name: String
            }
            let session: Session
        }

        let decoder = JSONDecoder()
        let authResponse = try decoder.decode(AuthResponse.self, from: data)

        UserDefaults.standard.set(username, forKey: "lastfmUsername")
        UserDefaults.standard.set(authResponse.session.key, forKey: "lastfmSessionKey")

        return authResponse.session.key
    }

    func scrobbleTrack(_ scrobble: Scrobble) async throws {
        // Get stored session key (fixed typo here)
        guard let sessionKey = UserDefaults.standard.string(forKey: "lastfmSessionKey") else {
            throw NSError(domain: "LastFMError", code: 2,
                          userInfo: [NSLocalizedDescriptionKey: "Not authenticated"])
        }

        let timestamp = Int(scrobble.timestamp.timeIntervalSince1970)
        var params: [String: String] = [
            "method": "track.scrobble",
            "artist": scrobble.artistName,
            "track": scrobble.trackName,
            "timestamp": "\(timestamp)",
            "api_key": apiKey,
            "sk": sessionKey,
            "format": "json"
        ]

        if let album = scrobble.albumName {
            params["album"] = album
        }

        params["api_sig"] = generateSignature(params: params)

        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyString = params
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)" }
            .joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "LastFMError", code: 3,
                          userInfo: [NSLocalizedDescriptionKey: "Scrobbling failed"])
        }
    }
}

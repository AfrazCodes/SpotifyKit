//
//  SpotifyAPIManager.swift
//  SpotifyKit
//

import Foundation

/// Auth Manager for Spotify
public final class SpotifyAuthManager {
    /// Singleton
    public static let shared = SpotifyAuthManager()

    /// Flag to note if token is being refreshed
    private var refreshingToken = false

    /// Constatns
    private struct Constants {
        /// Authorization url
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    }

    /// SDK Configuration
    private var configuration: SpotifyKitConfiguration?

    /// Private constructor
    private init() {}

    /// Configure SDK
    /// - Parameter configuration: Config object
    public func configure(with configuration: SpotifyKitConfiguration) {
        self.configuration = configuration
    }

    /// Sign in auth url to show in webView
    public var signInURL: URL? {
        guard let config = configuration else {
            fatalError("SpotifyKit not configured")
        }

        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(config.clientID)&scope=\(config.scopes)&redirect_uri=\(config.redirectUri)&show_dialog=TRUE"
        return URL(string: string)
    }

    /// Check if current user has spotify connected
    public var isSpotifyConnected: Bool {
        return accessToken != nil
    }

    /// Spotify access token
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "spotify_access_token")
    }

    /// Spotify refresh token
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "spotify_refresh_token")
    }

    /// Spotify access token expiration date
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "spotify_expirationDate") as? Date
    }

    /// Chekc if access token should be refreshed
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }

    /// Exchange code for access token
    /// - Parameters:
    ///   - code: Code
    ///   - completion: Callback with result
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping ((SpotifyAuthResponse?) -> Void)
    ) {
        guard let config = configuration else {
            fatalError("SpotifyKit not configured")
        }

        // Get Token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            completion(nil)
            return
        }

        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: config.redirectUri),
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)

        let basicToken = config.clientID+":"+config.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            completion(nil)
            return
        }

        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let result = try JSONDecoder().decode(SpotifyAuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(result)
            }
            catch {
                completion(nil)
            }
        }
        task.resume()
    }

    /// Queued blocks to fire when valid token is present
    private var onRefreshBlocks = [((String) -> Void)]()

    /// Supplies valid token to be used with API Calls
    func withValidToken(completion: @escaping (String?) -> Void) {
        guard !refreshingToken else {
            // Append the compleiton
            onRefreshBlocks.append(completion)
            return
        }

        if shouldRefreshToken {
            // Refresh
            refreshIfNeeded { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
                else {
                    completion(nil)
                }
            }
        }
        else if let token = accessToken {
            completion(token)
        }
        else {
            completion(nil)
        }
    }

    /// Refresh spotify credentials if needed
    /// - Parameter completion: Nullable callback
    public func refreshIfNeeded(force: Bool = false, completion: ((Bool) -> Void)?) {
        guard !refreshingToken else {
            return
        }

        if !force {
            guard shouldRefreshToken else {
                completion?(true)
                return
            }
        }

        guard let refreshToken = refreshToken else{
            return
        }

        // Refresh the token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }

        guard let config = configuration else {
            fatalError("SpotifyKit not configured")
        }

        refreshingToken = true

        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)

        let basicToken = config.clientID+":"+config.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            completion?(false)
            return
        }

        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                completion?(false)
                return
            }

            do {
                let result = try JSONDecoder().decode(SpotifyAuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach { $0(result.access_token) }
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion?(true)
            }
            catch {
                completion?(false)
            }
        }
        task.resume()
    }

    /// Get updated access token for given credential
    /// - Parameters:
    ///   - credential: Token to refresh
    ///   - completion: Callback
    public func refreshed(
        with credential: SpotifyAuthResponse,
        completion: @escaping (String?) -> Void
    ) {
        guard let config = configuration else {
            fatalError("SpotifyKit not configured")
        }

        let refreshToken = credential.refresh_token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }

        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)

        let basicToken = config.clientID+":"+config.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            completion(nil)
            return
        }

        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let result = try JSONDecoder().decode(SpotifyAuthResponse.self, from: data)
                completion(result.access_token)
            }
            catch {
                completion(nil)
            }
        }
        task.resume()
    }

    /// Cache spotify token
    /// - Parameter result: Result with data to cache
    private func cacheToken(result: SpotifyAuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "spotify_access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "spotify_refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "spotify_expirationDate")
    }

    /// Reset cached spotify credentials
    private func clearCache() {
        UserDefaults.standard.setValue(nil, forKey: "spotify_access_token")
        UserDefaults.standard.setValue(nil, forKey: "spotify_refresh_token")
        UserDefaults.standard.setValue(nil, forKey: "spotify_expirationDate")
    }

    /// Get short lived access token for credential swap
    /// Reference: https://developer.spotify.com/documentation/general/guides/authorization/client-credentials/
    func getCredentialAccessToken(completion: @escaping (SpotifyCredentialAuthResponse?) -> Void) {
        guard let config = configuration else {
            fatalError("SpotifyKit not configured")
        }

        guard let url = URL(string: Constants.tokenAPIURL) else {
            completion(nil)
            return
        }

        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "client_credentials")
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)

        let basicToken = config.clientID+":"+config.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            completion(nil)
            return
        }

        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let result = try JSONDecoder().decode(SpotifyCredentialAuthResponse.self, from: data)
                completion(result)
            }
            catch {
                completion(nil)
            }
        }
        task.resume()
    }
}

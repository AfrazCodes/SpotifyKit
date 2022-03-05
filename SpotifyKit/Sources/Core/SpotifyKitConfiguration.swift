//
//  SpotifyAPIManager.swift
//  SpotifyKit
//

import Foundation

/// Config object for sdk
public struct SpotifyKitConfiguration {
    /// Comma separated scopes for Spotify api
    let scopes: String
    /// Redirect Uri for OAuth
    let redirectUri: String
    /// Client id for Registered spotify app/client
    let clientID: String
    /// Client secret
    /// NOTE: We strongly recommend handling token authorization on the server
    /// at your redirect uri. We have included this here for local functionality as well
    let clientSecret: String

    // MARK: - Init

    /// Constructor
    public init(
        scopes: String,
        redirectUri: String,
        clientID: String,
        clientSecret: String
    ) {
        self.scopes = scopes
        self.redirectUri = redirectUri
        self.clientID = clientID
        self.clientSecret = clientSecret
    }
}

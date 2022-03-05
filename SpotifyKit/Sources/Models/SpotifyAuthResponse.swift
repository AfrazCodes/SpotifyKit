//
//  SpotifyAPIManager.swift
//  SpotifyKit
//

import Foundation

/// Spotify auth response
public struct SpotifyAuthResponse: Codable, Equatable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}

/// Credential response
public struct SpotifyCredentialAuthResponse: Codable, Equatable {
    let access_token: String
    let token_type: String
    let expires_in: Int
}

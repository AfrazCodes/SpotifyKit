//
//  SpotifyAPIManager.swift
//  SpotifyKit
//

import Foundation

/// Auth error for token authorization
public struct SpotifyAuthError: Codable {
    let error: SPError
}

public struct SPError: Codable {
    let message: String
    let status: Int
}

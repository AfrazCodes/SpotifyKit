//
//  SpotifyAPIManager.swift
//  SpotifyKit
//

import Foundation

/// Spotify artist object
public struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let images: [APIImage]?
    let external_urls: [String: String]
}

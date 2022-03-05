//
//  SpotifyAPIManager.swift
//  SpotifyKit
//

import Foundation

/// Playlist detail data
public struct PlaylistDetailsResponse: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let tracks: PlaylistTracksResponse
}

public struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItem]
}

public struct PlaylistItem: Codable {
    let track: SPItem
}

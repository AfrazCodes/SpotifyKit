//
//  SpotifyAPIManager.swift
//  SpotifyKit
//

import Foundation

/// Featured playlist node
public struct FeaturedPlaylistsResponse: Codable {
    let playlists: PlaylistResponse
}

/// Categorical playlist
public struct CategoryPlaylistsResponse: Codable {
    let playlists: PlaylistResponse
}

/// Playlist response
public struct PlaylistResponse: Codable {
    let items: [Playlist]
}

/// Spotify user object
public struct SpotifyUser: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}

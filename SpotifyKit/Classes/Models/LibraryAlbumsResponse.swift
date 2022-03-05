//
//  SpotifyAPIManager.swift
//  SpotifyKit
//

import Foundation

/// Library albums
struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

/// Saved albums
struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}

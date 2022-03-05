//
//  SpotifyAPIManager.swift
//  SpotifyKit
//

import Foundation

/// Search results for multiple types
public struct SearchResultsResponse: Codable {
    let albums: SearchAlbumResponse
    let artists: SearchArtistsResponse
    let playlists: SearchPlaylistsResponse
    let tracks: SearchTrackssResponse
}

public struct SearchAlbumResponse: Codable {
    let items: [Album]
}

public struct SearchArtistsResponse: Codable {
    let items: [Artist]
}

public struct SearchPlaylistsResponse: Codable {
    let items: [Playlist]
}

public struct SearchTrackssResponse: Codable {
    let items: [SPItem]
}

//
//  SpotifyAPIManager.swift
//  SpotifyKit
//

import Foundation

/// New releases data
public struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse
}

/// Single album reponse
public struct AlbumsResponse: Codable {
    let items: [Album]
}

/// Album from spotify
public struct Album: Codable {
    let album_type: String
    let available_markets: [String]
    let id: String
    var images: [APIImage]
    let name: String
    let release_date: String
    let total_tracks: Int
    let artists: [Artist]
}

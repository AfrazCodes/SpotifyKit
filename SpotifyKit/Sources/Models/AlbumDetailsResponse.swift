//
//  SpotifyAPIManager.swift
//  SpotifyKit
//

import Foundation

/// Response for details of album
public struct AlbumDetailsResponse: Codable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let tracks: TracksResponse
}

/// Response for tracks
public struct TracksResponse: Codable {
    let items: [AudioTrack]
}

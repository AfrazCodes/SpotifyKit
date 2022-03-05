//
//  SpotifyAPIManager.swift
//  SpotifyKit
//

import Foundation

/// Artistt top tracks response
public struct ArtistTopTracksResponse: Codable {
    let tracks: [SPItem]
}

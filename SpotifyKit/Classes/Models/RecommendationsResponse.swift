//
//  SpotifyAPIManager.swift
//  SpotifyKit
//

import Foundation

/// recommended spotify content
public struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}



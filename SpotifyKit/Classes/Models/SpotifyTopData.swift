//
//  SpotifyAPIManager.swift
//  SpotifyKit
//

import Foundation

/// Top data for user (spotify)
public struct TopDataResult: Codable {
    let items: [SPItem]
    let total: Int
}

/// Widely used object for generic spotify content; written to database
public struct SPItem: Codable {
    let album: SPAlbum?
    let artists: [SPArtist]?
    let external_ids: [String: String]?
    let external_urls: [String: String]
    let genres: [String]?
    let id: String
    let href: String
    let name: String
    let popularity: Int
    let preview_url: String?
    let type: String
    let uri: String
    let images: [SPImage]?
}

public struct SPAlbum: Codable {
    let album_type: String
    let artists: [SPArtist]
    let external_urls: [String: String]
    let href: String
    let id: String
    let images: [SPImage]
    let name: String
    let type: String
    let uri: String?
}

public struct SPImage: Codable {
    let width: Int
    let height: Int
    let url: String
}

public struct SPArtist: Codable {
    let external_urls: [String: String]
    let href: String
    let id: String
    let name: String
    let type: String
    let url: String?
}

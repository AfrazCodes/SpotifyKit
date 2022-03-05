//
//  SpotifyAPIManager.swift
//  SpotifyKit
//

import Foundation

/// All categories list response
public struct AllCategoriesResponse: Codable {
    let categories: Categories
}

/// Categories response
public struct Categories: Codable {
    let items: [Category]
}

/// Single category in response
public struct Category: Codable {
    let id: String
    let name: String
    let icons: [APIImage]
}

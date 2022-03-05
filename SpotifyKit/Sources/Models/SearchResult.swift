//
//  SpotifyAPIManager.swift
//  SpotifyKit
//
import Foundation

/// Search result for spotify
@frozen public enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}

# SpotifyKit

iOS Library to authenticate and interact with Spotify services.

## Install

You can integrate this framework via Cocoapods.

```swift
pod 'Spotify-Kit'
```

## Features

- Spotify OAuth Support: Log In, Refresh Token, Persist Credentials Securely
- Fetch Albums
- Fetch Artists
- Fetch Playlists
- Search Content
- Get User Specific Top Content (artists, tracks, playlists)
- Get New Releases
- Update/Create/Delete content in user library (auth required)
- Get Top Charts & Trending Content
- More 🚀

## Usage

1. Configure the SDK via the singleton's configure method.

```swift
let config = SpotifyKitConfiguration(...)
SpotifyAuthManager.shared.configure(config)
```

2. Leverage auth APIs to authenticate a user and obtain OAuth credentials.

3. Make calls against SpotifyAPIManager. The library handles creation of signed/authenticated requests for you.

```swift
// Fetch a users top streamed tracks of all time
SpotifyAPIManager.shared.getTopContent(
  .tracks,
  for: .lifetime
) { result in
  switch result {
    case .success(let tracks):
      for track in tracks {
          print(track.name)
          print(track.artist)
          print(track.preview_url)
          // ...
      }
    csae .failure(let error):
      print(error.localizedDescription)
      break
  }
}

```

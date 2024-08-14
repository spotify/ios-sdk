# Now Playing View

A project that demonstrates listening to and displaying the current player state, and allowing the user to control the playback.

Steps:

1. Install XcodeGen via `brew install xcodegen` command.
2. Run `xcodegen` in the demo project
2. Open `NowPlayingView.xcodeproj`
3. Create an app in [https://developer.spotify.com/dashboard](https://developer.spotify.com/dashboard)
    - Add any name and description
    - Add the redirect URI: `spotify-ios-test-app://spotify-login-callback`
    - Check iOS SDK
4. Edit Settings and add the bundleId `com.spotify.SpotifyAppRemoteDemo`
3. Copy your `clientID` in `SceneDelegate.swift`

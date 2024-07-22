# Changelog

## Spotify iOS SDK v2.1.6

What's New:

- Strip binary symbols

## Spotify iOS SDK v2.1.5

What's New:

- Migrate build system to Bazel

## Spotify iOS SDK v2.1.4

What's New:

- Add support for raw scope string

## Spotify iOS SDK v2.1.3

What's New:

- Fix bug in the web authentication when using Universal Links in the redirect URI

## Spotify iOS SDK v2.1.2

What's New:

- Dismiss authentication screen when Spotify app is installed.

## Spotify iOS SDK v2.1.1

What's New:

- Added the new campaign parameter in the sample apps.

## Spotify iOS SDK v2.1.0

What's New:

- Expanded existing API with campaign parameter to allow consumers to specify details about where the auth flow was initiated

## Spotify iOS SDK v2.0.1

What's New:
- Bumped the min deployment target version to iOS 12.0 in Package.swift

## Spotify iOS SDK v2.0.0

What's New:

- Added a completionHandler to authorizeAndPlayURI API
- Support for pinned items in Your Library
- Fix crash NSRangeException -[NSConcreteMutableData replaceBytesInRange:withBytes:length:]:
- Fix umbrela header warnings in SpotifyiOS.xcframework
- Bumped the min deployment target version to iOS 12.0

## Spotify iOS SDK v1.2.5

What's New:

- Adds Privacy Manifest (xcframework only)

## Spotify iOS SDK v1.2.4

What's New:

- Adds new API to allow for a session identifier to be passed along in connection phase for enhanced instrumentation.
- Adds `SPTAppRemoteConnectivityAPI` and `SPTAppRemoteConnectivityAPIDelegate` for subscribing to connectivity changes of the Spotify app.
- Adds `SpotifyiOS.xcframework` as default in NowPlayingView sample project.

## Spotify iOS SDK v1.2.3

- Support Swift Package Manager

## Spotify iOS SDK v1.2.2

What's New:

- Work around for missing symbols reported in some cases.
- Update the demo apps

## Spotify iOS SDK v1.2.1

What's New:

- Remove the need for the `-Objc` linker flag
- Update the demo apps

## Spotify iOS SDK v1.2.0

What's New:

- Adds support for connecting to Spotify when completely offline.
- Adds a method to start playing radio from a URI.
- Adds a method to get the content item object from a URI.

## Spotify iOS SDK v1.0.2

What's New

- Adds a method to start playing a playlist from a given index
- Adds a method to query the crossfade state (on/off) and duration

## Spotify iOS SDK v1.0.1

**Important Note:** The api for `fetchRecommendedContentItemsForType:` on `SPTAppRemoteContentAPI` has been renamed to `fetchRootContentItemsForType:` and still functions as it did returning root items. A new method for `fetchRecommendedContentItemsForType:flattenContainers:` has been added to fetch actual recommended items.

What's New

- Adds convenience methods for dealing with podcasts
- Adds additional convenience methods for fetching recommended items
- Adds the ability to check if Spotify is active before authorization

## Spotify iOS SDK v1.0.0

What's New

- Initial iOS SDK release
- Includes authentication and playback control capabilities
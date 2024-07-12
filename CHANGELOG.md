# Changelog

## [2.1.2]

What's New:
- Dismiss authentication screen when Spotify app is installed
- Migrate build system to Bazel

## [2.1.1]

What's New:
- Added the new campaign parameter in the sample apps.

## [2.1.0]

What's New:
- Expanded existing API with campaign parameter to allow consumers to specify details about where the auth flow was initiated

## [2.0.1]

What's New:
- Bumped the min deployment target version to iOS 12.0 in Package.swift

## [2.0.0]

What's New:
- Added a completionHandler to authorizeAndPlayURI API
- Support for pinned items in Your Library
- Fix crash NSRangeException -[NSConcreteMutableData replaceBytesInRange:withBytes:length:]:
- Fix umbrela header warnings in SpotifyiOS.xcframework
- Bumped the min deployment target version to iOS 12.0

## [1.2.5]

What's New:

- Adds Privacy Manifest (xcframework only)

## [1.2.4]

What's New:

- Adds new API to allow for a session identifier to be passed along in connection phase for enhanced instrumentation.
- Adds `SPTAppRemoteConnectivityAPI` and `SPTAppRemoteConnectivityAPIDelegate` for subscribing to connectivity changes of the Spotify app.
- Adds `SpotifyiOS.xcframework` as default in NowPlayingView sample project.

## [1.2.3]

- Support Swift Package Manager

## [1.2.2]

What's New:

- Work around for missing symbols reported in some cases.
- Update the demo apps

## [1.2.1]

What's New:

- Remove the need for the `-Objc` linker flag
- Update the demo apps

## [1.2.0]

What's New:

- Adds support for connecting to Spotify when completely offline.
- Adds a method to start playing radio from a URI.
- Adds a method to get the content item object from a URI.

## [1.0.2]

What's New

- Adds a method to start playing a playlist from a given index
- Adds a method to query the crossfade state (on/off) and duration

## [1.0.1]

**Important Note:** The api for `fetchRecommendedContentItemsForType:` on `SPTAppRemoteContentAPI` has been renamed to `fetchRootContentItemsForType:` and still functions as it did returning root items. A new method for `fetchRecommendedContentItemsForType:flattenContainers:` has been added to fetch actual recommended items.

What's New

- Adds convenience methods for dealing with podcasts
- Adds additional convenience methods for fetching recommended items
- Adds the ability to check if Spotify is active before authorization

## [1.0.0]

What's New

- Initial iOS SDK release
- Includes authentication and playback control capabilities

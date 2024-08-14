# SPTLoginSampleAppObjc

A project that focuses solely on the authentication part of the SDK.

Steps:

1. Install XcodeGen via `brew install xcodegen` command.
2. Run `xcodegen` in the demo project
2. Open `SPTLoginSampleAppObjc.xcodeproj`
3. Create an app in [https://developer.spotify.com/dashboard](https://developer.spotify.com/dashboard)
    - Add any name and description
    - Add the redirect URI: `spotify-login-sdk-test-app-objc://spotify-login-callback`
    - Check iOS SDK
4. Edit Settings and add the bundleId `com.spotify.SPTLoginSampleAppObjc`
3. Copy your `clientID` in `ViewController.m`

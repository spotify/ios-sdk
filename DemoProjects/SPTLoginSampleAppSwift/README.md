# SPTLoginSampleAppSwift

A project that demonstrates how to use both the authentication and remote control parts of the SDK together.

Steps:

1. Install XcodeGen via `brew install xcodegen` command.
2. Run `xcodegen` in the demo project
2. Open `SPTLoginSampleAppSwift.xcodeproj`
3. Create an app in [https://developer.spotify.com/dashboard](https://developer.spotify.com/dashboard)
    - Add any name and description
    - Add the redirect URI: `spotify-login-sdk-test-app-swift://spotify-login-callback`
    - Check iOS SDK
4. Edit Settings and add the bundleId `com.spotify.SPTLoginSampleAppSwift`
3. Copy your `clientID` in `ViewController.swift`

For this project is required to perform an OAuth token swap. 

A sample server is provided for testing. Navigate to the directory containing this README in your terminal and run the following commands:

1. `brew install rbenv`
2. `rbenv install $(rbenv local)`
3. `$(rbenv which gem) install sinatra encrypted_strings`

Now to run the ruby script and have your local server running simply execute the following command:

```sh
$(rbenv which ruby) spotify_token_swap.rb
```

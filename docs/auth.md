# Auth

## SPTSessionManager

The main entry point for authentication if you need to authorize without starting music playback.

### Using the  `SPTSessionManager`  Authorization flow

**Note:** This is only necessary if you want to authenticate even if the Spotify app isn't installed or without starting music playback. This approach requires you to have your own server to perform an OAuth token swap.

1. Initialize `SPTConfiguration` with your client ID and redirect URI.

    ```objective-c
    SPTConfiguration *configuration =
        [[SPTConfiguration alloc] initWithClientID:@"your_client_id" redirectURL:[NSURL urlWithString:@"your_redirect_uri"]];

    // Optional: If you plan to connect SPTAppRemote you can start playback during authorization by setting playURI to a non-nil string. If Spotify is already playing it will continue playing even though a URI is provided.
    configuration.playURI = "";
    ```

2. Set your token swap and refresh URLs . These endpoints will hold your client secret and communicate with Spotify's servers to get an OAuth token.

    ```objective-c
    // Set these urls to your backend which contains the secret to exchange for an access token
    configuration.tokenSwapURL = [NSURL URLWithString: @"http://[your_server]/swap"];
    configuration.tokenRefreshURL = [NSURL URLWithString: @"http://[your_server]/refresh"];
    ```

3. Initialize `SPTSessionManager` with your configuration and delegate.

    ```objective-c
    self.sessionManager = [SPTSessionManager sessionManagerWithConfiguration:configuration delegate:self];
    ```

4. Configure your `AppDelegate` to parse the returned token from the Spotify app.

    ```objective-c
    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)URL options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
    {
        return [self.sessionManager application:application openURL:URL options:options];
    }
    ```

    If you using a Universal Link in the redirect URI, you should use this delegate method instead:

    ```objective-c
    - (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
        return [self.rootViewController.sessionManager application:application continueUserActivity:userActivity restorationHandler:restorationHandler]
    }
    ```


5. If using `SPTAppRemote` to control playback be sure to set the returned token on its connection parameters in the `SPTSessionManager` delegate callback.

    ```objective-c
    - (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session
    {
        self.appRemote.connectionParams.accessToken = session.accessToken
    }
    ```

6. Initiate the the authorization process

    ```objective-c
    /*
    Scopes let you specify exactly what types of data your application wants to
    access, and the set of scopes you pass in your call determines what access
    permissions the user is asked to grant.
    For more information, see https://developer.spotify.com/web-api/using-scopes/.
    */
    SPTScope scope = SPTUserFollowReadScope | SPTAppRemoteControlScope;

    [self.sessionManager initiateSessionWithScope:scope options:SPTDefaultAuthorizationOption];
    ```
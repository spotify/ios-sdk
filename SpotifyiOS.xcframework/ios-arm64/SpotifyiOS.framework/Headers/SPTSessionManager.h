#import <UIKit/UIKit.h>
#import "SPTScope.h"

NS_ASSUME_NONNULL_BEGIN

@class SPTConfiguration, SPTSession;
@protocol SPTSessionManagerDelegate;

/// Options for determining the most suitable method for authorization
typedef NS_OPTIONS(NSUInteger, SPTAuthorizationOptions) {
    /// Authorize using a suitable method. If Spotify is installed the app will be used instead of a web view
    SPTDefaultAuthorizationOption NS_SWIFT_NAME(default) = (0),
    /// Authorize using only the Spotify client. If Spotify is not installed authorization will fail.
    SPTClientAuthorizationOption NS_SWIFT_NAME(clientOnly) = (1 << 0),
} NS_SWIFT_NAME(AuthorizationOptions);

typedef NSString *const SPTAuthorizationCode;


/// This class manages a Spotify user session, in the form of `SPTSession`.
@interface SPTSessionManager : NSObject

/// The `SPTSession` for the `SPTSessionManager` to manage. If no user has been authenticated this will be nil
@property (nullable, nonatomic, strong) SPTSession *session;

/// The `SPTSessionManagerDelegate` to notify of initiating a session, renewing a session, and/or errors related to a
/// session
@property (nullable, nonatomic, weak) id<SPTSessionManagerDelegate> delegate;

/**
 Determine if the Spotify app is installed.

 Will be `YES` if the Spotify app is installed (and the URL scheme is whitelisted), otherwise is `NO`.
 Note: You must whitelist the "spotify" URL scheme in your info.plist LSApplicationQueriesSchemes or this will always be
 NO
 */
@property (nonatomic, readonly, getter=isSpotifyAppInstalled) BOOL spotifyAppInstalled;

/**
 Set this value to `YES` when debugging to have the Spotify app always show the authorization confirmation screen.
 You SHOULD NOT set this value to `YES` in production or your users will always have to confirm.
 */
@property (nonatomic, assign) BOOL alwaysShowAuthorizationDialog;

- (instancetype)init NS_UNAVAILABLE;

/**
 Initiate the authorization process

 @param scope The scope to request, e.g. `SPTPlaylistReadPrivateScope`|`SPTUserReadEmailScope` if you wish to request
 read access to private playlists, and read access to the user's email address.
 @param options Options bitmask that informs authorization behavior.
 @param campaign The campaign identifier, to help attribute where the account linking was initiated from.
 See `SPTSessionManagerDelegate` for messages regarding changes in session state.
 */
- (void)initiateSessionWithScope:(SPTScope)scope
                         options:(SPTAuthorizationOptions)options
                        campaign:(nullable NSString *)campaign;

/**
 Initiate the authorization process
 @note Prefer `initiateSessionWithScope:options:campaign` instead, unless you need additional scopes that aren't listed
 in `SPTScope`
 @param scope The scope to request, e.g. `"playlist-read-private user-read-email"` if you wish to request read access to
 private playlists, and read access to the user's email address.
 @param options Options bitmask that informs authorization behavior.
 @param campaign The campaign identifier, to help attribute where the account linking was initiated from.
 See `SPTSessionManagerDelegate` for messages regarding changes in session state.
 */
- (void)initiateSessionWithRawScope:(NSString *)scope
                            options:(SPTAuthorizationOptions)options
                           campaign:(nullable NSString *)campaign;

/// Attempt to renew the access token, using the refresh token in the current `SPTSession` which must be valid.
- (void)renewSession;

/**
 Create an `SPTSessionManager` with the provided configuration.

 @param configuration An `SPTConfiguration` object.
 @param delegate An optional delegate conforming to `SPTSessionManagerDelegate`.
 @return An `SPTSessionManager` with the desired configuration.
*/
- (instancetype)initWithConfiguration:(SPTConfiguration *)configuration
                             delegate:(nullable id<SPTSessionManagerDelegate>)delegate;

+ (instancetype)sessionManagerWithConfiguration:(SPTConfiguration *)configuration
                                       delegate:(nullable id<SPTSessionManagerDelegate>)delegate;
/**
 Handle openURL callbacks from the `AppDelegate`

 @param application The `UIApplication` passed into the matching `AppDelegate` method
 @param URL The URL to attempt to parse the access token from
 @param options The options passed in to the matching `AppDelegate` method
 @return Returns `YES` if `SPTSessionManager` recognizes the URL and will attempt to parse an access token, otherwise
 returns `NO`.
*/
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)URL
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

/**
 Handle continueUserActivity callbacks from the `AppDelegate`

 @param application The `UIApplication` passed into the matching `AppDelegate` method
 @param userActivity An object encapsulating a user activity supported by this responder.
 @param restorationHandler A block to execute if your app creates objects to perform the task the user was performing
 @return Returns `YES` if `SPTSessionManager` recognizes the URL and will attempt to parse an access token, otherwise
 returns `NO`.
*/
- (BOOL)application:(UIApplication *)application
    continueUserActivity:(NSUserActivity *)userActivity
      restorationHandler:
          (void (^)(NSArray<id<UIUserActivityRestoring>> *__nullable restorableObjects))restorationHandler;

@end

/// The `SPTSessionManagerDelegate` to use for monitoring state changes of a `SPTSessionManager`
@protocol SPTSessionManagerDelegate <NSObject>

/**
 This message is sent when a session has been initiated successfully.

 @param manager The `SPTSessionManager` that initiated the session.
 @param session The initiated `SPTSession` object.
*/
- (void)sessionManager:(SPTSessionManager *)manager
    didInitiateSession:(SPTSession *)session NS_SWIFT_NAME(sessionManager(manager:didInitiate:));

/**
 This message is sent when the manager failed to initiate or renew a session.

 @param manager The `SPTSessionManager` instance.
 @param error The `NSError` that occured.
*/
- (void)sessionManager:(SPTSessionManager *)manager
      didFailWithError:(NSError *)error NS_SWIFT_NAME(sessionManager(manager:didFailWith:));

@optional

/**
 This message is sent when the manager has renewed a session.

 @param manager The `SPTSessionManager` instance.
 @param session The renewed `SPTSession` object.
*/
- (void)sessionManager:(SPTSessionManager *)manager
       didRenewSession:(SPTSession *)session NS_SWIFT_NAME(sessionManager(manager:didRenew:));

/**
 Sent when the `SPTSessionManager` has obtained an authorization code,
 and is about to swap it for an access token. If you wish to handle this
 yourself, return `NO` and use the provided authorization code.

 @param manager The `SPTSessionManager` instance.
 @param code An OAuth authorization code.
 @return `NO` to request the access token yourself; `YES` to let `SPTSessionManager` handle it.
*/
- (BOOL)sessionManager:(SPTSessionManager *)manager
    shouldRequestAccessTokenWithAuthorizationCode:(SPTAuthorizationCode)code
    NS_SWIFT_NAME(sessionManager(manager:shouldRequestAccessTokenWith:));

@end


NS_ASSUME_NONNULL_END

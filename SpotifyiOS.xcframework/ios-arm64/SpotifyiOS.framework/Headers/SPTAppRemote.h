#import <Foundation/Foundation.h>

@class SPTAppRemote;
@class SPTAppRemoteConnectionParams;
@class SPTConfiguration;

@protocol SPTAppRemoteImageAPI;
@protocol SPTAppRemotePlayerAPI;
@protocol SPTAppRemoteUserAPI;
@protocol SPTAppRemoteContentAPI;
@protocol SPTAppRemoteConnectivityAPI;

NS_ASSUME_NONNULL_BEGIN

extern NSString *const SPTAppRemoteAccessTokenKey;
extern NSString *const SPTAppRemoteErrorKey;
extern NSString *const SPTAppRemoteErrorDescriptionKey;

/// The severity of log messages that the App Remote should log to console.
typedef NS_ENUM(NSUInteger, SPTAppRemoteLogLevel) {
    /// Do not log at all.
    SPTAppRemoteLogLevelNone = 0,
    /// Log debug, info and error messages.
    SPTAppRemoteLogLevelDebug = 1,
    /// Log info and error messages.
    SPTAppRemoteLogLevelInfo = 2,
    /// Log only error messages.
    SPTAppRemoteLogLevelError = 3,
};

/**
 *  The `SPTAppRemoteDelegate` receives updates from the `SPTAppRemote` whenever something has
 *  happened with the connection.
 */
@protocol SPTAppRemoteDelegate <NSObject>

/**
 *  Called when the App Remote has established connection with the Spotify app.
 *
 *  @param appRemote The transport that has connected.
 */
- (void)appRemoteDidEstablishConnection:(SPTAppRemote *)appRemote;

/**
 *  Called when the connection attempt made by the App Remote failed.
 *
 *  @param appRemote The App Remote that failed to connect.
 *  @param error     The error that occurred.
 */
- (void)appRemote:(SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(nullable NSError *)error;

/**
 *  Called when the App Remote has disconnected.
 *
 *  @note All APIs will be released by the App Remote at this point. The will no longer be usable,
 *        and so you should release them as well.
 *
 *  @param appRemote The App Remote that disconnected.
 *  @param error     The error that caused the disconnect, or `nil` if the disconnect was explicit.
 */
- (void)appRemote:(SPTAppRemote *)appRemote didDisconnectWithError:(nullable NSError *)error;

@end

/**
 *  The `SPTAppRemote` is the main entry point for interacting with the Spotify app using the Spotify App Remote for
 * iOS.
 */
@interface SPTAppRemote : NSObject

#pragma mark Lifecycle

/**
 *  Convenience Initializer for a new App Remote instance
 *
 *  @param configuration The `SPTConfiguration` to use for client-id's and redirect URLs
 *  @param logLevel The lowest severity to log to console.
 *
 *  @return A fresh new App Remote, ready to connect.
 */
- (instancetype)initWithConfiguration:(SPTConfiguration *)configuration logLevel:(SPTAppRemoteLogLevel)logLevel;

/**
 *  Designated Initializer for a new App Remote instance
 *
 *  @param configuration The `SPTConfiguration` to use for client-id's and redirect URLs
 *  @param connectionParameters `SPTAppRemoteConnectionParams` for custom image sizes and types, and to hold the
 * accessToken
 *  @param logLevel The lowest severity to log to console.
 *
 *  @return A fresh new App Remote, ready to connect.
 */
- (instancetype)initWithConfiguration:(SPTConfiguration *)configuration
                 connectionParameters:(SPTAppRemoteConnectionParams *)connectionParameters
                             logLevel:(SPTAppRemoteLogLevel)logLevel NS_DESIGNATED_INITIALIZER;
#pragma mark Class Methods

/**
 * Determine the current version of the Spotify App Remote
 *
 * @return The current version of the Spotify App Remote
 */
+ (NSString *)appRemoteVersion;

/**
 * The Spotify app iTunes item identifier for use with `SKStoreProductViewController` for installing Spotify from the
 * App Store.
 *
 * @return An `NSNumber` representing the Spotify iTunes item identifier to be used for the
 * `SKStoreProductParameterITunesItemIdentifier` key
 */
+ (NSNumber *)spotifyItunesItemIdentifier;

#pragma mark Connection

/**
 * The parameters to use during connection.
 */
@property (nonatomic, strong, readonly) SPTAppRemoteConnectionParams *connectionParameters;

/**
 *  `YES` if the App Remote is connected to the Spotify application, otherwise `NO`.
 *
 *  @note Not KVO’able.
 *
 *  See The `SPTAppRemoteDelegate` in order to receive updates when the connection status changes.
 */
@property (nonatomic, assign, readonly, getter=isConnected) BOOL connected;

/**
 *  The delegate to notify for connection status changes and other events originating from the App Remote.
 */
@property (nonatomic, weak) id<SPTAppRemoteDelegate> delegate;

/**
 * Attempts to connect to the Spotify application.
 *
 * @discussion If the Spotify app is not running you will need to use authorizeAndPlayURI: to wake it up
 */
- (void)connect;

/**
 * Attempts to connect to the Spotify application with a given session identifier.
 *
 * @discussion If the Spotify app is not running you will need to use authorizeAndPlayURI: to wake it up.
 *
 * @discussion If `authorizeAndPlayURI` was used without a given session identifier, `connect` should be used instead of
 * this method.
 *
 * @param sessionIdentifier The unique session identifier which was used when calling
 * `authorizeAndPlayURI:asRadio:additionalScopes:sessionIdentifier:`
 */
- (void)connectWithSessionIdentifier:(NSUUID *)sessionIdentifier;

/**
 * Disconnect from the Spotify application
 */
- (void)disconnect;

/**
 * Open Spotify app to obtain access token and start playback.
 * The passed URI will start playing unless Spotify is already playing.
 *
 * @param URI The URI to play. Use a blank string to attempt to play the user's last song
 * @param completionHandler `YES` if the Spotify app is installed and an authorization attempt can be made, otherwise
 * `NO`.
 *
 * Note: The return `BOOL` here is not a measure of whether or not authentication succeeded, only a check if
 * the Spotify app is installed and can attempt to handle the authorization request.
 */
- (void)authorizeAndPlayURI:(NSString *)URI completionHandler:(void (^__nullable)(BOOL success))completionHandler;

/**
 * Open Spotify app to obtain access token and start playback.
 *
 * @param playURI The URI to play. Use a blank string to attempt to play the user's last song
 * @param asRadio `YES` to start radio for the given URI.
 * @param completionHandler `YES` if the Spotify app is installed and an authorization attempt can be made, otherwise
 * `NO`.
 *
 * Note: The return `BOOL` here is not a measure of whether or not authentication succeeded, only a check if
 * the Spotify app is installed and can attempt to handle the authorization request.
 */
- (void)authorizeAndPlayURI:(NSString *)playURI
                    asRadio:(BOOL)asRadio
          completionHandler:(void (^__nullable)(BOOL success))completionHandler;

/**
 * Open Spotify app to obtain access token and start playback.
 *
 * @param playURI The URI to play. Use a blank string to attempt to play the user's last song
 * @param asRadio `YES` to start radio for the given URI.
 * @param additionalScopes An array of scopes in addition to `app-remote-control`. Can be nil if you only need
 * `app-remote-control`
 * @param completionHandler `YES` if the Spotify app is installed and an authorization attempt can be made, otherwise
 * `NO`.
 *
 * Note: The return `BOOL` here is not a measure of whether or not authentication succeeded, only a check if
 * the Spotify app is installed and can attempt to handle the authorization request.
 */
- (void)authorizeAndPlayURI:(NSString *)playURI
                    asRadio:(BOOL)asRadio
           additionalScopes:(nullable NSArray<NSString *> *)additionalScopes
          completionHandler:(void (^__nullable)(BOOL success))completionHandler;

/**
 * Open Spotify app to obtain access token and start playback.
 *
 * @param playURI The URI to play. Use a blank string to attempt to play the user's last song
 * @param asRadio `YES` to start radio for the given URI.
 * @param additionalScopes An array of scopes in addition to `app-remote-control`. Can be nil if you only need
 * `app-remote-control`
 * @param sessionIdentifier An optional unique identifier for this specific session, which is used for analytics
 * purposes. Every new attempt to connect to the Spotify app should have a new identifier, but the identifier used here
 * should then be reused for the accompanied call to `connectWithSessionIdentifier:`.
 * @param completionHandler `YES` if the Spotify app is installed and an authorization attempt can be made, otherwise
 * `NO`.
 *
 * Note: The return `BOOL` here is not a measure of whether or not authentication succeeded, only a check if
 * the Spotify app is installed and can attempt to handle the authorization request.
 */
- (void)authorizeAndPlayURI:(NSString *)playURI
                    asRadio:(BOOL)asRadio
           additionalScopes:(nullable NSArray<NSString *> *)additionalScopes
          sessionIdentifier:(nullable NSUUID *)sessionIdentifier
          completionHandler:(void (^__nullable)(BOOL success))completionHandler;
/**
 * Parse out an access token or error description from a url passed to application:openURL:options:
 *
 * @param url The URL returned from the Spotify app after calling authorizeAndPlayURI
 *
 * @return A dictionary containing the access token or error description from the provided URL.
 * Will return nil if the URL Scheme does not match the redirect URI provided.
 * Use `SPTAppRemoteAccessTokenKey` and `SPTAppRemoteErrorDescriptionKey` to get the appropriate values.
 */
- (nullable NSDictionary<NSString *, NSString *> *)authorizationParametersFromURL:(NSURL *)url;

#pragma mark APIs

/**
 *  The API used to control the Spotify player.
 *
 *  @note Will only be populated when the App Remote is connected. If you retain this object you must release it on
 *        disconnect.
 */
@property (nullable, nonatomic, strong, readonly) id<SPTAppRemotePlayerAPI> playerAPI;

/**
 *  The API used to fetch images from the Spotify app.
 *
 *  @note Will only be populated when the App Remote is connected. If you retain this object you must release it on
 *        disconnect.
 */
@property (nullable, nonatomic, strong, readonly) id<SPTAppRemoteImageAPI> imageAPI;

/**
 *  The API used to fetch user data from the Spotify app.
 *
 *  @note Will only be populated when the App Remote is connected. If you retain this object you must release it on
 *        disconnect.
 */
@property (nullable, nonatomic, strong, readonly) id<SPTAppRemoteUserAPI> userAPI;

/**
 *  The API used to fetch content from the Spotify app.
 *
 *  @note Will only be populated when the App Remote is connected. If you retain this object you must release it on
 *        disconnect.
 */
@property (nullable, nonatomic, strong, readonly) id<SPTAppRemoteContentAPI> contentAPI;

/**
 *  The API used to get connectivity data from the Spotify app.
 *
 *  @note Will only be populated when the App Remote is connected. If you retain this object you must release it on
 *        disconnect.
 */
@property (nullable, nonatomic, strong, readonly) id<SPTAppRemoteConnectivityAPI> connectivityAPI;

#pragma mark Unavailable initializers

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

#import <Foundation/Foundation.h>
#import "SPTAppRemoteCommon.h"

@protocol SPTAppRemoteConnectivityAPI;
@protocol SPTAppRemoteConnectivityState;

NS_ASSUME_NONNULL_BEGIN

/**
 * The `SPTAppRemoteConnectivityAPIDelegate` gets notified whenever the connectivity API receives new data from
 * subscription events.
 */
@protocol SPTAppRemoteConnectivityAPIDelegate <NSObject>

/**
 * Called when the connectivity state has been updated.
 *
 * @param connectivityAPI The API that received updates.
 * @param connectivityState The new connectivity state received.
 */
- (void)connectivityAPI:(id<SPTAppRemoteConnectivityAPI>)connectivityAPI
    didReceiveNewConnectivityState:(id<SPTAppRemoteConnectivityState>)connectivityState;

@end

/**
 The @c SPTAppRemoteConnectivityAPI class is used to get connectivity data from the Spotify app.
 */
@protocol SPTAppRemoteConnectivityAPI <NSObject>

/// The delegate receiving player state updates
@property (nonatomic, weak) id<SPTAppRemoteConnectivityAPIDelegate> delegate;

/**
 * Subscribes to connection state changes from the Spotify app.
 *
 * @note Implement `SPTAppRemoteConnectivityAPIDelegate` and set yourself as delegate in order to be notified when the
 *       the connection state changes.
 *
 * @param callback On success `result` will be `YES`
 *                 On error `result` will be `nil` and error set
 */
- (void)subscribeToConnectivityState:(nullable SPTAppRemoteCallback)callback;

/**
 * Stops subscribing to connection state changes from the Spotify app.
 *
 * @param callback On success `result` will be `YES`
 *                 On error `result` will be `nil` and error set
 */
- (void)unsubscribeToConnectivityState:(nullable SPTAppRemoteCallback)callback;

@end

NS_ASSUME_NONNULL_END

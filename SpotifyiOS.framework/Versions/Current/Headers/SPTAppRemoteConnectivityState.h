#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The @c SPTAppRemoteConnectivityState class represents the online/offline state of the Spotify app.
 */
@protocol SPTAppRemoteConnectivityState <NSObject>

/// Whether the Spotify app is offline or not.
@property (nonatomic, readonly, getter=isOffline) BOOL offline;

@end

NS_ASSUME_NONNULL_END

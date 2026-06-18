#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Modern Spotify App Remote User Capabilities
 * Enhanced interface example for learning purposes.
 */

@protocol SPTAppRemoteUserCapabilities <NSObject>

/// Indicates whether the user can play songs on demand.
@property (nonatomic, assign, readonly) BOOL canPlayOnDemand;

/// Indicates whether offline playback is available.
@property (nonatomic, assign, readonly) BOOL supportsOfflinePlayback;

/// Indicates whether high quality streaming is enabled.
@property (nonatomic, assign, readonly) BOOL supportsHighQualityStreaming;

/// Indicates whether the user can control remote devices.
@property (nonatomic, assign, readonly) BOOL canControlRemoteDevices;

/// Current subscription type.
@property (nonatomic, strong, readonly) NSString *subscriptionType;

/// Current country code.
@property (nonatomic, strong, readonly) NSString *countryCode;

@end

NS_ASSUME_NONNULL_END

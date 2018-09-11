#import "SPTAppRemoteImageRepresentable.h"

@protocol SPTAppRemoteAlbum;
@protocol SPTAppRemoteArtist;

NS_ASSUME_NONNULL_BEGIN

/**
 *  The `SPTAppRemoteTrack` represents a track.
 */
@protocol SPTAppRemoteTrack <NSObject, SPTAppRemoteImageRepresentable>

/// The name of the track.
@property (nonatomic, copy, readonly) NSString *name;

/// The URI of the track.
@property (nonatomic, copy, readonly) NSString *URI;

/// The duration of the track in miliseconds.
@property (nonatomic, assign, readonly) NSUInteger duration;

/// The artist of the track.
@property (nonatomic, strong, readonly) id<SPTAppRemoteArtist> artist;

/// The album of the track.
@property (nonatomic, strong, readonly) id<SPTAppRemoteAlbum> album;

/// `YES` if the user has saved the track, otherwise `NO`.
@property (nonatomic, assign, readonly, getter=isSaved) BOOL saved;

@end

NS_ASSUME_NONNULL_END

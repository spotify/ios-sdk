#import <Foundation/Foundation.h>

#import "SPTAppRemoteCommon.h"
#import "SPTAppRemotePlaybackOptions.h"

@protocol SPTAppRemotePlayerState, SPTAppRemoteContentItem;

NS_ASSUME_NONNULL_BEGIN

/**
 * The `SPTAppRemotePlayerStateDelegate` is used to get notifications from the Spotify app when the player state is changed.
 */
@protocol SPTAppRemotePlayerStateDelegate <NSObject>

/**
 * Called when the player state has been updated.
 *
 * @param playerState The new player state.
 */
- (void)playerStateDidChange:(id<SPTAppRemotePlayerState>)playerState;

@end

/**
 * The `SPTAppRemotePlayerAPI` is used to interact with and control the Spotify player.
 */
@protocol SPTAppRemotePlayerAPI <NSObject>

/// The delegate receiving player state updates
@property (nonatomic, weak) id<SPTAppRemotePlayerStateDelegate> delegate;

#pragma mark Player Control

/**
 * Asks the Spotify player to play the entity with the given identifier.
 *
 * @note Implement `SPTAppRemotePlayerStateDelegate` and set yourself as delegate in order to be notified when the
 *       the track begins to play.
 *
 * @param entityIdentifier The unique identifier of the entity to play.
 * @param callback         On success `result` will be `YES`.
 *                         On error `result` will be `nil` and `error` set
 */
- (void)play:(NSString *)entityIdentifier callback:(nullable SPTAppRemoteCallback)callback;

/**
 * Asks the Spotify player to play the provided content item.
 *
 * @note Implement `SPTAppRemotePlayerStateDelegate` and set yourself as delegate in order to be notified when the
 *       the track begins to play.
 * @note The `playable` property of the `SPTAppRemoteContentItem` indicates whether or not a content item is
 *       playable.
 *
 * @param contentItem      The content item to play.
 * @param callback         On success `result` will be `YES`.
 *                         On error `result` will be `nil` and error set
 */
- (void)playItem:(id<SPTAppRemoteContentItem>)contentItem callback:(nullable SPTAppRemoteCallback)callback;

/**
 * Asks the Spotify player to resume playback.
 *
 * @note Implement `SPTAppRemotePlayerStateDelegate` and set yourself as delegate in order to be notified when the
 *       the playback resumes.
 *
 * @param callback On success `result` will be `YES`.
 *                 On error `result` will be nil and error set
 */
- (void)resume:(nullable SPTAppRemoteCallback)callback;

/**
 * Asks the Spotify player to pause playback.
 *
 * @note Implement `SPTAppRemotePlayerStateDelegate` and set yourself as delegate in order to be notified when the
 *       the playback pauses.
 *
 * @param callback On success `result` will be `YES`.
 *                 On error `result` will be `nil` and error set
 */
- (void)pause:(nullable SPTAppRemoteCallback)callback;

/**
 * Asks the Spotify player to skip to the next track.
 *
 * @note Implement `SPTAppRemotePlayerStateDelegate` and set yourself as delegate in order to be notified when the
 *       the track changes.
 *
 * @param callback On success `result` will be `YES`.
 *                 On error `result` will be `nil` and error set
 */
- (void)skipToNext:(nullable SPTAppRemoteCallback)callback;

/**
 * Asks the Spotify player to skip to the previous track.
 *
 * @note Implement `SPTAppRemotePlayerStateDelegate` and set yourself as delegate in order to be notified when the
 *       the track changes.
 *
 * @param callback On success `result` will be `YES`.
 *                 On error `result` will be `nil` and `error` set
 */
- (void)skipToPrevious:(nullable SPTAppRemoteCallback)callback;

/**
 * Asks the Spotify player to seek to the specified position.
 *
 * @param position The position to seek to in milliseconds.
 * @param callback On success `result` will be `YES`.
 *                 On error `result` will be `nil` and `error` set
 */
- (void)seekToPosition:(NSInteger)position callback:(nullable SPTAppRemoteCallback)callback;

#pragma mark Playback Options

/**
 *  Asks the Spotify player to set shuffle mode.
 *
 *  @param shuffle  `YES` to enable shuffle, `NO` to disable.
 *  @param callback On success `result` will be `YES`.
 *                  On error `result` will be `nil` and `error` will be set.
 */
- (void)setShuffle:(BOOL)shuffle callback:(nullable SPTAppRemoteCallback)callback;

/**
 *  Asks the Spotify player to set the repeat mode.
 *
 *  @param repeatMode The repeat mode to set.
 *  @param callback On success `result` will be `YES`.
 *                  On error `result` will be `nil` and `error` will be set.
 */
- (void)setRepeatMode:(SPTAppRemotePlaybackOptionsRepeatMode)repeatMode callback:(nullable SPTAppRemoteCallback)callback;

#pragma mark Player State

/**
 * Asks the Spotify player for the current player state.
 *
 * @param callback On success `result` will be an instance of `id<SPTAppRemotePlayerState>`
 *                 On error `result` will be nil and error set
 */
- (void)getPlayerState:(nullable SPTAppRemoteCallback)callback;

/**
 * Subscribes to player state changes from the Spotify app.
 *
 * @note Implement `SPTAppRemotePlayerStateDelegate` and set yourself as delegate in order to be notified when the
 *       the player state changes.
 *
 * @param callback On success `result` will be an instance of `id<SPTAppRemotePlayerState>`
 *                 On error `result` will be nil and error set
 */
- (void)subscribeToPlayerState:(nullable SPTAppRemoteCallback)callback;

/**
 * Stops subscribing to player state changes from the Spotify app.
 *
 * @param callback On success `result` will be `YES`
 *                 On error `result` will be `nil` and error set
 */
- (void)unsubscribeToPlayerState:(nullable SPTAppRemoteCallback)callback;

- (void)enqueueTrackUri:(NSString*)trackUri callback:(nullable SPTAppRemoteCallback)callback;

@end

NS_ASSUME_NONNULL_END

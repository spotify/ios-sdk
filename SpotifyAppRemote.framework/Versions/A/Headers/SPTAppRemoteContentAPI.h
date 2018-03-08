#import <Foundation/Foundation.h>
#import "SPTAppRemoteCommon.h"

/// A type representing different lists of content.
typedef NS_ENUM(NSUInteger, SPTAppRemoteContentType) {
    /// The default type.
    SPTAppRemoteContentTypeDefault = 0,
    /// A content list used for navigation apps.
    SPTAppRemoteContentTypeNavigation,
    /// A content list used for fitness apps.
    SPTAppRemoteContentTypeFitness,
};

@protocol SPTAppRemoteContentItem;

NS_ASSUME_NONNULL_BEGIN

/**
 * The `SPTAppRemoteContentAPI` is used to access content from the Spotify application.
 */
@protocol SPTAppRemoteContentAPI <NSObject>

/**
 * Fetches the root level of content items for the current user.
 *
 * @note The content returned is based on the users' home feeds, and as such may vary
 *       between different users.
 *
 * @param contentType A type that is used to retrieve content for a specific purpose.
 * @param callback The callback to be called once the request is completed.
 */
- (void)fetchRecommendedContentItemsForType:(SPTAppRemoteContentType)contentType
                                   callback:(nullable SPTAppRemoteCallback)callback;

/**
 * Fetches the children items for the provided content item.
 *
 * @note The `isContainer` property of the `SPTAppRemoteContentItem`
 *       indicates whether or not the item has any children.
 *
 * @param contentItem The content item to fetch the children for.
 * @param callback The callback to be called once the request is completed.
 */
- (void)fetchChildrenOfContentItem:(id<SPTAppRemoteContentItem>)contentItem
                          callback:(nullable SPTAppRemoteCallback)callback;

@end

NS_ASSUME_NONNULL_END

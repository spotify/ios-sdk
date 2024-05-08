@import UIKit;
@import SpotifyiOS;

NS_ASSUME_NONNULL_BEGIN


@interface ViewController : UIViewController <SPTSessionManagerDelegate>

@property (nonatomic) SPTSessionManager *sessionManager;

@end


NS_ASSUME_NONNULL_END

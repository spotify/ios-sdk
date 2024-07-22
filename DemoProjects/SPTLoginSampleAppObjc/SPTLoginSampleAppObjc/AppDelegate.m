#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@property(nonatomic, strong) ViewController *rootViewController;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<NSString *, id> *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [ViewController new];
    self.rootViewController = [ViewController new];
    self.window.rootViewController = self.rootViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)URL
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    // Use this method if your SpotifyRedirectURL is a native deeplink
    return [self.rootViewController.sessionManager application:application openURL:URL options:options];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    // Use this method if your SpotifyRedirectURL is an universal link (https/http)
    return [self.rootViewController.sessionManager application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
}

@end

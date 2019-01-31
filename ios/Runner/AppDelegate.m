#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
@import Firebase;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  [FIRApp configure];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

// NOTE: Necessary, until Flutter supports
//       `application:continueUserActivity:restorationHandler` within the
//       `FlutterPlugin` protocol.
- (BOOL)application:(UIApplication *)application
    continueUserActivity:(NSUserActivity *)userActivity
      restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
  return [[UniLinksPlugin sharedInstance] application:application
                                 continueUserActivity:userActivity
                                   restorationHandler:restorationHandler];
}

@end

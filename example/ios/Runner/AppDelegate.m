#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include <FltUmengpushCommonPlugin.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    //初始化友盟推送
    [FltUmengpushCommonPlugin initWithAppKey:@"友盟推送appKey" channel:@"渠道"];
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end

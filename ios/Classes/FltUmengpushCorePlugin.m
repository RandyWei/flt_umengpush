#import "FltUmengpushCorePlugin.h"
#import <UMPush/UMessage.h>

@interface FltUmengpushCorePlugin () <UNUserNotificationCenterDelegate>

@end

@implementation FltUmengpushCorePlugin {
    FlutterEventSink eventSink;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"plugin.bughub.dev/flt_umengpush_core"
            binaryMessenger:[registrar messenger]];
  FltUmengpushCorePlugin* instance = [[FltUmengpushCorePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"plugin.bughub.dev/flt_umengpush_core/event" binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:instance];
    
    [registrar addApplicationDelegate:instance];
}



- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"configure" isEqualToString:call.method]) {
      
      [[UIApplication sharedApplication] registerForRemoteNotifications];
      
    result(nil);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (NSString *)stringDevicetoken:(NSData *)deviceToken {
    NSString *token = [deviceToken description];
    NSString *pushToken = [[[token stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"umeng_push_plugin token: %@", pushToken);
    return pushToken;
}

#pragma ApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    NSLog(@"didFinishLaunchingWithOptions");
        UMessageRegisterEntity *entity = [[UMessageRegisterEntity alloc]init];
        if (@available(iOS 10.0, *)) {
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        } else {
            // Fallback on earlier versions
        }
        [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
            NSLog(@"didReceiveRemoteNotification:%d %@",granted,error);
        }];
    
    return YES;
}

#pragma UNUserNotificationCenterDelegate

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    eventSink(@{@"event":@"configure",
    @"deviceToken":[self stringDevicetoken:deviceToken]
    });
}

//iOS10以下使用这两个方法接收通知
- (BOOL)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    NSLog(@"didReceiveRemoteNotification:%@",userInfo);
    
    [UMessage setAutoAlert:NO];
    if ([[[UIDevice currentDevice] systemVersion]intValue] < 10) {
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
    return YES;
}

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

//iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    NSLog(@"willPresentNotification:%@",userInfo);
    
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    
}

//iOS10新增：处理后台点击通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    NSLog(@"didReceiveNotificationResponse:%@",userInfo);
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于后台时的本地推送接受
    }
}

#endif

#pragma FltterStreamHandler
-(FlutterError *)onCancelWithArguments:(id)arguments{
    eventSink = nil;
    return nil;
}

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events{
    eventSink = events;
    return nil;
}

@end

#import "FltUmengpushCommonPlugin.h"
#import <UIKit/UIKit.h>
#import <UMCommon/UMCommon.h>

@implementation FltUmengpushCommonPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"plugin.bughub.dev/flt_umengpush_common"
            binaryMessenger:[registrar messenger]];
  FltUmengpushCommonPlugin* instance = [[FltUmengpushCommonPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"init" isEqualToString:call.method]) {
    
      NSString* appKey = call.arguments[@"appKey"];
      NSString* channel = call.arguments[@"channel"];
      
      if (appKey==nil||[appKey isEqual:[NSNull null]]||[appKey isEqualToString:@""]) {
          result([FlutterError errorWithCode:@"Error" message:@"appKey is null" details:nil]);
          return;
      }
      
      if (channel==nil||[channel isEqual:[NSNull null]]||[channel isEqualToString:@""]) {
          result([FlutterError errorWithCode:@"Error" message:@"channel is null" details:nil]);
          return;
      }
      
      [UMConfigure initWithAppkey:appKey channel:channel];
      
      result(nil);
  } else if ([@"setLogEnabled" isEqualToString:call.method]) {
    
      BOOL bFlag = [call.arguments[@"enabled"] boolValue];
      
      [UMConfigure setLogEnabled:bFlag];
      
      result(nil);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end

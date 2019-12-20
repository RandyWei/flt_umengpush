#import "FltUmengpushUtdidPlugin.h"
#if __has_include(<flt_umengpush_utdid/flt_umengpush_utdid-Swift.h>)
#import <flt_umengpush_utdid/flt_umengpush_utdid-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flt_umengpush_utdid-Swift.h"
#endif

@implementation FltUmengpushUtdidPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFltUmengpushUtdidPlugin registerWithRegistrar:registrar];
}
@end

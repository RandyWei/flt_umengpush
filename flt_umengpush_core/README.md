# flt_umengpush_core

友盟推送核心包

## 安装方法

```
//pub
dependencies:
  flt_umengpush_common: ^lastest_version
  flt_umengpush_utdid: ^lastest_version   #如果项目中有其他三方库引入了utdid，无需加入该插件
  flt_umengpush_core: ^lastest_version

//import
dependencies:
  flt_umengpush_common:
    git:
      url: https://github.com/RandyWei/flt_umengpush.git
      path: flt_umengpush_common
  flt_umengpush_core:
    git:
      url: https://github.com/RandyWei/flt_umengpush.git
      path: flt_umengpush_core
  flt_umengpush_utdid:    #如果项目中有其他三方库引入了utdid，无需加入该插件
    git:
      url: https://github.com/RandyWei/flt_umengpush.git
      path: flt_umengpush_utdid
```

### Android

创建 App 类继承 io.flutter.app.FlutterApplication

```
class App: FlutterApplication() {
    override fun onCreate() {
        super.onCreate()

        val appKey = "友盟AppKey"
        val secret = "友盟secret"
        FltUmengpushCommonPlugin.init(this,appKey,secret)
        FltUmengpushCorePlugin.register(this)
    }
}
```

然后在 AndroidManifest.xml 中使用该类,并配置权限

```xml
<manifest
    ...
    xmlns:tools="http://schemas.android.com/tools" >

    <!-- 必须的权限 -->
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <uses-permission android:name="android.permission.INTERNET" />

    <!-- 推荐的权限 -->
    <!-- 添加如下权限，以便使用更多的第三方SDK和更精准的统计数据 -->
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

    <application android:name=".App">
        ...
    </application>
</manifest>

```

### iOS

#### swift

在 项目名-Bridgin-Header.h 中导包

```
#import "FltUmengpushCommonPlugin.h"
```

在 ApppDelegate 中添加以下代码

```
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    //初始化友盟推送
    FltUmengpushCommonPlugin.initWithAppKey("友盟推送AppKey", channel: "渠道")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

#### oc

```
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
```

### dart 代码

在程序入口监听通知

```dart
  @override
  void initState() {
    super.initState();
      FltUmengpushCore.listen(tokenCallback: (token) {
          //注册成功token回调
          print("deviceToken:$token");
        }, notificationCallback: (pushData) {
          //点击通知回调，pushData为自定义数据，按需进行添加逻辑代码
          print("data:$pushData");
        });
      }
  }
```

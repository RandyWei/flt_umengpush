# flt_umengpush_common

友盟推送common基础包


## 安装方法

```
//pub
dependencies:
  flt_umengpush_common: ^lastest_version

//import
dependencies:
  flt_umengpush_common:
    git:
      url: git://github.com/RandyWei/flt_umengpush_common.git
```

### Android

#### 权限

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

    <application>
        ...
    </application>
</manifest>
```

### 方法

```
/**
* 设置组件化的Log开关
* 参数: boolean 默认为false，如需查看LOG设置为true
*/
FltUmengpushCommon.setLogEnabled(true);


/**
* 初始化common库
* 参数1:【友盟+】 appKey
* 参数2:Push推送业务的secret
* 参数4:【友盟+】 channel
* 参数3:设备类型，FltUmengpushCommon.DEVICE_TYPE_PHONE为手机、FltUmengpushCommon.DEVICE_TYPE_BOX为盒子，默认为手机
*/
FltUmengpushCommon.init(appKey, secret, channel, deviceType);
```

### Example
```dart
import 'package:flt_video_player/flt_video_player.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.path(
        "https://github.com/RandyWei/flt_video_player/blob/master/example/SampleVideo_1280x720_30mb.mp4?raw=true")
      ..initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Simple Demo",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Simple Demo"),
        ),
        body: AspectRatio(
          aspectRatio: 1.8,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }
}

```

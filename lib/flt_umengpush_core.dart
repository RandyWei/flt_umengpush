import 'dart:async';
import 'dart:ffi';

import 'package:flutter/services.dart';

typedef TokenCallBack(String token);
typedef NotificationCallback(dynamic pushData);

class FltUmengpushCore {
  static const MethodChannel _channel = const MethodChannel('plugin.bughub.dev/flt_umengpush_core');

  /*
  * 监听通知
  * */
  static Future<Void> listen(
      {TokenCallBack tokenCallback, NotificationCallback notificationCallback}) async {
    EventChannel eventChannel = const EventChannel("plugin.bughub.dev/flt_umengpush_core/event");
    eventChannel.receiveBroadcastStream().listen((channelData) {
      var event = channelData["event"];
      if (event == "configure") {
        var deviceToken = channelData["deviceToken"];
        tokenCallback(deviceToken);
      } else if (event == "notificationHandler") {
        var data = channelData["data"];
        notificationCallback(data);
      }
    }, onError: (Object obj) {
      print(obj);
    });

    return await _channel.invokeMethod('configure');
  }
}

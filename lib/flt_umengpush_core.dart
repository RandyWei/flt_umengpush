import 'dart:async';
import 'dart:ffi';

import 'package:flutter/services.dart';

class FltUmengpushCore {
  static const MethodChannel _channel = const MethodChannel('plugin.bughub.dev/flt_umengpush_core');

  /*
  * 注册推送服务
  * */
  static Future<Void> register(Function registerCallback, Function notificationCallback) async {
    EventChannel eventChannel = const EventChannel("plugin.bughub.dev/flt_umengpush_core/event");
    eventChannel.receiveBroadcastStream().listen((channelData) {
      var event = channelData["event"];
      if (event == "register") {
        var deviceToken = channelData["deviceToken"];
        registerCallback(deviceToken);
      } else if (event == "notificationHandler") {
        var data = channelData["data"];
        notificationCallback(data);
      }
    }, onError: () {});

    return await _channel.invokeMethod('register');
  }
}

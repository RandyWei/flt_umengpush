import 'dart:async';
import 'dart:ffi';

import 'package:flutter/services.dart';

class FltUmengpushCommon {
  static const int DEVICE_TYPE_PHONE = 1;
  static const int DEVICE_TYPE_BOX = 2;

  static const MethodChannel _channel =
      const MethodChannel('plugin.bughub.dev/flt_umengpush_common');

  static Future<Void> init(String appKey, String secret, [String channel, int deviceType]) async {
    return await _channel.invokeMethod(
        'init', {"appKey": appKey, "secret": secret, "channel": channel, "deviceType": deviceType});
  }

  static Future<Void> setLogEnabled(bool enabled) async {
    return await _channel.invokeMethod('setLogEnabled', {"enabled": enabled});
  }
}

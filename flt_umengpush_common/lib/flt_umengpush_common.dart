import 'dart:async';
import 'dart:ffi';

import 'package:flutter/services.dart';

class FltUmengpushCommon {
  /*设备类型：手机 */
  static const int DEVICE_TYPE_PHONE = 1;
  /*设备类型：盒子 */
  static const int DEVICE_TYPE_BOX = 2;

  static const MethodChannel _channel =
      const MethodChannel('plugin.bughub.dev/flt_umengpush_common');

  /*
   * 初始化方法
   */
  static Future<Void?> init(String appKey, String secret,
      [String? channel, int? deviceType]) async {
    return await _channel.invokeMethod('init', {
      "appKey": appKey,
      "secret": secret,
      "channel": channel,
      "deviceType": deviceType
    });
  }

  /*
  * 是否开启日志
  */
  static Future<Void?> setLogEnabled(bool enabled) async {
    return await _channel.invokeMethod('setLogEnabled', {"enabled": enabled});
  }
}

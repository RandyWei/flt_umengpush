import 'dart:async';

import 'package:flutter/services.dart';

class FltUmengpushUtdid {
  static const MethodChannel _channel =
      const MethodChannel('flt_umengpush_utdid');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

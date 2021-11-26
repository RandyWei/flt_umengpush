import 'dart:async';
import 'dart:ffi';

import 'package:flutter/services.dart';

typedef TokenCallBack(String? token);
typedef NotificationCallback(dynamic pushData);

class FltUmengpushCore {
  static const MethodChannel _channel =
      const MethodChannel('plugin.bughub.dev/flt_umengpush_core');

  /*
  * 监听通知
  * */
  static Future<Void?> listen(
      {TokenCallBack? tokenCallback,
      NotificationCallback? notificationCallback}) async {
    EventChannel eventChannel =
        const EventChannel("plugin.bughub.dev/flt_umengpush_core/event");
    eventChannel.receiveBroadcastStream().listen((channelData) {
      var event = channelData["event"];
      if (event == "configure") {
        var deviceToken = channelData["deviceToken"];
        tokenCallback?.call(deviceToken);
      } else if (event == "notificationHandler") {
        var data = channelData["data"];
        notificationCallback?.call(data);
      }
    }, onError: (Object obj) {
      print(obj);
    });

    return await _channel.invokeMethod('configure');
  }

  /*
   * 添加标签 示例：将“标签1”、“标签2”绑定至该设备
   */
  static Future<Void?> addTags(List<String> args, {Function? callback}) async {
    MethodChannel(
            "plugin.bughub.dev/flt_umengpush_core/UTrack.ICallBack_addTags")
        .setMethodCallHandler((call) {
      if (call.method == "") {
        callback?.call();
      }
      return Future.value(null);
    });
    return await _channel.invokeMethod("addTags", {"tags": args});
  }

  /*
   * 删除标签,将之前添加的标签中的一个或多个删除
   */
  static Future<Void?> deleteTags(List<String> args) async {
    return await _channel.invokeMethod("deleteTags", {"tags": args});
  }

  /*
   * 别名增加，将某一类型的别名ID绑定至某设备，老的绑定设备信息还在，别名ID和device_token是一对多的映射关系
   */
  static Future<Void?> addAlias(String args,
      {String type = "CustomType", Function? callback}) async {
    MethodChannel(
            "plugin.bughub.dev/flt_umengpush_core/UTrack.ICallBack_addAlias")
        .setMethodCallHandler((call) {
      if (call.method == "callback") {
        callback?.call(call.arguments);
      }
      return Future.value(null);
    });
    return await _channel
        .invokeMethod("addAlias", {"alias": args, "type": type});
  }

  /*
   * 别名绑定，将某一类型的别名ID绑定至某设备，老的绑定设备信息被覆盖，别名ID和deviceToken是一对一的映射关系
   */
  static Future<Void?> setAlias(String args,
      {String type = "CustomType", Function? callback}) async {
    MethodChannel(
            "plugin.bughub.dev/flt_umengpush_core/UTrack.ICallBack_setAlias")
        .setMethodCallHandler((call) {
      if (call.method == "callback") {
        callback?.call(call.arguments);
      }
      return Future.value(null);
    });
    return await _channel
        .invokeMethod("setAlias", {"alias": args, "type": type});
  }

  /*
   * 移除别名ID
   */
  static Future<Void?> deleteAlias(String args,
      {String type = "CustomType", Function? callback}) async {
    MethodChannel(
            "plugin.bughub.dev/flt_umengpush_core/UTrack.ICallBack_deleteAlias")
        .setMethodCallHandler((call) {
      if (call.method == "callback") {
        callback?.call(call.arguments);
      }
      return Future.value(null);
    });
    return await _channel
        .invokeMethod("deleteAlias", {"alias": args, "type": type});
  }
}

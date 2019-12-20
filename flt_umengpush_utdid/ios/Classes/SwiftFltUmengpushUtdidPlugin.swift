import Flutter
import UIKit

public class SwiftFltUmengpushUtdidPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flt_umengpush_utdid", binaryMessenger: registrar.messenger())
    let instance = SwiftFltUmengpushUtdidPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}

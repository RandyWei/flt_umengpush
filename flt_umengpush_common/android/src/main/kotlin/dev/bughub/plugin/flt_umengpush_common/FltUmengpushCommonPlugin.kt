package dev.bughub.plugin.flt_umengpush_common

import android.content.Context
import android.text.TextUtils
import android.util.Log
import com.umeng.commonsdk.UMConfigure
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class FltUmengpushCommonPlugin: MethodCallHandler,FlutterPlugin {

  var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null
  companion object {

    @JvmStatic
    fun init(context: Context, appKey:String, secret:String, channel:String="Umeng", deviceType:Int=UMConfigure.DEVICE_TYPE_PHONE){
      if (TextUtils.isEmpty(secret)){
        Log.e("UmengpushCommonPlugin","secret is null")
        return
      }

      if (TextUtils.isEmpty(appKey)){
        Log.e("UmengpushCommonPlugin","appKey is null")
        return
      }
      UMConfigure.setLogEnabled(true)
      UMConfigure.init(context, appKey, channel, deviceType, secret)
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    /**
     * 设置组件化的Log开关
     * 参数: boolean 默认为false，如需查看LOG设置为true
     */
    when (call.method) {
        "setLogEnabled" -> {
          val enabled = call.argument<Boolean>("enabled") ?: false
          UMConfigure.setLogEnabled(enabled)
          result.success(null)
        }
        "init" -> {
          val appKey = call.argument<String>("appKey")
          val secret = call.argument<String>("secret")
          val channel = call.argument<String>("channel") ?: "Umeng"
          val deviceType = call.argument<Int>("deviceType") ?: UMConfigure.DEVICE_TYPE_PHONE

          if (TextUtils.isEmpty(secret)){
            result.error("0001","secret is null",null)
            return
          }

          if (TextUtils.isEmpty(appKey)){
            result.error("0002","appKey is null",null)
            return
          }

          UMConfigure.init(flutterPluginBinding?.applicationContext, appKey, channel, deviceType, secret)

          result.success(null)
        }
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    flutterPluginBinding = binding
    val channel = MethodChannel(binding.binaryMessenger, "plugin.bughub.dev/flt_umengpush_common")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {

  }
}

package dev.bughub.plugin.flt_umengpush_core

import android.content.Context
import android.util.Log
import com.chinahrt.flutter_plugin_demo.QueuingEventSink
import com.umeng.message.IUmengRegisterCallback
import com.umeng.message.PushAgent
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class FltUmengpushCorePlugin(private val registrar: Registrar): MethodCallHandler {

  val eventSink = QueuingEventSink()


  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {

      val plugin = FltUmengpushCorePlugin(registrar)

      val channel = MethodChannel(registrar.messenger(), "plugin.bughub.dev/flt_umengpush_core")
      channel.setMethodCallHandler(plugin)

      val eventChannel = EventChannel(registrar.messenger(), "plugin.bughub.dev/flt_umengpush_core/event")
      eventChannel.setStreamHandler(object :EventChannel.StreamHandler{
        override fun onListen(p0: Any?, sink: EventChannel.EventSink?) {
          // 把eventSink存起来
          plugin.eventSink.setDelegate(sink)
        }

        override fun onCancel(p0: Any?) {
          plugin.eventSink.setDelegate(null)
        }

      })
    }

    @JvmField
    var pushAgent:PushAgent? = null

    @JvmField
    var deviceToken:String? = null

    @JvmStatic
    fun register(context: Context){
      //获取消息推送代理
      val pushAgent = PushAgent.getInstance(context)
      FltUmengpushCorePlugin.pushAgent = pushAgent
      pushAgent.register(object : IUmengRegisterCallback{
        override fun onSuccess(deviceToken: String?) {
          Log.i("FltUmengpushCorePlugin","deviceToken:$deviceToken")
          FltUmengpushCorePlugin.deviceToken = deviceToken
        }

        override fun onFailure(p0: String?, p1: String?) {
          Log.i("FltUmengpushCorePlugin","onFailure:$p1  $p0")
        }

      })

    }
  }

  
  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "configure") {

      deviceToken?.let {
        val eventResult = HashMap<String, Any>()
        eventResult["event"] = "configure"
        eventResult["deviceToken"] = it

        eventSink.success(eventResult)
      }

      //自定义通知栏打开动作
      pushAgent?.setNotificationClickHandler { _, uMessage ->

        Log.i("FltUmengpushCorePlugin","uMessage:$uMessage")
        Log.i("FltUmengpushCorePlugin","uMessage.custom:${uMessage.custom}")

        val eventResult = HashMap<String, Any>()
        eventResult["event"] = "notificationHandler"
        eventResult["data"] = uMessage.custom

        eventSink.success(eventResult)
      }

      result.success(null)
    } else {
      result.notImplemented()
    }
  }
}
